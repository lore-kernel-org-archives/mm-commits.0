Return-Path: <SRS0=lrFz=DV=vger.kernel.org=mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 119A1C4363D
	for <mm-commits@archiver.kernel.org>; Wed, 14 Oct 2020 21:01:56 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id AEE3B22248
	for <mm-commits@archiver.kernel.org>; Wed, 14 Oct 2020 21:01:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1602709315;
	bh=f96mnS3QnZ8gn1+oCM0jNau4isVNWyK2zW5u54RL6l8=;
	h=Date:From:To:Subject:Reply-To:List-ID:From;
	b=ZwHKRw+EL3lm2lMQ8akQEekI1PETMITHNBNtOsrFcSBcivKOLXeL5AGaeJ8jWuBmE
	 c3D0PQXYd21BVUOJXd3j12YNJIPtGPMuS+lOu+H8zhW0zsHsiXH6Bi1oLx5YL+/TtR
	 yg40xF0tTGluwmf0jqKkJqi2A6RdLzstpjjs4cQ0=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730558AbgJNVBn (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 14 Oct 2020 17:01:43 -0400
Received: from mail.kernel.org ([198.145.29.99]:51626 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730498AbgJNVBn (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Wed, 14 Oct 2020 17:01:43 -0400
Received: from localhost.localdomain (c-71-198-47-131.hsd1.ca.comcast.net [71.198.47.131])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id C69822225C;
        Wed, 14 Oct 2020 21:01:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1602709301;
        bh=f96mnS3QnZ8gn1+oCM0jNau4isVNWyK2zW5u54RL6l8=;
        h=Date:From:To:Subject:From;
        b=q5IqXARdaUH/BSRsa+pQdmtiWGUkmtXl7XcE69k5eabXNKtx/7934Dzen/tghfva4
         HzFSYQ68do+t3Xpz3qjEfS+95O5vkNVkunhAkpz6b9siYyub72clMFfyxwo7gR9NR4
         LGkCR4yYfbyfzhECoI8HeWGU+M/aZ3r44y10E7R0=
Date:   Wed, 14 Oct 2020 14:01:40 -0700
From:   akpm@linux-foundation.org
To:     jgg@nvidia.com, jglisse@redhat.com, jhubbard@nvidia.com,
        mm-commits@vger.kernel.org, rcampbell@nvidia.com, shuah@kernel.org
Subject:  [merged] mm-test-use-the-new-skip-macro.patch removed
 from -mm tree
Message-ID: <20201014210140.TuRX1MvjG%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: tools/testing/selftests/vm/hmm-tests.c: use the new SKIP() macro
has been removed from the -mm tree.  Its filename was
     mm-test-use-the-new-skip-macro.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Ralph Campbell <rcampbell@nvidia.com>
Subject: tools/testing/selftests/vm/hmm-tests.c: use the new SKIP() macro

Some tests might not be able to be run if resources like huge pages are
not available.  Mark these tests as skipped instead of simply passing.

Link: http://lkml.kernel.org/r/20200827190400.12608-1-rcampbell@nvidia.com
Signed-off-by: Ralph Campbell <rcampbell@nvidia.com>
Reviewed-by: Jason Gunthorpe <jgg@nvidia.com>
Cc: Jerome Glisse <jglisse@redhat.com>
Cc: John Hubbard <jhubbard@nvidia.com>
Cc: Shuah Khan <shuah@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 tools/testing/selftests/vm/hmm-tests.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/tools/testing/selftests/vm/hmm-tests.c~mm-test-use-the-new-skip-macro
+++ a/tools/testing/selftests/vm/hmm-tests.c
@@ -680,7 +680,7 @@ TEST_F(hmm, anon_write_hugetlbfs)
 
 	n = gethugepagesizes(pagesizes, 4);
 	if (n <= 0)
-		return;
+		SKIP(return, "Huge page size could not be determined");
 	for (idx = 0; --n > 0; ) {
 		if (pagesizes[n] < pagesizes[idx])
 			idx = n;
@@ -694,7 +694,7 @@ TEST_F(hmm, anon_write_hugetlbfs)
 	buffer->ptr = get_hugepage_region(size, GHR_STRICT);
 	if (buffer->ptr == NULL) {
 		free(buffer);
-		return;
+		SKIP(return, "Huge page could not be allocated");
 	}
 
 	buffer->fd = -1;
_

Patches currently in -mm which might be from rcampbell@nvidia.com are


