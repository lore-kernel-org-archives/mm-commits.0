Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9828BC433EF
	for <mm-commits@archiver.kernel.org>; Sun, 19 Sep 2021 23:47:08 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 678036101B
	for <mm-commits@archiver.kernel.org>; Sun, 19 Sep 2021 23:47:08 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230260AbhISXsd (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Sun, 19 Sep 2021 19:48:33 -0400
Received: from mail.kernel.org ([198.145.29.99]:48162 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229517AbhISXsd (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Sun, 19 Sep 2021 19:48:33 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id EE48260FC2;
        Sun, 19 Sep 2021 23:47:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1632095227;
        bh=M2ZMeuQfp7Y2D8S/FoUNunvBSKgg7YeYv8rHYj0+J4s=;
        h=Date:From:To:Subject:From;
        b=P5JbqlbMx7DDI5pZxsKFDXzhxDdaYsKgsIDUdQSI6h5oJYOGm1WE5U4CnorDYjfpF
         S2Ty2fGyVu7TJKI55aartT3j/6bwI+J5RzsDvmjpc7twBObVgQqIYt+js8imVP3rtl
         ny53uK1Vca2BgzuESIzgMae1YZtljy7axbk2iUFs=
Date:   Sun, 19 Sep 2021 16:47:06 -0700
From:   akpm@linux-foundation.org
To:     mm-commits@vger.kernel.org, willy@infradead.org,
        songmuchun@bytedance.com, mhocko@kernel.org, hannes@cmpxchg.org,
        david@redhat.com, peterx@redhat.com
Subject:  + mm-memcg-drop-swp_entry_t-in-mc_handle_file_pte.patch
 added to -mm tree
Message-ID: <20210919234706.FCOys%akpm@linux-foundation.org>
User-Agent: s-nail v14.9.10
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/memcg: drop swp_entry_t* in mc_handle_file_pte()
has been added to the -mm tree.  Its filename is
     mm-memcg-drop-swp_entry_t-in-mc_handle_file_pte.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/mm-memcg-drop-swp_entry_t-in-mc_handle_file_pte.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/mm-memcg-drop-swp_entry_t-in-mc_handle_file_pte.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Peter Xu <peterx@redhat.com>
Subject: mm/memcg: drop swp_entry_t* in mc_handle_file_pte()

After the rework of f5df8635c5a3 ("mm: use find_get_incore_page in memcontrol",
2020-10-13) it's unused.

Link: https://lkml.kernel.org/r/20210916193014.80129-1-peterx@redhat.com
Signed-off-by: Peter Xu <peterx@redhat.com>
Reviewed-by: Muchun Song <songmuchun@bytedance.com>
Reviewed-by: David Hildenbrand <david@redhat.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Michal Hocko <mhocko@kernel.org>
Cc: Matthew Wilcox <willy@infradead.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memcontrol.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/mm/memcontrol.c~mm-memcg-drop-swp_entry_t-in-mc_handle_file_pte
+++ a/mm/memcontrol.c
@@ -5555,7 +5555,7 @@ static struct page *mc_handle_swap_pte(s
 #endif
 
 static struct page *mc_handle_file_pte(struct vm_area_struct *vma,
-			unsigned long addr, pte_t ptent, swp_entry_t *entry)
+			unsigned long addr, pte_t ptent)
 {
 	if (!vma->vm_file) /* anonymous vma */
 		return NULL;
@@ -5728,7 +5728,7 @@ static enum mc_target_type get_mctgt_typ
 	else if (is_swap_pte(ptent))
 		page = mc_handle_swap_pte(vma, ptent, &ent);
 	else if (pte_none(ptent))
-		page = mc_handle_file_pte(vma, addr, ptent, &ent);
+		page = mc_handle_file_pte(vma, addr, ptent);
 
 	if (!page && !ent.val)
 		return ret;
_

Patches currently in -mm which might be from peterx@redhat.com are

mm-smaps-fix-shmem-pte-hole-swap-calculation.patch
mm-smaps-use-vma-vm_pgoff-directly-when-counting-partial-swap.patch
mm-smaps-simplify-shmem-handling-of-pte-holes.patch
mm-memcg-drop-swp_entry_t-in-mc_handle_file_pte.patch
mm-shmem-unconditionally-set-pte-dirty-in-mfill_atomic_install_pte.patch
mm-clear-vmf-pte-after-pte_unmap_same-returns.patch
mm-drop-first_index-last_index-in-zap_details.patch
mm-add-zap_skip_check_mapping-helper.patch
mm-hugetlb-drop-__unmap_hugepage_range-definition-from-hugetlbh.patch

