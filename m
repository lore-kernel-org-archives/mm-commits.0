From: akpm@linux-foundation.org
Subject: [merged]
 fs-ramfs-file-nommuc-replace-countsize-kzalloc-by-kcalloc.patch removed
 from -mm tree
Date: Tue, 12 Aug 2014 12:38:16 -0700
Message-ID: <53ea6d28.bTpLCzNGH8tW7Kdu%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-oa0-f74.google.com ([209.85.219.74]:37267 "EHLO
	mail-oa0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754794AbaHLTiS (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 12 Aug 2014 15:38:18 -0400
Received: by mail-oa0-f74.google.com with SMTP id eb12so1918785oac.3
        for <mm-commits@vger.kernel.org>; Tue, 12 Aug 2014 12:38:16 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: fabf@skynet.be, axel.lin@ingics.com, mm-commits@vger.kernel.org


The patch titled
     Subject: fs/ramfs/file-nommu.c: replace count*size kzalloc by kcalloc
has been removed from the -mm tree.  Its filename was
     fs-ramfs-file-nommuc-replace-countsize-kzalloc-by-kcalloc.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Fabian Frederick <fabf@skynet.be>
Subject: fs/ramfs/file-nommu.c: replace count*size kzalloc by kcalloc

Signed-off-by: Fabian Frederick <fabf@skynet.be>
Cc: Axel Lin <axel.lin@ingics.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/ramfs/file-nommu.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN fs/ramfs/file-nommu.c~fs-ramfs-file-nommuc-replace-countsize-kzalloc-by-kcalloc fs/ramfs/file-nommu.c
--- a/fs/ramfs/file-nommu.c~fs-ramfs-file-nommuc-replace-countsize-kzalloc-by-kcalloc
+++ a/fs/ramfs/file-nommu.c
@@ -222,7 +222,7 @@ static unsigned long ramfs_nommu_get_unm
 
 	/* gang-find the pages */
 	ret = -ENOMEM;
-	pages = kzalloc(lpages * sizeof(struct page *), GFP_KERNEL);
+	pages = kcalloc(lpages, sizeof(struct page *), GFP_KERNEL);
 	if (!pages)
 		goto out_free;
 
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

