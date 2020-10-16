Return-Path: <SRS0=zz/k=DX=vger.kernel.org=mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E0ADCC433E7
	for <mm-commits@archiver.kernel.org>; Fri, 16 Oct 2020 03:04:36 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 967E12087D
	for <mm-commits@archiver.kernel.org>; Fri, 16 Oct 2020 03:04:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1602817476;
	bh=Or2CQpqLEow/lTsRBd/DMklcdBJcMe9YNSJWWD0WuiM=;
	h=Date:From:To:Subject:In-Reply-To:Reply-To:List-ID:From;
	b=sIvr4kxK+6g7ztNxWq8VRWeUoIIQL/DkY/kuZuIWU/oXOcmgPT5v1RWE+JtZIUs1Q
	 TC0k8ZKj66SLbf2Q4HrUlkj7/uc8YhE5Awif4dTG2jbRB6suyAeukeNX7NHusqiB9P
	 by0oyFjrFFa2fccIFswdhwMSVs22UHxKgikiVKvI=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732581AbgJPDEg (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 15 Oct 2020 23:04:36 -0400
Received: from mail.kernel.org ([198.145.29.99]:43588 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728261AbgJPDEg (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Thu, 15 Oct 2020 23:04:36 -0400
Received: from localhost.localdomain (c-73-231-172-41.hsd1.ca.comcast.net [73.231.172.41])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id C439F208E4;
        Fri, 16 Oct 2020 03:04:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1602817474;
        bh=Or2CQpqLEow/lTsRBd/DMklcdBJcMe9YNSJWWD0WuiM=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=UKHLkdhGJANl6FxzLavEdW3GQ4apJ3m924MvlP+R0yAMzUFaZxyEBe8ofk7ZOz04j
         ZQwQEIm6sDvPBIDRmqAPD49HRo+sXJGceSmVKLOTWJtmzCmRjRlCYj/pAYMKhRTE0j
         SxhtzLe9GiCwe6bKyD/JKuSEczr02Z2FdhTe44nM=
Date:   Thu, 15 Oct 2020 20:04:33 -0700
From:   Andrew Morton <akpm@linux-foundation.org>
To:     akpm@linux-foundation.org, aneesh.kumar@linux.ibm.com,
        anshuman.khandual@arm.com, christophe.leroy@csgroup.eu,
        mm-commits@vger.kernel.org, mpe@ellerman.id.au,
        torvalds@linux-foundation.org
Subject:  [patch 004/156] mm/debug_vm_pgtable/ppc64: avoid setting
 top bits in radom value
Message-ID: <20201016030433.MZtKsUVYK%akpm@linux-foundation.org>
In-Reply-To: <20201015194043.84cda0c1d6ca2a6847f2384a@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

From: "Aneesh Kumar K.V" <aneesh.kumar@linux.ibm.com>
Subject: mm/debug_vm_pgtable/ppc64: avoid setting top bits in radom value

ppc64 use bit 62 to indicate a pte entry (_PAGE_PTE).  Avoid setting that
bit in random value.

Link: https://lkml.kernel.org/r/20200902114222.181353-4-aneesh.kumar@linux.ibm.com
Signed-off-by: Aneesh Kumar K.V <aneesh.kumar@linux.ibm.com>
Reviewed-by: Anshuman Khandual <anshuman.khandual@arm.com>
Cc: Christophe Leroy <christophe.leroy@csgroup.eu>
Cc: Michael Ellerman <mpe@ellerman.id.au>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/debug_vm_pgtable.c |   13 ++++++++++---
 1 file changed, 10 insertions(+), 3 deletions(-)

--- a/mm/debug_vm_pgtable.c~mm-debug_vm_pgtable-ppc64-avoid-setting-top-bits-in-radom-value
+++ a/mm/debug_vm_pgtable.c
@@ -44,10 +44,17 @@
  * entry type. But these bits might affect the ability to clear entries with
  * pxx_clear() because of how dynamic page table folding works on s390. So
  * while loading up the entries do not change the lower 4 bits. It does not
- * have affect any other platform.
+ * have affect any other platform. Also avoid the 62nd bit on ppc64 that is
+ * used to mark a pte entry.
  */
-#define S390_MASK_BITS	4
-#define RANDOM_ORVALUE	GENMASK(BITS_PER_LONG - 1, S390_MASK_BITS)
+#define S390_SKIP_MASK		GENMASK(3, 0)
+#if __BITS_PER_LONG == 64
+#define PPC64_SKIP_MASK		GENMASK(62, 62)
+#else
+#define PPC64_SKIP_MASK		0x0
+#endif
+#define ARCH_SKIP_MASK (S390_SKIP_MASK | PPC64_SKIP_MASK)
+#define RANDOM_ORVALUE (GENMASK(BITS_PER_LONG - 1, 0) & ~ARCH_SKIP_MASK)
 #define RANDOM_NZVALUE	GENMASK(7, 0)
 
 static void __init pte_basic_tests(unsigned long pfn, pgprot_t prot)
_
