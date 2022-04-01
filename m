Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 12C18C433EF
	for <mm-commits@archiver.kernel.org>; Fri,  1 Apr 2022 00:57:37 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230257AbiDAA7X (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 31 Mar 2022 20:59:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33916 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232254AbiDAA7W (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 31 Mar 2022 20:59:22 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 026F61F126F
        for <mm-commits@vger.kernel.org>; Thu, 31 Mar 2022 17:57:32 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 9423CB82296
        for <mm-commits@vger.kernel.org>; Fri,  1 Apr 2022 00:57:31 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 39375C340ED;
        Fri,  1 Apr 2022 00:57:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1648774650;
        bh=fRpLUK/NPB59I5Jkngv42nx0aqilgovk9W66EDwfHgg=;
        h=Date:To:From:Subject:From;
        b=kHKrRAgwK4u0qBziWV7d1pbk4tHkDH/5pR+pcSC2N2Oc5oHpjcAIryyFDjoLVmi9T
         nIZ8ZbYZx2MZAwWzLVHqPWMdARYjOFJsO/jRB7ZQHvPYX++rxu9qv3QWZZFfayURGJ
         Y9GMvtbvFioaiGUVLoJtEBqTaXopCUOZYVFV6mMU=
Date:   Thu, 31 Mar 2022 17:57:29 -0700
To:     mm-commits@vger.kernel.org, will@kernel.org, rientjes@google.com,
        osalvador@suse.de, mike.kravetz@oracle.com, mark.rutland@arm.com,
        james.morse@arm.com, fam.zheng@bytedance.com,
        duanxiongchun@bytedance.com, david@redhat.com,
        catalin.marinas@arm.com, bodeddub@amazon.com, baohua@kernel.org,
        akpm@linux-foundation.org, songmuchun@bytedance.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-hugetlb_vmemmap-introduce-arch_want_hugetlb_page_free_vmemmap.patch added to -mm tree
Message-Id: <20220401005730.39375C340ED@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm: hugetlb_vmemmap: introduce ARCH_WANT_HUGETLB_PAGE_FREE_VMEMMAP
has been added to the -mm tree.  Its filename is
     mm-hugetlb_vmemmap-introduce-arch_want_hugetlb_page_free_vmemmap.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/mm-hugetlb_vmemmap-introduce-arch_want_hugetlb_page_free_vmemmap.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/mm-hugetlb_vmemmap-introduce-arch_want_hugetlb_page_free_vmemmap.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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
 	select ARCH_WANTS_RT_DELAYED_SIGNALS
 	select ARCH_WANTS_THP_SWAP		if X86_64
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

mm-kfence-fix-objcgs-vector-allocation.patch
mm-hugetlb_vmemmap-introduce-arch_want_hugetlb_page_free_vmemmap.patch
arm64-mm-hugetlb-enable-hugetlb_page_free_vmemmap-for-arm64.patch

