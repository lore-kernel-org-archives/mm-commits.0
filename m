Return-Path: <SRS0=mer4=AT=vger.kernel.org=mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.0 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 21F7AC433DF
	for <mm-commits@archiver.kernel.org>; Wed,  8 Jul 2020 23:16:49 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id F0CCB2078A
	for <mm-commits@archiver.kernel.org>; Wed,  8 Jul 2020 23:16:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1594250209;
	bh=4Efzii989IZyzw1gLDYqsdLLZc62DZUePjKECJ1rmY0=;
	h=Date:From:To:Subject:In-Reply-To:Reply-To:List-ID:From;
	b=GIQagH468y2ObTcU7fZiZmSlsIYfm2YCE5j/9RBzO/UFqwakv99GbBBhFtVVwYvD4
	 lLeZ+iR2jun63ElizaM3oe/C9avot+lMcMaglmRjrxwCV2HYPzSlyYNnf9DJfzj7qE
	 c+l53kmxplpcl+15a3Rm/654UfG1s3OXCcnEkrCw=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726376AbgGHXQs (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 8 Jul 2020 19:16:48 -0400
Received: from mail.kernel.org ([198.145.29.99]:34360 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726261AbgGHXQs (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Wed, 8 Jul 2020 19:16:48 -0400
Received: from localhost.localdomain (c-73-231-172-41.hsd1.ca.comcast.net [73.231.172.41])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id ED0C120775;
        Wed,  8 Jul 2020 23:16:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1594250207;
        bh=4Efzii989IZyzw1gLDYqsdLLZc62DZUePjKECJ1rmY0=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=qanZE0/E2+xfd4initsJ+cvoouh2V+hvGNoaXMltoPOpULCI1FC3TLOCuXbXSoTCs
         tr6d688/Bu0dLUULcaFDUh65zBtnsWj7lMp30yyFpbBnLARGC+B+K1tliCpwNS8DUu
         q+4yRG82iW8hS+J0d2t7uXNmD7HWseP8NqxfP5/g=
Date:   Wed, 08 Jul 2020 16:16:46 -0700
From:   Andrew Morton <akpm@linux-foundation.org>
To:     aneesh.kumar@linux.ibm.com, anshuman.khandual@arm.com,
        digetx@gmail.com, kirill.shutemov@linux.intel.com,
        mm-commits@vger.kernel.org, peterx@redhat.com,
        richard.weiyang@linux.alibaba.com, sean.j.christopherson@intel.com,
        thellstrom@vmware.com, thomas_os@shipmail.org, vbabka@suse.cz,
        willy@infradead.org, yang.shi@linux.alibaba.com
Subject:  + mm-mremap-start-addresses-are-properly-aligned.patch
 added to -mm tree
Message-ID: <20200708231646.7UdlDqH1R%akpm@linux-foundation.org>
In-Reply-To: <20200703151445.b6a0cfee402c7c5c4651f1b1@linux-foundation.org>
User-Agent: s-nail v14.8.16
Sender: mm-commits-owner@vger.kernel.org
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org
Message-ID: <20200708231646.XhTfiG9tXJd5umOfuRLuiXYg0Pdn_uAhNx2kMgxYiPE@z>


The patch titled
     Subject: mm/mremap: start addresses are properly aligned
has been added to the -mm tree.  Its filename is
     mm-mremap-start-addresses-are-properly-aligned.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-mremap-start-addresses-are-properly-aligned.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-mremap-start-addresses-are-properly-aligned.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Wei Yang <richard.weiyang@linux.alibaba.com>
Subject: mm/mremap: start addresses are properly aligned

After previous cleanup, extent is the minimal step for both source and
destination.  This means when extent is HPAGE_PMD_SIZE or PMD_SIZE,
old_addr and new_addr are properly aligned too.

Since these two functions are only invoked in move_page_tables, it is safe
to remove the check now.

Link: http://lkml.kernel.org/r/20200708095028.41706-4-richard.weiyang@linux.alibaba.com
Signed-off-by: Wei Yang <richard.weiyang@linux.alibaba.com>
Tested-by: Dmitry Osipenko <digetx@gmail.com>
Acked-by: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
Cc: Aneesh Kumar K.V <aneesh.kumar@linux.ibm.com>
Cc: Anshuman Khandual <anshuman.khandual@arm.com>
Cc: Matthew Wilcox <willy@infradead.org>
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

mm-mremap-it-is-sure-to-have-enough-space-when-extent-meets-requirement.patch
mm-mremap-calculate-extent-in-one-place.patch
mm-mremap-start-addresses-are-properly-aligned.patch
mm-mremap-use-pmd_addr_end-to-simplify-the-calculate-of-extent.patch
mm-sparse-never-partially-remove-memmap-for-early-section.patch
mm-sparse-only-sub-section-aligned-range-would-be-populated.patch
mm-page_allocc-replace-the-definition-of-nr_migratetype_bits-with-pb_migratetype_bits.patch
mm-page_allocc-extract-the-common-part-in-pfn_to_bitidx.patch
mm-page_allocc-simplify-pageblock-bitmap-access.patch
mm-page_allocc-remove-unnecessary-end_bitidx-for-_pfnblock_flags_mask.patch
mm-page_alloc-fallbacks-at-most-has-3-elements.patch

