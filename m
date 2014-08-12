From: akpm@linux-foundation.org
Subject: [folded-merged] fs-isofs-logging-clean-up-fix.patch removed from
 -mm tree
Date: Tue, 12 Aug 2014 13:34:05 -0700
Message-ID: <53ea7a3d.WOq5MZvUnZqhi1wS%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-yh0-f73.google.com ([209.85.213.73]:50403 "EHLO
	mail-yh0-f73.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754021AbaHLUeG (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 12 Aug 2014 16:34:06 -0400
Received: by mail-yh0-f73.google.com with SMTP id f73so1313849yha.2
        for <mm-commits@vger.kernel.org>; Tue, 12 Aug 2014 13:34:05 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, fabf@skynet.be, mm-commits@vger.kernel.org


The patch titled
     Subject: fs-isofs-logging-clean-up-fix
has been removed from the -mm tree.  Its filename was
     fs-isofs-logging-clean-up-fix.patch

This patch was dropped because it was folded into fs-isofs-logging-clean-up.patch

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: fs-isofs-logging-clean-up-fix

118-column lines make my eyes bleed.

Cc: Fabian Frederick <fabf@skynet.be>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/isofs/compress.c |   13 +++++++++----
 1 file changed, 9 insertions(+), 4 deletions(-)

diff -puN fs/isofs/compress.c~fs-isofs-logging-clean-up-fix fs/isofs/compress.c
--- a/fs/isofs/compress.c~fs-isofs-logging-clean-up-fix
+++ a/fs/isofs/compress.c
@@ -156,10 +156,15 @@ static loff_t zisofs_uncompress_block(st
 				if (zerr == Z_MEM_ERROR)
 					*errp = -ENOMEM;
 				else {
-					pr_debug("zisofs_inflate returned %d, inode = %lu, page idx = %d, bh idx = %d, avail_in = %ld, avail_out = %ld\n",
-						 zerr, inode->i_ino, curpage,
-						 curbh, stream.avail_in,
-						 stream.avail_out);
+					pr_debug(
+					       "zisofs: zisofs_inflate returned"
+					       " %d, inode = %lu,"
+					       " page idx = %d, bh idx = %d,"
+					       " avail_in = %ld,"
+					       " avail_out = %ld\n",
+					       zerr, inode->i_ino, curpage,
+					       curbh, stream.avail_in,
+					       stream.avail_out);
 					*errp = -EIO;
 				}
 				goto inflate_out;
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

origin.patch
i-need-old-gcc.patch
arch-alpha-kernel-systblss-remove-debug-check.patch
maintainers-akpm-maintenance.patch
kernel-posix-timersc-code-clean-up-checkpatch-fixes.patch
input-route-kbd-leds-through-the-generic-leds-layer.patch
ocfs2-free-inode-when-i_count-becomes-zero.patch
mm.patch
mm-hugetlb-remove-unused-argument-of-follow_huge_pmdpud.patch
mm-introduce-do_shared_fault-and-drop-do_fault-fix-fix.patch
mm-compactionc-isolate_freepages_block-small-tuneup.patch
do_shared_fault-check-that-mmap_sem-is-held.patch
fs-isofs-logging-clean-up.patch
linux-next.patch
drivers-gpio-gpio-zevioc-fix-build.patch
mm-replace-remap_file_pages-syscall-with-emulation-fix.patch
debugging-keep-track-of-page-owners.patch
journal_add_journal_head-debug.patch
journal_add_journal_head-debug-fix.patch
kernel-forkc-export-kernel_thread-to-modules.patch
mutex-subsystem-synchro-test-module.patch
slab-leaks3-default-y.patch
put_bh-debug.patch

