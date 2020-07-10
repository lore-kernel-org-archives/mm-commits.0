Return-Path: <SRS0=29NR=AV=vger.kernel.org=mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.0 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 785A7C433E0
	for <mm-commits@archiver.kernel.org>; Fri, 10 Jul 2020 22:34:08 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 5200120720
	for <mm-commits@archiver.kernel.org>; Fri, 10 Jul 2020 22:34:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1594420448;
	bh=IQ4Bkcv4+rnwwnYNo+vAMJMT0tVhFoGsT3WQLT0X0FA=;
	h=Date:From:To:Subject:Reply-To:List-ID:From;
	b=APY1qr3vHN46e03SZ8y+pBLv0L4JTtvgcaCzjLzQf8GJtGKHTL9z2K1kEx4tjx6Yx
	 q6sYXpCwHlz3x1FuL1fyX0AvD5++CV+cRhxAnIAR0Qp7Td2gXmTNzIGsUsQJMwMSQh
	 j3pYjsCvzL+46TxGUO9wdz6KR+LGEP+yazIVMsgk=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726407AbgGJWeI (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 10 Jul 2020 18:34:08 -0400
Received: from mail.kernel.org ([198.145.29.99]:45738 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726385AbgGJWeH (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Fri, 10 Jul 2020 18:34:07 -0400
Received: from localhost.localdomain (c-73-231-172-41.hsd1.ca.comcast.net [73.231.172.41])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 84A48206F4;
        Fri, 10 Jul 2020 22:34:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1594420447;
        bh=IQ4Bkcv4+rnwwnYNo+vAMJMT0tVhFoGsT3WQLT0X0FA=;
        h=Date:From:To:Subject:From;
        b=uLF5l5yLRAIHx3Ki+sOv5gX+cskd9fPqxqA98HBuV6tAE7YmVSQdAmocRwPUgZhnn
         CJigPSSRaZAGhBWBPF4cx1JkfbjMRN1q3KxvatnqNyncV+1K+z2IZFk2kXnRQI3WYD
         VzqYkIA6NdmvCEewQN38SjIWBxpp7Vqoxe5+4BD4=
Date:   Fri, 10 Jul 2020 15:34:06 -0700
From:   akpm@linux-foundation.org
To:     aneesh.kumar@linux.ibm.com, anshuman.khandual@arm.com,
        digetx@gmail.com, kirill.shutemov@linux.intel.com,
        mm-commits@vger.kernel.org, peterx@redhat.com,
        richard.weiyang@linux.alibaba.com, sean.j.christopherson@intel.com,
        thellstrom@vmware.com, thomas_os@shipmail.org, vbabka@suse.cz,
        willy@infradead.org, yang.shi@linux.alibaba.com
Subject:  [withdrawn]
 mm-mremap-use-pmd_addr_end-to-simplify-the-calculate-of-extent.patch
 removed from -mm tree
Message-ID: <20200710223406.zLW8zHiNw%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Sender: mm-commits-owner@vger.kernel.org
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/mremap: use pmd_addr_end to simplify the calculate of extent
has been removed from the -mm tree.  Its filename was
     mm-mremap-use-pmd_addr_end-to-simplify-the-calculate-of-extent.patch

This patch was dropped because it was withdrawn

------------------------------------------------------
From: Wei Yang <richard.weiyang@linux.alibaba.com>
Subject: mm/mremap: use pmd_addr_end to simplify the calculate of extent

The purpose of this code is to calculate the smaller extent in old and new
range.  Let's leverage pmd_addr_end() to do the calculation.

Hope this would make the code easier to read.

Link: http://lkml.kernel.org/r/20200708095028.41706-5-richard.weiyang@linux.alibaba.com
Signed-off-by: Wei Yang <richard.weiyang@linux.alibaba.com>

Cc: Aneesh Kumar K.V <aneesh.kumar@linux.ibm.com>
Cc: Anshuman Khandual <anshuman.khandual@arm.com>
Cc: Dmitry Osipenko <digetx@gmail.com>
Cc: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
Cc: Matthew Wilcox <willy@infradead.org>
Cc: Peter Xu <peterx@redhat.com>
Cc: Sean Christopherson <sean.j.christopherson@intel.com>
Cc: Thomas Hellstrom <thellstrom@vmware.com>
Cc: Thomas Hellstrom (VMware) <thomas_os@shipmail.org>
Cc: Vlastimil Babka <vbabka@suse.cz>
Cc: Yang Shi <yang.shi@linux.alibaba.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/mremap.c |   16 +++++++---------
 1 file changed, 7 insertions(+), 9 deletions(-)

--- a/mm/mremap.c~mm-mremap-use-pmd_addr_end-to-simplify-the-calculate-of-extent
+++ a/mm/mremap.c
@@ -237,11 +237,12 @@ unsigned long move_page_tables(struct vm
 		unsigned long new_addr, unsigned long len,
 		bool need_rmap_locks)
 {
-	unsigned long extent, next, old_end;
+	unsigned long extent, old_next, new_next, old_end, new_end;
 	struct mmu_notifier_range range;
 	pmd_t *old_pmd, *new_pmd;
 
 	old_end = old_addr + len;
+	new_end = new_addr + len;
 	flush_cache_range(vma, old_addr, old_end);
 
 	mmu_notifier_range_init(&range, MMU_NOTIFY_UNMAP, 0, vma, vma->vm_mm,
@@ -250,14 +251,11 @@ unsigned long move_page_tables(struct vm
 
 	for (; old_addr < old_end; old_addr += extent, new_addr += extent) {
 		cond_resched();
-		next = (old_addr + PMD_SIZE) & PMD_MASK;
-		/* even if next overflowed, extent below will be ok */
-		extent = next - old_addr;
-		if (extent > old_end - old_addr)
-			extent = old_end - old_addr;
-		next = (new_addr + PMD_SIZE) & PMD_MASK;
-		if (extent > next - new_addr)
-			extent = next - new_addr;
+
+		old_next = pmd_addr_end(old_addr, old_end);
+		new_next = pmd_addr_end(new_addr, new_end);
+		extent = min(old_next - old_addr, new_next - new_addr);
+
 		old_pmd = get_old_pmd(vma->vm_mm, old_addr);
 		if (!old_pmd)
 			continue;
_

Patches currently in -mm which might be from richard.weiyang@linux.alibaba.com are

mm-mremap-it-is-sure-to-have-enough-space-when-extent-meets-requirement.patch
mm-mremap-calculate-extent-in-one-place.patch
mm-mremap-start-addresses-are-properly-aligned.patch
mm-sparse-never-partially-remove-memmap-for-early-section.patch
mm-sparse-only-sub-section-aligned-range-would-be-populated.patch
mm-page_allocc-replace-the-definition-of-nr_migratetype_bits-with-pb_migratetype_bits.patch
mm-page_allocc-extract-the-common-part-in-pfn_to_bitidx.patch
mm-page_allocc-simplify-pageblock-bitmap-access.patch
mm-page_allocc-remove-unnecessary-end_bitidx-for-_pfnblock_flags_mask.patch
mm-page_alloc-fallbacks-at-most-has-3-elements.patch

