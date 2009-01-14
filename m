From: akpm@linux-foundation.org
Subject: + lib-idrc-use-kmem_cache_zalloc-for-the-idr_layer-cache.patch added to -mm tree
Date: Wed, 14 Jan 2009 10:38:13 -0800
Message-ID: <200901141838.n0EIcDlX031948@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:38040 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752933AbZANSk4 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 14 Jan 2009 13:40:56 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: akpm@linux-foundation.org, Nadia.Derbey@bull.net, dcm@acm.org, krh@redhat.com, manfred@colorfullife.com, paulmck@us.ibm.com, penberg@cs.helsinki.fi, stable@kernel.org, stefanr@s5r6.in-berlin.de, torvalds@linux-foundation.org


The patch titled
     lib/idr.c: use kmem_cache_zalloc() for the idr_layer cache
has been added to the -mm tree.  Its filename is
     lib-idrc-use-kmem_cache_zalloc-for-the-idr_layer-cache.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://userweb.kernel.org/~akpm/stuff/added-to-mm.txt to find
out what to do about this

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
kernel-upc-omit-it-if-smp=y-use_generic_smp_helpers=n.patch
alpha-fix-vmalloc-breakage-fix.patch
hp_accel-do-not-call-acpi-from-invalid-context-fix.patch
revert-mm-vmalloc-use-mutex-for-purge.patch
kprobes-fix-module-compilation-error-with-config_kprobes=n-fix.patch
lib-idrc-use-kmem_cache_zalloc-for-the-idr_layer-cache.patch
i-need-old-gcc.patch
mm-remove-the-might_sleep-from-lock_page.patch
linux-next.patch
next-remove-localversion.patch
thinkpad-acpi-split-delayed-leds-stuff-clean-up-code-checkpatch-fixes.patch
clocksource-pass-clocksource-to-read-callback.patch
pci-quirks-unhide-overflow-device-on-i828675p-pe-chipsets.patch
kernel-trace-ring_bufferc-reduce-inlining.patch
kernel-trace-ring_bufferc-use-div_round_up.patch
raw-fix-rawctl-compat-ioctls-breakage-on-amd64-and-itanic.patch
ext2-update-also-inode-on-disk-when-dir-is-is_dirsync-fix.patch
scsi-dpt_i2o-is-bust-on-ia64.patch
page_fault-retry-with-nopage_retry.patch
page_fault-retry-with-nopage_retry-fix-3-fix.patch
mm-add-proc-controls-for-pdflush-threads-fix.patch
mm-add-proc-controls-for-pdflush-threads-fix-fix.patch
nommu-fix-a-number-of-issues-with-the-per-mm-vma-patch.patch
rtc-cumulative-style-fixes-fix.patch
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

