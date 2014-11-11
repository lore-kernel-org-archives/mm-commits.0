From: akpm@linux-foundation.org
Subject: + slab-improve-checking-for-invalid-gfp_flags.patch added to -mm
 tree
Date: Tue, 11 Nov 2014 15:32:21 -0800
Message-ID: <54629c85.VR9F/ErhnW3sPNAz%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:57143 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752448AbaKKXcW (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 11 Nov 2014 18:32:22 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, cl@linux.com, iamjoonsoo.kim@lge.com, penberg@kernel.org, rientjes@google.com, mm-commits@vger.kernel.org


The patch titled
     Subject: slab: improve checking for invalid gfp_flags
has been added to the -mm tree.  Its filename is
     slab-improve-checking-for-invalid-gfp_flags.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/slab-improve-checking-for-invalid-gfp_flags.patch
		echo and later at
		echo  http://ozlabs.org/~akpm/mmotm/broken-out/slab-improve-checking-for-invalid-gfp_flags.patch

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
Subject: slab: improve checking for invalid gfp_flags

- The code goes BUG, but doesn't tell us which bits were unexpectedly
  set.  Print that out.

- The code goes BUG when it could jsut fix things up and proceed.  Do that.

- ~__GFP_BITS_MASK already includes __GFP_DMA32 and __GFP_HIGHMEM, so
  remove those from the GFP_SLAB_BUG_MASK definition.

Cc: Christoph Lameter <cl@linux.com>
Cc: Pekka Enberg <penberg@kernel.org>
Cc: David Rientjes <rientjes@google.com>
Cc: Joonsoo Kim <iamjoonsoo.kim@lge.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/gfp.h |    2 +-
 mm/slab.c           |    5 ++++-
 mm/slub.c           |    5 ++++-
 3 files changed, 9 insertions(+), 3 deletions(-)

diff -puN include/linux/gfp.h~slab-improve-checking-for-invalid-gfp_flags include/linux/gfp.h
--- a/include/linux/gfp.h~slab-improve-checking-for-invalid-gfp_flags
+++ a/include/linux/gfp.h
@@ -145,7 +145,7 @@ struct vm_area_struct;
 #define GFP_CONSTRAINT_MASK (__GFP_HARDWALL|__GFP_THISNODE)
 
 /* Do not use these with a slab allocator */
-#define GFP_SLAB_BUG_MASK (__GFP_DMA32|__GFP_HIGHMEM|~__GFP_BITS_MASK)
+#define GFP_SLAB_BUG_MASK (~__GFP_BITS_MASK)
 
 /* Flag - indicates that the buffer will be suitable for DMA.  Ignored on some
    platforms, used as appropriate on others */
diff -puN mm/slab.c~slab-improve-checking-for-invalid-gfp_flags mm/slab.c
--- a/mm/slab.c~slab-improve-checking-for-invalid-gfp_flags
+++ a/mm/slab.c
@@ -2590,7 +2590,10 @@ static int cache_grow(struct kmem_cache
 	 * Be lazy and only check for valid flags here,  keeping it out of the
 	 * critical path in kmem_cache_alloc().
 	 */
-	BUG_ON(flags & GFP_SLAB_BUG_MASK);
+	if (WARN_ON(flags & GFP_SLAB_BUG_MASK)) {
+		pr_emerg("gfp: %u\n", flags & GFP_SLAB_BUG_MASK);
+		flags &= ~GFP_SLAB_BUG_MASK;
+	}
 	local_flags = flags & (GFP_CONSTRAINT_MASK|GFP_RECLAIM_MASK);
 
 	/* Take the node list lock to change the colour_next on this node */
diff -puN mm/slub.c~slab-improve-checking-for-invalid-gfp_flags mm/slub.c
--- a/mm/slub.c~slab-improve-checking-for-invalid-gfp_flags
+++ a/mm/slub.c
@@ -1377,7 +1377,10 @@ static struct page *new_slab(struct kmem
 	int order;
 	int idx;
 
-	BUG_ON(flags & GFP_SLAB_BUG_MASK);
+	if (WARN_ON(flags & GFP_SLAB_BUG_MASK)) {
+		pr_emerg("gfp: %u\n", flags & GFP_SLAB_BUG_MASK);
+		flags &= ~GFP_SLAB_BUG_MASK;
+	}
 
 	page = allocate_slab(s,
 		flags & (GFP_RECLAIM_MASK | GFP_CONSTRAINT_MASK), node);
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

i-need-old-gcc.patch
arch-alpha-kernel-systblss-remove-debug-check.patch
input-route-kbd-leds-through-the-generic-leds-layer.patch
o2dlm-fix-null-pointer-dereference-in-o2dlm_blocking_ast_wrapper-checkpatch-fixes.patch
ocfs2-free-inode-when-i_count-becomes-zero.patch
ocfs2-add-functions-to-add-and-remove-inode-in-orphan-dir-fix.patch
mm.patch
slab-improve-checking-for-invalid-gfp_flags.patch
mm-memcontrol-lockless-page-counters-fix.patch
mm-memcontrol-lockless-page-counters-fix-fix.patch
kernel-res_counter-remove-the-unused-api-fix.patch
mm-compaction-simplify-deferred-compaction-fix.patch
mm-memcontrol-remove-unnecessary-pcg_used-pc-mem_cgroup-valid-flag-fix.patch
mm-memcontrol-fold-mem_cgroup_start_move-mem_cgroup_end_move-fix.patch
mm-introduce-do_shared_fault-and-drop-do_fault-fix-fix.patch
do_shared_fault-check-that-mmap_sem-is-held.patch
fs-proc-use-a-rb-tree-for-the-directory-entries-fix.patch
fs-binfmt_miscc-use-gfp_kernel-instead-of-gfp_user.patch
init-allow-config_init_fallback=n-to-disable-defaults-if-init=-fails-checkpatch-fixes.patch
rtc-omap-add-support-for-pmic_power_en-v3-fix.patch
sysctl-terminate-strings-also-on-r-fix.patch
ipc-semc-chance-memory-barrier-in-sem_lock-to-smp_rmb-fix.patch
ipc-semc-chance-memory-barrier-in-sem_lock-to-smp_rmb-fix-fix.patch
ipc-msg-increase-msgmni-remove-scaling-checkpatch-fixes.patch
linux-next.patch
linux-next-rejects.patch
drivers-gpio-gpio-zevioc-fix-build.patch
mm-cma-make-kmemleak-ignore-cma-regions.patch
lib-show_mem-this-patch-adds-cma-reserved-infromation-fix.patch
mm-replace-remap_file_pages-syscall-with-emulation.patch
debugging-keep-track-of-page-owners.patch
debugging-keep-track-of-page-owners-fix.patch
journal_add_journal_head-debug.patch
journal_add_journal_head-debug-fix.patch
kernel-forkc-export-kernel_thread-to-modules.patch
mutex-subsystem-synchro-test-module.patch
slab-leaks3-default-y.patch

