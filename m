Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3897FC433FE
	for <mm-commits@archiver.kernel.org>; Tue, 10 May 2022 04:17:34 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231368AbiEJEVZ (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 10 May 2022 00:21:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46154 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236218AbiEJEUB (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 10 May 2022 00:20:01 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3F8222AC6C2
        for <mm-commits@vger.kernel.org>; Mon,  9 May 2022 21:14:43 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id BF0E961746
        for <mm-commits@vger.kernel.org>; Tue, 10 May 2022 04:14:42 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 190FCC385A6;
        Tue, 10 May 2022 04:14:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1652156082;
        bh=u0R7PWgTwdpueNbXJUTji+OV4evHNZkn/O5I/kZXj7o=;
        h=Date:To:From:Subject:From;
        b=B982CsvidXZpUleUzic/FEK4gt9HFP+e//BQ6Oq56DneWh8ZWjeyowhwSbouuPVlP
         9SVU3eI8wJ+L4s73Xc9AH9hu6/mzVl2soAInHV6pd8bcK/AG9+HW6MDyrZpaTcFvom
         bzYYDNHUnRhMKWnZJX/ECU8ohbha/Oj0nWBH4WP0=
Date:   Mon, 09 May 2022 21:14:41 -0700
To:     mm-commits@vger.kernel.org, zhangliang5@huawei.com,
        willy@infradead.org, vbabka@suse.cz, shy828301@gmail.com,
        shakeelb@google.com, rppt@linux.ibm.com, rientjes@google.com,
        riel@surriel.com, peterx@redhat.com, pedrodemargomes@gmail.com,
        oleg@redhat.com, oded.gabbay@gmail.com, namit@vmware.com,
        mike.kravetz@oracle.com, mhocko@kernel.org,
        kirill.shutemov@linux.intel.com, khalid.aziz@oracle.com,
        jhubbard@nvidia.com, jgg@nvidia.com, jannh@google.com,
        jack@suse.cz, hughd@google.com, hch@lst.de, guro@fb.com,
        ddutile@redhat.com, aarcange@redhat.com, david@redhat.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-rmap-use-page_move_anon_rmap-when-reusing-a-mapped-pageanon-page-exclusively.patch removed from -mm tree
Message-Id: <20220510041442.190FCC385A6@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: mm/rmap: use page_move_anon_rmap() when reusing a mapped PageAnon() page exclusively
has been removed from the -mm tree.  Its filename was
     mm-rmap-use-page_move_anon_rmap-when-reusing-a-mapped-pageanon-page-exclusively.patch

This patch was dropped because it was merged into mm-stable

------------------------------------------------------
From: David Hildenbrand <david@redhat.com>
Subject: mm/rmap: use page_move_anon_rmap() when reusing a mapped PageAnon() page exclusively

We want to mark anonymous pages exclusive, and when using
page_move_anon_rmap() we know that we are the exclusive user, as properly
documented.  This is a preparation for marking anonymous pages exclusive
in page_move_anon_rmap().

In both instances, we're holding page lock and are sure that we're the
exclusive owner (page_count() == 1).  hugetlb already properly uses
page_move_anon_rmap() in the write fault handler.

Note that in case of a PTE-mapped THP, we'll only end up calling this
function if the whole THP is only referenced by the single PTE mapping a
single subpage (page_count() == 1); consequently, it's fine to modify the
compound page mapping inside page_move_anon_rmap().

Link: https://lkml.kernel.org/r/20220428083441.37290-10-david@redhat.com
Signed-off-by: David Hildenbrand <david@redhat.com>
Acked-by: Vlastimil Babka <vbabka@suse.cz>
Cc: Andrea Arcangeli <aarcange@redhat.com>
Cc: Christoph Hellwig <hch@lst.de>
Cc: David Rientjes <rientjes@google.com>
Cc: Don Dutile <ddutile@redhat.com>
Cc: Hugh Dickins <hughd@google.com>
Cc: Jan Kara <jack@suse.cz>
Cc: Jann Horn <jannh@google.com>
Cc: Jason Gunthorpe <jgg@nvidia.com>
Cc: John Hubbard <jhubbard@nvidia.com>
Cc: Khalid Aziz <khalid.aziz@oracle.com>
Cc: "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>
Cc: Liang Zhang <zhangliang5@huawei.com>
Cc: "Matthew Wilcox (Oracle)" <willy@infradead.org>
Cc: Michal Hocko <mhocko@kernel.org>
Cc: Mike Kravetz <mike.kravetz@oracle.com>
Cc: Mike Rapoport <rppt@linux.ibm.com>
Cc: Nadav Amit <namit@vmware.com>
Cc: Oded Gabbay <oded.gabbay@gmail.com>
Cc: Oleg Nesterov <oleg@redhat.com>
Cc: Pedro Demarchi Gomes <pedrodemargomes@gmail.com>
Cc: Peter Xu <peterx@redhat.com>
Cc: Rik van Riel <riel@surriel.com>
Cc: Roman Gushchin <guro@fb.com>
Cc: Shakeel Butt <shakeelb@google.com>
Cc: Yang Shi <shy828301@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/huge_memory.c |    2 ++
 mm/memory.c      |    1 +
 2 files changed, 3 insertions(+)

--- a/mm/huge_memory.c~mm-rmap-use-page_move_anon_rmap-when-reusing-a-mapped-pageanon-page-exclusively
+++ a/mm/huge_memory.c
@@ -1317,6 +1317,8 @@ vm_fault_t do_huge_pmd_wp_page(struct vm
 		try_to_free_swap(page);
 	if (page_count(page) == 1) {
 		pmd_t entry;
+
+		page_move_anon_rmap(page, vma);
 		entry = pmd_mkyoung(orig_pmd);
 		entry = maybe_pmd_mkwrite(pmd_mkdirty(entry), vma);
 		if (pmdp_set_access_flags(vma, haddr, vmf->pmd, entry, 1))
--- a/mm/memory.c~mm-rmap-use-page_move_anon_rmap-when-reusing-a-mapped-pageanon-page-exclusively
+++ a/mm/memory.c
@@ -3303,6 +3303,7 @@ static vm_fault_t do_wp_page(struct vm_f
 		 * and the page is locked, it's dark out, and we're wearing
 		 * sunglasses. Hit it.
 		 */
+		page_move_anon_rmap(page, vma);
 		unlock_page(page);
 		wp_page_reuse(vmf);
 		return VM_FAULT_WRITE;
_

Patches currently in -mm which might be from david@redhat.com are


