From: akpm@linux-foundation.org
Subject: [merged] lib-idrc-use-kmem_cache_zalloc-for-the-idr_layer-cache.patch removed from -mm tree
Date: Fri, 16 Jan 2009 11:17:48 -0800
Message-ID: <200901161917.n0GJHmfD026399@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:45902 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S936588AbZAPTSx (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 16 Jan 2009 14:18:53 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, Nadia.Derbey@bull.net, dcm@acm.org, krh@redhat.com, manfred@colorfullife.com, paulmck@us.ibm.com, penberg@cs.helsinki.fi, stable@kernel.org, stefanr@s5r6.in


The patch titled
     lib/idr.c: use kmem_cache_zalloc() for the idr_layer cache
has been removed from the -mm tree.  Its filename was
     lib-idrc-use-kmem_cache_zalloc-for-the-idr_layer-cache.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: lib/idr.c: use kmem_cache_zalloc() for the idr_layer cache
From: Andrew Morton <akpm@linux-foundation.org>

David points out that the idr_remove_all() function returns unused slabs
to the kmem cache, but needs to zero them first or else they will be
uninitialized upon next use.  This causes crashes which have been observed
in the firewire subsystem.

He fixed this by zeroing the object before freeing it in idr_remove_all().

But we agree that simply removing the constructor and zeroing the object
at allocation time is simpler than relying upon slab constructor machinery
and might even be faster.

This problem was introduced by

commit cf481c20c476ad2c0febdace9ce23f5a4db19582
Author:     Nadia Derbey <Nadia.Derbey@bull.net>
AuthorDate: Fri Jul 25 01:48:02 2008 -0700
Commit:     Linus Torvalds <torvalds@linux-foundation.org>
CommitDate: Fri Jul 25 10:53:42 2008 -0700

    idr: make idr_remove rcu-safe

which was first released in 2.6.27.

There are no known codesites which trigger this bug in 2.6.27 or 2.6.28. 
The post-2.6.28 firewire changes are the only known triggerer.

There might of course be not-yet-discovered triggerers in 2.6.27 and
2.6.28, and there might be out-of-tree triggerers which are added to those
kernel versions.  I'll let the -stable guys decide whether they want to
backport this fix.

Reported-by: David Moore <dcm@acm.org>
Cc: Stefan Richter <stefanr@s5r6.in-berlin.de>
Cc: Nadia Derbey <Nadia.Derbey@bull.net>
Cc: Paul E. McKenney <paulmck@us.ibm.com>
Cc: Manfred Spraul <manfred@colorfullife.com>
Cc: Kristian Hgsberg <krh@redhat.com>
Acked-by: Pekka Enberg <penberg@cs.helsinki.fi>
Cc: <stable@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/idr.c |   10 ++--------
 1 file changed, 2 insertions(+), 8 deletions(-)

diff -puN lib/idr.c~lib-idrc-use-kmem_cache_zalloc-for-the-idr_layer-cache lib/idr.c
--- a/lib/idr.c~lib-idrc-use-kmem_cache_zalloc-for-the-idr_layer-cache
+++ a/lib/idr.c
@@ -121,7 +121,7 @@ int idr_pre_get(struct idr *idp, gfp_t g
 {
 	while (idp->id_free_cnt < IDR_FREE_MAX) {
 		struct idr_layer *new;
-		new = kmem_cache_alloc(idr_layer_cache, gfp_mask);
+		new = kmem_cache_zalloc(idr_layer_cache, gfp_mask);
 		if (new == NULL)
 			return (0);
 		move_to_free_list(idp, new);
@@ -623,16 +623,10 @@ void *idr_replace(struct idr *idp, void 
 }
 EXPORT_SYMBOL(idr_replace);
 
-static void idr_cache_ctor(void *idr_layer)
-{
-	memset(idr_layer, 0, sizeof(struct idr_layer));
-}
-
 void __init idr_init_cache(void)
 {
 	idr_layer_cache = kmem_cache_create("idr_layer_cache",
-				sizeof(struct idr_layer), 0, SLAB_PANIC,
-				idr_cache_ctor);
+				sizeof(struct idr_layer), 0, SLAB_PANIC, NULL);
 }
 
 /**
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

origin.patch
kprobes-fix-module-compilation-error-with-config_kprobes=n-fix.patch
i-need-old-gcc.patch
linux-next.patch
linux-next-git-rejects.patch
next-remove-localversion.patch
thinkpad-acpi-split-delayed-leds-stuff-clean-up-code-checkpatch-fixes.patch
drivers-consolidate-driver_probe_done-loops-into-one-place-fix.patch
drivers-consolidate-driver_probe_done-loops-into-one-place-checkpatch-fixes.patch
clocksource-pass-clocksource-to-read-callback.patch
drivers-net-mlx4-profilec-fix-min-warning.patch
pci-quirks-unhide-overflow-device-on-i828675p-pe-chipsets.patch
regulator-minor-cleanup-of-virtual-consumer-fix.patch
raw-fix-rawctl-compat-ioctls-breakage-on-amd64-and-itanic.patch
scsi-dpt_i2o-is-bust-on-ia64.patch
nommu-fix-a-number-of-issues-with-the-per-mm-vma-patch.patch
page_fault-retry-with-nopage_retry.patch
page_fault-retry-with-nopage_retry-fix-3-fix.patch
mm-add-proc-controls-for-pdflush-threads-fix.patch
mm-add-proc-controls-for-pdflush-threads-fix-fix.patch
proc-pid-maps-dont-show-pgoff-of-pure-anon-vmas-checkpatch-fixes.patch
rtc-convert-leap_year-into-an-inline.patch
rtc-add-platform-driver-for-efi-fix.patch
nilfs2-integrated-block-mapping-remove-nilfs-bmap-wrapper-macros-checkpatch-fixes.patch
nilfs2-inode-operations-fix.patch
nilfs2-pathname-operations-fix.patch
nilfs2-super-block-operations-fix.patch
reiser4.patch
reiser4-remove-simple_prepare_write-usage-checkpatch-fixes.patch
slab-leaks3-default-y.patch
put_bh-debug.patch
shrink_slab-handle-bad-shrinkers.patch
getblk-handle-2tb-devices.patch
getblk-handle-2tb-devices-fix.patch
undeprecate-pci_find_device.patch
notify_change-callers-must-hold-i_mutex.patch
drivers-net-bonding-bond_sysfsc-suppress-uninitialized-var-warning.patch
w1-build-fix.patch

