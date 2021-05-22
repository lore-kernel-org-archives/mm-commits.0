Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6114CC2B9F2
	for <mm-commits@archiver.kernel.org>; Sat, 22 May 2021 22:16:35 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 2776F60FE3
	for <mm-commits@archiver.kernel.org>; Sat, 22 May 2021 22:16:35 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231431AbhEVWR6 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Sat, 22 May 2021 18:17:58 -0400
Received: from mail.kernel.org ([198.145.29.99]:36518 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231428AbhEVWR4 (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Sat, 22 May 2021 18:17:56 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id B871061182;
        Sat, 22 May 2021 22:16:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1621721790;
        bh=i40D/QmStt33DaCgG4plIjLJ+TlWN0EkqEiFDZ9aWaI=;
        h=Date:From:To:Subject:From;
        b=YRt0IwOpXwJWi2z4pVk8QACtmi8Icm907TLf47WTZ9rJmJWMaAlhAzUYtgznPzmVQ
         KCC+jTgcefSwjOavSVqKN5gtCTh98s2jvxaFS6fFz19Uw+WVa/F0L/Q30m2we38NPc
         pSFz7PnQKFzdd0bzSb2IdrStMUgudZ3J5mdInvmg=
Date:   Sat, 22 May 2021 15:16:30 -0700
From:   akpm@linux-foundation.org
To:     anshuman.khandual@arm.com, mike.kravetz@oracle.com,
        mm-commits@vger.kernel.org, rdunlap@infradead.org,
        songmuchun@bytedance.com
Subject:  +
 mm-migrate-fix-missing-update-page_private-to-hugetlb_page_subpool-v2.patch
 added to -mm tree
Message-ID: <20210522221630.MtkBxtkgF%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm: migrate: fix missing update page_private to hugetlb_page_subpool
has been added to the -mm tree.  Its filename is
     mm-migrate-fix-missing-update-page_private-to-hugetlb_page_subpool-v2.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/mm-migrate-fix-missing-update-page_private-to-hugetlb_page_subpool-v2.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/mm-migrate-fix-missing-update-page_private-to-hugetlb_page_subpool-v2.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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
@@ -925,6 +925,11 @@ static inline bool is_hugetlb_free_vmemm
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
mm-migrate-fix-missing-update-page_private-to-hugetlb_page_subpool.patch
mm-migrate-fix-missing-update-page_private-to-hugetlb_page_subpool-v2.patch

