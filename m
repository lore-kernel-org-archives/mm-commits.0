Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D0AF1C43334
	for <mm-commits@archiver.kernel.org>; Sat,  9 Jul 2022 02:32:06 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229489AbiGICcF (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 8 Jul 2022 22:32:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53652 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229608AbiGICbz (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 8 Jul 2022 22:31:55 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A5D647A53B
        for <mm-commits@vger.kernel.org>; Fri,  8 Jul 2022 19:31:54 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 181D76255A
        for <mm-commits@vger.kernel.org>; Sat,  9 Jul 2022 02:31:54 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5EAFAC341C8;
        Sat,  9 Jul 2022 02:31:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1657333913;
        bh=zL6jnVMUNipF2+YHaQJVZcjLXWDEz8X431ql6DWadz0=;
        h=Date:To:From:Subject:From;
        b=Vx70Kqj07PtWMtFqV2wvoY+FY+y24IPaj6CLQzedQeVzLsAKXUp8taRzk+FZu5UhA
         yBB+0DasLh1uHuf95PY/gZTYBbOJYQYVl8KPUdo0nC7Sp0D8b2MEKBUAOOyDrshdPH
         uUI2C7EsyAdM07yN3H+zaVFyMBq0uKwA9mOLdnRg=
Date:   Fri, 08 Jul 2022 19:31:52 -0700
To:     mm-commits@vger.kernel.org, shakeelb@google.com,
        roman.gushchin@linux.dev, mkoutny@suse.com, mhocko@kernel.org,
        longman@redhat.com, hannes@cmpxchg.org,
        duanxiongchun@bytedance.com, songmuchun@bytedance.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [to-be-updated] mm-lru-add-vm_warn_on_once_folio-to-lru-maintenance-function.patch removed from -mm tree
Message-Id: <20220709023153.5EAFAC341C8@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: mm: lru: add VM_WARN_ON_ONCE_FOLIO to lru maintenance function
has been removed from the -mm tree.  Its filename was
     mm-lru-add-vm_warn_on_once_folio-to-lru-maintenance-function.patch

This patch was dropped because an updated version will be merged

------------------------------------------------------
From: Muchun Song <songmuchun@bytedance.com>
Subject: mm: lru: add VM_WARN_ON_ONCE_FOLIO to lru maintenance function
Date: Tue, 21 Jun 2022 20:56:57 +0800

We need to make sure that the page is deleted from or added to the correct
lruvec list.  So add a VM_WARN_ON_ONCE_FOLIO() to catch invalid users. 
Then the VM_BUG_ON_PAGE() in move_pages_to_lru() could be removed since
add_page_to_lru_list() will check that.

Link: https://lkml.kernel.org/r/20220621125658.64935-11-songmuchun@bytedance.com
Signed-off-by: Muchun Song <songmuchun@bytedance.com>
Acked-by: Roman Gushchin <roman.gushchin@linux.dev>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Michal Hocko <mhocko@kernel.org>
Cc: Michal Koutný <mkoutny@suse.com>
Cc: Shakeel Butt <shakeelb@google.com>
Cc: Waiman Long <longman@redhat.com>
Cc: Xiongchun Duan <duanxiongchun@bytedance.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/mm_inline.h |    6 ++++++
 mm/vmscan.c               |    1 -
 2 files changed, 6 insertions(+), 1 deletion(-)

--- a/include/linux/mm_inline.h~mm-lru-add-vm_warn_on_once_folio-to-lru-maintenance-function
+++ a/include/linux/mm_inline.h
@@ -99,6 +99,8 @@ void lruvec_add_folio(struct lruvec *lru
 {
 	enum lru_list lru = folio_lru_list(folio);
 
+	VM_WARN_ON_ONCE_FOLIO(!folio_matches_lruvec(folio, lruvec), folio);
+
 	update_lru_size(lruvec, lru, folio_zonenum(folio),
 			folio_nr_pages(folio));
 	if (lru != LRU_UNEVICTABLE)
@@ -116,6 +118,8 @@ void lruvec_add_folio_tail(struct lruvec
 {
 	enum lru_list lru = folio_lru_list(folio);
 
+	VM_WARN_ON_ONCE_FOLIO(!folio_matches_lruvec(folio, lruvec), folio);
+
 	update_lru_size(lruvec, lru, folio_zonenum(folio),
 			folio_nr_pages(folio));
 	/* This is not expected to be used on LRU_UNEVICTABLE */
@@ -133,6 +137,8 @@ void lruvec_del_folio(struct lruvec *lru
 {
 	enum lru_list lru = folio_lru_list(folio);
 
+	VM_WARN_ON_ONCE_FOLIO(!folio_matches_lruvec(folio, lruvec), folio);
+
 	if (lru != LRU_UNEVICTABLE)
 		list_del(&folio->lru);
 	update_lru_size(lruvec, lru, folio_zonenum(folio),
--- a/mm/vmscan.c~mm-lru-add-vm_warn_on_once_folio-to-lru-maintenance-function
+++ a/mm/vmscan.c
@@ -2355,7 +2355,6 @@ static unsigned int move_pages_to_lru(st
 			continue;
 		}
 
-		VM_BUG_ON_FOLIO(!folio_matches_lruvec(folio, lruvec), folio);
 		lruvec_add_folio(lruvec, folio);
 		nr_pages = folio_nr_pages(folio);
 		nr_moved += nr_pages;
_

Patches currently in -mm which might be from songmuchun@bytedance.com are

mm-fix-missing-wake-up-event-for-fsdax-pages.patch
mm-hugetlb_vmemmap-delete-hugetlb_optimize_vmemmap_enabled.patch
mm-hugetlb_vmemmap-optimize-vmemmap_optimize_mode-handling.patch
mm-hugetlb_vmemmap-introduce-the-name-hvo.patch
mm-hugetlb_vmemmap-move-vmemmap-code-related-to-hugetlb-to-hugetlb_vmemmapc.patch
mm-hugetlb_vmemmap-replace-early_param-with-core_param.patch
mm-hugetlb_vmemmap-improve-hugetlb_vmemmap-code-readability.patch
mm-hugetlb_vmemmap-move-code-comments-to-vmemmap_deduprst.patch
mm-hugetlb_vmemmap-use-ptrs_per_pte-instead-of-pmd_size-page_size.patch

