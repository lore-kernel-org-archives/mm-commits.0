Return-Path: <SRS0=kBw3=D5=vger.kernel.org=mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CE4F9C388F7
	for <mm-commits@archiver.kernel.org>; Thu, 22 Oct 2020 23:09:48 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 7DAFD2245F
	for <mm-commits@archiver.kernel.org>; Thu, 22 Oct 2020 23:09:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1603408188;
	bh=UB2Hy6wGEtWR9QTiItT7XnrnAQE4mor+IPe/eO5AGOE=;
	h=Date:From:To:Subject:Reply-To:List-ID:From;
	b=jx7tYC9pk+DowAetlz4M81/R3fuXwiaakEbN6DckWnX/kfhEDboQRDe2fGZoIsTqA
	 x7ChF8bUFKhvqCwM6NKLnRZL0GYNKGtzWKacZKlLFZMdqBXamWL0iqxtxs2tIskZee
	 ro2sou+FkZ13yHnNOOE+xAzSfyIj9Aqg1nZrAvTg=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S373249AbgJVXJr (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 22 Oct 2020 19:09:47 -0400
Received: from mail.kernel.org ([198.145.29.99]:50132 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S373127AbgJVXJr (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Thu, 22 Oct 2020 19:09:47 -0400
Received: from localhost.localdomain (c-71-198-47-131.hsd1.ca.comcast.net [71.198.47.131])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 2C5C5208B3;
        Thu, 22 Oct 2020 23:09:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1603408186;
        bh=UB2Hy6wGEtWR9QTiItT7XnrnAQE4mor+IPe/eO5AGOE=;
        h=Date:From:To:Subject:From;
        b=vgJG/gVqlw1C0GOYosIqQ0Q8o3993q+H+RmBuMuBKH5HSVasP05j3/TjqbYFcRsWZ
         sdL0FlpY6FfnEoXGf+ImdCLqRcBY7rO6ZmzoGFJxIp78CiqNCn4EgkNNJ3I2UZ8Qxp
         H3anr0PqGyR4nn5qMlAXqbQfC7sqqoi4PSB1GV40=
Date:   Thu, 22 Oct 2020 16:09:45 -0700
From:   akpm@linux-foundation.org
To:     jhubbard@nvidia.com, mm-commits@vger.kernel.org,
        rcampbell@nvidia.com, shuah@kernel.org, sj38.park@gmail.com
Subject:  [merged] selftests-vm-10x-speedup-for-hmm-tests.patch
 removed from -mm tree
Message-ID: <20201022230945.EaAOID4g0%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: selftests/vm: 10x speedup for hmm-tests
has been removed from the -mm tree.  Its filename was
     selftests-vm-10x-speedup-for-hmm-tests.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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


