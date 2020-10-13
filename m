Return-Path: <SRS0=1pWp=DU=vger.kernel.org=mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E1F5EC433DF
	for <mm-commits@archiver.kernel.org>; Tue, 13 Oct 2020 23:54:31 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 8E2C9221FF
	for <mm-commits@archiver.kernel.org>; Tue, 13 Oct 2020 23:54:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1602633271;
	bh=JsT6c8ztUlM5GIySrn5W4bQ9FmOtvGKIIglrkwGLQqM=;
	h=Date:From:To:Subject:In-Reply-To:Reply-To:List-ID:From;
	b=Swc49wIl+nz6v6FcKDrr9DIdyRKdQemXeJAkyecTB2JogVY7KbxN0zN8wWXW1fN6Z
	 1OJrzBoofjeFciuTafVm4kHqZoP9iWBZ25amCY3Mus52lJpvsvR772oGwkqiV0T9pL
	 6Y80w4RhPq/7seSh0xiPUeylf+jBfePYxq3+dzps=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730365AbgJMXyb (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 13 Oct 2020 19:54:31 -0400
Received: from mail.kernel.org ([198.145.29.99]:39612 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726953AbgJMXya (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Tue, 13 Oct 2020 19:54:30 -0400
Received: from localhost.localdomain (c-73-231-172-41.hsd1.ca.comcast.net [73.231.172.41])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 9C964206D5;
        Tue, 13 Oct 2020 23:54:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1602633270;
        bh=JsT6c8ztUlM5GIySrn5W4bQ9FmOtvGKIIglrkwGLQqM=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=d2ezA567/NT06UC0/lYleSjA39+w7yljwyoS2jbCkQFb7WvofJ46Jms2492Duyd4x
         WjubCW6iUwgF/Sj3hVsqY6HOXiiwduzLDfwrcxhGwDFopXnVXHm+ni9gY7vIvMrHfg
         AO+MnFsx1Uc9eJvbzak6R6V/p/t9PTOXEm3msK2A=
Date:   Tue, 13 Oct 2020 16:54:29 -0700
From:   Andrew Morton <akpm@linux-foundation.org>
To:     akpm@linux-foundation.org, jgg@nvidia.com, jglisse@redhat.com,
        jhubbard@nvidia.com, linux-mm@kvack.org,
        mm-commits@vger.kernel.org, rcampbell@nvidia.com, shuah@kernel.org,
        torvalds@linux-foundation.org
Subject:  [patch 111/181] tools/testing/selftests/vm/hmm-tests.c:
 use the new SKIP() macro
Message-ID: <20201013235429.trZvTJkV_%akpm@linux-foundation.org>
In-Reply-To: <20201013164658.3bfd96cc224d8923e66a9f4e@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

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
