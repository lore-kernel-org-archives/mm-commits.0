Return-Path: <SRS0=MO2u=DC=vger.kernel.org=mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.0 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B7AACC4346E
	for <mm-commits@archiver.kernel.org>; Fri, 25 Sep 2020 02:57:27 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 6C39B20888
	for <mm-commits@archiver.kernel.org>; Fri, 25 Sep 2020 02:57:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1601002647;
	bh=OtreFy8hfeU/11hfh8JZgUvIpZmxxanADXKulK7j94I=;
	h=Date:From:To:Subject:Reply-To:List-ID:From;
	b=xTZaDBCrq5Oi/71x9zWJJQGqHtFUypGntMMPw/F3HxkWjjjDZEHo1FZAdDa4Uw9hW
	 bgVnPeXYl0bK5EuONJ52HoqZ2OSQAXyEL+59sNXxM3wDfhnSIN43FVlHFfX5wv1lJa
	 cyjwi2e138P3kvOJSlencvJgFQCtaPs8977uS4HQ=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726704AbgIYC51 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 24 Sep 2020 22:57:27 -0400
Received: from mail.kernel.org ([198.145.29.99]:50920 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726676AbgIYC51 (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Thu, 24 Sep 2020 22:57:27 -0400
Received: from X1 (unknown [104.245.68.101])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 9DF6F20838;
        Fri, 25 Sep 2020 02:57:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1601002646;
        bh=OtreFy8hfeU/11hfh8JZgUvIpZmxxanADXKulK7j94I=;
        h=Date:From:To:Subject:From;
        b=lTVBXB3WlG7v+ovUk6cYkPg5s00HDU+SVpr6/CwH/zkWows/8iwDBsd3u7EQ7S8EZ
         6r9JdcVdx1zJIYc7w1JOPaZjsVO+RknmHVLRtdCSVZuZPs+wm+mF1Y0QKYEG8CWQ1S
         s/yAmvz0a2Z1joE5iWErKeWVoGYuO1dUiroVPN7I=
Date:   Thu, 24 Sep 2020 19:57:26 -0700
From:   akpm@linux-foundation.org
To:     mm-commits@vger.kernel.org, rppt@linux.ibm.com
Subject:  + mm-remove-unused-early_pfn_valid.patch added to -mm tree
Message-ID: <20200925025726.bQoBs%akpm@linux-foundation.org>
User-Agent: s-nail v14.9.10
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: include/linux/mmzone.h: remove unused early_pfn_valid()
has been added to the -mm tree.  Its filename is
     mm-remove-unused-early_pfn_valid.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/mm-remove-unused-early_pfn_valid.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/mm-remove-unused-early_pfn_valid.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Mike Rapoport <rppt@linux.ibm.com>
Subject: include/linux/mmzone.h: remove unused early_pfn_valid()

The early_pfn_valid() macro is defined but it is never used.  Remove it.

Link: https://lkml.kernel.org/r/20200923162915.26935-1-rppt@kernel.org
Signed-off-by: Mike Rapoport <rppt@linux.ibm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/mmzone.h |    5 -----
 1 file changed, 5 deletions(-)

--- a/include/linux/mmzone.h~mm-remove-unused-early_pfn_valid
+++ a/include/linux/mmzone.h
@@ -1420,7 +1420,6 @@ static inline unsigned long next_present
 #define pfn_to_nid(pfn)		(0)
 #endif
 
-#define early_pfn_valid(pfn)	pfn_valid(pfn)
 void sparse_init(void);
 #else
 #define sparse_init()	do {} while (0)
@@ -1440,10 +1439,6 @@ struct mminit_pfnnid_cache {
 	int last_nid;
 };
 
-#ifndef early_pfn_valid
-#define early_pfn_valid(pfn)	(1)
-#endif
-
 /*
  * If it is possible to have holes within a MAX_ORDER_NR_PAGES, then we
  * need to check pfn validity within that MAX_ORDER_NR_PAGES block.
_

Patches currently in -mm which might be from rppt@linux.ibm.com are

mm-account-pmd-tables-like-pte-tables-fix.patch
kvm-ppc-book3s-hv-simplify-kvm_cma_reserve.patch
dma-contiguous-simplify-cma_early_percent_memory.patch
arm-xtensa-simplify-initialization-of-high-memory-pages.patch
arm64-numa-simplify-dummy_numa_init.patch
h8300-nds32-openrisc-simplify-detection-of-memory-extents.patch
riscv-drop-unneeded-node-initialization.patch
mircoblaze-drop-unneeded-numa-and-sparsemem-initializations.patch
memblock-make-for_each_memblock_type-iterator-private.patch
memblock-make-memblock_debug-and-related-functionality-private.patch
memblock-reduce-number-of-parameters-in-for_each_mem_range.patch
arch-mm-replace-for_each_memblock-with-for_each_mem_pfn_range.patch
arch-drivers-replace-for_each_membock-with-for_each_mem_range.patch
arch-drivers-replace-for_each_membock-with-for_each_mem_range-fix-2.patch
x86-setup-simplify-initrd-relocation-and-reservation.patch
x86-setup-simplify-reserve_crashkernel.patch
memblock-remove-unused-memblock_mem_size.patch
memblock-implement-for_each_reserved_mem_region-using-__next_mem_region.patch
memblock-use-separate-iterators-for-memory-and-reserved-regions.patch
mm-remove-unused-early_pfn_valid.patch
mm-add-definition-of-pmd_page_order.patch
mmap-make-mlock_future_check-global.patch
mm-introduce-memfd_secret-system-call-to-create-secret-memory-areas.patch
arch-mm-wire-up-memfd_secret-system-call-were-relevant.patch
mm-secretmem-use-pmd-size-pages-to-amortize-direct-map-fragmentation.patch
secretmem-test-add-basic-selftest-for-memfd_secret2.patch

