From: akpm@linux-foundation.org
Subject: [patch 03/12] sysctl: handle error writing UINT_MAX to u32 fields
Date: Thu, 25 Aug 2016 15:16:51 -0700
Message-ID: <57bf6e53.POzoiQFFosIGYM8g%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:59010 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1757783AbcHYWRp (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 25 Aug 2016 18:17:45 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: torvalds@linux-foundation.org, mm-commits@vger.kernel.org, akpm@linux-foundation.org, subashab@codeaurora.org, davem@davemloft.net, keescook@chromium.org, mingo@redhat.com, xypron.glpk@gmx.de

From: Subash Abhinov Kasiviswanathan <subashab@codeaurora.org>
Subject: sysctl: handle error writing UINT_MAX to u32 fields

We have scripts which write to certain fields on 3.18 kernels but this
seems to be failing on 4.4 kernels.  An entry which we write to here is
xfrm_aevent_rseqth which is u32.

echo 4294967295  > /proc/sys/net/core/xfrm_aevent_rseqth

Commit 230633d109e3 ("kernel/sysctl.c: detect overflows when converting to
int") prevented writing to sysctl entries when integer overflow occurs. 
However, this does not apply to unsigned integers.

Heinrich suggested that we introduce a new option to handle 64 bit limits
and set min as 0 and max as UINT_MAX.  This might not work as it leads to
issues similar to __do_proc_doulongvec_minmax.  Alternatively, we would
need to change the datatype of the entry to 64 bit.

static int __do_proc_doulongvec_minmax(void *data, struct ctl_table
{
    i = (unsigned long *) data;   //This cast is causing to
read beyond the size of data (u32)
    vleft = table->maxlen / sizeof(unsigned long); //vleft is 0
because maxlen is sizeof(u32) which is lesser than sizeof(unsigned
long) on x86_64.

Introduce a new proc handler proc_douintvec.  Individual proc entries will
need to be updated to use the new handler.

[akpm@linux-foundation.org: coding-style fixes]
Fixes: 230633d109e3 ("kernel/sysctl.c:detect overflows when converting to int")
Link: http://lkml.kernel.org/r/1471479806-5252-1-git-send-email-subashab@codeaurora.org
Signed-off-by: Subash Abhinov Kasiviswanathan <subashab@codeaurora.org>
Cc: Heinrich Schuchardt <xypron.glpk@gmx.de>
Cc: Kees Cook <keescook@chromium.org>
Cc: "David S. Miller" <davem@davemloft.net>
Cc: Ingo Molnar <mingo@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/sysctl.h |    2 +
 kernel/sysctl.c        |   45 +++++++++++++++++++++++++++++++++++++--
 2 files changed, 45 insertions(+), 2 deletions(-)

diff -puN include/linux/sysctl.h~sysctl-handle-error-writing-uint_max-to-u32-fields include/linux/sysctl.h
--- a/include/linux/sysctl.h~sysctl-handle-error-writing-uint_max-to-u32-fields
+++ a/include/linux/sysctl.h
@@ -42,6 +42,8 @@ extern int proc_dostring(struct ctl_tabl
 			 void __user *, size_t *, loff_t *);
 extern int proc_dointvec(struct ctl_table *, int,
 			 void __user *, size_t *, loff_t *);
+extern int proc_douintvec(struct ctl_table *, int,
+			 void __user *, size_t *, loff_t *);
 extern int proc_dointvec_minmax(struct ctl_table *, int,
 				void __user *, size_t *, loff_t *);
 extern int proc_dointvec_jiffies(struct ctl_table *, int,
diff -puN kernel/sysctl.c~sysctl-handle-error-writing-uint_max-to-u32-fields kernel/sysctl.c
--- a/kernel/sysctl.c~sysctl-handle-error-writing-uint_max-to-u32-fields
+++ a/kernel/sysctl.c
@@ -2140,6 +2140,21 @@ static int do_proc_dointvec_conv(bool *n
 	return 0;
 }
 
+static int do_proc_douintvec_conv(bool *negp, unsigned long *lvalp,
+				 int *valp,
+				 int write, void *data)
+{
+	if (write) {
+		if (*negp)
+			return -EINVAL;
+		*valp = *lvalp;
+	} else {
+		unsigned int val = *valp;
+		*lvalp = (unsigned long)val;
+	}
+	return 0;
+}
+
 static const char proc_wspace_sep[] = { ' ', '\t', '\n' };
 
 static int __do_proc_dointvec(void *tbl_data, struct ctl_table *table,
@@ -2259,8 +2274,27 @@ static int do_proc_dointvec(struct ctl_t
 int proc_dointvec(struct ctl_table *table, int write,
 		     void __user *buffer, size_t *lenp, loff_t *ppos)
 {
-    return do_proc_dointvec(table,write,buffer,lenp,ppos,
-		    	    NULL,NULL);
+	return do_proc_dointvec(table, write, buffer, lenp, ppos, NULL, NULL);
+}
+
+/**
+ * proc_douintvec - read a vector of unsigned integers
+ * @table: the sysctl table
+ * @write: %TRUE if this is a write to the sysctl file
+ * @buffer: the user buffer
+ * @lenp: the size of the user buffer
+ * @ppos: file position
+ *
+ * Reads/writes up to table->maxlen/sizeof(unsigned int) unsigned integer
+ * values from/to the user buffer, treated as an ASCII string.
+ *
+ * Returns 0 on success.
+ */
+int proc_douintvec(struct ctl_table *table, int write,
+		     void __user *buffer, size_t *lenp, loff_t *ppos)
+{
+	return do_proc_dointvec(table, write, buffer, lenp, ppos,
+				do_proc_douintvec_conv, NULL);
 }
 
 /*
@@ -2858,6 +2892,12 @@ int proc_dointvec(struct ctl_table *tabl
 	return -ENOSYS;
 }
 
+int proc_douintvec(struct ctl_table *table, int write,
+		  void __user *buffer, size_t *lenp, loff_t *ppos)
+{
+	return -ENOSYS;
+}
+
 int proc_dointvec_minmax(struct ctl_table *table, int write,
 		    void __user *buffer, size_t *lenp, loff_t *ppos)
 {
@@ -2903,6 +2943,7 @@ int proc_doulongvec_ms_jiffies_minmax(st
  * exception granted :-)
  */
 EXPORT_SYMBOL(proc_dointvec);
+EXPORT_SYMBOL(proc_douintvec);
 EXPORT_SYMBOL(proc_dointvec_jiffies);
 EXPORT_SYMBOL(proc_dointvec_minmax);
 EXPORT_SYMBOL(proc_dointvec_userhz_jiffies);
_
