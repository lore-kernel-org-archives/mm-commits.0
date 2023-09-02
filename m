Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 916C5C001DB
	for <mm-commits@archiver.kernel.org>; Sat,  2 Sep 2023 22:14:13 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232766AbjIBWOP (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Sat, 2 Sep 2023 18:14:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40798 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229959AbjIBWOO (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Sat, 2 Sep 2023 18:14:14 -0400
Received: from sin.source.kernel.org (sin.source.kernel.org [145.40.73.55])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 218DBCDD
        for <mm-commits@vger.kernel.org>; Sat,  2 Sep 2023 15:14:11 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 2378ACE0171
        for <mm-commits@vger.kernel.org>; Sat,  2 Sep 2023 22:14:09 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5DF6FC433C7;
        Sat,  2 Sep 2023 22:14:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1693692847;
        bh=672QC0rNlW3Tn/SQhIA601/g6y7IjLrGkWz549pkqGI=;
        h=Date:To:From:Subject:From;
        b=tJMkBPsv5dc0vPKytjtj/bm4nka5h92MxHFaFsHHP4ypRmf95u8CYjXNZ7f5D4liv
         k3wbdycqzfxTy7DAPY71e3XUreiWUFX/rfWgHbnYWtClK4cVYKoIrkW7YfHUtuFWI2
         OJRNtRYTtZmm2dCrs29cUrGKu6+3DJD5AxeGNwn4=
Date:   Sat, 02 Sep 2023 15:14:06 -0700
To:     mm-commits@vger.kernel.org, riel@surriel.com, hannes@cmpxchg.org,
        david@redhat.com, shr@devkernel.io, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [folded-merged] proc-ksm-add-ksm-stats-to-proc-pid-smaps-v5.patch removed from -mm tree
Message-Id: <20230902221407.5DF6FC433C7@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: proc-ksm-add-ksm-stats-to-proc-pid-smaps-v5
has been removed from the -mm tree.  Its filename was
     proc-ksm-add-ksm-stats-to-proc-pid-smaps-v5.patch

This patch was dropped because it was folded into proc-ksm-add-ksm-stats-to-proc-pid-smaps.patch

------------------------------------------------------
From: Stefan Roesch <shr@devkernel.io>
Subject: proc-ksm-add-ksm-stats-to-proc-pid-smaps-v5
Date: Wed, 23 Aug 2023 10:01:07 -0700

Link: https://lkml.kernel.org/r/20230823170107.1457915-1-shr@devkernel.io
Signed-off-by: Stefan Roesch <shr@devkernel.io>
Reviewed-by: David Hildenbrand <david@redhat.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Rik van Riel <riel@surriel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/filesystems/proc.rst |    4 ++--
 fs/proc/task_mmu.c                 |   12 ++++++------
 2 files changed, 8 insertions(+), 8 deletions(-)

--- a/Documentation/filesystems/proc.rst~proc-ksm-add-ksm-stats-to-proc-pid-smaps-v5
+++ a/Documentation/filesystems/proc.rst
@@ -502,8 +502,8 @@ accessed.
 a mapping associated with a file may contain anonymous pages: when MAP_PRIVATE
 and a page is modified, the file page is replaced by a private anonymous copy.
 
-"KSM" shows the amount of anonymous memory that has been de-duplicated. The
-value is independent of the use of shared zeropage.
+"KSM" reports how many of the pages are KSM pages. Note that KSM-placed zeropages
+are not included, only actual KSM pages.
 
 "LazyFree" shows the amount of memory which is marked by madvise(MADV_FREE).
 The memory isn't freed immediately with madvise(). It's freed in memory
--- a/fs/proc/task_mmu.c~proc-ksm-add-ksm-stats-to-proc-pid-smaps-v5
+++ a/fs/proc/task_mmu.c
@@ -437,9 +437,9 @@ static void smaps_page_accumulate(struct
 	}
 }
 
-static void smaps_account(struct mem_size_stats *mss, pte_t *pte,
-		struct page *page, bool compound, bool young, bool dirty,
-		bool locked, bool migration)
+static void smaps_account(struct mem_size_stats *mss, struct page *page,
+		bool compound, bool young, bool dirty, bool locked,
+		bool migration)
 {
 	int i, nr = compound ? compound_nr(page) : 1;
 	unsigned long size = nr * PAGE_SIZE;
@@ -454,7 +454,7 @@ static void smaps_account(struct mem_siz
 			mss->lazyfree += size;
 	}
 
-	if (PageKsm(page) && (!pte || !is_ksm_zero_pte(*pte)))
+	if (PageKsm(page))
 		mss->ksm += size;
 
 	mss->resident += size;
@@ -562,7 +562,7 @@ static void smaps_pte_entry(pte_t *pte,
 	if (!page)
 		return;
 
-	smaps_account(mss, pte, page, false, young, dirty, locked, migration);
+	smaps_account(mss, page, false, young, dirty, locked, migration);
 }
 
 #ifdef CONFIG_TRANSPARENT_HUGEPAGE
@@ -596,7 +596,7 @@ static void smaps_pmd_entry(pmd_t *pmd,
 	else
 		mss->file_thp += HPAGE_PMD_SIZE;
 
-	smaps_account(mss, NULL, page, true, pmd_young(*pmd), pmd_dirty(*pmd),
+	smaps_account(mss, page, true, pmd_young(*pmd), pmd_dirty(*pmd),
 		      locked, migration);
 }
 #else
_

Patches currently in -mm which might be from shr@devkernel.io are

proc-ksm-add-ksm-stats-to-proc-pid-smaps.patch

