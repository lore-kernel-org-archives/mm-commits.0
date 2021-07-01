Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D4133C11F68
	for <mm-commits@archiver.kernel.org>; Thu,  1 Jul 2021 00:56:39 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id BC6DE61477
	for <mm-commits@archiver.kernel.org>; Thu,  1 Jul 2021 00:56:39 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235579AbhGAA7I (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 30 Jun 2021 20:59:08 -0400
Received: from mail.kernel.org ([198.145.29.99]:58234 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232066AbhGAA7H (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Wed, 30 Jun 2021 20:59:07 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 355A861474;
        Thu,  1 Jul 2021 00:56:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1625100998;
        bh=FAXijJj9/X/ewDyq0UYZzu96jIu2ywEzC7Se3yF49CE=;
        h=Date:From:To:Subject:From;
        b=Xk7L29J5Rbik0tivyiyxWuSx1i73N/CryYYsxWgCKdEzrs7XWhMOc0aBqBHwBCz3T
         /ACwvcCpVzoEMyLL5Aubk2q25vi2ujmfeMK8Wg1GPnzZPYSgOCHOJ1TCqZsj3/fugC
         daY3ri1yJVoYuGm2SMNVHgx94MRxntybqSKzDHvc=
Date:   Wed, 30 Jun 2021 17:56:37 -0700
From:   akpm@linux-foundation.org
To:     anshuman.khandual@arm.com, mike.kravetz@oracle.com,
        mm-commits@vger.kernel.org, rdunlap@infradead.org,
        songmuchun@bytedance.com
Subject:  [folded-merged]
 mm-migrate-fix-missing-update-page_private-to-hugetlb_page_subpool-v2.patch
 removed from -mm tree
Message-ID: <20210701005637._us7M1RCJ%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm: migrate: fix missing update page_private to hugetlb_page_subpool
has been removed from the -mm tree.  Its filename was
     mm-migrate-fix-missing-update-page_private-to-hugetlb_page_subpool-v2.patch

This patch was dropped because it was folded into mm-migrate-fix-missing-update-page_private-to-hugetlb_page_subpool.patch

------------------------------------------------------
From: Muchun Song <songmuchun@bytedance.com>
Subject: mm: migrate: fix missing update page_private to hugetlb_page_subpool

fix compiler error when !CONFIG_HUGETLB_PAGE reported by Randy

Link: https://lkml.kernel.org/r/20210521022747.35736-1-songmuchun@bytedance.com
Fixes: d6995da31122 ("hugetlb: use page.private for hugetlb specific page flags")
Signed-off-by: Muchun Song <songmuchun@bytedance.com>
Reported-by: Anshuman Khandual <anshuman.khandual@arm.com>
Reported-by: Randy Dunlap <rdunlap@infradead.org>
Reviewed-by: Mike Kravetz <mike.kravetz@oracle.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/hugetlb.h |    5 +++++
 1 file changed, 5 insertions(+)

--- a/include/linux/hugetlb.h~mm-migrate-fix-missing-update-page_private-to-hugetlb_page_subpool-v2
+++ a/include/linux/hugetlb.h
@@ -898,6 +898,11 @@ static inline void huge_ptep_modify_prot
 #else	/* CONFIG_HUGETLB_PAGE */
 struct hstate {};
 
+static inline struct hugepage_subpool *hugetlb_page_subpool(struct page *hpage)
+{
+	return NULL;
+}
+
 static inline int isolate_or_dissolve_huge_page(struct page *page,
 						struct list_head *list)
 {
_

Patches currently in -mm which might be from songmuchun@bytedance.com are

mm-memcontrol-fix-root_mem_cgroup-charging.patch
mm-memcontrol-fix-page-charging-in-page-replacement.patch
mm-memcontrol-bail-out-early-when-mm-in-get_mem_cgroup_from_mm.patch
mm-memcontrol-remove-the-pgdata-parameter-of-mem_cgroup_page_lruvec.patch
mm-memcontrol-simplify-lruvec_holds_page_lru_lock.patch
mm-memcontrol-rename-lruvec_holds_page_lru_lock-to-page_matches_lruvec.patch
mm-memcontrol-simplify-the-logic-of-objcg-pinning-memcg.patch
mm-memcontrol-move-obj_cgroup_uncharge_pages-out-of-css_set_lock.patch
mm-vmscan-remove-noinline_for_stack.patch
mm-memory_hotplug-factor-out-bootmem-core-functions-to-bootmem_infoc.patch
mm-hugetlb-introduce-a-new-config-hugetlb_page_free_vmemmap.patch
mm-hugetlb-gather-discrete-indexes-of-tail-page.patch
mm-hugetlb-free-the-vmemmap-pages-associated-with-each-hugetlb-page.patch
mm-hugetlb-defer-freeing-of-hugetlb-pages.patch
mm-hugetlb-alloc-the-vmemmap-pages-associated-with-each-hugetlb-page.patch
mm-hugetlb-add-a-kernel-parameter-hugetlb_free_vmemmap.patch
mm-memory_hotplug-disable-memmap_on_memory-when-hugetlb_free_vmemmap-enabled.patch
mm-hugetlb-introduce-nr_free_vmemmap_pages-in-the-struct-hstate.patch
mm-sparsemem-split-the-huge-pmd-mapping-of-vmemmap-pages.patch
mm-sparsemem-use-huge-pmd-mapping-for-vmemmap-pages.patch
mm-hugetlb-introduce-config_hugetlb_page_free_vmemmap_default_on.patch
mm-migrate-fix-missing-update-page_private-to-hugetlb_page_subpool.patch

