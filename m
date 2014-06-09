From: akpm@linux-foundation.org
Subject: [merged] fs-hfsplus-wrapperc-replace-shift-loop-by-ilog2.patch
 removed from -mm tree
Date: Mon, 09 Jun 2014 12:32:17 -0700
Message-ID: <53960bc1.E6VOR+Pu4+0jqaaf%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:53935 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750822AbaFITcR (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 9 Jun 2014 15:32:17 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, slava@dubeyko.com, joe@perches.com, fabf@skynet.be

Subject: [merged] fs-hfsplus-wrapperc-replace-shift-loop-by-ilog2.patch removed from -mm tree
To: fabf@skynet.be,joe@perches.com,slava@dubeyko.com,mm-commits@vger.kernel.org
From: akpm@linux-foundation.org
Date: Mon, 09 Jun 2014 12:32:17 -0700


The patch titled
     Subject: fs/hfsplus/wrapper.c: replace shift loop by ilog2
has been removed from the -mm tree.  Its filename was
     fs-hfsplus-wrapperc-replace-shift-loop-by-ilog2.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Fabian Frederick <fabf@skynet.be>
Subject: fs/hfsplus/wrapper.c: replace shift loop by ilog2

Replace while blocksize;shift by ilog2

Signed-off-by: Fabian Frederick <fabf@skynet.be>
Cc: Vyacheslav Dubeyko <slava@dubeyko.com>
Cc: Joe Perches <joe@perches.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/hfsplus/wrapper.c |    4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

diff -puN fs/hfsplus/wrapper.c~fs-hfsplus-wrapperc-replace-shift-loop-by-ilog2 fs/hfsplus/wrapper.c
--- a/fs/hfsplus/wrapper.c~fs-hfsplus-wrapperc-replace-shift-loop-by-ilog2
+++ a/fs/hfsplus/wrapper.c
@@ -231,9 +231,7 @@ reread:
 	if (blocksize < HFSPLUS_SECTOR_SIZE || ((blocksize - 1) & blocksize))
 		goto out_free_backup_vhdr;
 	sbi->alloc_blksz = blocksize;
-	sbi->alloc_blksz_shift = 0;
-	while ((blocksize >>= 1) != 0)
-		sbi->alloc_blksz_shift++;
+	sbi->alloc_blksz_shift = ilog2(blocksize);
 	blocksize = min_t(u32, sbi->alloc_blksz, PAGE_SIZE);
 
 	/*
_

Patches currently in -mm which might be from fabf@skynet.be are

origin.patch
fs-cifs-remove-obsolete-__constant.patch
kernel-posix-timersc-code-clean-up.patch
kernel-posix-timersc-code-clean-up-checkpatch-fixes.patch
fs-ext4-fsyncc-generic_file_fsync-call-based-on-barrier-flag.patch
fs-isofs-logging-clean-up.patch
linux-next.patch
kernel-watchdogc-convert-printk-pr_warning-to-pr_foo.patch
init-mainc-code-clean-up.patch
kernel-kprobesc-convert-printk-to-pr_foo.patch

