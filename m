Return-Path: <SRS0=SqaX=DN=vger.kernel.org=mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.5 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3EBEDC4363D
	for <mm-commits@archiver.kernel.org>; Tue,  6 Oct 2020 21:53:27 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id DC60C208B6
	for <mm-commits@archiver.kernel.org>; Tue,  6 Oct 2020 21:53:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1602021206;
	bh=76ID0n7Rwluvuvp3TcYse39jSV5imWHppnxD/V/9l1o=;
	h=Date:From:To:Subject:Reply-To:List-ID:From;
	b=h0lEq/koVTcPhYuJpC2F5AK6qDFXKTNx2dSO9UdcP7XzN/k8lK/94kdtAFbOKubsu
	 OipD8lUZA7ES9a+rVEr7rdfv4pInkypGfMN5aA54NShER8JXoSA95WTd73kvqvZ2WN
	 vPdMmbN1aga4EdfbwRwu4dZqBsZjMdAzXZ8X002Y=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726860AbgJFVx0 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 6 Oct 2020 17:53:26 -0400
Received: from mail.kernel.org ([198.145.29.99]:45606 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726759AbgJFVxY (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Tue, 6 Oct 2020 17:53:24 -0400
Received: from localhost.localdomain (c-73-231-172-41.hsd1.ca.comcast.net [73.231.172.41])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 071722065C;
        Tue,  6 Oct 2020 21:53:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1602021203;
        bh=76ID0n7Rwluvuvp3TcYse39jSV5imWHppnxD/V/9l1o=;
        h=Date:From:To:Subject:From;
        b=152I+g/xDWW+KKqjLb/t/plHDdCe1qVrpK1p+ZwJLV2n2I2pZ62PClyCAnNv14j5y
         iyp8/avFYw6Uh+F5T75ONQEEPF0v2ZQd92f7GHYNsafls1V1QRgnDMVSEwAMMnhyFC
         8aWUPVhJNKyWFdu0QqDr6Jq/7sF1y6tkx5p7iCao=
Date:   Tue, 06 Oct 2020 14:53:22 -0700
From:   akpm@linux-foundation.org
To:     jhubbard@nvidia.com, mm-commits@vger.kernel.org,
        rcampbell@nvidia.com, shuah@kernel.org, sj38.park@gmail.com
Subject:  + selftests-vm-10x-speedup-for-hmm-tests.patch added to
 -mm tree
Message-ID: <20201006215322.n2xbPAC0U%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: selftests/vm: 10x speedup for hmm-tests
has been added to the -mm tree.  Its filename is
     selftests-vm-10x-speedup-for-hmm-tests.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/selftests-vm-10x-speedup-for-hmm-tests.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/selftests-vm-10x-speedup-for-hmm-tests.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: John Hubbard <jhubbard@nvidia.com>
Subject: selftests/vm: 10x speedup for hmm-tests

This patch reduces the running time for hmm-tests from about 10+ seconds,
to just under 1.0 second, for an approximately 10x speedup.  That brings
it in line with most of the other tests in selftests/vm, which mostly run
in < 1 sec.

This is done with a one-line change that simply reduces the number of
iterations of several tests, from 256, to 10.  Thanks to Ralph Campbell
for suggesting changing NTIMES as a way to get the speedup.

Link: https://lkml.kernel.org/r/20201003011721.44238-1-jhubbard@nvidia.com
Signed-off-by: John Hubbard <jhubbard@nvidia.com>
Suggested-by: Ralph Campbell <rcampbell@nvidia.com>
Cc: SeongJae Park <sj38.park@gmail.com>
Cc: Shuah Khan <shuah@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 tools/testing/selftests/vm/hmm-tests.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/tools/testing/selftests/vm/hmm-tests.c~selftests-vm-10x-speedup-for-hmm-tests
+++ a/tools/testing/selftests/vm/hmm-tests.c
@@ -49,7 +49,7 @@ struct hmm_buffer {
 #define TWOMEG		(1 << 21)
 #define HMM_BUFFER_SIZE (1024 << 12)
 #define HMM_PATH_MAX    64
-#define NTIMES		256
+#define NTIMES		10
 
 #define ALIGN(x, a) (((x) + (a - 1)) & (~((a) - 1)))
 
_

Patches currently in -mm which might be from jhubbard@nvidia.com are

mm-dump_page-rename-head_mapcount-head_compound_mapcount.patch
mm-gup-protect-unpin_user_pages-against-npages==-errno.patch
selftests-vm-fix-false-build-success-on-the-second-and-later-attempts.patch
selftests-vm-fix-incorrect-gcc-invocation-in-some-cases.patch
selftests-vm-8x-compaction_test-speedup.patch
mm-gup_benchmark-rename-to-mm-gup_test.patch
selftests-vm-use-a-common-gup_testh.patch
selftests-vm-rename-run_vmtests-run_vmtestssh.patch
selftests-vm-minor-cleanup-makefile-and-gup_testc.patch
selftests-vm-only-some-gup_test-items-are-really-benchmarks.patch
selftests-vm-gup_test-introduce-the-dump_pages-sub-test.patch
selftests-vm-run_vmtestsh-update-and-clean-up-gup_test-invocation.patch
selftests-vm-hmm-tests-remove-the-libhugetlbfs-dependency.patch
selftests-vm-hmm-tests-remove-the-libhugetlbfs-dependency-fix.patch
selftests-vm-10x-speedup-for-hmm-tests.patch

