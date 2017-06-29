From: akpm@linux-foundation.org
Subject: + linux-next-git-rejects.patch added to -mm tree
Date: Thu, 29 Jun 2017 12:33:03 -0700
Message-ID: <20170629193303.vkViUWEPX%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:49692 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751681AbdF2TdF (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 29 Jun 2017 15:33:05 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, mm-commits@vger.kernel.org


The patch titled
     Subject: linux-next-git-rejects
has been added to the -mm tree.  Its filename is
     linux-next-git-rejects.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/linux-next-git-rejects.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/linux-next-git-rejects.patch

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
Subject: linux-next-git-rejects

Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---


diff -puN drivers/gpu/drm/i915/i915_gem_execbuffer.c~linux-next-git-rejects drivers/gpu/drm/i915/i915_gem_execbuffer.c
--- a/drivers/gpu/drm/i915/i915_gem_execbuffer.c~linux-next-git-rejects
+++ a/drivers/gpu/drm/i915/i915_gem_execbuffer.c
@@ -1339,21 +1339,6 @@ out:
 	return target->node.start | UPDATE;
 }
 
-<<<<<<< HEAD
-static int
-i915_gem_execbuffer_relocate_entry(struct i915_vma *vma,
-				   struct eb_vmas *eb,
-				   struct drm_i915_gem_relocation_entry *reloc,
-				   struct reloc_cache *cache)
-{
-	struct drm_i915_gem_object *obj = vma->obj;
-	struct drm_i915_private *dev_priv = to_i915(obj->base.dev);
-	struct drm_gem_object *target_obj;
-	struct drm_i915_gem_object *target_i915_obj;
-	struct i915_vma *target_vma;
-	uint64_t target_offset;
-	int ret;
-=======
 static u64
 eb_relocate_entry(struct i915_execbuffer *eb,
 		  struct i915_vma *vma,
@@ -1361,7 +1346,6 @@ eb_relocate_entry(struct i915_execbuffer
 {
 	struct i915_vma *target;
 	int err;
->>>>>>> linux-next/akpm-base
 
 	/* we've already hold a reference to all valid objects */
 	target = eb_get_vma(eb, reloc->target_handle);
@@ -1445,13 +1429,6 @@ eb_relocate_entry(struct i915_execbuffer
 	 * of our synchronisation.
 	 */
 	vma->exec_entry->flags &= ~EXEC_OBJECT_ASYNC;
-<<<<<<< HEAD
-
-	ret = relocate_entry(obj, reloc, cache, target_offset);
-	if (ret)
-		return ret;
-=======
->>>>>>> linux-next/akpm-base
 
 	/* and update the user's relocation entry */
 	return relocate_entry(vma, reloc, eb, target);
@@ -1504,14 +1481,9 @@ static int eb_relocate_vma(struct i915_e
 		do {
 			u64 offset = eb_relocate_entry(eb, vma, r);
 
-<<<<<<< HEAD
-			ret = i915_gem_execbuffer_relocate_entry(vma, eb, r, &cache);
-			if (ret)
-=======
 			if (likely(offset == 0)) {
 			} else if ((s64)offset < 0) {
 				remain = (int)offset;
->>>>>>> linux-next/akpm-base
 				goto out;
 			} else {
 				/*
@@ -1557,24 +1529,7 @@ eb_relocate_vma_slow(struct i915_execbuf
 	int err;
 
 	for (i = 0; i < entry->relocation_count; i++) {
-<<<<<<< HEAD
-		ret = i915_gem_execbuffer_relocate_entry(vma, eb, &relocs[i], &cache);
-		if (ret)
-			break;
-	}
-	reloc_cache_fini(&cache);
-
-	return ret;
-}
-
-static int
-i915_gem_execbuffer_relocate(struct eb_vmas *eb)
-{
-	struct i915_vma *vma;
-	int ret = 0;
-=======
 		u64 offset = eb_relocate_entry(eb, vma, &relocs[i]);
->>>>>>> linux-next/akpm-base
 
 		if ((s64)offset < 0) {
 			err = (int)offset;
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

i-need-old-gcc.patch
arm-arch-arm-include-asm-pageh-needs-personalityh.patch
ocfs2-old-mle-put-and-release-after-the-function-dlm_add_migration_mle-called-fix.patch
ocfs2-dlm-optimization-of-code-while-free-dead-node-locks-checkpatch-fixes.patch
mm.patch
mm-slub-wrap-cpu_slab-partial-in-config_slub_cpu_partial-fix.patch
mm-memory_hotplug-do-not-associate-hotadded-memory-to-zones-until-online-fix-2-fix.patch
swap-add-block-io-poll-in-swapin-path-checkpatch-fixes.patch
mm-oom_kill-count-global-and-memory-cgroup-oom-kills-fix.patch
mm-oom_kill-count-global-and-memory-cgroup-oom-kills-fix-fix.patch
mm-swap-sort-swap-entries-before-free-fix.patch
mm-vmscan-avoid-thrashing-anon-lru-when-free-file-is-low-fix.patch
mm-hwpoison-dissolve-in-use-hugepage-in-unrecoverable-memory-error-fix.patch
mm-hugetlb-warn-the-user-when-issues-arise-on-boot-due-to-hugepages-fix.patch
mm-improve-readability-of-transparent_hugepage_enabled-fix.patch
mm-improve-readability-of-transparent_hugepage_enabled-fix-fix.patch
hugetlb-memory_hotplug-prefer-to-use-reserved-pages-for-migration-fix.patch
mm-page_allocc-eliminate-unsigned-confusion-in-__rmqueue_fallback-fix.patch
mm-memory_hotplug-just-build-zonelist-for-new-added-node-fix.patch
signal-avoid-undefined-behaviour-in-kill_something_info-fix.patch
kernel-reboot-add-devm_register_reboot_notifier-fix.patch
fault-inject-support-systematic-fault-injection-fix.patch
linux-next-rejects.patch
powerpc-64s-implement-arch-specific-hardlockup-watchdog-checkpatch-fixes.patch
mm-tree-wide-replace-__gfp_repeat-by-__gfp_retry_mayfail-with-more-useful-semantic-fix.patch
kernel-forkc-export-kernel_thread-to-modules.patch
slab-leaks3-default-y.patch
linux-next-git-rejects.patch

