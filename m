Return-Path: <SRS0=Fe7N=DY=vger.kernel.org=mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 07B97C43457
	for <mm-commits@archiver.kernel.org>; Sat, 17 Oct 2020 23:14:49 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id BE8E020878
	for <mm-commits@archiver.kernel.org>; Sat, 17 Oct 2020 23:14:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1602976488;
	bh=25RfhTqr2Jfw6P3r6zDykxyPWbiJknJ7qwh27f3yQic=;
	h=Date:From:To:Subject:In-Reply-To:Reply-To:List-ID:From;
	b=u3M4cqCff6MLvKATHHR/NoYrXtzmdgz1hbg6kja3ymK1sheif757MZU3Jzt19ylI0
	 nWwN6irojWmALjRVqKTgq/cvcecQxY2H0R/KdlxmINHaLT5o/qFp4GQMEqqY1VR3ci
	 0wNdN4S7uCzjIQOSC25hU2Z3ZiH81Tur+ZsroaJM=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2439903AbgJQXOs (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Sat, 17 Oct 2020 19:14:48 -0400
Received: from mail.kernel.org ([198.145.29.99]:48566 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2439878AbgJQXOs (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Sat, 17 Oct 2020 19:14:48 -0400
Received: from localhost.localdomain (c-73-231-172-41.hsd1.ca.comcast.net [73.231.172.41])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 8CBA3212CC;
        Sat, 17 Oct 2020 23:14:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1602976487;
        bh=25RfhTqr2Jfw6P3r6zDykxyPWbiJknJ7qwh27f3yQic=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=EmRDwEgZvAUwkCRkYXY55983hD7TvnkRXlNWpLbwzSl4v+Le3P6he8EmejHQiJAs2
         nyGFbRwmRaLQwIGd+Zo8njT+KV5i1Befpyzw6oxT5coCTexTJ/pXddxDOvxBjlSWvx
         Y+C6HhiEgjQGyFDgjAN8cjYK997CjwJjtJrLu7ok=
Date:   Sat, 17 Oct 2020 16:14:47 -0700
From:   Andrew Morton <akpm@linux-foundation.org>
To:     akpm@linux-foundation.org, jhubbard@nvidia.com, linux-mm@kvack.org,
        mm-commits@vger.kernel.org, rcampbell@nvidia.com, shuah@kernel.org,
        sj38.park@gmail.com, torvalds@linux-foundation.org
Subject:  [patch 23/40] selftests/vm: 10x speedup for hmm-tests
Message-ID: <20201017231447.uw23bzJ9_%akpm@linux-foundation.org>
In-Reply-To: <20201017161314.88890b87fae7446ccc13c902@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

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
