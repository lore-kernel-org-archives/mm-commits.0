From: akpm@linux-foundation.org
Subject: [folded] writeback-make-nr_to_write-a-per-file-limit-fix.patch removed from -mm tree
Date: Tue, 18 Jan 2011 14:05:21 -0800
Message-ID: <201101182205.p0IM5LY8008147@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:49856 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751644Ab1ARWGk (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 18 Jan 2011 17:06:40 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, a.p.zijlstra@chello.nl, axboe@kernel.dk, chris.mason@oracle.com, david@fromorbit.com, fengguang.wu@intel.com, hch@lst.de, jack@suse.cz, kosaki.motohiro@jp.f


The patch titled
     writeback-make-nr_to_write-a-per-file-limit-fix
has been removed from the -mm tree.  Its filename was
     writeback-make-nr_to_write-a-per-file-limit-fix.patch

This patch was dropped because it was folded into writeback-make-nr_to_write-a-per-file-limit.patch

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: writeback-make-nr_to_write-a-per-file-limit-fix
From: Andrew Morton <akpm@linux-foundation.org>

older gcc's are dumb:

fs/fs-writeback.c: In function 'writeback_single_inode':
fs/fs-writeback.c:334: warning: 'nr_to_write' may be used uninitialized in this function

Cc: Chris Mason <chris.mason@oracle.com>
Cc: Christoph Hellwig <hch@lst.de>
Cc: Dave Chinner <david@fromorbit.com>
Cc: Jan Kara <jack@suse.cz>
Cc: Jens Axboe <axboe@kernel.dk>
Cc: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Cc: Li Shaohua <shaohua.li@intel.com>
Cc: Mel Gorman <mel@csn.ul.ie>
Cc: Michael Rubin <mrubin@google.com>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Richard Kennedy <richard@rsk.demon.co.uk>
Cc: Rik van Riel <riel@redhat.com>
Cc: Theodore Ts'o <tytso@mit.edu>
Cc: Wu Fengguang <fengguang.wu@intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/fs-writeback.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN fs/fs-writeback.c~writeback-make-nr_to_write-a-per-file-limit-fix fs/fs-writeback.c
--- a/fs/fs-writeback.c~writeback-make-nr_to_write-a-per-file-limit-fix
+++ a/fs/fs-writeback.c
@@ -331,7 +331,7 @@ writeback_single_inode(struct inode *ino
 {
 	struct address_space *mapping = inode->i_mapping;
 	long per_file_limit = wbc->per_file_limit;
-	long nr_to_write;
+	long uninitialized_var(nr_to_write);
 	unsigned dirty;
 	int ret;
 
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

origin.patch
linux-next.patch
linux-next-git-rejects.patch
next-remove-localversion.patch
i-need-old-gcc.patch
arch-alpha-kernel-systblss-remove-debug-check.patch
arch-alpha-include-asm-ioh-s-extern-inline-static-inline.patch
mm-vmap-area-cache.patch
drivers-gpu-drm-radeon-atomc-fix-warning.patch
leds-route-kbd-leds-through-the-generic-leds-layer.patch
drivers-message-fusion-mptsasc-fix-warning.patch
mm.patch
writeback-make-nr_to_write-a-per-file-limit.patch
mm-deactivate-invalidated-pages.patch
frv-duplicate-output_buffer-of-e03-checkpatch-fixes.patch
hpet-factor-timer-allocate-from-open.patch
lib-hexdumpc-make-hex2bin-return-the-updated-src-address.patch
fs-binfmt_miscc-use-kernels-hex_to_bin-method-fix.patch
fs-binfmt_miscc-use-kernels-hex_to_bin-method-fix-fix.patch
exec_domain-establish-a-linux32-domain-on-config_compat-systems.patch
scatterlist-new-helper-functions-fix.patch
journal_add_journal_head-debug.patch
slab-leaks3-default-y.patch
put_bh-debug.patch
memblock-add-input-size-checking-to-memblock_find_region.patch
memblock-add-input-size-checking-to-memblock_find_region-fix.patch

