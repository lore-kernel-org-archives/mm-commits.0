Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7079BC11F64
	for <mm-commits@archiver.kernel.org>; Tue, 29 Jun 2021 00:17:21 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 4209861CF4
	for <mm-commits@archiver.kernel.org>; Tue, 29 Jun 2021 00:17:21 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231975AbhF2ATq (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 28 Jun 2021 20:19:46 -0400
Received: from mail.kernel.org ([198.145.29.99]:58684 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229852AbhF2ATq (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Mon, 28 Jun 2021 20:19:46 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id A5C5F61CD5;
        Tue, 29 Jun 2021 00:17:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1624925840;
        bh=42o6Ij1z1+xfkPpdbp82qyQM8D++L4cxcutwMA+VPq0=;
        h=Date:From:To:Subject:From;
        b=Jn5Qc+3CmStEOhpoKWDo508UsnwNrcaRWl1doniAOsFrGamiQzAHhXbwCUSyjUSqD
         c0S9p7+Rxr3QBxY64J6SlpFu3yD9o1b5QSSkexYFONANStRNsy8ZPGlR4UXdpON88r
         z2JHB06JouGIgCTgyKcaqzf02BCV5E2LRCSPRNhM=
Date:   Mon, 28 Jun 2021 17:17:19 -0700
From:   akpm@linux-foundation.org
To:     akpm@linux-foundation.org, cl@linux.com, iamjoonsoo.kim@lge.com,
        joe@perches.com, lkp@intel.com, mm-commits@vger.kernel.org,
        penberg@kernel.org, pmladek@suse.com, rientjes@google.com,
        songmuchun@bytedance.com, swboyd@chromium.org, vbabka@suse.cz
Subject:  [folded-merged]
 slub-force-on-no_hash_pointers-when-slub_debug-is-enabled-fix.patch removed
 from -mm tree
Message-ID: <20210629001719.SO1jXJdc2%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: slub-force-on-no_hash_pointers-when-slub_debug-is-enabled-fix
has been removed from the -mm tree.  Its filename was
     slub-force-on-no_hash_pointers-when-slub_debug-is-enabled-fix.patch

This patch was dropped because it was folded into slub-force-on-no_hash_pointers-when-slub_debug-is-enabled.patch

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: slub-force-on-no_hash_pointers-when-slub_debug-is-enabled-fix

fix build with CONFIG_SLUB_DEBUG=n

Reported-by: kernel test robot <lkp@intel.com>
Cc: Christoph Lameter <cl@linux.com>
Cc: David Rientjes <rientjes@google.com>
Cc: Joe Perches <joe@perches.com>
Cc: Joonsoo Kim <iamjoonsoo.kim@lge.com>
Cc: Muchun Song <songmuchun@bytedance.com>
Cc: Pekka Enberg <penberg@kernel.org>
Cc: Petr Mladek <pmladek@suse.com>
Cc: Stephen Boyd <swboyd@chromium.org>
Cc: Vlastimil Babka <vbabka@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/slub.c |   18 ++++++++++++++++--
 1 file changed, 16 insertions(+), 2 deletions(-)

--- a/mm/slub.c~slub-force-on-no_hash_pointers-when-slub_debug-is-enabled-fix
+++ a/mm/slub.c
@@ -118,12 +118,26 @@
  */
 
 #ifdef CONFIG_SLUB_DEBUG
+
 #ifdef CONFIG_SLUB_DEBUG_ON
 DEFINE_STATIC_KEY_TRUE(slub_debug_enabled);
 #else
 DEFINE_STATIC_KEY_FALSE(slub_debug_enabled);
 #endif
-#endif
+
+static inline bool __slub_debug_enabled(void)
+{
+	return static_branch_unlikely(&slub_debug_enabled);
+}
+
+#else		/* CONFIG_SLUB_DEBUG */
+
+static inline bool __slub_debug_enabled(void)
+{
+	return false;
+}
+
+#endif		/* CONFIG_SLUB_DEBUG */
 
 static inline bool kmem_cache_debug(struct kmem_cache *s)
 {
@@ -4488,7 +4502,7 @@ void __init kmem_cache_init(void)
 		slub_max_order = 0;
 
 	/* Print slub debugging pointers without hashing */
-	if (static_branch_unlikely(&slub_debug_enabled))
+	if (__slub_debug_enabled())
 		no_hash_pointers_enable(NULL);
 
 	kmem_cache_node = &boot_kmem_cache_node;
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

slub-force-on-no_hash_pointers-when-slub_debug-is-enabled.patch
fs-remove-noop_set_page_dirty-fix.patch
mm-gup-pack-has_pinned-in-mmf_has_pinned-checkpatch-fixes.patch
mm-memcg-optimize-user-context-object-stock-access-checkpatch-fixes.patch
mm-memcg-slab-create-a-new-set-of-kmalloc-cg-n-caches-v5-fix.patch
binfmt-remove-in-tree-usage-of-map_executable-fix.patch
mm-mmap-introduce-unlock_range-for-code-cleanup-fix.patch
mm-page_alloc-convert-per-cpu-list-protection-to-local_lock-fix-checkpatch-fixes.patch
mm.patch
lazy-tlb-allow-lazy-tlb-mm-refcounting-to-be-configurable-fix.patch
mm-memory_hotplug-disable-memmap_on_memory-when-hugetlb_free_vmemmap-enabled-fix.patch
nommu-remove-__gfp_highmem-in-vmalloc-vzalloc-checkpatch-fixes.patch
mm-madvise-introduce-madv_populate_readwrite-to-prefault-page-tables-checkpatch-fixes.patch
mmmemory_hotplug-drop-unneeded-locking-fix.patch
fs-proc-kcorec-add-mmap-interface-fix.patch
kernelh-split-out-panic-and-oops-helpers-fix.patch
lib-math-rational-add-kunit-test-cases-fix.patch
lib-decompressors-remove-set-but-not-used-variabled-level-fix.patch
ipc-utilc-use-binary-search-for-max_idx-fix.patch
linux-next-pre.patch
linux-next-post.patch
linux-next-rejects.patch
kernel-cgroup-cgroupc-dont-export-cgroup_get_e_css-twice.patch
mm-introduce-memfd_secret-system-call-to-create-secret-memory-areas-fix.patch
module-add-printk-formats-to-add-module-build-id-to-stacktraces-fix.patch
module-add-printk-formats-to-add-module-build-id-to-stacktraces-fix-fix.patch
kernel-forkc-export-kernel_thread-to-modules.patch

