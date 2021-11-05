Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1D428C433F5
	for <mm-commits@archiver.kernel.org>; Fri,  5 Nov 2021 20:37:31 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 0723B60E08
	for <mm-commits@archiver.kernel.org>; Fri,  5 Nov 2021 20:37:31 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232016AbhKEUkK (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 5 Nov 2021 16:40:10 -0400
Received: from mail.kernel.org ([198.145.29.99]:34952 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233038AbhKEUkJ (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Fri, 5 Nov 2021 16:40:09 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 2628A60720;
        Fri,  5 Nov 2021 20:37:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1636144649;
        bh=4eOvPhGrgkxeO9IzUCUsx6OFT8uD8g534bxI7hddIGQ=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=ajt+6bLrxFljrO5kKf1ZOoa1ZZ6Q2ZGWAtyKifFzuZBQnpYCdGmYhjryX6nByczWQ
         XGw44A1hEyVSonvl5JJPc8lD1K9ipgO+8ORQv326djPnBnAPAK3BI1iJVaSeu9zcsX
         66fmM9/bDaAfo1rkQ4MBKwV/QV1t+S0in62UTRJE=
Date:   Fri, 05 Nov 2021 13:37:28 -0700
From:   Andrew Morton <akpm@linux-foundation.org>
To:     akpm@linux-foundation.org, david@redhat.com, hannes@cmpxchg.org,
        linux-mm@kvack.org, mhocko@kernel.org, mm-commits@vger.kernel.org,
        peterx@redhat.com, songmuchun@bytedance.com,
        torvalds@linux-foundation.org, willy@infradead.org
Subject:  [patch 054/262] mm/memcg: drop swp_entry_t* in
 mc_handle_file_pte()
Message-ID: <20211105203728.UuCSJCA-O%akpm@linux-foundation.org>
In-Reply-To: <20211105133408.cccbb98b71a77d5e8430aba1@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

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
@@ -5545,7 +5545,7 @@ static struct page *mc_handle_swap_pte(s
 #endif
 
 static struct page *mc_handle_file_pte(struct vm_area_struct *vma,
-			unsigned long addr, pte_t ptent, swp_entry_t *entry)
+			unsigned long addr, pte_t ptent)
 {
 	if (!vma->vm_file) /* anonymous vma */
 		return NULL;
@@ -5718,7 +5718,7 @@ static enum mc_target_type get_mctgt_typ
 	else if (is_swap_pte(ptent))
 		page = mc_handle_swap_pte(vma, ptent, &ent);
 	else if (pte_none(ptent))
-		page = mc_handle_file_pte(vma, addr, ptent, &ent);
+		page = mc_handle_file_pte(vma, addr, ptent);
 
 	if (!page && !ent.val)
 		return ret;
_
