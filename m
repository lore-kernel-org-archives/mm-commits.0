From: akpm@linux-foundation.org
Subject: [merged]
 kernel-gcov-fsc-remove-unnecessary-null-test-before-debugfs_remove.patch
 removed from -mm tree
Date: Tue, 12 Aug 2014 12:40:40 -0700
Message-ID: <53ea6db8.WlY2R0Y5mwUCq3CX%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-pd0-f202.google.com ([209.85.192.202]:51742 "EHLO
	mail-pd0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754953AbaHLTkk (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 12 Aug 2014 15:40:40 -0400
Received: by mail-pd0-f202.google.com with SMTP id w10so2670954pde.1
        for <mm-commits@vger.kernel.org>; Tue, 12 Aug 2014 12:40:40 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: fabf@skynet.be, oberpar@linux.vnet.ibm.com, mm-commits@vger.kernel.org


The patch titled
     Subject: kernel/gcov/fs.c: remove unnecessary null test before debugfs_remove
has been removed from the -mm tree.  Its filename was
     kernel-gcov-fsc-remove-unnecessary-null-test-before-debugfs_remove.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Fabian Frederick <fabf@skynet.be>
Subject: kernel/gcov/fs.c: remove unnecessary null test before debugfs_remove

This fixes checkpatch warning:

"WARNING: debugfs_remove(NULL) is safe this check is probably not required"

Signed-off-by: Fabian Frederick <fabf@skynet.be>
Cc: Peter Oberparleiter <oberpar@linux.vnet.ibm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/gcov/fs.c |    3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff -puN kernel/gcov/fs.c~kernel-gcov-fsc-remove-unnecessary-null-test-before-debugfs_remove kernel/gcov/fs.c
--- a/kernel/gcov/fs.c~kernel-gcov-fsc-remove-unnecessary-null-test-before-debugfs_remove
+++ a/kernel/gcov/fs.c
@@ -784,8 +784,7 @@ static __init int gcov_fs_init(void)
 
 err_remove:
 	pr_err("init failed\n");
-	if (root_node.dentry)
-		debugfs_remove(root_node.dentry);
+	debugfs_remove(root_node.dentry);
 
 	return rc;
 }
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

