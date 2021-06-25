Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 79209C49EA5
	for <mm-commits@archiver.kernel.org>; Fri, 25 Jun 2021 01:32:19 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 55B7F613C0
	for <mm-commits@archiver.kernel.org>; Fri, 25 Jun 2021 01:32:19 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232917AbhFYBeh (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 24 Jun 2021 21:34:37 -0400
Received: from mail.kernel.org ([198.145.29.99]:57074 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232873AbhFYBeh (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Thu, 24 Jun 2021 21:34:37 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 0E5A7613B9;
        Fri, 25 Jun 2021 01:32:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1624584737;
        bh=fubalHI2SJHDTs4hV1ysePjoURfryIy4Bx75RlS5Lao=;
        h=Date:From:To:Subject:From;
        b=mZ9sFeTWo6pTUGJueRZ3GAkUe4arFCa02E0/UgFnwNYxSSPCtlfSg5DM//SFv4iWT
         mKV25yd1gGCKtuBVGV3j3HN8GGEhUzG20lc3hPg22aCJui77MO1hOCz5GJe9UBc82x
         4uMiRGCN73/COdAAKHKo4WD0C/0y8sXNGfFG0Ylw=
Date:   Thu, 24 Jun 2021 18:32:16 -0700
From:   akpm@linux-foundation.org
To:     akpm@linux-foundation.org, bp@alien8.de, bp@suse.de,
        david@redhat.com, juew@google.com, luto@kernel.org,
        mm-commits@vger.kernel.org, naoya.horiguchi@nec.com,
        osalvador@suse.de, tony.luck@intel.com, yaoaili@kingsoft.com
Subject:  [folded-merged]
 mm-memory-failure-use-a-mutex-to-avoid-memory_failure-races-fix.patch
 removed from -mm tree
Message-ID: <20210625013216.u0BdD3h4f%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm-memory-failure-use-a-mutex-to-avoid-memory_failure-races-fix
has been removed from the -mm tree.  Its filename was
     mm-memory-failure-use-a-mutex-to-avoid-memory_failure-races-fix.patch

This patch was dropped because it was folded into mm-memory-failure-use-a-mutex-to-avoid-memory_failure-races.patch

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: mm-memory-failure-use-a-mutex-to-avoid-memory_failure-races-fix

make mf_mutex local to memory_failure()

Cc: Aili Yao <yaoaili@kingsoft.com>
Cc: Andy Lutomirski <luto@kernel.org>
Cc: Borislav Petkov <bp@alien8.de>
Cc: Borislav Petkov <bp@suse.de>
Cc: David Hildenbrand <david@redhat.com>
Cc: Jue Wang <juew@google.com>
Cc: Naoya Horiguchi <naoya.horiguchi@nec.com>
Cc: Oscar Salvador <osalvador@suse.de>
Cc: Tony Luck <tony.luck@intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memory-failure.c |    3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

--- a/mm/memory-failure.c~mm-memory-failure-use-a-mutex-to-avoid-memory_failure-races-fix
+++ a/mm/memory-failure.c
@@ -1406,8 +1406,6 @@ out:
 	return rc;
 }
 
-static DEFINE_MUTEX(mf_mutex);
-
 /**
  * memory_failure - Handle memory failure of a page.
  * @pfn: Page Number of the corrupted page
@@ -1434,6 +1432,7 @@ int memory_failure(unsigned long pfn, in
 	int res = 0;
 	unsigned long page_flags;
 	bool retry = true;
+	static DEFINE_MUTEX(mf_mutex);
 
 	if (!sysctl_memory_failure_recovery)
 		panic("Memory failure on page %lx", pfn);
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

mm-memory-failure-use-a-mutex-to-avoid-memory_failure-races.patch
mm-page_alloc-fix-memory-map-initialization-for-descending-nodes-checkpatch-fixes.patch
mm.patch
mm-slub-kunit-add-a-kunit-test-for-slub-debugging-functionality-fix-2.patch
slub-force-on-no_hash_pointers-when-slub_debug-is-enabled-fix.patch
fs-remove-noop_set_page_dirty-fix.patch
mm-gup-pack-has_pinned-in-mmf_has_pinned-checkpatch-fixes.patch
mm-memcg-optimize-user-context-object-stock-access-checkpatch-fixes.patch
mm-memcg-slab-create-a-new-set-of-kmalloc-cg-n-caches-v5-fix.patch
binfmt-remove-in-tree-usage-of-map_executable-fix.patch
mm-mmap-introduce-unlock_range-for-code-cleanup-fix.patch
lazy-tlb-allow-lazy-tlb-mm-refcounting-to-be-configurable-fix.patch
mm-page_alloc-convert-per-cpu-list-protection-to-local_lock-fix-checkpatch-fixes.patch
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
linux-next-git-rejects.patch
kernel-cgroup-cgroupc-dont-export-cgroup_get_e_css-twice.patch
mm-introduce-memfd_secret-system-call-to-create-secret-memory-areas-fix.patch
module-add-printk-formats-to-add-module-build-id-to-stacktraces-fix.patch
module-add-printk-formats-to-add-module-build-id-to-stacktraces-fix-fix.patch
kernel-forkc-export-kernel_thread-to-modules.patch

