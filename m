From: akpm@linux-foundation.org
Subject: [folded] nilfs2-segment-buffer-fix.patch removed from -mm tree
Date: Mon, 06 Apr 2009 15:35:34 -0700
Message-ID: <200904062235.n36MZZNK018192@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:33224 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752899AbZDFWh4 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 6 Apr 2009 18:37:56 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, jens.axboe@oracle.com, konishi.ryusuke@lab.ntt.co.jp, mm-commits@vger.kernel.org


The patch titled
     nilfs2-segment-buffer-fix
has been removed from the -mm tree.  Its filename was
     nilfs2-segment-buffer-fix.patch

This patch was dropped because it was folded into nilfs2-segment-buffer.patch

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: nilfs2-segment-buffer-fix
From: Andrew Morton <akpm@linux-foundation.org>

BIO_RW_SYNC got removed.  Hope this is right..

Cc: Ryusuke Konishi <konishi.ryusuke@lab.ntt.co.jp>
Cc: Jens Axboe <jens.axboe@oracle.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/nilfs2/segbuf.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN fs/nilfs2/segbuf.c~nilfs2-segment-buffer-fix fs/nilfs2/segbuf.c
--- a/fs/nilfs2/segbuf.c~nilfs2-segment-buffer-fix
+++ a/fs/nilfs2/segbuf.c
@@ -416,7 +416,7 @@ int nilfs_segbuf_write(struct nilfs_segm
 		 * Last BIO is always sent through the following
 		 * submission.
 		 */
-		rw |= (1 << BIO_RW_SYNC);
+		rw |= (1 << BIO_RW_SYNCIO);
 		res = nilfs_submit_seg_bio(wi, rw);
 		if (unlikely(res))
 			goto failed_bio;
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

origin.patch
mm-add-proc-controls-for-pdflush-threads.patch
proc-pid-maps-dont-show-pgoff-of-pure-anon-vmas.patch
namespaces-mqueue-namespace-adapt-sysctl.patch
nilfs2-integrated-block-mapping.patch
vfs-simple_set_mnt-should-return-void-fix-nilfs.patch
nilfs2-segment-buffer.patch
nilfs2-segment-buffer-fix.patch
reiser4-export-remove_from_page_cache-fix.patch
reiser4.patch
reiser4-remove-simple_prepare_write-usage-checkpatch-fixes.patch
slab-leaks3-default-y.patch
put_bh-debug.patch
shrink_slab-handle-bad-shrinkers.patch
getblk-handle-2tb-devices.patch
getblk-handle-2tb-devices-fix.patch
undeprecate-pci_find_device.patch
notify_change-callers-must-hold-i_mutex.patch
page-owner-tracking.patch
page-owner-tracking-checkpatch-fixes.patch
drivers-net-bonding-bond_sysfsc-suppress-uninitialized-var-warning.patch

