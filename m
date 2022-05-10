Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 71409C433FE
	for <mm-commits@archiver.kernel.org>; Tue, 10 May 2022 04:11:51 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236116AbiEJEPo (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 10 May 2022 00:15:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46158 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236029AbiEJEPP (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 10 May 2022 00:15:15 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A66002EA20
        for <mm-commits@vger.kernel.org>; Mon,  9 May 2022 21:11:04 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id D6E3B61737
        for <mm-commits@vger.kernel.org>; Tue, 10 May 2022 04:11:03 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 367DAC385C7;
        Tue, 10 May 2022 04:11:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1652155863;
        bh=SNrpE2axiIkYgeV5ahFwswGtP+kU2oULkinkTTjzYn0=;
        h=Date:To:From:Subject:From;
        b=XEJVg07W8lZ13wI5CVwkrfdGNotmhXdEoodCGo9wTSb3RvIZR4cOF0eeSO62UhzRs
         RS7ybxR8Lv+PhYveeWZVEvrTbAOWWJYHZV2Xicv0K41GIfib2kXWdlO+MvX6nPBr/T
         GMZ6G2aYuPZw+CcHsiPRsDIo4UGjQW0DLDtxdHxE=
Date:   Mon, 09 May 2022 21:11:02 -0700
To:     mm-commits@vger.kernel.org, will@kernel.org, rientjes@google.com,
        osalvador@suse.de, mike.kravetz@oracle.com, mark.rutland@arm.com,
        james.morse@arm.com, fam.zheng@bytedance.com,
        duanxiongchun@bytedance.com, david@redhat.com,
        catalin.marinas@arm.com, bodeddub@amazon.com, baohua@kernel.org,
        anshuman.khandual@arm.com, akpm@linux-foundation.org,
        songmuchun@bytedance.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-hugetlb_vmemmap-introduce-arch_want_hugetlb_page_free_vmemmap.patch removed from -mm tree
Message-Id: <20220510041103.367DAC385C7@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: mm: hugetlb_vmemmap: introduce ARCH_WANT_HUGETLB_PAGE_FREE_VMEMMAP
has been removed from the -mm tree.  Its filename was
     mm-hugetlb_vmemmap-introduce-arch_want_hugetlb_page_free_vmemmap.patch

This patch was dropped because it was merged into mm-stable

------------------------------------------------------
From: Muchun Song <songmuchun@bytedance.com>
Subject: mm: hugetlb_vmemmap: introduce ARCH_WANT_HUGETLB_PAGE_FREE_VMEMMAP

The feature of minimizing overhead of struct page associated with each
HugeTLB page is implemented on x86_64, however, the infrastructure of this
feature is already there, we could easily enable it for other
architectures.  Introduce ARCH_WANT_HUGETLB_PAGE_FREE_VMEMMAP for other
architectures to be easily enabled.  Just select this config if they want
to enable this feature.

Link: https://lkml.kernel.org/r/20220331065640.5777-1-songmuchun@bytedance.com
Signed-off-by: Muchun Song <songmuchun@bytedance.com>
Suggested-by: Andrew Morton <akpm@linux-foundation.org>
Reviewed-by: Barry Song <baohua@kernel.org>
Tested-by: Barry Song <baohua@kernel.org>
Reviewed-by: Anshuman Khandual <anshuman.khandual@arm.com>
Cc: Bodeddula Balasubramaniam <bodeddub@amazon.com>
Cc: Catalin Marinas <catalin.marinas@arm.com>
Cc: David Hildenbrand <david@redhat.com>
Cc: David Rientjes <rientjes@google.com>
Cc: Fam Zheng <fam.zheng@bytedance.com>
Cc: James Morse <james.morse@arm.com>
Cc: Mark Rutland <mark.rutland@arm.com>
Cc: Mike Kravetz <mike.kravetz@oracle.com>
Cc: Oscar Salvador <osalvador@suse.de>
Cc: Will Deacon <will@kernel.org>
Cc: Xiongchun Duan <duanxiongchun@bytedance.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/x86/Kconfig |    1 +
 fs/Kconfig       |   10 +++++++++-
 2 files changed, 10 insertions(+), 1 deletion(-)

--- a/arch/x86/Kconfig~mm-hugetlb_vmemmap-introduce-arch_want_hugetlb_page_free_vmemmap
+++ a/arch/x86/Kconfig
@@ -121,6 +121,7 @@ config X86
 	select ARCH_WANTS_NO_INSTR
 	select ARCH_WANT_GENERAL_HUGETLB
 	select ARCH_WANT_HUGE_PMD_SHARE
+	select ARCH_WANT_HUGETLB_PAGE_FREE_VMEMMAP	if X86_64
 	select ARCH_WANT_LD_ORPHAN_WARN
 	select ARCH_WANTS_THP_SWAP		if X86_64
 	select ARCH_HAS_PARANOID_L1D_FLUSH
--- a/fs/Kconfig~mm-hugetlb_vmemmap-introduce-arch_want_hugetlb_page_free_vmemmap
+++ a/fs/Kconfig
@@ -245,9 +245,17 @@ config HUGETLBFS
 config HUGETLB_PAGE
 	def_bool HUGETLBFS
 
+#
+# Select this config option from the architecture Kconfig, if it is preferred
+# to enable the feature of minimizing overhead of struct page associated with
+# each HugeTLB page.
+#
+config ARCH_WANT_HUGETLB_PAGE_FREE_VMEMMAP
+	bool
+
 config HUGETLB_PAGE_FREE_VMEMMAP
 	def_bool HUGETLB_PAGE
-	depends on X86_64
+	depends on ARCH_WANT_HUGETLB_PAGE_FREE_VMEMMAP
 	depends on SPARSEMEM_VMEMMAP
 
 config HUGETLB_PAGE_FREE_VMEMMAP_DEFAULT_ON
_

Patches currently in -mm which might be from songmuchun@bytedance.com are

mm-hugetlb_vmemmap-disable-hugetlb_optimize_vmemmap-when-struct-page-crosses-page-boundaries.patch
mm-memory_hotplug-override-memmap_on_memory-when-hugetlb_free_vmemmap=on.patch
mm-hugetlb_vmemmap-use-kstrtobool-for-hugetlb_vmemmap-param-parsing.patch
mm-hugetlb_vmemmap-add-hugetlb_optimize_vmemmap-sysctl.patch

