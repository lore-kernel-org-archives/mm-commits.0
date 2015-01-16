From: akpm@linux-foundation.org
Subject: +
 mm-slab-convert-cache-name-allocations-to-kstrdup_const-fix.patch added to
 -mm tree
Date: Fri, 16 Jan 2015 13:45:18 -0800
Message-ID: <54b9866e.CMUzPHI90IZmfgPP%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:47581 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751535AbbAPVpU (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 16 Jan 2015 16:45:20 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, a.hajda@samsung.com, cl@linux.com, geert@linux-m68k.org, greg@kroah.com, iamjoonsoo.kim@lge.com, kyungmin.park@samsung.com, m.szyprowski@samsung.com, mturquette@linaro.org, penberg@kernel.org, rientjes@google.com, tj@kernel.org, viro@zeniv.linux.org.uk, mm-commits@vger.kernel.org


The patch titled
     Subject: mm-slab-convert-cache-name-allocations-to-kstrdup_const-fix
has been added to the -mm tree.  Its filename is
     mm-slab-convert-cache-name-allocations-to-kstrdup_const-fix.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-slab-convert-cache-name-allocations-to-kstrdup_const-fix.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-slab-convert-cache-name-allocations-to-kstrdup_const-fix.patch

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
Subject: mm-slab-convert-cache-name-allocations-to-kstrdup_const-fix

mm/slab_common.c:391: warning: assignment discards qualifiers from pointer target type

make the handling of kmem_cache.name const-correct

Cc: Alexander Viro <viro@zeniv.linux.org.uk>
Cc: Andrzej Hajda <a.hajda@samsung.com>
Cc: Christoph Lameter <cl@linux.com>
Cc: David Rientjes <rientjes@google.com>
Cc: Geert Uytterhoeven <geert@linux-m68k.org>
Cc: Greg KH <greg@kroah.com>
Cc: Joonsoo Kim <iamjoonsoo.kim@lge.com>
Cc: Kyungmin Park <kyungmin.park@samsung.com>
Cc: Marek Szyprowski <m.szyprowski@samsung.com>
Cc: Mike Turquette <mturquette@linaro.org>
Cc: Pekka Enberg <penberg@kernel.org>
Cc: Tejun Heo <tj@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/slab_common.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff -puN mm/slab_common.c~mm-slab-convert-cache-name-allocations-to-kstrdup_const-fix mm/slab_common.c
--- a/mm/slab_common.c~mm-slab-convert-cache-name-allocations-to-kstrdup_const-fix
+++ a/mm/slab_common.c
@@ -293,8 +293,8 @@ unsigned long calculate_alignment(unsign
 }
 
 static struct kmem_cache *
-do_kmem_cache_create(char *name, size_t object_size, size_t size, size_t align,
-		     unsigned long flags, void (*ctor)(void *),
+do_kmem_cache_create(const char *name, size_t object_size, size_t size,
+		     size_t align, unsigned long flags, void (*ctor)(void *),
 		     struct mem_cgroup *memcg, struct kmem_cache *root_cache)
 {
 	struct kmem_cache *s;
@@ -361,7 +361,7 @@ kmem_cache_create(const char *name, size
 		  unsigned long flags, void (*ctor)(void *))
 {
 	struct kmem_cache *s;
-	char *cache_name;
+	const char *cache_name;
 	int err;
 
 	get_online_cpus();
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

origin.patch
i-need-old-gcc.patch
arch-alpha-kernel-systblss-remove-debug-check.patch
fanotify-dont-recalculate-a-marks-mask-if-only-the-ignored-mask-changed-checkpatch-fixes.patch
fanotify-dont-set-fan_ondir-implicitly-on-a-marks-ignored-mask-checkpatch-fixes.patch
input-route-kbd-leds-through-the-generic-leds-layer.patch
o2dlm-fix-null-pointer-dereference-in-o2dlm_blocking_ast_wrapper.patch
ocfs2-add-functions-to-add-and-remove-inode-in-orphan-dir.patch
mm.patch
mm-vmstatc-fix-cleanup-ifdefs.patch
mm-replace-remap_file_pages-syscall-with-emulation.patch
mm-page_allocc-__alloc_pages_nodemask-dont-alter-arg-gfp_mask.patch
vmscan-force-scan-offline-memory-cgroups-fix.patch
mm-memcontrol-default-hierarchy-interface-for-memory-checkpatch-fixes.patch
mm-memcontrol-fold-move_anon-and-move_file-fix.patch
fs-shrinker-always-scan-at-least-one-object-of-each-type-fix.patch
x86-add-pmd_-for-thp-fix.patch
sparc-add-pmd_-for-thp-fix.patch
task_mmu-add-user-space-support-for-resetting-mm-hiwater_rss-peak-rss.patch
lib-bitmap-update-bitmap_onto-to-unsigned-checkpatch-fixes.patch
lib-bitmap-change-parameters-of-bitmap_fold-to-unsigned-fix.patch
hexdump-makes-it-return-amount-of-bytes-placed-in-buffer-fix.patch
mm-slab-convert-cache-name-allocations-to-kstrdup_const-fix.patch
rtc-rk808-fix-the-rtc-time-reading-issue-fix.patch
fs-befs-linuxvfsc-remove-unnecessary-casting-fix.patch
linux-next.patch
linux-next-git-rejects.patch
drivers-gpio-gpio-zevioc-fix-build.patch
mm-fix-xip-fault-vs-truncate-race-fix.patch
mm-fix-xip-fault-vs-truncate-race-fix-fix.patch
mm-allow-page-fault-handlers-to-perform-the-cow-fix.patch
mm-allow-page-fault-handlers-to-perform-the-cow-fix-fix-3.patch
mm-allow-page-fault-handlers-to-perform-the-cow-fix-fix.patch
daxext2-replace-the-xip-page-fault-handler-with-the-dax-page-fault-handler-fix.patch
daxext2-replace-the-xip-page-fault-handler-with-the-dax-page-fault-handler-fix-2.patch
daxext2-replace-the-xip-page-fault-handler-with-the-dax-page-fault-handler-fix-3.patch
dax-add-dax_zero_page_range-fix.patch
ext4-add-dax-functionality-fix.patch
do_shared_fault-check-that-mmap_sem-is-held.patch
journal_add_journal_head-debug.patch
journal_add_journal_head-debug-fix.patch
kernel-forkc-export-kernel_thread-to-modules.patch
mutex-subsystem-synchro-test-module.patch
slab-leaks3-default-y.patch
mm-vmscan-fix-the-page-state-calculation-in-too_many_isolated-fix.patch

