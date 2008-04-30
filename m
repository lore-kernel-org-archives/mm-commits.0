From: akpm@linux-foundation.org
Subject: - remove-aoedev_isbusy.patch removed from -mm tree
Date: Tue, 29 Apr 2008 22:48:03 -0700
Message-ID: <200804300548.m3U5m32L029826@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:54208 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758568AbYD3GLa (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 30 Apr 2008 02:11:30 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: bunk@kernel.org, ecashin@coraid.com, mm-commits@vger.kernel.org


The patch titled
     remove aoedev_isbusy()
has been removed from the -mm tree.  Its filename was
     remove-aoedev_isbusy.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: remove aoedev_isbusy()
From: Adrian Bunk <bunk@kernel.org>

Remove the no longer used aoedev_isbusy().

Signed-off-by: Adrian Bunk <bunk@kernel.org>
Cc: "Ed L. Cashin" <ecashin@coraid.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/block/aoe/aoe.h    |    1 -
 drivers/block/aoe/aoedev.c |   18 ------------------
 2 files changed, 19 deletions(-)

diff -puN drivers/block/aoe/aoe.h~remove-aoedev_isbusy drivers/block/aoe/aoe.h
--- a/drivers/block/aoe/aoe.h~remove-aoedev_isbusy
+++ a/drivers/block/aoe/aoe.h
@@ -195,7 +195,6 @@ void aoedev_exit(void);
 struct aoedev *aoedev_by_aoeaddr(int maj, int min);
 struct aoedev *aoedev_by_sysminor_m(ulong sysminor);
 void aoedev_downdev(struct aoedev *d);
-int aoedev_isbusy(struct aoedev *d);
 int aoedev_flush(const char __user *str, size_t size);
 
 int aoenet_init(void);
diff -puN drivers/block/aoe/aoedev.c~remove-aoedev_isbusy drivers/block/aoe/aoedev.c
--- a/drivers/block/aoe/aoedev.c~remove-aoedev_isbusy
+++ a/drivers/block/aoe/aoedev.c
@@ -18,24 +18,6 @@ static void skbpoolfree(struct aoedev *d
 static struct aoedev *devlist;
 static DEFINE_SPINLOCK(devlist_lock);
 
-int
-aoedev_isbusy(struct aoedev *d)
-{
-	struct aoetgt **t, **te;
-	struct frame *f, *e;
-
-	t = d->targets;
-	te = t + NTARGETS;
-	for (; t < te && *t; t++) {
-		f = (*t)->frames;
-		e = f + (*t)->nframes;
-		for (; f < e; f++)
-			if (f->tag != FREETAG)
-				return 1;
-	}
-	return 0;
-}
-
 struct aoedev *
 aoedev_by_aoeaddr(int maj, int min)
 {
_

Patches currently in -mm which might be from bunk@kernel.org are

origin.patch
mm-filemapc-generic_write_checks-mustnt-be-inline.patch
fs-block_devc-i_bdev-mustnt-be-inline.patch
frv-fix-arch-frv-mm-unalignedo-build-error.patch
reiserfs-some-functions-mustnt-be-inline.patch
git-acpi.patch
git-x86.patch
arch-x86-video-fbdevc-add-module_license.patch
md-make-dm_dirty_log_initexit-static.patch
drm-make-drm_minors_cleanup-static.patch
git-m32r.patch
net-ipv4-ip_outputc-ip_send_check-mustnt-be-inline.patch
nfs-make-nfs4_drop_state_owner-static.patch
git-ocfs2.patch
show_schedstat-fix-memleak.patch
git-sh.patch
if-0-ses_match_host.patch
git-watchdog.patch
xen-drivers-xen-balloonc-make-a-function-static.patch
make-marker_debug-static.patch
reiser4.patch

