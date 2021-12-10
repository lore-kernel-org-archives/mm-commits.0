Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 17807C4332F
	for <mm-commits@archiver.kernel.org>; Fri, 10 Dec 2021 22:46:59 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344828AbhLJWud (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 10 Dec 2021 17:50:33 -0500
Received: from sin.source.kernel.org ([145.40.73.55]:57232 "EHLO
        sin.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344886AbhLJWuc (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 10 Dec 2021 17:50:32 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 7A2A1CE2D8D
        for <mm-commits@vger.kernel.org>; Fri, 10 Dec 2021 22:46:55 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 62833C341C8;
        Fri, 10 Dec 2021 22:46:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1639176413;
        bh=j7vMc6yY9pIVL00NDf/jp8vWGXPM6Hke9NvpPZQ7TOM=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=QorWqNOXe27PsLXZIAes6qTkuTFXNfEENLYeKdWTpwg7iZTICcRMx0Tm+LEb1x9pY
         dVLIqF3ncISERR8HB6ZgfXj2T13sHVRg/vD8nuLFWBB/oA7o7IuxsKP841wqTCcTdp
         MMU8CL2aFzEiG3PXd6lAOTHDadpcN1FvIJNHiM8Y=
Date:   Fri, 10 Dec 2021 14:46:52 -0800
From:   Andrew Morton <akpm@linux-foundation.org>
To:     akpm@linux-foundation.org, brendanhiggins@google.com,
        linux-mm@kvack.org, mm-commits@vger.kernel.org, shuah@kernel.org,
        sj@kernel.org, torvalds@linux-foundation.org
Subject:  [patch 15/21] selftests/damon: test wrong DAMOS condition
 ranges input
Message-ID: <20211210224652.mEAbDc-RE%akpm@linux-foundation.org>
In-Reply-To: <20211210144539.663efee2c80d8450e6180230@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

From: SeongJae Park <sj@kernel.org>
Subject: selftests/damon: test wrong DAMOS condition ranges input

A patch titled "mm/damon/schemes: add the validity judgment of
thresholds"[1] makes DAMON debugfs interface to validate DAMON scheme
inputs.  This commit adds a test case for the validation logic in DAMON
selftests.

[1] https://lore.kernel.org/linux-mm/d78360e52158d786fcbf20bc62c96785742e76d3.1637239568.git.xhao@linux.alibaba.com/

Link: https://lkml.kernel.org/r/20211201150440.1088-10-sj@kernel.org
Signed-off-by: SeongJae Park <sj@kernel.org>
Cc: Brendan Higgins <brendanhiggins@google.com>
Cc: Shuah Khan <shuah@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 tools/testing/selftests/damon/debugfs_attrs.sh |    2 ++
 1 file changed, 2 insertions(+)

--- a/tools/testing/selftests/damon/debugfs_attrs.sh~selftests-damon-test-wrong-damos-condition-ranges-input
+++ a/tools/testing/selftests/damon/debugfs_attrs.sh
@@ -77,6 +77,8 @@ test_write_succ "$file" "1 2 3 4 5 6 4 0
 test_write_fail "$file" "1 2
 3 4 5 6 3 0 0 0 1 2 3 1 100 3 2 1" "$orig_content" "multi lines"
 test_write_succ "$file" "" "$orig_content" "disabling"
+test_write_fail "$file" "2 1 2 1 10 1 3 10 1 1 1 1 1 1 1 1 2 3" \
+	"$orig_content" "wrong condition ranges"
 echo "$orig_content" > "$file"
 
 # Test target_ids file
_
