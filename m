From: akpm@linux-foundation.org
Subject: - bitmaph-remove-dead-artifacts.patch removed from -mm tree
Date: Thu, 18 Oct 2007 00:02:55 -0700
Message-ID: <200710180702.l9I72tiT031313@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:33179 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1760038AbXJRH1P (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 18 Oct 2007 03:27:15 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: bunk@kernel.org, bfields@fieldses.org, neilb@suse.de, mm-commits@vger.kernel.org


The patch titled
     bitmap.h: remove dead artifacts
has been removed from the -mm tree.  Its filename was
     bitmaph-remove-dead-artifacts.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: bitmap.h: remove dead artifacts
From: Adrian Bunk <bunk@kernel.org>

bitmap_active() no longer exists and BITMAP_ACTIVE is no longer used.

Signed-off-by: Adrian Bunk <bunk@kernel.org>
Cc: Neil Brown <neilb@suse.de>
Cc: "J. Bruce Fields" <bfields@fieldses.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/raid/bitmap.h |    2 --
 1 file changed, 2 deletions(-)

diff -puN include/linux/raid/bitmap.h~bitmaph-remove-dead-artifacts include/linux/raid/bitmap.h
--- a/include/linux/raid/bitmap.h~bitmaph-remove-dead-artifacts
+++ a/include/linux/raid/bitmap.h
@@ -138,7 +138,6 @@ typedef __u16 bitmap_counter_t;
 
 /* use these for bitmap->flags and bitmap->sb->state bit-fields */
 enum bitmap_state {
-	BITMAP_ACTIVE = 0x001, /* the bitmap is in use */
 	BITMAP_STALE  = 0x002,  /* the bitmap file is out of date or had -EIO */
 	BITMAP_WRITE_ERROR = 0x004, /* A write error has occurred */
 	BITMAP_HOSTENDIAN = 0x8000,
@@ -258,7 +257,6 @@ struct bitmap {
 int  bitmap_create(mddev_t *mddev);
 void bitmap_flush(mddev_t *mddev);
 void bitmap_destroy(mddev_t *mddev);
-int  bitmap_active(struct bitmap *bitmap);
 
 char *file_path(struct file *file, char *buf, int count);
 void bitmap_print_sb(struct bitmap *bitmap);
_

Patches currently in -mm which might be from bunk@kernel.org are

origin.patch
git-dvb.patch
git-nfs-make-nfs_wb_page_priority-static.patch
drivers-net-wireless-b43-mainc-fix-an-uninitialized.patch
make-kernel-power-maincsuspend_enter-static.patch
sysctl-parport-remove-binary-paths-fix.patch
sysctl-error-on-bad-sysctl-tables-kernel-sysctl_checkc-must-include-linux-stringh.patch
memory-controller-add-per-container-lru-and-reclaim-v7-cleanup.patch
memory-controller-add-switch-to-control-what-type-of-pages-to-limit-v7-cleanup.patch
remove-asm-bitopsh-includes.patch
forbid-asm-bitopsh-direct-inclusion.patch
alpha-lock-bitops-fix.patch
reiser4-cryptcompress-misc-fixups-make-3-functions-static.patch
remove-asm-bitopsh-includes-reiser4.patch
