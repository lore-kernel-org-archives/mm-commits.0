Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CB6E4C07E9D
	for <mm-commits@archiver.kernel.org>; Tue, 27 Sep 2022 02:51:52 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230337AbiI0Cvu (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 26 Sep 2022 22:51:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58000 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230438AbiI0Ctm (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 26 Sep 2022 22:49:42 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 729BEF34E2
        for <mm-commits@vger.kernel.org>; Mon, 26 Sep 2022 19:49:01 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 1D686B81911
        for <mm-commits@vger.kernel.org>; Tue, 27 Sep 2022 02:49:00 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B49E3C433C1;
        Tue, 27 Sep 2022 02:48:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1664246939;
        bh=E3ynWRErUKtn/EjtpdaKzQKmEozVRFhSUODNAfU3RgI=;
        h=Date:To:From:Subject:From;
        b=Zow4k1KWXqgPOJb96riC3r0q/hDp4ElhJuhTF4UHAQ306eMPFEYN1ClcK/Y1uFV4j
         mhKhKb2lwZKRKtQAooqbx3ypfNV5+dkKgNFD49/wxRVnBQ5HKNKbWRBlBOtNLG06ZA
         1FmRvZPmLoufOazJ2E0HtjO75f8Tx5Q7q2R/TJIo=
Date:   Mon, 26 Sep 2022 19:48:59 -0700
To:     mm-commits@vger.kernel.org, yuzhao@google.com, willy@infradead.org,
        will@kernel.org, vbabka@suse.cz, svens@linux.ibm.com,
        sj@kernel.org, dhowells@redhat.com, david@redhat.com,
        dave@stgolabs.net, catalin.marinas@arm.com,
        Liam.Howlett@Oracle.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-khugepaged-optimize-collapse_pte_mapped_thp-by-using-vma_lookup.patch removed from -mm tree
Message-Id: <20220927024859.B49E3C433C1@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: mm/khugepaged: optimize collapse_pte_mapped_thp() by using vma_lookup()
has been removed from the -mm tree.  Its filename was
     mm-khugepaged-optimize-collapse_pte_mapped_thp-by-using-vma_lookup.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: "Liam R. Howlett" <Liam.Howlett@Oracle.com>
Subject: mm/khugepaged: optimize collapse_pte_mapped_thp() by using vma_lookup()
Date: Tue, 6 Sep 2022 19:48:50 +0000

vma_lookup() will walk the vma tree once and not continue to look for the
next vma.  Since the exact vma is checked below, this is a more optimal
way of searching.

Link: https://lkml.kernel.org/r/20220906194824.2110408-22-Liam.Howlett@oracle.com
Signed-off-by: Liam R. Howlett <Liam.Howlett@Oracle.com>
Reviewed-by: Vlastimil Babka <vbabka@suse.cz>
Tested-by: Yu Zhao <yuzhao@google.com>
Cc: Catalin Marinas <catalin.marinas@arm.com>
Cc: David Hildenbrand <david@redhat.com>
Cc: David Howells <dhowells@redhat.com>
Cc: Davidlohr Bueso <dave@stgolabs.net>
Cc: "Matthew Wilcox (Oracle)" <willy@infradead.org>
Cc: SeongJae Park <sj@kernel.org>
Cc: Sven Schnelle <svens@linux.ibm.com>
Cc: Will Deacon <will@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/khugepaged.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/mm/khugepaged.c~mm-khugepaged-optimize-collapse_pte_mapped_thp-by-using-vma_lookup
+++ a/mm/khugepaged.c
@@ -1389,7 +1389,7 @@ static void collapse_and_free_pmd(struct
 void collapse_pte_mapped_thp(struct mm_struct *mm, unsigned long addr)
 {
 	unsigned long haddr = addr & HPAGE_PMD_MASK;
-	struct vm_area_struct *vma = find_vma(mm, haddr);
+	struct vm_area_struct *vma = vma_lookup(mm, haddr);
 	struct page *hpage;
 	pte_t *start_pte, *pte;
 	pmd_t *pmd;
_

Patches currently in -mm which might be from Liam.Howlett@Oracle.com are


