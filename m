From: akpm@linux-foundation.org
Subject: - remove-mca_is_adapter_used.patch removed from -mm tree
Date: Tue, 29 Apr 2008 22:39:43 -0700
Message-ID: <200804300539.m3U5dhVl028875@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:50245 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754411AbYD3FkC (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 30 Apr 2008 01:40:02 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: bunk@kernel.org, James.Bottomley@steeleye.com, mm-commits@vger.kernel.org


The patch titled
     remove mca_is_adapter_used()
has been removed from the -mm tree.  Its filename was
     remove-mca_is_adapter_used.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: remove mca_is_adapter_used()
From: Adrian Bunk <bunk@kernel.org>

Remove the no longer used mca_is_adapter_used().

Signed-off-by: Adrian Bunk <bunk@kernel.org>
Cc: James Bottomley <James.Bottomley@steeleye.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/mca/mca-legacy.c   |   18 ------------------
 include/linux/mca-legacy.h |    1 -
 2 files changed, 19 deletions(-)

diff -puN drivers/mca/mca-legacy.c~remove-mca_is_adapter_used drivers/mca/mca-legacy.c
--- a/drivers/mca/mca-legacy.c~remove-mca_is_adapter_used
+++ a/drivers/mca/mca-legacy.c
@@ -282,24 +282,6 @@ void mca_set_adapter_name(int slot, char
 EXPORT_SYMBOL(mca_set_adapter_name);
 
 /**
- *	mca_is_adapter_used - check if claimed by driver
- *	@slot:	slot to check
- *
- *	Returns 1 if the slot has been claimed by a driver
- */
-
-int mca_is_adapter_used(int slot)
-{
-	struct mca_device *mca_dev = mca_find_device_by_slot(slot);
-
-	if(!mca_dev)
-		return 0;
-
-	return mca_device_claimed(mca_dev);
-}
-EXPORT_SYMBOL(mca_is_adapter_used);
-
-/**
  *	mca_mark_as_used - claim an MCA device
  *	@slot:	slot to claim
  *	FIXME:  should we make this threadsafe
diff -puN include/linux/mca-legacy.h~remove-mca_is_adapter_used include/linux/mca-legacy.h
--- a/include/linux/mca-legacy.h~remove-mca_is_adapter_used
+++ a/include/linux/mca-legacy.h
@@ -34,7 +34,6 @@
 extern int mca_find_adapter(int id, int start);
 extern int mca_find_unused_adapter(int id, int start);
 
-extern int mca_is_adapter_used(int slot);
 extern int mca_mark_as_used(int slot);
 extern void mca_mark_as_unused(int slot);
 
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

