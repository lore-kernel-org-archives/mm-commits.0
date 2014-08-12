From: akpm@linux-foundation.org
Subject: [merged]
 fs-dlm-debug_fsc-remove-unnecessary-null-test-before-debugfs_remove.patch
 removed from -mm tree
Date: Tue, 12 Aug 2014 12:41:48 -0700
Message-ID: <53ea6dfc.+5kEQKYL5Onp2Jnc%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-oi0-f74.google.com ([209.85.218.74]:38514 "EHLO
	mail-oi0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754855AbaHLTlt (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 12 Aug 2014 15:41:49 -0400
Received: by mail-oi0-f74.google.com with SMTP id a141so1911172oig.1
        for <mm-commits@vger.kernel.org>; Tue, 12 Aug 2014 12:41:48 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: fabf@skynet.be, ccaulfie@redhat.com, mm-commits@vger.kernel.org


The patch titled
     Subject: fs/dlm/debug_fs.c: remove unnecessary null test before debugfs_remove
has been removed from the -mm tree.  Its filename was
     fs-dlm-debug_fsc-remove-unnecessary-null-test-before-debugfs_remove.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Fabian Frederick <fabf@skynet.be>
Subject: fs/dlm/debug_fs.c: remove unnecessary null test before debugfs_remove

This fixes checkpatch warning:

"WARNING: debugfs_remove(NULL) is safe this check is probably not required"

Signed-off-by: Fabian Frederick <fabf@skynet.be>
Cc: Christine Caulfield <ccaulfie@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/dlm/debug_fs.c |   15 +++++----------
 1 file changed, 5 insertions(+), 10 deletions(-)

diff -puN fs/dlm/debug_fs.c~fs-dlm-debug_fsc-remove-unnecessary-null-test-before-debugfs_remove fs/dlm/debug_fs.c
--- a/fs/dlm/debug_fs.c~fs-dlm-debug_fsc-remove-unnecessary-null-test-before-debugfs_remove
+++ a/fs/dlm/debug_fs.c
@@ -718,16 +718,11 @@ static const struct file_operations wait
 
 void dlm_delete_debug_file(struct dlm_ls *ls)
 {
-	if (ls->ls_debug_rsb_dentry)
-		debugfs_remove(ls->ls_debug_rsb_dentry);
-	if (ls->ls_debug_waiters_dentry)
-		debugfs_remove(ls->ls_debug_waiters_dentry);
-	if (ls->ls_debug_locks_dentry)
-		debugfs_remove(ls->ls_debug_locks_dentry);
-	if (ls->ls_debug_all_dentry)
-		debugfs_remove(ls->ls_debug_all_dentry);
-	if (ls->ls_debug_toss_dentry)
-		debugfs_remove(ls->ls_debug_toss_dentry);
+	debugfs_remove(ls->ls_debug_rsb_dentry);
+	debugfs_remove(ls->ls_debug_waiters_dentry);
+	debugfs_remove(ls->ls_debug_locks_dentry);
+	debugfs_remove(ls->ls_debug_all_dentry);
+	debugfs_remove(ls->ls_debug_toss_dentry);
 }
 
 int dlm_create_debug_file(struct dlm_ls *ls)
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

