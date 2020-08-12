Return-Path: <SRS0=McLq=BW=vger.kernel.org=mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.0 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 730F6C433DF
	for <mm-commits@archiver.kernel.org>; Wed, 12 Aug 2020 01:31:52 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 4A48D207DA
	for <mm-commits@archiver.kernel.org>; Wed, 12 Aug 2020 01:31:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1597195912;
	bh=Q/9tUn2pMbMLHYOcmNyiaP59st/oFr3ssKMDobiL838=;
	h=Date:From:To:Subject:In-Reply-To:Reply-To:List-ID:From;
	b=J7b+igPaEqUzk1q4CqCAx9MLUSvu0TFTV6n2L0ZZc+gZ9UeQojXRQ3gNiu8ibmbHm
	 nt7VY+RcmfMzqgXLVxK0rs8UfElOSWd+LNvyjKE7L0sH1PfVkAOAPM00pGB6i8BJej
	 grOZzyrfmfFlNZAAlpS9vLDLtQEwdNGVHAZqHA0s=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726657AbgHLBbr (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 11 Aug 2020 21:31:47 -0400
Received: from mail.kernel.org ([198.145.29.99]:59536 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726642AbgHLBbq (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Tue, 11 Aug 2020 21:31:46 -0400
Received: from localhost.localdomain (c-73-231-172-41.hsd1.ca.comcast.net [73.231.172.41])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 640B5206B2;
        Wed, 12 Aug 2020 01:31:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1597195905;
        bh=Q/9tUn2pMbMLHYOcmNyiaP59st/oFr3ssKMDobiL838=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=INoQK9B+Vh3Je07rJUxLVnxCq1QuhqeZjmXIVjwZBRyESWLnkGaf1ectrb7lMgqpa
         DL4b3Vj9BRWRL7RbvBAud7z8wjWOrP8UVGjJSGw+yXSBFauUf/SVk7oIeiwuHwz6Ma
         hpHwLJjBVrRWva0ST7zCSYwNnAVpGMg4bUxXhVwA=
Date:   Tue, 11 Aug 2020 18:31:45 -0700
From:   Andrew Morton <akpm@linux-foundation.org>
To:     akpm@linux-foundation.org, bharata@linux.ibm.com, hch@lst.de,
        jgg@mellanox.com, jglisse@redhat.com, jhubbard@nvidia.com,
        linux-mm@kvack.org, mm-commits@vger.kernel.org,
        rcampbell@nvidia.com, shuah@kernel.org,
        torvalds@linux-foundation.org
Subject:  [patch 028/165] mm/migrate: add migrate-shared test for
 migrate_vma_*()
Message-ID: <20200812013145.OdoSBJtGw%akpm@linux-foundation.org>
In-Reply-To: <20200811182949.e12ae9a472e3b5e27e16ad6c@linux-foundation.org>
User-Agent: s-nail v14.8.16
Sender: mm-commits-owner@vger.kernel.org
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

From: Ralph Campbell <rcampbell@nvidia.com>
Subject: mm/migrate: add migrate-shared test for migrate_vma_*()

Add a migrate_vma_*() self test for mmap(MAP_SHARED) to verify that
!vma_anonymous() ranges won't be migrated.

Link: http://lkml.kernel.org/r/20200710194840.7602-3-rcampbell@nvidia.com
Link: http://lkml.kernel.org/r/20200709165711.26584-3-rcampbell@nvidia.com
Signed-off-by: Ralph Campbell <rcampbell@nvidia.com>
Cc: Jerome Glisse <jglisse@redhat.com>
Cc: John Hubbard <jhubbard@nvidia.com>
Cc: Christoph Hellwig <hch@lst.de>
Cc: Jason Gunthorpe <jgg@mellanox.com>
Cc: "Bharata B Rao" <bharata@linux.ibm.com>
Cc: Shuah Khan <shuah@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 tools/testing/selftests/vm/hmm-tests.c |   35 +++++++++++++++++++++++
 1 file changed, 35 insertions(+)

--- a/tools/testing/selftests/vm/hmm-tests.c~mm-migrate-add-migrate-shared-test-for-migrate_vma_
+++ a/tools/testing/selftests/vm/hmm-tests.c
@@ -942,6 +942,41 @@ TEST_F(hmm, migrate_fault)
 }
 
 /*
+ * Migrate anonymous shared memory to device private memory.
+ */
+TEST_F(hmm, migrate_shared)
+{
+	struct hmm_buffer *buffer;
+	unsigned long npages;
+	unsigned long size;
+	int ret;
+
+	npages = ALIGN(HMM_BUFFER_SIZE, self->page_size) >> self->page_shift;
+	ASSERT_NE(npages, 0);
+	size = npages << self->page_shift;
+
+	buffer = malloc(sizeof(*buffer));
+	ASSERT_NE(buffer, NULL);
+
+	buffer->fd = -1;
+	buffer->size = size;
+	buffer->mirror = malloc(size);
+	ASSERT_NE(buffer->mirror, NULL);
+
+	buffer->ptr = mmap(NULL, size,
+			   PROT_READ | PROT_WRITE,
+			   MAP_SHARED | MAP_ANONYMOUS,
+			   buffer->fd, 0);
+	ASSERT_NE(buffer->ptr, MAP_FAILED);
+
+	/* Migrate memory to device. */
+	ret = hmm_dmirror_cmd(self->fd, HMM_DMIRROR_MIGRATE, buffer, npages);
+	ASSERT_EQ(ret, -ENOENT);
+
+	hmm_buffer_free(buffer);
+}
+
+/*
  * Try to migrate various memory types to device private memory.
  */
 TEST_F(hmm2, migrate_mixed)
_
