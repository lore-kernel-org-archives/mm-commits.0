From: akpm@linux-foundation.org
Subject: + increase-slab-redzone-to-64bits-fix.patch added to -mm tree
Date: Wed, 02 May 2007 22:03:39 -0700
Message-ID: <200705030503.l4353d7Y005197@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([65.172.181.25]:59369 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1767389AbXECFDv (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 3 May 2007 01:03:51 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: akpm@linux-foundation.org, clameter@engr.sgi.com, dwmw2@infradead.org, penberg@cs.helsinki.fi


The patch titled
     increase-slab-redzone-to-64bits-fix
has been added to the -mm tree.  Its filename is
     increase-slab-redzone-to-64bits-fix.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: increase-slab-redzone-to-64bits-fix
From: Andrew Morton <akpm@linux-foundation.org>

Use u64's

Cc: Christoph Lameter <clameter@engr.sgi.com>
Cc: David Woodhouse <dwmw2@infradead.org>
Cc: Pekka Enberg <penberg@cs.helsinki.fi>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/slab.c |   38 ++++++++++++++++++++------------------
 1 file changed, 20 insertions(+), 18 deletions(-)

diff -puN mm/slab.c~increase-slab-redzone-to-64bits-fix mm/slab.c
--- a/mm/slab.c~increase-slab-redzone-to-64bits-fix
+++ a/mm/slab.c
@@ -148,11 +148,11 @@
  * Usually, the kmalloc caches are cache_line_size() aligned, except when
  * DEBUG and FORCED_DEBUG are enabled, then they are BYTES_PER_WORD aligned.
  * Some archs want to perform DMA into kmalloc caches and need a guaranteed
- * alignment larger than the alignment of a uint64_t. ARCH_KMALLOC_MINALIGN
+ * alignment larger than the alignment of a u64. ARCH_KMALLOC_MINALIGN
  * allows that.
  * Note that increasing this value may disable some debug features.
  */
-#define ARCH_KMALLOC_MINALIGN __alignof__(uint64_t)
+#define ARCH_KMALLOC_MINALIGN __alignof__(u64)
 #endif
 
 #ifndef ARCH_SLAB_MINALIGN
@@ -537,19 +537,19 @@ static int obj_size(struct kmem_cache *c
 	return cachep->obj_size;
 }
 
-static unsigned long long *dbg_redzone1(struct kmem_cache *cachep, void *objp)
+static u64 *dbg_redzone1(struct kmem_cache *cachep, void *objp)
 {
 	BUG_ON(!(cachep->flags & SLAB_RED_ZONE));
-	return (unsigned long long*) (objp+obj_offset(cachep)-8);
+	return (u64 *)(objp+obj_offset(cachep)-8);
 }
 
-static unsigned long long *dbg_redzone2(struct kmem_cache *cachep, void *objp)
+static u64 *dbg_redzone2(struct kmem_cache *cachep, void *objp)
 {
 	BUG_ON(!(cachep->flags & SLAB_RED_ZONE));
 	if (cachep->flags & SLAB_STORE_USER)
-		return (unsigned long long *)(objp + cachep->buffer_size - 8 -
+		return (u64 *)(objp + cachep->buffer_size - 8 -
 					      BYTES_PER_WORD);
-	return (unsigned long long *) (objp + cachep->buffer_size - 8);
+	return (u64 *)(objp + cachep->buffer_size - 8);
 }
 
 static void **dbg_userword(struct kmem_cache *cachep, void *objp)
@@ -562,8 +562,8 @@ static void **dbg_userword(struct kmem_c
 
 #define obj_offset(x)			0
 #define obj_size(cachep)		(cachep->buffer_size)
-#define dbg_redzone1(cachep, objp)	({BUG(); (unsigned long long *)NULL;})
-#define dbg_redzone2(cachep, objp)	({BUG(); (unsigned long long *)NULL;})
+#define dbg_redzone1(cachep, objp)	({BUG(); (u64 *)NULL;})
+#define dbg_redzone2(cachep, objp)	({BUG(); (u64 *)NULL;})
 #define dbg_userword(cachep, objp)	({BUG(); (void **)NULL;})
 
 #endif
@@ -2240,7 +2240,7 @@ kmem_cache_create (const char *name, siz
 	 * is greater than BYTES_PER_WORD.
 	 */
 	if (flags & SLAB_RED_ZONE || flags & SLAB_STORE_USER)
-		ralign = __alignof__(unsigned long long);
+		ralign = __alignof__(u64);
 
 	/* 2) arch mandated alignment */
 	if (ralign < ARCH_SLAB_MINALIGN) {
@@ -2251,7 +2251,7 @@ kmem_cache_create (const char *name, siz
 		ralign = align;
 	}
 	/* disable debug if necessary */
-	if (ralign > __alignof__(unsigned long long))
+	if (ralign > __alignof__(u64))
 		flags &= ~(SLAB_RED_ZONE | SLAB_STORE_USER);
 	/*
 	 * 4) Store it.
@@ -2272,8 +2272,8 @@ kmem_cache_create (const char *name, siz
 	 */
 	if (flags & SLAB_RED_ZONE) {
 		/* add space for red zone words */
-		cachep->obj_offset += sizeof(unsigned long long);
-		size += 2 * sizeof(unsigned long long);
+		cachep->obj_offset += sizeof(u64);
+		size += 2 * sizeof(u64);
 	}
 	if (flags & SLAB_STORE_USER) {
 		/* user store requires one word storage behind the end of
@@ -2834,7 +2834,7 @@ static void kfree_debugcheck(const void 
 
 static inline void verify_redzone_free(struct kmem_cache *cache, void *obj)
 {
-	unsigned long long redzone1, redzone2;
+	u64 redzone1, redzone2;
 
 	redzone1 = *dbg_redzone1(cache, obj);
 	redzone2 = *dbg_redzone2(cache, obj);
@@ -2851,7 +2851,8 @@ static inline void verify_redzone_free(s
 		slab_error(cache, "memory outside object was overwritten");
 
 	printk(KERN_ERR "%p: redzone 1:0x%llx, redzone 2:0x%llx.\n",
-			obj, redzone1, redzone2);
+			obj, (unsigned long long)redzone1,
+			(unsigned long long)redzone2);
 }
 
 static void *cache_free_debugcheck(struct kmem_cache *cachep, void *objp,
@@ -3066,9 +3067,10 @@ static void *cache_alloc_debugcheck_afte
 			slab_error(cachep, "double free, or memory outside"
 						" object was overwritten");
 			printk(KERN_ERR
-				"%p: redzone 1:0x%llx, redzone 2:0x%llx\n",
-				objp, *dbg_redzone1(cachep, objp),
-				*dbg_redzone2(cachep, objp));
+			    "%p: redzone 1:0x%llx, redzone 2:0x%llx\n",
+			    objp,
+			    (unsigned long long)*dbg_redzone1(cachep, objp),
+			    (unsigned long long)*dbg_redzone2(cachep, objp));
 		}
 		*dbg_redzone1(cachep, objp) = RED_ACTIVE;
 		*dbg_redzone2(cachep, objp) = RED_ACTIVE;
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

origin.patch
slab-introduce-krealloc.patch
rm9000-serial-driver.patch
add-apply_to_page_range-which-applies-a-function-to-a-pte-range.patch
smaps-add-clear_refs-file-to-clear-reference.patch
slab-mark-set_up_list3s-__init.patch
slub-core.patch
mm-optimize-kill_bdev.patch
get_unmapped_area-handles-map_fixed-in-hugetlbfs-fix.patch
srmcons-fix-kmallocgfp_kernel-inside-spinlock.patch
uml-driver-formatting-fixes-fix.patch
cx88-video-build-fix.patch
zlib-backout.patch
git-acpi.patch
git-alsa.patch
git-agpgart.patch
git-arm.patch
git-avr32.patch
revert-gregkh-driver-remove-struct-subsystem-as-it-is-no-longer-needed.patch
ida-implement-idr-based-id-allocator-fix.patch
more-fix-gregkh-driver-sysfs-kill-unnecessary-attribute-owner.patch
even-more-fix-gregkh-driver-sysfs-kill-unnecessary-attribute-owner.patch
even-even-more-fix-gregkh-driver-sysfs-kill-unnecessary-attribute-owner.patch
git-drm.patch
git-gfs2-nmw.patch
git-hid-fixup.patch
git-ieee1394.patch
sbp2-include-fixes.patch
ieee1394-iso-needs-schedh.patch
git-input.patch
git-jfs.patch
git-kvm.patch
git-mmc.patch
git-e1000.patch
git-e1000-fixup-2.patch
input-rfkill-add-support-for-input-key-to-control-wireless-radio.patch
git-ocfs2.patch
git-parisc.patch
fix-gregkh-pci-pci-remove-the-broken-pci_multithread_probe-option.patch
git-pciseg.patch
git-s390-vs-gregkh-driver-sysfs-kill-unnecessary-attribute-owner.patch
git-sh-fixup.patch
git-scsi-misc.patch
scsi-fix-config_scsi_wait_scan=m.patch
git-block-fixup.patch
git-unionfs.patch
i386-map-enough-initial-memory-to-create-lowmem-mappings-fix.patch
i386-__inquire_remote_apic-printk-warning-fix.patch
xfs-clean-up-shrinker-games.patch
lazy-freeing-of-memory-through-madv_free.patch
increase-slab-redzone-to-64bits-fix.patch
add-__gfp_movable-for-callers-to-flag-allocations-from-high-memory-that-may-be-migrated.patch
bias-the-location-of-pages-freed-for-min_free_kbytes-in-the-same-max_order_nr_pages-blocks.patch
mm-merge-populate-and-nopage-into-fault-fixes-nonlinear.patch
mm-merge-nopfn-into-fault.patch
maps2-move-the-page-walker-code-to-lib.patch
maps2-add-proc-pid-pagemap-interface.patch
mm-move-common-segment-checks-to-separate-helper-function-v7.patch
cache-pipe-buf-page-address-for-non-highmem-arch.patch
reduce-size-of-task_struct-on-64-bit-machines.patch
mm-shrink-parent-dentries-when-shrinking-slab.patch
merge-sys_clone-sys_unshare-nsproxy-and-namespace.patch
virtual_eisa_root_init-should-be-__init.patch
proc-maps-protection.patch
fix-cycladesh-for-x86_64-and-probably-others.patch
rtc-add-rtc-rs5c313-driver.patch
enlarge-console-name.patch
move-die-notifier-handling-to-common-code.patch
fix-sscanf-%n-match-at-end-of-input-string.patch
parport-dev-driver-model-support.patch
add-support-for-deferrable-timers-respun.patch
linux-sysdevh-needs-to-include-linux-moduleh.patch
time-smp-friendly-alignment-of-struct-clocksource.patch
move-timekeeping-code-to-timekeepingc.patch
fix-kevents-childs-priority-greediness.patch
display-all-possible-partitions-when-the-root-filesystem-failed-to-mount.patch
enhance-initcall_debug-measure-latency.patch
dtlk-fix-error-checks-in-module_init.patch
document-spin_lock_unlocked-rw_lock_unlocked-deprecation.patch
upper-32-bits.patch
driver-for-the-maxim-ds1wm-a-1-wire-bus-master-asic-core.patch
define-and-use-new-eventscpu_lock_acquire-and-cpu_lock_release.patch
call-cpu_chain-with-cpu_down_failed-if-cpu_down_prepare-failed-vs-reduce-size-of-task_struct-on-64-bit-machines.patch
kthread-dont-depend-on-work-queues-take-2.patch
fix-kthread_create-vs-freezer-theoretical-race.patch
speedup-divides-by-cpu_power-in-scheduler.patch
utimensat-implementation.patch
revert-rtc-add-rtc_merge_alarm.patch
declare-struct-ktime.patch
make-futex_wait-use-an-hrtimer-for-timeout.patch
kprobes-the-on-off-knob-thru-debugfs-updated.patch
atomich-add-atomic64-cmpxchg-xchg-and-add_unless-to-powerpc.patch
local_t-powerpc-extension.patch
linux-kernel-markers-i386-optimization.patch
signal-timer-event-fds-v9-signalfd-core.patch
signal-timer-event-fds-v9-timerfd-core.patch
signal-timer-event-fds-v9-eventfd-core.patch
revoke-core-code-fix-shared-mapping-revoke.patch
revoke-wire-up-i386-system-calls.patch
x86-serial-convert-legacy-com-ports-to-platform-devices.patch
lguest-vs-x86_64-mm-use-per-cpu-variables-for-gdt-pda.patch
lguest-the-host-code-vs-x86_64-mm-i386-separate-hardware-defined-tss-from-linux-additions.patch
lguest-the-host-code-vs-futex-new-private-futexes.patch
fs-convert-core-functions-to-zero_user_page-pass-kmap-type.patch
fs-convert-core-functions-to-zero_user_page-fix-2.patch
ntfs-use-zero_user_page-fix.patch
reiser4-slab-allocators-remove-slab_debug_initial-flag.patch
fbdev-hecuba-framebuffer-driver.patch
vt-add-color-support-to-the-underline-and-italic-attributes-fix.patch
sm501fb-printk-warning-fixes.patch
integrity-new-hooks-fix.patch
integrity-evm-as-an-integrity-service-provider-tidy.patch
integrity-evm-as-an-integrity-service-provider-tidy-fix.patch
integrity-evm-as-an-integrity-service-provider-tidy-fix-2.patch
integrity-ima-integrity_measure-support-tidy.patch
integrity-ima-integrity_measure-support-fix.patch
integrity-ima-integrity_measure-support-fix-2.patch
integrity-tpm-internal-kernel-interface-tidy.patch
w1-build-fix.patch
