From: akpm@linux-foundation.org
Subject: + lib-cpu_rmap-avoid-flushing-all-workqueues-fix.patch added to -mm tree
Date: Thu, 03 Jan 2013 13:48:05 -0800
Message-ID: <20130103214806.A4FB4200057@hpza10.eem.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-bk0-f74.google.com ([209.85.214.74]:57912 "EHLO
	mail-bk0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753737Ab3ACVsK (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 3 Jan 2013 16:48:10 -0500
Received: by mail-bk0-f74.google.com with SMTP id je9so982350bkc.3
        for <mm-commits@vger.kernel.org>; Thu, 03 Jan 2013 13:48:08 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: akpm@linux-foundation.org, amirv@mellanox.com, bhutchings@solarflare.com, davem@davemloft.net, decot@googlers.com, edumazet@google.com, josh@joshtriplett.org, ogerlitz@mellanox.com


The patch titled
     Subject: lib-cpu_rmap-avoid-flushing-all-workqueues-fix
has been added to the -mm tree.  Its filename is
     lib-cpu_rmap-avoid-flushing-all-workqueues-fix.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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

ipc-add-sysctl-to-specify-desired-next-object-id.patch
ipc-message-queue-receive-cleanup.patch
ipc-convert-prepare_copy-from-macro-to-function.patch
rtc-add-rtc-driver-for-tps6586x-fix.patch
rtc-add-rtc-driver-for-tps6586x-fix2.patch
linux-next.patch
make-my-i386-build-work.patch
arch-alpha-kernel-systblss-remove-debug-check.patch
bugh-prevent-double-evaulation-of-in-build_bug_on-fix.patch
bugh-compilerh-introduce-compiletime_assert-build_bug_on_msg-checkpatch-fixes.patch
i-need-old-gcc.patch
lib-cpu_rmap-avoid-flushing-all-workqueues-fix.patch
arch-x86-tools-insn_sanityc-identify-source-of-messages.patch
fb-rework-locking-to-fix-lock-ordering-on-takeover-fix.patch
fb-rework-locking-to-fix-lock-ordering-on-takeover-fix-2.patch
mm.patch
mm-memcontrolc-convert-printkkern_foo-to-pr_foo.patch
mm-hugetlbc-convert-to-pr_foo.patch
cma-make-putback_lru_pages-call-conditional-fix.patch
mm-vmscan-clean-up-get_scan_count-fix.patch
mm-vmscan-compaction-works-against-zones-not-lruvecs-fix.patch
mm-page_allocc-__setup_per_zone_wmarks-make-min_pages-unsigned-long.patch
mm-vmscanc-__zone_reclaim-replace-max_t-with-max.patch
drop_caches-add-some-documentation-and-info-messsge.patch
memcg-debugging-facility-to-access-dangling-memcgs-fix.patch
scripts-pnmtologo-fix-for-plain-pbm-checkpatch-fixes.patch
backlight-add-lms501kf03-lcd-driver-fix.patch
backlight-add-new-lp8788-backlight-driver-checkpatch-fixes.patch
binfmt_elfc-use-get_random_int-to-fix-entropy-depleting.patch
rtc-ds1307-long-block-operations-bugfix-fix.patch
rtc-max77686-add-maxim-77686-driver-fix.patch
rtc-pcf8523-add-low-battery-voltage-support-fix.patch
hfsplus-add-osx-prefix-for-handling-namespace-of-mac-os-x-extended-attributes.patch
drivers-char-miscc-misc_register-do-not-loop-on-misc_list-unconditionally-fix.patch
dma-debug-new-interfaces-to-debug-dma-mapping-errors-fix-fix.patch
journal_add_journal_head-debug.patch
kernel-forkc-export-kernel_thread-to-modules.patch
mutex-subsystem-synchro-test-module.patch
slab-leaks3-default-y.patch
put_bh-debug.patch

