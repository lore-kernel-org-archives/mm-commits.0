Return-Path: <SRS0=vc0r=AR=vger.kernel.org=mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.0 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7C4DDC433DF
	for <mm-commits@archiver.kernel.org>; Mon,  6 Jul 2020 23:04:03 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 57B2D20739
	for <mm-commits@archiver.kernel.org>; Mon,  6 Jul 2020 23:04:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1594076643;
	bh=u7eAVEtpUZH3JBOP2bQEumBKuh8YXnd+ujGhkaCk+IQ=;
	h=Date:From:To:Subject:In-Reply-To:Reply-To:List-ID:From;
	b=lxkfltYjxRwpJCHwn1G5GlHBQfCGGkDr1V+yhQp27JWBMog6FVuVfZDBQ1Od6fwLO
	 jfWjXbKxbZLPH7a2TD2ql/sJNsEp+FbQmj+A7noEAA/7353uoVP0BpjZrJfrswb7kz
	 Y6+N4QvVo+mBdRs7K6MNwgP48ZBWk0lcjo7Iv6Ms=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726805AbgGFXED (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 6 Jul 2020 19:04:03 -0400
Received: from mail.kernel.org ([198.145.29.99]:55936 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725942AbgGFXED (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Mon, 6 Jul 2020 19:04:03 -0400
Received: from localhost.localdomain (c-73-231-172-41.hsd1.ca.comcast.net [73.231.172.41])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id B02E220723;
        Mon,  6 Jul 2020 23:04:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1594076642;
        bh=u7eAVEtpUZH3JBOP2bQEumBKuh8YXnd+ujGhkaCk+IQ=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=riiyH6hCsAmh9/kw9RszPlxcE0+FraLqOBhpi1H4xSotJlrc8E3xbnw1Hoj/DfFR/
         VTfU7Sc1w1FO4M6J8KFIvQqlNTF/cNcLqWuyLQDB2l4fXJiI8QO6YQMUWGsqg4ofW9
         NQGruQG+iLAr0T0Ge6vKuoiIBxmr0U75JVf3+9AE=
Date:   Mon, 06 Jul 2020 16:04:01 -0700
From:   Andrew Morton <akpm@linux-foundation.org>
To:     aneesh.kumar@linux.ibm.com, anshuman.khandual@arm.com,
        digetx@gmail.com, kirill.shutemov@linux.intel.com,
        mm-commits@vger.kernel.org, peterx@redhat.com,
        richard.weiyang@linux.alibaba.com, sean.j.christopherson@intel.com,
        thellstrom@vmware.com, thomas_os@shipmail.org, vbabka@suse.cz,
        walken@google.com, willy@infradead.org, yang.shi@linux.alibaba.com
Subject:  [to-be-updated]
 mm-mremap-start-addresses-are-properly-aligned.patch removed from -mm tree
Message-ID: <20200706230401.zZSZfWDwX%akpm@linux-foundation.org>
In-Reply-To: <20200703151445.b6a0cfee402c7c5c4651f1b1@linux-foundation.org>
User-Agent: s-nail v14.8.16
Sender: mm-commits-owner@vger.kernel.org
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org
Message-ID: <20200706230401.ZAtvf8dGVbx9JNK7VhNR8Xm8QCiEQctZ2QrEMoN04m8@z>


The patch titled
     Subject: mm/mremap: start addresses are properly aligned
has been removed from the -mm tree.  Its filename was
     mm-mremap-start-addresses-are-properly-aligned.patch

This patch was dropped because an updated version will be merged

------------------------------------------------------
From: Wei Yang <richard.weiyang@linux.alibaba.com>
Subject: mm/mremap: start addresses are properly aligned

After previous cleanup, extent is the minimal step for both source and
destination.  This means when extent is HPAGE_PMD_SIZE or PMD_SIZE,
old_addr and new_addr are properly aligned too.

Since these two functions are only invoked in move_page_tables, it is safe
to remove the check now.

Link: http://lkml.kernel.org/r/20200626135216.24314-5-richard.weiyang@linux.alibaba.com
Signed-off-by: Wei Yang <richard.weiyang@linux.alibaba.com>
Tested-by: Dmitry Osipenko <digetx@gmail.com>
Cc: Aneesh Kumar K.V <aneesh.kumar@linux.ibm.com>
Cc: Anshuman Khandual <anshuman.khandual@arm.com>
Cc: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: Michel Lespinasse <walken@google.com>
Cc: Peter Xu <peterx@redhat.com>
Cc: Sean Christopherson <sean.j.christopherson@intel.com>
Cc: Thomas Hellstrom <thellstrom@vmware.com>
Cc: Thomas Hellstrom (VMware) <thomas_os@shipmail.org>
Cc: Vlastimil Babka <vbabka@suse.cz>
Cc: Yang Shi <yang.shi@linux.alibaba.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/huge_memory.c |    3 ---
 mm/mremap.c      |    3 ---
 2 files changed, 6 deletions(-)

--- a/mm/huge_memory.c~mm-mremap-start-addresses-are-properly-aligned
+++ a/mm/huge_memory.c
@@ -1729,9 +1729,6 @@ bool move_huge_pmd(struct vm_area_struct
 	struct mm_struct *mm = vma->vm_mm;
 	bool force_flush = false;
 
-	if ((old_addr & ~HPAGE_PMD_MASK) || (new_addr & ~HPAGE_PMD_MASK))
-		return false;
-
 	/*
 	 * The destination pmd shouldn't be established, free_pgtables()
 	 * should have release it.
--- a/mm/mremap.c~mm-mremap-start-addresses-are-properly-aligned
+++ a/mm/mremap.c
@@ -199,9 +199,6 @@ static bool move_normal_pmd(struct vm_ar
 	struct mm_struct *mm = vma->vm_mm;
 	pmd_t pmd;
 
-	if ((old_addr & ~PMD_MASK) || (new_addr & ~PMD_MASK))
-		return false;
-
 	/*
 	 * The destination pmd shouldn't be established, free_pgtables()
 	 * should have release it.
_

Patches currently in -mm which might be from richard.weiyang@linux.alibaba.com are

mm-sparse-never-partially-remove-memmap-for-early-section.patch
mm-sparse-only-sub-section-aligned-range-would-be-populated.patch
mm-page_allocc-replace-the-definition-of-nr_migratetype_bits-with-pb_migratetype_bits.patch
mm-page_allocc-extract-the-common-part-in-pfn_to_bitidx.patch
mm-page_allocc-simplify-pageblock-bitmap-access.patch
mm-page_allocc-remove-unnecessary-end_bitidx-for-_pfnblock_flags_mask.patch
mm-page_alloc-fallbacks-at-most-has-3-elements.patch

