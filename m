From: akpm@linux-foundation.org
Subject: [folded-merged] lib-cpu_rmap-avoid-flushing-all-workqueues-fix.patch removed from -mm tree
Date: Fri, 11 Jan 2013 14:27:47 -0800
Message-ID: <20130111222748.4F17820004E@hpza10.eem.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-bk0-f74.google.com ([209.85.214.74]:43189 "EHLO
	mail-bk0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754674Ab3AKW1w (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 11 Jan 2013 17:27:52 -0500
Received: by mail-bk0-f74.google.com with SMTP id je9so135393bkc.3
        for <mm-commits@vger.kernel.org>; Fri, 11 Jan 2013 14:27:50 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, amirv@mellanox.com, bhutchings@solarflare.com, davem@davemloft.net, decot@googlers.com, edumazet@google.com, josh@joshtriplett.org, ogerlitz@mellanox.com, mm-commits@vger.kernel.org


The patch titled
     Subject: lib-cpu_rmap-avoid-flushing-all-workqueues-fix
has been removed from the -mm tree.  Its filename was
     lib-cpu_rmap-avoid-flushing-all-workqueues-fix.patch

This patch was dropped because it was folded into lib-cpu_rmap-avoid-flushing-all-workqueues.patch

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: lib-cpu_rmap-avoid-flushing-all-workqueues-fix

eliminate free_cpu_rmap, rename cpu_rmap_reclaim() to cpu_rmap_release(),
propagate kref_put() retval from cpu_rmap_put()

Cc: "David S. Miller" <davem@davemloft.net>
Cc: Amir Vadai <amirv@mellanox.com>
Cc: Ben Hutchings <bhutchings@solarflare.com>
Cc: David Decotigny <decot@googlers.com>
Cc: Eric Dumazet <edumazet@google.com>
Cc: Josh Triplett <josh@joshtriplett.org>
Cc: Or Gerlitz <ogerlitz@mellanox.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/cpu_rmap.h |    2 +-
 lib/cpu_rmap.c           |   21 ++++++---------------
 2 files changed, 7 insertions(+), 16 deletions(-)

diff -puN include/linux/cpu_rmap.h~lib-cpu_rmap-avoid-flushing-all-workqueues-fix include/linux/cpu_rmap.h
--- a/include/linux/cpu_rmap.h~lib-cpu_rmap-avoid-flushing-all-workqueues-fix
+++ a/include/linux/cpu_rmap.h
@@ -36,7 +36,7 @@ struct cpu_rmap {
 #define CPU_RMAP_DIST_INF 0xffff
 
 extern struct cpu_rmap *alloc_cpu_rmap(unsigned int size, gfp_t flags);
-extern void free_cpu_rmap(struct cpu_rmap *rmap);
+extern int cpu_rmap_put(struct cpu_rmap *rmap);
 
 extern int cpu_rmap_add(struct cpu_rmap *rmap, void *obj);
 extern int cpu_rmap_update(struct cpu_rmap *rmap, u16 index,
diff -puN lib/cpu_rmap.c~lib-cpu_rmap-avoid-flushing-all-workqueues-fix lib/cpu_rmap.c
--- a/lib/cpu_rmap.c~lib-cpu_rmap-avoid-flushing-all-workqueues-fix
+++ a/lib/cpu_rmap.c
@@ -65,10 +65,10 @@ struct cpu_rmap *alloc_cpu_rmap(unsigned
 EXPORT_SYMBOL(alloc_cpu_rmap);
 
 /**
- * cpu_rmap_reclaim - internal reclaiming helper called from kref_put
+ * cpu_rmap_release - internal reclaiming helper called from kref_put
  * @ref: kref to struct cpu_rmap
  */
-static void cpu_rmap_reclaim(struct kref *ref)
+static void cpu_rmap_release(struct kref *ref)
 {
 	struct cpu_rmap *rmap = container_of(ref, struct cpu_rmap, refcount);
 	kfree(rmap);
@@ -84,23 +84,14 @@ static inline void cpu_rmap_get(struct c
 }
 
 /**
- * cpu_rmap_put - internal helper to release ref on a cpu_rmap
+ * cpu_rmap_put - release ref on a cpu_rmap
  * @rmap: reverse-map allocated with alloc_cpu_rmap()
  */
-static inline void cpu_rmap_put(struct cpu_rmap *rmap)
+int cpu_rmap_put(struct cpu_rmap *rmap)
 {
-	kref_put(&rmap->refcount, cpu_rmap_reclaim);
+	return kref_put(&rmap->refcount, cpu_rmap_release);
 }
-
-/**
- * free_cpu_rmap - free CPU affinity reverse-map
- * @rmap: Reverse-map allocated with alloc_cpu_rmap()
- */
-void free_cpu_rmap(struct cpu_rmap *rmap)
-{
-	cpu_rmap_put(rmap);
-}
-EXPORT_SYMBOL(free_cpu_rmap);
+EXPORT_SYMBOL(cpu_rmap_put);
 
 /* Reevaluate nearest object for given CPU, comparing with the given
  * neighbours at the given distance.
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

lib-cpu_rmap-avoid-flushing-all-workqueues.patch
drivers-rtc-rtc-da9055c-fix-cross-section-reference.patch
arch-mn10300-kconfig-select-config_generic_atomic64.patch
kernel-auditc-avoid-negative-sleep-durations.patch
linux-next.patch
make-my-i386-build-work.patch
arch-alpha-kernel-systblss-remove-debug-check.patch
bugh-prevent-double-evaulation-of-in-build_bug_on-fix.patch
bugh-compilerh-introduce-compiletime_assert-build_bug_on_msg-checkpatch-fixes.patch
i-need-old-gcc.patch
fb-rework-locking-to-fix-lock-ordering-on-takeover-fix.patch
fb-rework-locking-to-fix-lock-ordering-on-takeover-fix-2.patch
arch-x86-tools-insn_sanityc-identify-source-of-messages.patch
mm.patch
mm-memcontrolc-convert-printkkern_foo-to-pr_foo.patch
mm-hugetlbc-convert-to-pr_foo.patch
cma-make-putback_lru_pages-call-conditional-fix.patch
mm-vmscan-clean-up-get_scan_count-fix.patch
mm-vmscan-compaction-works-against-zones-not-lruvecs-fix.patch
mm-page_allocc-__setup_per_zone_wmarks-make-min_pages-unsigned-long.patch
mm-vmscanc-__zone_reclaim-replace-max_t-with-max.patch
mm-make-madvisemadv_willneed-support-swap-file-prefetch-fix.patch
mm-compaction-make-__compact_pgdat-and-compact_pgdat-return-void.patch
mm-remove-flags-argument-to-mmap_region-fix.patch
memory-hotplug-common-apis-to-support-page-tables-hot-remove-fix.patch
memory-hotplug-remove-page-table-of-x86_64-architecture-fix.patch
drop_caches-add-some-documentation-and-info-messsge.patch
memcg-debugging-facility-to-access-dangling-memcgs-fix.patch
scripts-pnmtologo-fix-for-plain-pbm-checkpatch-fixes.patch
kernel-smpc-cleanups.patch
backlight-add-lms501kf03-lcd-driver-fix.patch
backlight-add-lms501kf03-lcd-driver-fix-fix.patch
backlight-add-new-lp8788-backlight-driver-checkpatch-fixes.patch
binfmt_elfc-use-get_random_int-to-fix-entropy-depleting.patch
rtc-ds1307-long-block-operations-bugfix-fix.patch
rtc-max77686-add-maxim-77686-driver-fix.patch
rtc-pcf8523-add-low-battery-voltage-support-fix.patch
rtc-add-rtc-driver-for-tps80031-tps80032-v2-fix.patch
rtc-add-support-for-spi-rtc-rx4581-checkpatch-fixes.patch
hfsplus-add-osx-prefix-for-handling-namespace-of-mac-os-x-extended-attributes.patch
drivers-char-miscc-misc_register-do-not-loop-on-misc_list-unconditionally-fix.patch
dma-debug-new-interfaces-to-debug-dma-mapping-errors-fix-fix.patch
aio-kiocb_cancel-fix.patch
wait-add-wait_event_hrtimeout-fix.patch
aio-give-shared-kioctx-fields-their-own-cachelines-fix.patch
generic-dynamic-per-cpu-refcounting-fix.patch
generic-dynamic-per-cpu-refcounting-sparse-fixes-fix.patch
generic-dynamic-per-cpu-refcounting-doc-fix.patch
aio-dont-include-aioh-in-schedh-fix.patch
aio-dont-include-aioh-in-schedh-fix-fix.patch
aio-dont-include-aioh-in-schedh-fix-3.patch
aio-kill-ki_retry-fix.patch
block-aio-batch-completion-for-bios-kiocbs-fix.patch
block-aio-batch-completion-for-bios-kiocbs-fix-fix.patch
block-aio-batch-completion-for-bios-kiocbs-fix-fix-fix.patch
aio-smoosh-struct-kiocb-fix.patch
journal_add_journal_head-debug.patch
kernel-forkc-export-kernel_thread-to-modules.patch
mutex-subsystem-synchro-test-module.patch
slab-leaks3-default-y.patch
put_bh-debug.patch

