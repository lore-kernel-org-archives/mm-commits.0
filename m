Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DD144C19F2B
	for <mm-commits@archiver.kernel.org>; Sat, 30 Jul 2022 01:09:36 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239595AbiG3BJf (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 29 Jul 2022 21:09:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35070 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239735AbiG3BI5 (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 29 Jul 2022 21:08:57 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 73F6787C2B
        for <mm-commits@vger.kernel.org>; Fri, 29 Jul 2022 18:08:47 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 34B1BB82926
        for <mm-commits@vger.kernel.org>; Sat, 30 Jul 2022 01:08:46 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DF2BFC433B5;
        Sat, 30 Jul 2022 01:08:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1659143325;
        bh=nPVQiDpTR2m00o8pwta210//gMgBDe3tlz1WrTV51t8=;
        h=Date:To:From:Subject:From;
        b=D1ELJua4vK0IdofyffIGEuzT8j65dPqOpVOiJbHkJUJ/G43vHVEuGMsDBC47aU/s6
         Dugd+xyywfu6nMAzwqYK8VyM5cSA/7+LJFlnBfQzVmDb+4rZkK3ve+xYTuce69RFy8
         am96b2I9dZL/dIwoZY0rxAdNM9Cd2YpdFjsLER4M=
Date:   Fri, 29 Jul 2022 18:08:44 -0700
To:     mm-commits@vger.kernel.org, Philip.Yang@amd.com, jgg@nvidia.com,
        felix.kuehling@amd.com, apopple@nvidia.com, rcampbell@nvidia.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-hmm-add-a-test-for-cross-device-private-faults.patch removed from -mm tree
Message-Id: <20220730010844.DF2BFC433B5@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: mm/hmm: add a test for cross device private faults
has been removed from the -mm tree.  Its filename was
     mm-hmm-add-a-test-for-cross-device-private-faults.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Ralph Campbell <rcampbell@nvidia.com>
Subject: mm/hmm: add a test for cross device private faults
Date: Mon, 25 Jul 2022 11:36:15 -0700

Add a simple test case for when hmm_range_fault() is called with the
HMM_PFN_REQ_FAULT flag and a device private PTE is found for a device
other than the hmm_range::dev_private_owner.  This should cause the page
to be faulted back to system memory from the other device and the PFN
returned in the output array.

Also, remove a piece of code that unnecessarily unmaps part of the buffer.

Link: https://lkml.kernel.org/r/20220727000837.4128709-3-rcampbell@nvidia.com
Link: https://lkml.kernel.org/r/20220725183615.4118795-3-rcampbell@nvidia.com
Signed-off-by: Ralph Campbell <rcampbell@nvidia.com>
Reviewed-by: Alistair Popple <apopple@nvidia.com>
Cc: Felix Kuehling <felix.kuehling@amd.com>
Cc: Philip Yang <Philip.Yang@amd.com>
Cc: Jason Gunthorpe <jgg@nvidia.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 tools/testing/selftests/vm/hmm-tests.c |   14 ++++++++++++--
 1 file changed, 12 insertions(+), 2 deletions(-)

--- a/tools/testing/selftests/vm/hmm-tests.c~mm-hmm-add-a-test-for-cross-device-private-faults
+++ a/tools/testing/selftests/vm/hmm-tests.c
@@ -1603,9 +1603,19 @@ TEST_F(hmm2, double_map)
 	for (i = 0, ptr = buffer->mirror; i < size / sizeof(*ptr); ++i)
 		ASSERT_EQ(ptr[i], i);
 
-	/* Punch a hole after the first page address. */
-	ret = munmap(buffer->ptr + self->page_size, self->page_size);
+	/* Migrate pages to device 1 and try to read from device 0. */
+	ret = hmm_dmirror_cmd(self->fd1, HMM_DMIRROR_MIGRATE, buffer, npages);
 	ASSERT_EQ(ret, 0);
+	ASSERT_EQ(buffer->cpages, npages);
+
+	ret = hmm_dmirror_cmd(self->fd0, HMM_DMIRROR_READ, buffer, npages);
+	ASSERT_EQ(ret, 0);
+	ASSERT_EQ(buffer->cpages, npages);
+	ASSERT_EQ(buffer->faults, 1);
+
+	/* Check what device 0 read. */
+	for (i = 0, ptr = buffer->mirror; i < size / sizeof(*ptr); ++i)
+		ASSERT_EQ(ptr[i], i);
 
 	hmm_buffer_free(buffer);
 }
_

Patches currently in -mm which might be from rcampbell@nvidia.com are


