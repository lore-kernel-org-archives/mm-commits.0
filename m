Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6388CC11F64
	for <mm-commits@archiver.kernel.org>; Tue, 29 Jun 2021 00:13:57 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 421B061CD0
	for <mm-commits@archiver.kernel.org>; Tue, 29 Jun 2021 00:13:57 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231937AbhF2AQV (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 28 Jun 2021 20:16:21 -0400
Received: from mail.kernel.org ([198.145.29.99]:58140 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229852AbhF2AQS (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Mon, 28 Jun 2021 20:16:18 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id A03EE61C72;
        Tue, 29 Jun 2021 00:13:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1624925631;
        bh=g6hip0axa/6AOqfikBzAilMtPBfBALCurl/QyR7B0vc=;
        h=Date:From:To:Subject:From;
        b=nG3DtEjOBU0WJ7giBJCLO5L1gHBFw5cZw+XlVumaaSsrlD8f2d0/JA7VfnRAGn4vT
         xTzeivsFPtcfsRC/b720iX/FcHv2WFIuKXU6MGNum/GXHOXh/B8ZH26A2riHYtWP2o
         osTdmdoBgcdxVCfA9GnOsrzCHBPZG1ziloUCewgY=
Date:   Mon, 28 Jun 2021 17:13:51 -0700
From:   akpm@linux-foundation.org
To:     akpm@linux-foundation.org, elver@google.com, glittao@gmail.com,
        mm-commits@vger.kernel.org, vbabka@suse.cz
Subject:  [folded-merged]
 mm-slub-kunit-add-a-kunit-test-for-slub-debugging-functionality-fix-2.patch
 removed from -mm tree
Message-ID: <20210629001351.6KvhKpDaK%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm-slub-kunit-add-a-kunit-test-for-slub-debugging-functionality-fix-2
has been removed from the -mm tree.  Its filename was
     mm-slub-kunit-add-a-kunit-test-for-slub-debugging-functionality-fix-2.patch

This patch was dropped because it was folded into mm-slub-kunit-add-a-kunit-test-for-slub-debugging-functionality.patch

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: mm-slub-kunit-add-a-kunit-test-for-slub-debugging-functionality-fix-2

export kasan_enable/disable_current to modules

Cc: Oliver Glitta <glittao@gmail.com>
Cc: Marco Elver <elver@google.com>
Cc: Vlastimil Babka <vbabka@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/kasan/common.c |    3 +++
 1 file changed, 3 insertions(+)

--- a/mm/kasan/common.c~mm-slub-kunit-add-a-kunit-test-for-slub-debugging-functionality-fix-2
+++ a/mm/kasan/common.c
@@ -51,11 +51,14 @@ void kasan_enable_current(void)
 {
 	current->kasan_depth++;
 }
+EXPORT_SYMBOL(kasan_enable_current);
 
 void kasan_disable_current(void)
 {
 	current->kasan_depth--;
 }
+EXPORT_SYMBOL(kasan_disable_current);
+
 #endif /* CONFIG_KASAN_GENERIC || CONFIG_KASAN_SW_TAGS */
 
 void __kasan_unpoison_range(const void *address, size_t size)
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

mm-slub-kunit-add-a-kunit-test-for-slub-debugging-functionality.patch
slub-force-on-no_hash_pointers-when-slub_debug-is-enabled-fix.patch
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

