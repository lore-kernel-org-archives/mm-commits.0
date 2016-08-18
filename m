From: akpm@linux-foundation.org
Subject: + sysctl-handle-error-writing-uint_max-to-u32-fields.patch added
 to -mm tree
Date: Thu, 18 Aug 2016 15:01:04 -0700
Message-ID: <57b63020.ZJUQ2VUkNIBAck5J%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:50510 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753736AbcHSBGy (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 18 Aug 2016 21:06:54 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: subashab@codeaurora.org, davem@davemloft.net, keescook@chromium.org, mingo@redhat.com, xypron.glpk@gmx.de, mm-commits@vger.kernel.org


The patch titled
     Subject: sysctl: handle error writing UINT_MAX to u32 fields
has been added to the -mm tree.  Its filename is
     sysctl-handle-error-writing-uint_max-to-u32-fields.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/sysctl-handle-error-writing-uint_max-to-u32-fields.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/sysctl-handle-error-writing-uint_max-to-u32-fields.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
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
 kernel/sysctl.c        |   42 +++++++++++++++++++++++++++++++++++++++
 2 files changed, 44 insertions(+)

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
@@ -2263,6 +2278,26 @@ int proc_dointvec(struct ctl_table *tabl
 		    	    NULL,NULL);
 }
 
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
+    return do_proc_dointvec(table,write,buffer,lenp,ppos,
+			    do_proc_douintvec_conv, NULL);
+}
+
 /*
  * Taint values can only be increased
  * This means we can safely use a temporary.
@@ -2858,6 +2893,12 @@ int proc_dointvec(struct ctl_table *tabl
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
@@ -2903,6 +2944,7 @@ int proc_doulongvec_ms_jiffies_minmax(st
  * exception granted :-)
  */
 EXPORT_SYMBOL(proc_dointvec);
+EXPORT_SYMBOL(proc_douintvec);
 EXPORT_SYMBOL(proc_dointvec_jiffies);
 EXPORT_SYMBOL(proc_dointvec_minmax);
 EXPORT_SYMBOL(proc_dointvec_userhz_jiffies);
_

Patches currently in -mm which might be from subashab@codeaurora.org are

sysctl-handle-error-writing-uint_max-to-u32-fields.patch

