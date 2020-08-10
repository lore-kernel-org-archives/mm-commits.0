Return-Path: <SRS0=A/n1=BU=vger.kernel.org=mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.0 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8BD10C433E3
	for <mm-commits@archiver.kernel.org>; Mon, 10 Aug 2020 02:38:38 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 5B46720723
	for <mm-commits@archiver.kernel.org>; Mon, 10 Aug 2020 02:38:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1597027118;
	bh=qt5/oE2UDYI12iWGuZx2VYd1Dse9L/zaEO1nqjF89LE=;
	h=Date:From:To:Subject:Reply-To:List-ID:From;
	b=aCTjnwY7ZbTNon26AK1FN+rsqIWqK0Dx6k16t3YM2PzPaAhO57pQWmHksBt2Zqwbj
	 y8lUt9TM2jZ6cn5NffwaYzEVZ83K6pjiMdPFHRcDYdvlRxEb2CaqD0r7XVM9+yTjHP
	 lKX/1qDCc7voSJ5aYlxUZuE0VGDOIgHhbee3C6h4=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726338AbgHJCih (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Sun, 9 Aug 2020 22:38:37 -0400
Received: from mail.kernel.org ([198.145.29.99]:41808 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726401AbgHJCig (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Sun, 9 Aug 2020 22:38:36 -0400
Received: from localhost.localdomain (c-71-198-47-131.hsd1.ca.comcast.net [71.198.47.131])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id AAA7B2065D;
        Mon, 10 Aug 2020 02:38:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1597027116;
        bh=qt5/oE2UDYI12iWGuZx2VYd1Dse9L/zaEO1nqjF89LE=;
        h=Date:From:To:Subject:From;
        b=YLLcU8+sjB1r5cMv1c6n86T8Ki1Pdf01Z/GoM2DihkoZPZV0w1sHkpCJ2rN0YeZtY
         5B3lyzMWPCdqnSnNLgXkhq1u1UR+wwHJL8XXewEZMLsBL1iQo3jztnNg+GnTo3ataV
         B99VMfuAfrX1fP+WxdVkH5QD0r9VdrjfMVpaJMY4=
Date:   Sun, 09 Aug 2020 19:38:35 -0700
From:   akpm@linux-foundation.org
To:     aneesh.kumar@linux.ibm.com, anshuman.khandual@arm.com,
        digetx@gmail.com, kirill.shutemov@linux.intel.com,
        mm-commits@vger.kernel.org, peterx@redhat.com,
        richard.weiyang@linux.alibaba.com, sean.j.christopherson@intel.com,
        thellstrom@vmware.com, thomas_os@shipmail.org, vbabka@suse.cz,
        willy@infradead.org, yang.shi@linux.alibaba.com
Subject:  [merged] mm-mremap-calculate-extent-in-one-place.patch
 removed from -mm tree
Message-ID: <20200810023835.rqwNP107T%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Sender: mm-commits-owner@vger.kernel.org
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/mremap: calculate extent in one place
has been removed from the -mm tree.  Its filename was
     mm-mremap-calculate-extent-in-one-place.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
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

Patches currently in -mm which might be from richard.weiyang@linux.alibaba.com are


