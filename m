From: akpm@linux-foundation.org
Subject: + md-avoid-overflow-in-raid0-calculation-with-large-components.patch added to -mm tree
Date: Sun, 20 May 2007 21:34:46 -0700
Message-ID: <200705210434.l4L4YjhC002470@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:36801 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754305AbXEUEiS (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 21 May 2007 00:38:18 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: neilb@suse.de, Jeff.Zheng@endace.com, stable@kernel.org


The patch titled
     md: avoid overflow in raid0 calculation with large components
has been added to the -mm tree.  Its filename is
     md-avoid-overflow-in-raid0-calculation-with-large-components.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: md: avoid overflow in raid0 calculation with large components
From: NeilBrown <neilb@suse.de>

If a raid0 has a component device larger than 4TB, and is accessed on a 32bit
machines, then as 'chunk' is unsigned lock,

   chunk << chunksize_bits

can overflow (this can be as high as the size of the device in KB).  chunk
itself will not overflow (without triggering a BUG).

So change 'chunk' to be 'sector_t, and get rid of the 'BUG' as it becomes
impossible to hit.

Cc: "Jeff Zheng" <Jeff.Zheng@endace.com>
Signed-off-by: Neil Brown <neilb@suse.de>
Cc: <stable@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/md/raid0.c |    3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff -puN drivers/md/raid0.c~md-avoid-overflow-in-raid0-calculation-with-large-components drivers/md/raid0.c
--- a/drivers/md/raid0.c~md-avoid-overflow-in-raid0-calculation-with-large-components
+++ a/drivers/md/raid0.c
@@ -415,7 +415,7 @@ static int raid0_make_request (request_q
 	raid0_conf_t *conf = mddev_to_conf(mddev);
 	struct strip_zone *zone;
 	mdk_rdev_t *tmp_dev;
-	unsigned long chunk;
+	sector_t chunk;
 	sector_t block, rsect;
 	const int rw = bio_data_dir(bio);
 
@@ -470,7 +470,6 @@ static int raid0_make_request (request_q
 
 		sector_div(x, zone->nb_dev);
 		chunk = x;
-		BUG_ON(x != (sector_t)chunk);
 
 		x = block >> chunksize_bits;
 		tmp_dev = zone->dev[sector_div(x, zone->nb_dev)];
_

Patches currently in -mm which might be from neilb@suse.de are

git-md-accel.patch
md-avoid-overflow-in-raid0-calculation-with-large-components.patch
md-dont-write-more-than-is-required-of-the-last-page-of-a-bitmap.patch
md-fix-bug-with-linear-hot-add-and-elsewhere.patch
knfsd-exportfs-add-exportfsh-header.patch
knfsd-exportfs-add-exportfsh-header-fix.patch
knfsd-exportfs-remove-iget-abuse.patch
knfsd-exportfs-remove-iget-abuse-fix.patch
knfsd-exportfs-add-procedural-interface-for-nfsd.patch
knfsd-exportfs-remove-call-macro.patch
knfsd-exportfs-untangle-isdir-logic-in-find_exported_dentry.patch
knfsd-exportfs-move-acceptable-check-into-find_acceptable_alias.patch
knfsd-exportfs-add-find_disconnected_root-helper.patch
knfsd-exportfs-split-out-reconnecting-a-dentry-from-find_exported_dentry.patch
nfsd-warning-fix.patch
use-menuconfig-objects-ii-md.patch
md-improve-message-about-invalid-superblock-during-autodetect.patch
md-improve-the-is_mddev_idle-test-fix.patch
md-check-that-internal-bitmap-does-not-overlap-other-data.patch
md-change-bitmap_unplug-and-others-to-void-functions.patch
