Return-Path: <SRS0=McLq=BW=vger.kernel.org=mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.0 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3D99CC433DF
	for <mm-commits@archiver.kernel.org>; Wed, 12 Aug 2020 21:02:06 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 18B5920768
	for <mm-commits@archiver.kernel.org>; Wed, 12 Aug 2020 21:02:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1597266126;
	bh=w6NximXLODwYSyL6spFp8pTk3EYN8Ca2ErLtT3ETaAM=;
	h=Date:From:To:Subject:Reply-To:List-ID:From;
	b=xI6mVVIiC+80k23cdB8v5kuOX+7hhYa4fM5Qq8RaMCuomS+YlvRZZnXvfTqq4yWiV
	 3Kb3poaja6USQhjbXa4EQpHgqLlDin8uI3Yu7fPWozoBo43V3iZo00gPCLQiTLk38Z
	 XdizkZh9ldDi2PTSJlG5ZhSuvqI2gYafGgX6sr+E=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726282AbgHLVCF (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 12 Aug 2020 17:02:05 -0400
Received: from mail.kernel.org ([198.145.29.99]:48430 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726526AbgHLVCF (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Wed, 12 Aug 2020 17:02:05 -0400
Received: from localhost.localdomain (c-71-198-47-131.hsd1.ca.comcast.net [71.198.47.131])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 95ED1207F7;
        Wed, 12 Aug 2020 21:02:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1597266124;
        bh=w6NximXLODwYSyL6spFp8pTk3EYN8Ca2ErLtT3ETaAM=;
        h=Date:From:To:Subject:From;
        b=b12SeViIuKtb4Xp0+QXhnheJzFDVA/9XW+/4g33Sgv+EomEZpv4jo7WpsvjU7oN47
         1Z38mFgnE5rJBV7/azTvVDxE99sjvGogxfKVZtIxgSlFetDdZzLMtd9DBcNBOvX7/p
         cJtzDysJp7R3Xcf1y6OMOtWQQQRgcuZpknF0mMeU=
Date:   Wed, 12 Aug 2020 14:02:04 -0700
From:   akpm@linux-foundation.org
To:     bharata@linux.ibm.com, hch@lst.de, jgg@mellanox.com,
        jglisse@redhat.com, jhubbard@nvidia.com,
        mm-commits@vger.kernel.org, rcampbell@nvidia.com, shuah@kernel.org
Subject:  [merged]
 mm-migrate-optimize-migrate_vma_setup-for-holes.patch removed from -mm tree
Message-ID: <20200812210204.xsM0F0E8s%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Sender: mm-commits-owner@vger.kernel.org
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/migrate: optimize migrate_vma_setup() for holes
has been removed from the -mm tree.  Its filename was
     mm-migrate-optimize-migrate_vma_setup-for-holes.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Ralph Campbell <rcampbell@nvidia.com>
Subject: mm/migrate: optimize migrate_vma_setup() for holes

Patch series "mm/migrate: optimize migrate_vma_setup() for holes".

A simple optimization for migrate_vma_*() when the source vma is not an
anonymous vma and a new test case to exercise it.


This patch (of 2):

When migrating system memory to device private memory, if the source
address range is a valid VMA range and there is no memory or a zero page,
the source PFN array is marked as valid but with no PFN.

This lets the device driver allocate private memory and clear it, then
insert the new device private struct page into the CPU's page tables when
migrate_vma_pages() is called.  migrate_vma_pages() only inserts the new
page if the VMA is an anonymous range.

There is no point in telling the device driver to allocate device private
memory and then not migrate the page.  Instead, mark the source PFN array
entries as not migrating to avoid this overhead.

[rcampbell@nvidia.com: v2]
  Link: http://lkml.kernel.org/r/20200710194840.7602-2-rcampbell@nvidia.com
Link: http://lkml.kernel.org/r/20200710194840.7602-1-rcampbell@nvidia.com
Link: http://lkml.kernel.org/r/20200709165711.26584-1-rcampbell@nvidia.com
Link: http://lkml.kernel.org/r/20200709165711.26584-2-rcampbell@nvidia.com
Signed-off-by: Ralph Campbell <rcampbell@nvidia.com>
Cc: Jerome Glisse <jglisse@redhat.com>
Cc: John Hubbard <jhubbard@nvidia.com>
Cc: Christoph Hellwig <hch@lst.de>
Cc: Jason Gunthorpe <jgg@mellanox.com>
Cc: "Bharata B Rao" <bharata@linux.ibm.com>
Cc: Shuah Khan <shuah@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/migrate.c |   16 ++++++++++++++--
 1 file changed, 14 insertions(+), 2 deletions(-)

--- a/mm/migrate.c~mm-migrate-optimize-migrate_vma_setup-for-holes
+++ a/mm/migrate.c
@@ -2168,6 +2168,16 @@ static int migrate_vma_collect_hole(unsi
 	struct migrate_vma *migrate = walk->private;
 	unsigned long addr;
 
+	/* Only allow populating anonymous memory. */
+	if (!vma_is_anonymous(walk->vma)) {
+		for (addr = start; addr < end; addr += PAGE_SIZE) {
+			migrate->src[migrate->npages] = 0;
+			migrate->dst[migrate->npages] = 0;
+			migrate->npages++;
+		}
+		return 0;
+	}
+
 	for (addr = start; addr < end; addr += PAGE_SIZE) {
 		migrate->src[migrate->npages] = MIGRATE_PFN_MIGRATE;
 		migrate->dst[migrate->npages] = 0;
@@ -2260,8 +2270,10 @@ again:
 		pte = *ptep;
 
 		if (pte_none(pte)) {
-			mpfn = MIGRATE_PFN_MIGRATE;
-			migrate->cpages++;
+			if (vma_is_anonymous(vma)) {
+				mpfn = MIGRATE_PFN_MIGRATE;
+				migrate->cpages++;
+			}
 			goto next;
 		}
 
_

Patches currently in -mm which might be from rcampbell@nvidia.com are


