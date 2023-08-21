Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 70956EE49A5
	for <mm-commits@archiver.kernel.org>; Mon, 21 Aug 2023 20:41:11 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231328AbjHUUlL (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 21 Aug 2023 16:41:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39818 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231237AbjHUUke (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 21 Aug 2023 16:40:34 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 35FC11A7
        for <mm-commits@vger.kernel.org>; Mon, 21 Aug 2023 13:40:14 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 271B964B0A
        for <mm-commits@vger.kernel.org>; Mon, 21 Aug 2023 20:40:07 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7B7B5C433C7;
        Mon, 21 Aug 2023 20:40:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1692650406;
        bh=tMXUxchOu1x7sx0tckUVBCMZ0O8k+ftU1nYsQ0A6kCU=;
        h=Date:To:From:Subject:From;
        b=dupYh0/1pR5Bc9356LuRSQ73A7tysqofRX7j1Dl+GILgcgPfNSsmw/GSG5HG2Vyz3
         E3ACOSw6w5dd9kl+7Bnt8+K4U0brAwkKdTjQPdWeadD/Sws0PhR2kwhhggVrr9jIWU
         2T728Kmb+emOB2cE0udjokKOFLZB23TGa2Nig2gk=
Date:   Mon, 21 Aug 2023 13:40:05 -0700
To:     mm-commits@vger.kernel.org, will@kernel.org,
        william.kucharski@oracle.com, songmuchun@bytedance.com,
        mike.kravetz@oracle.com, kirill@shutemov.name,
        kaleshsingh@google.com, joel@joelfernandes.org,
        catalin.marinas@arm.com, almasrymina@google.com, 21cnbao@gmail.com,
        wangkefeng.wang@huawei.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] arm64-hugetlb-enable-__have_arch_flush_hugetlb_tlb_range.patch removed from -mm tree
Message-Id: <20230821204006.7B7B5C433C7@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: arm64: hugetlb: enable __HAVE_ARCH_FLUSH_HUGETLB_TLB_RANGE
has been removed from the -mm tree.  Its filename was
     arm64-hugetlb-enable-__have_arch_flush_hugetlb_tlb_range.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Kefeng Wang <wangkefeng.wang@huawei.com>
Subject: arm64: hugetlb: enable __HAVE_ARCH_FLUSH_HUGETLB_TLB_RANGE
Date: Wed, 2 Aug 2023 09:27:31 +0800

It is better to use huge page size instead of PAGE_SIZE for stride when
flush hugepage, which reduces the loop in __flush_tlb_range().

Let's support arch's flush_hugetlb_tlb_range(), which is used in
hugetlb_unshare_all_pmds(), move_hugetlb_page_tables() and
hugetlb_change_protection() for now.

Note,: for hugepages based on contiguous bit, it has to be invalidated
individually since the contiguous PTE bit is just a hint, the hardware may
or may not take it into account.

Link: https://lkml.kernel.org/r/20230802012731.62512-1-wangkefeng.wang@huawei.com
Signed-off-by: Kefeng Wang <wangkefeng.wang@huawei.com>
Reviewed-by: Muchun Song <songmuchun@bytedance.com>
Reviewed-by: Catalin Marinas <catalin.marinas@arm.com>
Cc: Barry Song <21cnbao@gmail.com>
Cc: Joel Fernandes (Google) <joel@joelfernandes.org>
Cc: Kalesh Singh <kaleshsingh@google.com>
Cc: "Kirill A. Shutemov" <kirill@shutemov.name>
Cc: Mike Kravetz <mike.kravetz@oracle.com>
Cc: Mina Almasry <almasrymina@google.com>
Cc: Will Deacon <will@kernel.org>
Cc: William Kucharski <william.kucharski@oracle.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/arm64/include/asm/hugetlb.h |   15 +++++++++++++++
 1 file changed, 15 insertions(+)

--- a/arch/arm64/include/asm/hugetlb.h~arm64-hugetlb-enable-__have_arch_flush_hugetlb_tlb_range
+++ a/arch/arm64/include/asm/hugetlb.h
@@ -60,4 +60,19 @@ extern void huge_ptep_modify_prot_commit
 
 #include <asm-generic/hugetlb.h>
 
+#define __HAVE_ARCH_FLUSH_HUGETLB_TLB_RANGE
+static inline void flush_hugetlb_tlb_range(struct vm_area_struct *vma,
+					   unsigned long start,
+					   unsigned long end)
+{
+	unsigned long stride = huge_page_size(hstate_vma(vma));
+
+	if (stride == PMD_SIZE)
+		__flush_tlb_range(vma, start, end, stride, false, 2);
+	else if (stride == PUD_SIZE)
+		__flush_tlb_range(vma, start, end, stride, false, 1);
+	else
+		__flush_tlb_range(vma, start, end, PAGE_SIZE, false, 0);
+}
+
 #endif /* __ASM_HUGETLB_H */
_

Patches currently in -mm which might be from wangkefeng.wang@huawei.com are


