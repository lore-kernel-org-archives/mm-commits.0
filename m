Return-Path: <SRS0=ze/c=BR=vger.kernel.org=mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.0 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 348DCC433E3
	for <mm-commits@archiver.kernel.org>; Fri,  7 Aug 2020 06:23:48 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 03E6D22CAE
	for <mm-commits@archiver.kernel.org>; Fri,  7 Aug 2020 06:23:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1596781428;
	bh=qOMzU/b2o0LxbCa6/jIzP2n5jQBT0Us4j4G+LRsBMJY=;
	h=Date:From:To:Subject:In-Reply-To:Reply-To:List-ID:From;
	b=AHNSd6QTkIWExqdgRmy0xGoVwoQHMud1b51uzF9QzGgBDuUVd17R6zs5ha3wProvM
	 GE8upK8/aLGl/AbYselInQj76NrMXtPYCRUkBifD8CzMgsBilqlmYKs/Yz6frcY6Kw
	 GB60UEYOOE9sToNenRS52pc92AyM/hIadx7VVsG4=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726335AbgHGGXr (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 7 Aug 2020 02:23:47 -0400
Received: from mail.kernel.org ([198.145.29.99]:60844 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726198AbgHGGXq (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Fri, 7 Aug 2020 02:23:46 -0400
Received: from localhost.localdomain (c-73-231-172-41.hsd1.ca.comcast.net [73.231.172.41])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id C115F2177B;
        Fri,  7 Aug 2020 06:23:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1596781425;
        bh=qOMzU/b2o0LxbCa6/jIzP2n5jQBT0Us4j4G+LRsBMJY=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=xpJXDGYJclN/gTi7cQ/r3+RXiiQfB8J/dFvkBFnV/WzG93drDmPfGUhtcV0irf+gS
         vDJAuS/DXA2Z6HZnWybEUAXwxdAfwRYWsjaggVVbxmSFhuZee3FD139+TADi661Cqh
         7ullftIekTrfJwcOVdaJ4PT90Vc/kBRd9DETfJmo=
Date:   Thu, 06 Aug 2020 23:23:44 -0700
From:   Andrew Morton <akpm@linux-foundation.org>
To:     akpm@linux-foundation.org, aneesh.kumar@linux.ibm.com,
        anshuman.khandual@arm.com, digetx@gmail.com,
        kirill.shutemov@linux.intel.com, linux-mm@kvack.org,
        mm-commits@vger.kernel.org, peterx@redhat.com,
        richard.weiyang@linux.alibaba.com, sean.j.christopherson@intel.com,
        thellstrom@vmware.com, thomas_os@shipmail.org,
        torvalds@linux-foundation.org, vbabka@suse.cz, willy@infradead.org,
        yang.shi@linux.alibaba.com
Subject:  [patch 115/163] mm/mremap: calculate extent in one place
Message-ID: <20200807062344.aiW9-gNx4%akpm@linux-foundation.org>
In-Reply-To: <20200806231643.a2711a608dd0f18bff2caf2b@linux-foundation.org>
User-Agent: s-nail v14.8.16
Sender: mm-commits-owner@vger.kernel.org
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

From: Wei Yang <richard.weiyang@linux.alibaba.com>
Subject: mm/mremap: calculate extent in one place

Page tables is moved on the base of PMD.  This requires both source and
destination range should meet the requirement.

Current code works well since move_huge_pmd() and move_normal_pmd() would
check old_addr and new_addr again.  And then return to move_ptes() if the
either of them is not aligned.

Instead of calculating the extent separately, it is better to calculate in
one place, so we know it is not necessary to try move pmd.  By doing so,
the logic seems a little clear.

Link: http://lkml.kernel.org/r/20200708095028.41706-3-richard.weiyang@linux.alibaba.com
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

 mm/mremap.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

--- a/mm/mremap.c~mm-mremap-calculate-extent-in-one-place
+++ a/mm/mremap.c
@@ -277,6 +277,9 @@ unsigned long move_page_tables(struct vm
 		extent = next - old_addr;
 		if (extent > old_end - old_addr)
 			extent = old_end - old_addr;
+		next = (new_addr + PMD_SIZE) & PMD_MASK;
+		if (extent > next - new_addr)
+			extent = next - new_addr;
 		old_pmd = get_old_pmd(vma->vm_mm, old_addr);
 		if (!old_pmd)
 			continue;
@@ -320,9 +323,6 @@ unsigned long move_page_tables(struct vm
 
 		if (pte_alloc(new_vma->vm_mm, new_pmd))
 			break;
-		next = (new_addr + PMD_SIZE) & PMD_MASK;
-		if (extent > next - new_addr)
-			extent = next - new_addr;
 		move_ptes(vma, old_pmd, old_addr, old_addr + extent, new_vma,
 			  new_pmd, new_addr, need_rmap_locks);
 	}
_
