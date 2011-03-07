From: akpm@linux-foundation.org
Subject: + sysctl-add-proc_dointvec_bool-handler.patch added to -mm tree
Date: Mon, 07 Mar 2011 15:05:39 -0800
Message-ID: <201103072305.p27N5dCQ000465@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:42012 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756385Ab1CGXPV (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 7 Mar 2011 18:15:21 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: hidave.darkstar@gmail.com, adobriyan@gmail.com, ebiederm@xmission.com


The patch titled
     sysctl: add proc_dointvec_bool() handler
has been added to the -mm tree.  Its filename is
     sysctl-add-proc_dointvec_bool-handler.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://userweb.kernel.org/~akpm/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: sysctl: add proc_dointvec_bool() handler
From: Dave Young <hidave.darkstar@gmail.com>

Add a proc_dointvec_bool() sysctl handler for cases where the input value
is limited to 0 and 1.

Signed-off-by: Dave Young <hidave.darkstar@gmail.com>
Cc: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: Alexey Dobriyan <adobriyan@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/sysctl.h |    2 ++
 kernel/sysctl.c        |   27 +++++++++++++++++++++++++++
 2 files changed, 29 insertions(+)

diff -puN include/linux/sysctl.h~sysctl-add-proc_dointvec_bool-handler include/linux/sysctl.h
--- a/include/linux/sysctl.h~sysctl-add-proc_dointvec_bool-handler
+++ a/include/linux/sysctl.h
@@ -970,6 +970,8 @@ extern int proc_dointvec(struct ctl_tabl
 			 void __user *, size_t *, loff_t *);
 extern int proc_dointvec_minmax(struct ctl_table *, int,
 				void __user *, size_t *, loff_t *);
+extern int proc_dointvec_bool(struct ctl_table *, int,
+				void __user *, size_t *, loff_t *);
 extern int proc_dointvec_jiffies(struct ctl_table *, int,
 				 void __user *, size_t *, loff_t *);
 extern int proc_dointvec_userhz_jiffies(struct ctl_table *, int,
diff -puN kernel/sysctl.c~sysctl-add-proc_dointvec_bool-handler kernel/sysctl.c
--- a/kernel/sysctl.c~sysctl-add-proc_dointvec_bool-handler
+++ a/kernel/sysctl.c
@@ -2436,6 +2436,33 @@ int proc_dointvec_minmax(struct ctl_tabl
 				do_proc_dointvec_minmax_conv, &param);
 }
 
+/**
+ * proc_dointvec_bool - read a vector of integers with 0/1 values
+ * @table: the sysctl table
+ * @write: %TRUE if this is a write to the sysctl file
+ * @buffer: the user buffer
+ * @lenp: the size of the user buffer
+ * @ppos: file position
+ *
+ * Reads/writes up to table->maxlen/sizeof(unsigned int) integer
+ * values from/to the user buffer, treated as an ASCII string.
+ *
+ * This routine will ensure the values are either 0 or 1.
+ *
+ * Returns 0 on success.
+ */
+int proc_dointvec_bool(struct ctl_table *table, int write,
+		  void __user *buffer, size_t *lenp, loff_t *ppos)
+{
+	struct do_proc_dointvec_minmax_conv_param param = {
+		.min = &zero,
+		.max = &one,
+	};
+	return do_proc_dointvec(table, write, buffer, lenp, ppos,
+				do_proc_dointvec_minmax_conv, &param);
+}
+EXPORT_SYMBOL(proc_dointvec_bool);
+
 static int __do_proc_doulongvec_minmax(void *data, struct ctl_table *table, int write,
 				     void __user *buffer,
 				     size_t *lenp, loff_t *ppos,
_

Patches currently in -mm which might be from hidave.darkstar@gmail.com are

sysctl-add-proc_dointvec_bool-handler.patch
sysctl-use-proc_dointvec_bool-where-appropriate.patch
sysctl-add-proc_dointvec_unsigned-handler.patch
sysctl-use-proc_dointvec_unsigned-where-appropriate.patch

