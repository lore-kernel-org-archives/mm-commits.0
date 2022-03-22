Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 15E83C433EF
	for <mm-commits@archiver.kernel.org>; Tue, 22 Mar 2022 21:46:49 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236708AbiCVVsP (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 22 Mar 2022 17:48:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34728 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236604AbiCVVr7 (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 22 Mar 2022 17:47:59 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1D18F5FF14
        for <mm-commits@vger.kernel.org>; Tue, 22 Mar 2022 14:46:16 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id AC62B6119A
        for <mm-commits@vger.kernel.org>; Tue, 22 Mar 2022 21:46:15 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0B859C340EE;
        Tue, 22 Mar 2022 21:46:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1647985575;
        bh=RZk32U2wkpIOQUJvahJ71fz2IWCApZYl7wNieg6vRYk=;
        h=Date:To:From:In-Reply-To:Subject:From;
        b=NoVE+Vijy36uDUoTptgMWu633gboe8ANZ77+QSIL93sbpeSoW6AFsnHkDJpxcc6wj
         qutkvzmUc/DrNA7oTuMTQ2LIvfY/ES0g8sP/dpov9jXpIpIFZdtSnzckKWNMVoBRf+
         hunfFRtRniKuk/SDxiyhJsMXrxPZSNaMuXAGvLcs=
Date:   Tue, 22 Mar 2022 14:46:14 -0700
To:     sourabhjain@linux.ibm.com, osalvador@suse.de, mpe@ellerman.id.au,
        mike.kravetz@oracle.com, mahesh@linux.ibm.com, david@redhat.com,
        hbathini@linux.ibm.com, akpm@linux-foundation.org,
        patches@lists.linux.dev, linux-mm@kvack.org,
        mm-commits@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
In-Reply-To: <20220322143803.04a5e59a07e48284f196a2f9@linux-foundation.org>
Subject: [patch 152/227] mm/cma: provide option to opt out from exposing pages on activation failure
Message-Id: <20220322214615.0B859C340EE@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

From: Hari Bathini <hbathini@linux.ibm.com>
Subject: mm/cma: provide option to opt out from exposing pages on activation failure

Patch series "powerpc/fadump: handle CMA activation failure appropriately", v3.

Commit 072355c1cf2d ("mm/cma: expose all pages to the buddy if activation
of an area fails") started exposing all pages to buddy allocator on CMA
activation failure.  But there can be CMA users that want to handle the
reserved memory differently on CMA allocation failure.  Provide an option
to opt out from exposing pages to buddy for such cases.

Link: https://lkml.kernel.org/r/20220117075246.36072-1-hbathini@linux.ibm.com
Link: https://lkml.kernel.org/r/20220117075246.36072-2-hbathini@linux.ibm.com
Signed-off-by: Hari Bathini <hbathini@linux.ibm.com>
Reviewed-by: David Hildenbrand <david@redhat.com>
Cc: Oscar Salvador <osalvador@suse.de>
Cc: Mike Kravetz <mike.kravetz@oracle.com>
Cc: Mahesh Salgaonkar <mahesh@linux.ibm.com>
Cc: Sourabh Jain <sourabhjain@linux.ibm.com>
Cc: Michael Ellerman <mpe@ellerman.id.au>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/cma.h |    2 ++
 mm/cma.c            |   11 +++++++++--
 mm/cma.h            |    1 +
 3 files changed, 12 insertions(+), 2 deletions(-)

--- a/include/linux/cma.h~mm-cma-provide-option-to-opt-out-from-exposing-pages-on-activation-failure
+++ a/include/linux/cma.h
@@ -58,4 +58,6 @@ extern bool cma_pages_valid(struct cma *
 extern bool cma_release(struct cma *cma, const struct page *pages, unsigned long count);
 
 extern int cma_for_each_area(int (*it)(struct cma *cma, void *data), void *data);
+
+extern void cma_reserve_pages_on_error(struct cma *cma);
 #endif
--- a/mm/cma.c~mm-cma-provide-option-to-opt-out-from-exposing-pages-on-activation-failure
+++ a/mm/cma.c
@@ -131,8 +131,10 @@ not_in_zone:
 	bitmap_free(cma->bitmap);
 out_error:
 	/* Expose all pages to the buddy, they are useless for CMA. */
-	for (pfn = base_pfn; pfn < base_pfn + cma->count; pfn++)
-		free_reserved_page(pfn_to_page(pfn));
+	if (!cma->reserve_pages_on_error) {
+		for (pfn = base_pfn; pfn < base_pfn + cma->count; pfn++)
+			free_reserved_page(pfn_to_page(pfn));
+	}
 	totalcma_pages -= cma->count;
 	cma->count = 0;
 	pr_err("CMA area %s could not be activated\n", cma->name);
@@ -150,6 +152,11 @@ static int __init cma_init_reserved_area
 }
 core_initcall(cma_init_reserved_areas);
 
+void __init cma_reserve_pages_on_error(struct cma *cma)
+{
+	cma->reserve_pages_on_error = true;
+}
+
 /**
  * cma_init_reserved_mem() - create custom contiguous area from reserved memory
  * @base: Base address of the reserved area
--- a/mm/cma.h~mm-cma-provide-option-to-opt-out-from-exposing-pages-on-activation-failure
+++ a/mm/cma.h
@@ -30,6 +30,7 @@ struct cma {
 	/* kobject requires dynamic object */
 	struct cma_kobject *cma_kobj;
 #endif
+	bool reserve_pages_on_error;
 };
 
 extern struct cma cma_areas[MAX_CMA_AREAS];
_
