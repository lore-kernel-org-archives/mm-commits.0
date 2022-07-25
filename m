Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 98184C43334
	for <mm-commits@archiver.kernel.org>; Mon, 25 Jul 2022 22:31:02 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230292AbiGYWbB (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 25 Jul 2022 18:31:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39224 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230242AbiGYWbB (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 25 Jul 2022 18:31:01 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F04CD13E95
        for <mm-commits@vger.kernel.org>; Mon, 25 Jul 2022 15:30:59 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id BD7F6B80E4E
        for <mm-commits@vger.kernel.org>; Mon, 25 Jul 2022 22:30:58 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6EA42C341C6;
        Mon, 25 Jul 2022 22:30:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1658788257;
        bh=e5gOucRdqKmHrPxWE8fpsJoMwhK6CQVNHNlwwJ3nXKM=;
        h=Date:To:From:Subject:From;
        b=QTC2pqK6LNUe4yvt5utxpXIcarib6W2IF9HFLKGcXqEli2eb69/dVJGmkJSjOFj9E
         pzXkt7BCoMU6KktDtiLKe/L5kU+WPKau3ob2zr3EoT1TsX3vNXrcCzNFHMDojDpl+f
         /S/dhBMCEDGaAcr1NJhgvi2lJCTKDTPUpB6z7s3Q=
Date:   Mon, 25 Jul 2022 15:30:56 -0700
To:     mm-commits@vger.kernel.org, Philip.Yang@amd.com, jgg@nvidia.com,
        felix.kuehling@amd.com, apopple@nvidia.com, rcampbell@nvidia.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-hmm-add-a-test-for-cross-device-private-faults.patch added to mm-unstable branch
Message-Id: <20220725223057.6EA42C341C6@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/hmm: add a test for cross device private faults
has been added to the -mm mm-unstable branch.  Its filename is
     mm-hmm-add-a-test-for-cross-device-private-faults.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-hmm-add-a-test-for-cross-device-private-faults.patch

This patch will later appear in the mm-unstable branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next via the mm-everything
branch at git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
and is updated there every 2-3 working days

------------------------------------------------------
From: Ralph Campbell <rcampbell@nvidia.com>
Subject: mm/hmm: add a test for cross device private faults
Date: Mon, 25 Jul 2022 11:36:15 -0700

Add a simple test case for when hmm_range_fault() is called with the
HMM_PFN_REQ_FAULT flag and a device private PTE is found for a device
other than the hmm_range::dev_private_owner.  This should cause the page
to be faulted back to system memory from the other device and the PFN
returned in the output array.

Link: https://lkml.kernel.org/r/20220725183615.4118795-3-rcampbell@nvidia.com
Signed-off-by: Ralph Campbell <rcampbell@nvidia.com>
Cc: Felix Kuehling <felix.kuehling@amd.com>
Cc: Philip Yang <Philip.Yang@amd.com>
Cc: Alistair Popple <apopple@nvidia.com>
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

mm-hmm-fault-non-owner-device-private-entries.patch
mm-hmm-add-a-test-for-cross-device-private-faults.patch

