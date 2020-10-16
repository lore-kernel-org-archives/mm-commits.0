Return-Path: <SRS0=zz/k=DX=vger.kernel.org=mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2F60DC43457
	for <mm-commits@archiver.kernel.org>; Fri, 16 Oct 2020 02:41:13 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id D62BF2087D
	for <mm-commits@archiver.kernel.org>; Fri, 16 Oct 2020 02:41:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1602816072;
	bh=Or2CQpqLEow/lTsRBd/DMklcdBJcMe9YNSJWWD0WuiM=;
	h=Date:From:To:Subject:In-Reply-To:Reply-To:List-ID:From;
	b=bjsMaX8RrS/Ac5sFnW6w8U4bs6cr1jcZXEvO/zQnaril/Pe8sVoW2o90oxFGi/U84
	 H8BR96Abnea4wPpwqouiQMbY52bZvqd23DgwIZLSe48ByxwTqM5xeplPoILHPZabXd
	 F/Nfsbgh/xfzg2gL/xFxfWgwxH1A1EtHVap/xrd4=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2404282AbgJPClM (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 15 Oct 2020 22:41:12 -0400
Received: from mail.kernel.org ([198.145.29.99]:56694 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2404278AbgJPClM (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Thu, 15 Oct 2020 22:41:12 -0400
Received: from localhost.localdomain (c-73-231-172-41.hsd1.ca.comcast.net [73.231.172.41])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 388E220B1F;
        Fri, 16 Oct 2020 02:41:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1602816071;
        bh=Or2CQpqLEow/lTsRBd/DMklcdBJcMe9YNSJWWD0WuiM=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=n8pFGoVCrU4r7Z8+//qCK418Srrkz9ZWX/49PwNXIghPOeEXqRC+eTFwJZVDGC7XS
         lXzdzYC6aka98PLQXS/jpfQk8JAA9skzs/TrRRHDL3WHFgom8TBWwm8AC/MkBW84J6
         dsY0dIX9Cumf8VZNQbY5e25iiOGRdpPgyDR/qaD4=
Date:   Thu, 15 Oct 2020 19:41:10 -0700
From:   Andrew Morton <akpm@linux-foundation.org>
To:     akpm@linux-foundation.org, aneesh.kumar@linux.ibm.com,
        anshuman.khandual@arm.com, christophe.leroy@csgroup.eu,
        linux-mm@kvack.org, mm-commits@vger.kernel.org, mpe@ellerman.id.au,
        torvalds@linux-foundation.org
Subject:  [patch 004/156] mm/debug_vm_pgtable/ppc64: avoid setting
 top bits in radom value
Message-ID: <20201016024110.wV3GMM4Jv%akpm@linux-foundation.org>
In-Reply-To: <20201015192732.f448da14e9854c7cb7299956@linux-foundation.org>
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
