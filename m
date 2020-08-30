Return-Path: <SRS0=GXSN=CI=vger.kernel.org=mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.0 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 182B9C433E6
	for <mm-commits@archiver.kernel.org>; Sun, 30 Aug 2020 22:22:05 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id E789020BED
	for <mm-commits@archiver.kernel.org>; Sun, 30 Aug 2020 22:22:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1598826124;
	bh=7/4jMAN7rQxDsWASRUyTuLeIYawCWgC3CimuJl0hhUM=;
	h=Date:From:To:Subject:Reply-To:List-ID:From;
	b=aLJPF592JnAD9lTTViZALvRHDcFrHqrlYq7yuUyrFNnQRjnsDjpKW0q+hw4qtELG5
	 n0ymraCUfIJQo5u3xtB9ldSs1cw3EdJhnrG4UfXIg62rJzje2UC/RwMMVtglnnAXEJ
	 BywORYngVbpMWFMmG80pvjwXjo9dWaOw5AF30n+A=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726412AbgH3WWE (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Sun, 30 Aug 2020 18:22:04 -0400
Received: from mail.kernel.org ([198.145.29.99]:44730 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726178AbgH3WWD (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Sun, 30 Aug 2020 18:22:03 -0400
Received: from X1 (unknown [65.49.58.28])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 10564206F0;
        Sun, 30 Aug 2020 22:22:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1598826123;
        bh=7/4jMAN7rQxDsWASRUyTuLeIYawCWgC3CimuJl0hhUM=;
        h=Date:From:To:Subject:From;
        b=TrY1bXOT3wynt7W6fkZSpYrT1p65atsXIExk02XIzqWuQJouO3cXJsuWgvYPMNq4g
         6gFY19iuqlw7n/ocEHzJeLIQY8UDoqm87PqdnZK9dQVoHigm7EfG2BkSrOGPTemsVG
         Lmkn4vIYi391DL7r4tpTs53eEGq65RnPlsfLEYgs=
Date:   Sun, 30 Aug 2020 15:22:02 -0700
From:   akpm@linux-foundation.org
To:     mm-commits@vger.kernel.org, shuah@kernel.org, jhubbard@nvidia.com,
        jglisse@redhat.com, jgg@nvidia.com, rcampbell@nvidia.com
Subject:  + mm-test-use-the-new-skip-macro.patch added to -mm tree
Message-ID: <20200830222202.qV_sM%akpm@linux-foundation.org>
User-Agent: s-nail v14.9.10
Sender: mm-commits-owner@vger.kernel.org
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: tools/testing/selftests/vm/hmm-tests.c: use the new SKIP() macro
has been added to the -mm tree.  Its filename is
     mm-test-use-the-new-skip-macro.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-test-use-the-new-skip-macro.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-test-use-the-new-skip-macro.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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

mm-test-use-the-new-skip-macro.patch
mm-migrate-remove-cpages-in-migrate_vma_finalize.patch
mm-migrate-remove-obsolete-comment-about-device-public.patch

