Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BD6D9C41513
	for <mm-commits@archiver.kernel.org>; Wed,  2 Aug 2023 15:58:58 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235444AbjHBP66 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 2 Aug 2023 11:58:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47490 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235442AbjHBP6v (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 2 Aug 2023 11:58:51 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BCF3D126
        for <mm-commits@vger.kernel.org>; Wed,  2 Aug 2023 08:58:38 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 0C42B61A35
        for <mm-commits@vger.kernel.org>; Wed,  2 Aug 2023 15:58:38 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5679BC433C9;
        Wed,  2 Aug 2023 15:58:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1690991917;
        bh=s2iCm5xh2gZdsRK7VDt7bMJi5wN/3yMHI68n7aF0E0s=;
        h=Date:To:From:Subject:From;
        b=PAxjiSPe0c0BS3R4PGlS9zznLSuPjhwOz49GS1Mj4ac+DdMhkiHr78LAouZl+MpG9
         8alkMy5pqfWGmavTN3oF3z1a2eGBFzPGVoXzWcxmg+C7HkCqlc/zMvIv2f3FV/ucyU
         1A0RbdxUvllHoW+UmewQzC+fSWYBQyjZZxrHc3A0=
Date:   Wed, 02 Aug 2023 08:58:36 -0700
To:     mm-commits@vger.kernel.org, zhengqi.arch@bytedance.com,
        yuzhao@google.com, surenb@google.com, suleiman@google.com,
        steven@liquorix.net, quic_charante@quicinc.com,
        oleksandr@natalenko.name, matthias.bgg@gmail.com,
        lecopzer.chen@mediatek.com, heftig@archlinux.org,
        bgeffon@google.com, baohua@kernel.org,
        angelogioacchino.delregno@collabora.com,
        aneesh.kumar@linux.ibm.com, kaleshsingh@google.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-unstable-multi-gen-lru-fix-can_swap-in-lru_gen_look_around.patch added to mm-unstable branch
Message-Id: <20230802155837.5679BC433C9@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: Multi-gen LRU: Fix can_swap in lru_gen_look_around()
has been added to the -mm mm-unstable branch.  Its filename is
     mm-unstable-multi-gen-lru-fix-can_swap-in-lru_gen_look_around.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-unstable-multi-gen-lru-fix-can_swap-in-lru_gen_look_around.patch

This patch will later appear in the mm-unstable branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next via the mm-everything
branch at git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
and is updated there every 2-3 working days

------------------------------------------------------
From: Kalesh Singh <kaleshsingh@google.com>
Subject: Multi-gen LRU: Fix can_swap in lru_gen_look_around()
Date: Tue, 1 Aug 2023 19:56:04 -0700

walk->can_swap might be invalid since it's not guaranteed to be
initialized for the particular lruvec.  Instead deduce it from the folio
type (anon/file).

Link: https://lkml.kernel.org/r/20230802025606.346758-3-kaleshsingh@google.com
Fixes: 018ee47f1489 ("mm: multi-gen LRU: exploit locality in rmap")
Signed-off-by: Kalesh Singh <kaleshsingh@google.com>
Tested-by: AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com> [mediatek]
Tested-by: Charan Teja Kalla <quic_charante@quicinc.com>
Cc: Yu Zhao <yuzhao@google.com>
Cc: Aneesh Kumar K V <aneesh.kumar@linux.ibm.com>
Cc: Barry Song <baohua@kernel.org>
Cc: Brian Geffon <bgeffon@google.com>
Cc: Jan Alexander Steffens (heftig) <heftig@archlinux.org>
Cc: Lecopzer Chen <lecopzer.chen@mediatek.com>
Cc: Matthias Brugger <matthias.bgg@gmail.com>
Cc: Oleksandr Natalenko <oleksandr@natalenko.name>
Cc: Qi Zheng <zhengqi.arch@bytedance.com>
Cc: Steven Barrett <steven@liquorix.net>
Cc: Suleiman Souhlal <suleiman@google.com>
Cc: Suren Baghdasaryan <surenb@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/vmscan.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/mm/vmscan.c~mm-unstable-multi-gen-lru-fix-can_swap-in-lru_gen_look_around
+++ a/mm/vmscan.c
@@ -4656,6 +4656,7 @@ void lru_gen_look_around(struct page_vma
 	pte_t *pte = pvmw->pte;
 	unsigned long addr = pvmw->address;
 	struct folio *folio = pfn_folio(pvmw->pfn);
+	bool can_swap = !folio_is_file_lru(folio);
 	struct mem_cgroup *memcg = folio_memcg(folio);
 	struct pglist_data *pgdat = folio_pgdat(folio);
 	struct lruvec *lruvec = mem_cgroup_lruvec(memcg, pgdat);
@@ -4704,7 +4705,7 @@ void lru_gen_look_around(struct page_vma
 		if (!pte_young(ptent))
 			continue;
 
-		folio = get_pfn_folio(pfn, memcg, pgdat, !walk || walk->can_swap);
+		folio = get_pfn_folio(pfn, memcg, pgdat, can_swap);
 		if (!folio)
 			continue;
 
_

Patches currently in -mm which might be from kaleshsingh@google.com are

mm-unstable-multi-gen-lru-fix-per-zone-reclaim.patch
mm-unstable-multi-gen-lru-avoid-race-in-inc_min_seq.patch
mm-unstable-multi-gen-lru-fix-can_swap-in-lru_gen_look_around.patch

