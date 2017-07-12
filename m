From: akpm@linux-foundation.org
Subject: [patch 13/96] sysctl: add unsigned int range support
Date: Wed, 12 Jul 2017 14:33:40 -0700
Message-ID: <20170712213340.v1A4p09p8%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:53234 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753083AbdGLVdl (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 12 Jul 2017 17:33:41 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: adobriyan@gmail.com, akpm@linux-foundation.org, davem@davemloft.net, ebiederm@xmission.com, keescook@chromium.org, mcgrof@kernel.org, mingo@redhat.com, mm-commits@vger.kernel.org, subashab@codeaurora.org, torvalds@linux-foundation.org, viro@zeniv.linux.org.uk, xypron.glpk@gmx.de

From: "Luis R. Rodriguez" <mcgrof@kernel.org>
Subject: sysctl: add unsigned int range support

To keep parity with regular int interfaces provide the an unsigned int
proc_douintvec_minmax() which allows you to specify a range of allowed
valid numbers.

Adding proc_douintvec_minmax_sysadmin() is easy but we can wait for an
actual user for that.

Link: http://lkml.kernel.org/r/20170519033554.18592-6-mcgrof@kernel.org
Signed-off-by: Luis R. Rodriguez <mcgrof@kernel.org>
Acked-by: Kees Cook <keescook@chromium.org>
Cc: Subash Abhinov Kasiviswanathan <subashab@codeaurora.org>
Cc: Heinrich Schuchardt <xypron.glpk@gmx.de>
Cc: Kees Cook <keescook@chromium.org>
Cc: "David S. Miller" <davem@davemloft.net>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: Al Viro <viro@zeniv.linux.org.uk>
Cc: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: Alexey Dobriyan <adobriyan@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/proc/proc_sysctl.c  |    4 +-
 include/linux/sysctl.h |    3 +
 kernel/sysctl.c        |   66 +++++++++++++++++++++++++++++++++++++++
 3 files changed, 72 insertions(+), 1 deletion(-)

diff -puN fs/proc/proc_sysctl.c~sysctl-add-unsigned-int-range-support fs/proc/proc_sysctl.c
--- a/fs/proc/proc_sysctl.c~sysctl-add-unsigned-int-range-support
+++ a/fs/proc/proc_sysctl.c
@@ -1065,7 +1065,8 @@ static int sysctl_check_table_array(cons
 {
 	int err = 0;
 
-	if (table->proc_handler == proc_douintvec) {
+	if ((table->proc_handler == proc_douintvec) ||
+	    (table->proc_handler == proc_douintvec_minmax)) {
 		if (table->maxlen != sizeof(unsigned int))
 			err |= sysctl_err(path, table, "array now allowed");
 	}
@@ -1083,6 +1084,7 @@ static int sysctl_check_table(const char
 		if ((table->proc_handler == proc_dostring) ||
 		    (table->proc_handler == proc_dointvec) ||
 		    (table->proc_handler == proc_douintvec) ||
+		    (table->proc_handler == proc_douintvec_minmax) ||
 		    (table->proc_handler == proc_dointvec_minmax) ||
 		    (table->proc_handler == proc_dointvec_jiffies) ||
 		    (table->proc_handler == proc_dointvec_userhz_jiffies) ||
diff -puN include/linux/sysctl.h~sysctl-add-unsigned-int-range-support include/linux/sysctl.h
--- a/include/linux/sysctl.h~sysctl-add-unsigned-int-range-support
+++ a/include/linux/sysctl.h
@@ -47,6 +47,9 @@ extern int proc_douintvec(struct ctl_tab
 			 void __user *, size_t *, loff_t *);
 extern int proc_dointvec_minmax(struct ctl_table *, int,
 				void __user *, size_t *, loff_t *);
+extern int proc_douintvec_minmax(struct ctl_table *table, int write,
+				 void __user *buffer, size_t *lenp,
+				 loff_t *ppos);
 extern int proc_dointvec_jiffies(struct ctl_table *, int,
 				 void __user *, size_t *, loff_t *);
 extern int proc_dointvec_userhz_jiffies(struct ctl_table *, int,
diff -puN kernel/sysctl.c~sysctl-add-unsigned-int-range-support kernel/sysctl.c
--- a/kernel/sysctl.c~sysctl-add-unsigned-int-range-support
+++ a/kernel/sysctl.c
@@ -2567,6 +2567,65 @@ int proc_dointvec_minmax(struct ctl_tabl
 				do_proc_dointvec_minmax_conv, &param);
 }
 
+struct do_proc_douintvec_minmax_conv_param {
+	unsigned int *min;
+	unsigned int *max;
+};
+
+static int do_proc_douintvec_minmax_conv(unsigned long *lvalp,
+					 unsigned int *valp,
+					 int write, void *data)
+{
+	struct do_proc_douintvec_minmax_conv_param *param = data;
+
+	if (write) {
+		unsigned int val = *lvalp;
+
+		if ((param->min && *param->min > val) ||
+		    (param->max && *param->max < val))
+			return -ERANGE;
+
+		if (*lvalp > UINT_MAX)
+			return -EINVAL;
+		*valp = val;
+	} else {
+		unsigned int val = *valp;
+		*lvalp = (unsigned long) val;
+	}
+
+	return 0;
+}
+
+/**
+ * proc_douintvec_minmax - read a vector of unsigned ints with min/max values
+ * @table: the sysctl table
+ * @write: %TRUE if this is a write to the sysctl file
+ * @buffer: the user buffer
+ * @lenp: the size of the user buffer
+ * @ppos: file position
+ *
+ * Reads/writes up to table->maxlen/sizeof(unsigned int) unsigned integer
+ * values from/to the user buffer, treated as an ASCII string. Negative
+ * strings are not allowed.
+ *
+ * This routine will ensure the values are within the range specified by
+ * table->extra1 (min) and table->extra2 (max). There is a final sanity
+ * check for UINT_MAX to avoid having to support wrap around uses from
+ * userspace.
+ *
+ * Returns 0 on success.
+ */
+int proc_douintvec_minmax(struct ctl_table *table, int write,
+			  void __user *buffer, size_t *lenp, loff_t *ppos)
+{
+	struct do_proc_douintvec_minmax_conv_param param = {
+		.min = (unsigned int *) table->extra1,
+		.max = (unsigned int *) table->extra2,
+	};
+	return do_proc_douintvec(table, write, buffer, lenp, ppos,
+				 do_proc_douintvec_minmax_conv, &param);
+}
+
 static void validate_coredump_safety(void)
 {
 #ifdef CONFIG_COREDUMP
@@ -3066,6 +3125,12 @@ int proc_dointvec_minmax(struct ctl_tabl
 	return -ENOSYS;
 }
 
+int proc_douintvec_minmax(struct ctl_table *table, int write,
+			  void __user *buffer, size_t *lenp, loff_t *ppos)
+{
+	return -ENOSYS;
+}
+
 int proc_dointvec_jiffies(struct ctl_table *table, int write,
 		    void __user *buffer, size_t *lenp, loff_t *ppos)
 {
@@ -3108,6 +3173,7 @@ EXPORT_SYMBOL(proc_dointvec);
 EXPORT_SYMBOL(proc_douintvec);
 EXPORT_SYMBOL(proc_dointvec_jiffies);
 EXPORT_SYMBOL(proc_dointvec_minmax);
+EXPORT_SYMBOL_GPL(proc_douintvec_minmax);
 EXPORT_SYMBOL(proc_dointvec_userhz_jiffies);
 EXPORT_SYMBOL(proc_dointvec_ms_jiffies);
 EXPORT_SYMBOL(proc_dostring);
_
