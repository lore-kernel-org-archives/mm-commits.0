Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 77ACFC433E0
	for <mm-commits@archiver.kernel.org>; Thu, 28 Jan 2021 00:06:30 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 448A264DD3
	for <mm-commits@archiver.kernel.org>; Thu, 28 Jan 2021 00:06:30 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231131AbhA1AG1 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 27 Jan 2021 19:06:27 -0500
Received: from mail.kernel.org ([198.145.29.99]:50348 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231217AbhA1AGY (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Wed, 27 Jan 2021 19:06:24 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id BC45D64DD1;
        Thu, 28 Jan 2021 00:05:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1611792339;
        bh=sm91hxx5rmPm7Hi/18yz+QeZDnUkSBwKR16jJaN5WKM=;
        h=Date:From:To:Subject:From;
        b=w1Nv69JW9hSmys4zgVtCO2950+LH1BSMffqWf56mY/6RTPJy2WNmsjwNHpkWdWhNj
         zN4Q2vWvVGVG3ZuYCVP7Rclx8YFgwQ6KzXezZWLMBCrzN8t838gmqdFGJidm7QxKap
         FXTXIglOoRxiMmJKBk05mGpaTc5rU9ZdnVCfjhnQ=
Date:   Wed, 27 Jan 2021 16:05:39 -0800
From:   akpm@linux-foundation.org
To:     david@redhat.com, linmiaohe@huawei.com, mm-commits@vger.kernel.org
Subject:  +
 mm-memory_hotplug-use-helper-function-zone_end_pfn-to-get-end_pfn.patch
 added to -mm tree
Message-ID: <20210128000539.gOcqlpSC9%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/memory_hotplug: use helper function zone_end_pfn() to get end_pfn
has been added to the -mm tree.  Its filename is
     mm-memory_hotplug-use-helper-function-zone_end_pfn-to-get-end_pfn.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/mm-memory_hotplug-use-helper-function-zone_end_pfn-to-get-end_pfn.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/mm-memory_hotplug-use-helper-function-zone_end_pfn-to-get-end_pfn.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Miaohe Lin <linmiaohe@huawei.com>
Subject: mm/memory_hotplug: use helper function zone_end_pfn() to get end_pfn

Commit 108bcc96ef70 ("mm: add & use zone_end_pfn() and zone_spans_pfn()")
introduced the helper zone_end_pfn() to calculate the zone end pfn.  But
update_pgdat_span() forgot to use it.

Use this helper and rename local variable zone_end_pfn to end_pfn to avoid
a naming conflict with the existing zone_end_pfn().

Link: https://lkml.kernel.org/r/20210127093211.37714-1-linmiaohe@huawei.com
Signed-off-by: Miaohe Lin <linmiaohe@huawei.com>
Reviewed-by: David Hildenbrand <david@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memory_hotplug.c |    9 ++++-----
 1 file changed, 4 insertions(+), 5 deletions(-)

--- a/mm/memory_hotplug.c~mm-memory_hotplug-use-helper-function-zone_end_pfn-to-get-end_pfn
+++ a/mm/memory_hotplug.c
@@ -493,20 +493,19 @@ static void update_pgdat_span(struct pgl
 
 	for (zone = pgdat->node_zones;
 	     zone < pgdat->node_zones + MAX_NR_ZONES; zone++) {
-		unsigned long zone_end_pfn = zone->zone_start_pfn +
-					     zone->spanned_pages;
+		unsigned long end_pfn = zone_end_pfn(zone);
 
 		/* No need to lock the zones, they can't change. */
 		if (!zone->spanned_pages)
 			continue;
 		if (!node_end_pfn) {
 			node_start_pfn = zone->zone_start_pfn;
-			node_end_pfn = zone_end_pfn;
+			node_end_pfn = end_pfn;
 			continue;
 		}
 
-		if (zone_end_pfn > node_end_pfn)
-			node_end_pfn = zone_end_pfn;
+		if (end_pfn > node_end_pfn)
+			node_end_pfn = end_pfn;
 		if (zone->zone_start_pfn < node_start_pfn)
 			node_start_pfn = zone->zone_start_pfn;
 	}
_

Patches currently in -mm which might be from linmiaohe@huawei.com are

mm-page_owner-use-helper-function-zone_end_pfn-to-get-end_pfn.patch
mm-fix-potential-pte_unmap_unlock-pte-error.patch
mm-hugetlb-fix-potential-double-free-in-hugetlb_register_node-error-path.patch
mm-hugetlb-avoid-unnecessary-hugetlb_acct_memory-call.patch
mm-hugetlb-use-helper-huge_page_order-and-pages_per_huge_page.patch
mm-hugetlb-fix-use-after-free-when-subpool-max_hpages-accounting-is-not-enabled.patch
mm-workingsetc-avoid-unnecessary-max_nodes-estimation-in-count_shadow_nodes.patch
z3fold-remove-unused-attribute-for-release_z3fold_page.patch
z3fold-simplify-the-zhdr-initialization-code-in-init_z3fold_page.patch
mm-compaction-remove-duplicated-vm_bug_on_page-pagelocked.patch
hugetlbfs-remove-useless-bug_oninode-in-hugetlbfs_setattr.patch
hugetlbfs-use-helper-macro-default_hstate-in-init_hugetlbfs_fs.patch
hugetlbfs-correct-obsolete-function-name-in-hugetlbfs_read_iter.patch
hugetlbfs-remove-meaningless-variable-avoid_reserve.patch
hugetlbfs-make-hugepage-size-conversion-more-readable.patch
hugetlbfs-correct-some-obsolete-comments-about-inode-i_mutex.patch
mm-memory_hotplug-use-helper-function-zone_end_pfn-to-get-end_pfn.patch
mm-rmap-correct-some-obsolete-comments-of-anon_vma.patch
mm-zsmallocc-convert-to-use-kmem_cache_zalloc-in-cache_alloc_zspage.patch

