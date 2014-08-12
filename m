From: akpm@linux-foundation.org
Subject: [merged] proc-constify-seq_operations.patch removed from -mm tree
Date: Tue, 12 Aug 2014 12:39:46 -0700
Message-ID: <53ea6d82.U0wj5ld3sCfvJhpv%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-qa0-f73.google.com ([209.85.216.73]:46573 "EHLO
	mail-qa0-f73.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754734AbaHLTjr (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 12 Aug 2014 15:39:47 -0400
Received: by mail-qa0-f73.google.com with SMTP id s7so1311974qap.4
        for <mm-commits@vger.kernel.org>; Tue, 12 Aug 2014 12:39:46 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: fabf@skynet.be, joe@perches.com, mm-commits@vger.kernel.org


The patch titled
     Subject: proc: constify seq_operations
has been removed from the -mm tree.  Its filename was
     proc-constify-seq_operations.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Fabian Frederick <fabf@skynet.be>
Subject: proc: constify seq_operations

proc_uid_seq_operations, proc_gid_seq_operations and
proc_projid_seq_operations are only called in proc_id_map_open with
seq_open as const struct seq_operations so we can constify the 3
structures and update proc_id_map_open prototype.

   text    data     bss     dec     hex filename
   6817     404    1984    9205    23f5 kernel/user_namespace.o-before
   6913     308    1984    9205    23f5 kernel/user_namespace.o-after

Signed-off-by: Fabian Frederick <fabf@skynet.be>
Cc: Joe Perches <joe@perches.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/proc/base.c                 |    2 +-
 include/linux/user_namespace.h |    6 +++---
 kernel/user_namespace.c        |    6 +++---
 3 files changed, 7 insertions(+), 7 deletions(-)

diff -puN fs/proc/base.c~proc-constify-seq_operations fs/proc/base.c
--- a/fs/proc/base.c~proc-constify-seq_operations
+++ a/fs/proc/base.c
@@ -2449,7 +2449,7 @@ static int proc_tgid_io_accounting(struc
 
 #ifdef CONFIG_USER_NS
 static int proc_id_map_open(struct inode *inode, struct file *file,
-	struct seq_operations *seq_ops)
+	const struct seq_operations *seq_ops)
 {
 	struct user_namespace *ns = NULL;
 	struct task_struct *task;
diff -puN include/linux/user_namespace.h~proc-constify-seq_operations include/linux/user_namespace.h
--- a/include/linux/user_namespace.h~proc-constify-seq_operations
+++ a/include/linux/user_namespace.h
@@ -57,9 +57,9 @@ static inline void put_user_ns(struct us
 }
 
 struct seq_operations;
-extern struct seq_operations proc_uid_seq_operations;
-extern struct seq_operations proc_gid_seq_operations;
-extern struct seq_operations proc_projid_seq_operations;
+extern const struct seq_operations proc_uid_seq_operations;
+extern const struct seq_operations proc_gid_seq_operations;
+extern const struct seq_operations proc_projid_seq_operations;
 extern ssize_t proc_uid_map_write(struct file *, const char __user *, size_t, loff_t *);
 extern ssize_t proc_gid_map_write(struct file *, const char __user *, size_t, loff_t *);
 extern ssize_t proc_projid_map_write(struct file *, const char __user *, size_t, loff_t *);
diff -puN kernel/user_namespace.c~proc-constify-seq_operations kernel/user_namespace.c
--- a/kernel/user_namespace.c~proc-constify-seq_operations
+++ a/kernel/user_namespace.c
@@ -526,21 +526,21 @@ static void m_stop(struct seq_file *seq,
 	return;
 }
 
-struct seq_operations proc_uid_seq_operations = {
+const struct seq_operations proc_uid_seq_operations = {
 	.start = uid_m_start,
 	.stop = m_stop,
 	.next = m_next,
 	.show = uid_m_show,
 };
 
-struct seq_operations proc_gid_seq_operations = {
+const struct seq_operations proc_gid_seq_operations = {
 	.start = gid_m_start,
 	.stop = m_stop,
 	.next = m_next,
 	.show = gid_m_show,
 };
 
-struct seq_operations proc_projid_seq_operations = {
+const struct seq_operations proc_projid_seq_operations = {
 	.start = projid_m_start,
 	.stop = m_stop,
 	.next = m_next,
_

Patches currently in -mm which might be from fabf@skynet.be are

origin.patch
fs-cifs-remove-obsolete-__constant.patch
fs-cifs-filec-replace-countsize-kzalloc-by-kcalloc.patch
fs-cifs-smb2filec-replace-countsize-kzalloc-by-kcalloc.patch
fs-ext4-fsyncc-generic_file_fsync-call-based-on-barrier-flag.patch
fs-isofs-logging-clean-up.patch
fs-isofs-logging-clean-up-fix.patch
linux-next.patch
kernel-posix-timersc-code-clean-up.patch
kernel-posix-timersc-code-clean-up-checkpatch-fixes.patch
kernel-kprobesc-convert-printk-to-pr_foo.patch

