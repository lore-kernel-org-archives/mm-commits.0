From: akpm@linux-foundation.org
Subject: [to-be-updated] sysctl-add-proc_dointvec_unsigned-handler.patch removed from -mm tree
Date: Thu, 18 Aug 2011 14:52:33 -0700
Message-ID: <201108182152.p7ILqXjb029860@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:56308 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754496Ab1HRVwe (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 18 Aug 2011 17:52:34 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: hidave.darkstar@gmail.com, adobriyan@gmail.com, ebiederm@xmission.com, mm-commits@vger.kernel.org


The patch titled
     sysctl: add proc_dointvec_unsigned() handler
has been removed from the -mm tree.  Its filename was
     sysctl-add-proc_dointvec_unsigned-handler.patch

This patch was dropped because an updated version will be merged

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: sysctl: add proc_dointvec_unsigned() handler
From: Dave Young <hidave.darkstar@gmail.com>

Add a proc_dointvec_unsigned() sysctl handler for positive value cases.

Signed-off-by: Dave Young <hidave.darkstar@gmail.com>
Cc: Alexey Dobriyan <adobriyan@gmail.com>
Cc: "Eric W. Biederman" <ebiederm@xmission.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/sysctl.h |    2 ++
 kernel/sysctl.c        |   26 ++++++++++++++++++++++++++
 2 files changed, 28 insertions(+)

diff -puN include/linux/sysctl.h~sysctl-add-proc_dointvec_unsigned-handler include/linux/sysctl.h
--- a/include/linux/sysctl.h~sysctl-add-proc_dointvec_unsigned-handler
+++ a/include/linux/sysctl.h
@@ -973,6 +973,8 @@ extern int proc_dointvec_minmax(struct c
 				void __user *, size_t *, loff_t *);
 extern int proc_dointvec_bool(struct ctl_table *, int,
 				void __user *, size_t *, loff_t *);
+extern int proc_dointvec_unsigned(struct ctl_table *, int,
+				void __user *, size_t *, loff_t *);
 extern int proc_dointvec_jiffies(struct ctl_table *, int,
 				 void __user *, size_t *, loff_t *);
 extern int proc_dointvec_userhz_jiffies(struct ctl_table *, int,
diff -puN kernel/sysctl.c~sysctl-add-proc_dointvec_unsigned-handler kernel/sysctl.c
--- a/kernel/sysctl.c~sysctl-add-proc_dointvec_unsigned-handler
+++ a/kernel/sysctl.c
@@ -2490,6 +2490,32 @@ int proc_dointvec_bool(struct ctl_table 
 }
 EXPORT_SYMBOL(proc_dointvec_bool);
 
+/**
+ * proc_dointvec_unsigned - read a vector of integers with positive values
+ * @table: the sysctl table
+ * @write: %TRUE if this is a write to the sysctl file
+ * @buffer: the user buffer
+ * @lenp: the size of the user buffer
+ * @ppos: file position
+ *
+ * Reads/writes up to table->maxlen/sizeof(unsigned int) integer
+ * values from/to the user buffer, treated as an ASCII string.
+ *
+ * This routine will ensure the values are positive.
+ *
+ * Returns 0 on success.
+ */
+int proc_dointvec_unsigned(struct ctl_table *table, int write,
+		  void __user *buffer, size_t *lenp, loff_t *ppos)
+{
+	struct do_proc_dointvec_minmax_conv_param param = {
+		.min = &zero,
+	};
+	return do_proc_dointvec(table, write, buffer, lenp, ppos,
+				do_proc_dointvec_minmax_conv, &param);
+}
+EXPORT_SYMBOL(proc_dointvec_unsigned);
+
 static int __do_proc_doulongvec_minmax(void *data, struct ctl_table *table, int write,
 				     void __user *buffer,
 				     size_t *lenp, loff_t *ppos,
_

Patches currently in -mm which might be from hidave.darkstar@gmail.com are

sysctl-add-proc_dointvec_unsigned-handler-update.patch
sysctl-use-proc_dointvec_unsigned-where-appropriate.patch

