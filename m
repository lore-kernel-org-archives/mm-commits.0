Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2B216C433EF
	for <mm-commits@archiver.kernel.org>; Fri, 10 Dec 2021 22:46:58 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344870AbhLJWuc (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 10 Dec 2021 17:50:32 -0500
Received: from sin.source.kernel.org ([145.40.73.55]:57184 "EHLO
        sin.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344837AbhLJWu3 (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 10 Dec 2021 17:50:29 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 3B1DCCE2D93
        for <mm-commits@vger.kernel.org>; Fri, 10 Dec 2021 22:46:52 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 31AC3C00446;
        Fri, 10 Dec 2021 22:46:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1639176410;
        bh=i3iVDPV89gphsAABrhY9Ycqi2ruK+fz+sfEkcrmmibo=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=ci0sz+TOKXsLH0tr4ls8q8JvbsWau+Vk+3/0dzE0+hOoMNCRsn8BJRj2N+PM7B+xd
         f0QGM1CjHwwPQnTH+lC/oF5N/ne0wT/rArzGhtPyF74GVksV1d5hijJe7fBPArVF0h
         lP9bl3d0bmfvvkm+Ff+8GmOB8GgKLIHiZprpxVJk=
Date:   Fri, 10 Dec 2021 14:46:49 -0800
From:   Andrew Morton <akpm@linux-foundation.org>
To:     akpm@linux-foundation.org, brendanhiggins@google.com,
        linux-mm@kvack.org, mm-commits@vger.kernel.org, shuah@kernel.org,
        sj@kernel.org, torvalds@linux-foundation.org
Subject:  [patch 14/21] selftests/damon: test DAMON enabling with
 empty target_ids case
Message-ID: <20211210224649.ZcRmEwxc7%akpm@linux-foundation.org>
In-Reply-To: <20211210144539.663efee2c80d8450e6180230@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

From: SeongJae Park <sj@kernel.org>
Subject: selftests/damon: test DAMON enabling with empty target_ids case

DAMON debugfs didn't check empty targets when starting monitoring, and the
issue is fixed with commit b5ca3e83ddb0 ("mm/damon/dbgfs: add
adaptive_targets list check before enable monitor_on").  To avoid future
regression, this commit adds a test case for that in DAMON selftests.

Link: https://lkml.kernel.org/r/20211201150440.1088-9-sj@kernel.org
Signed-off-by: SeongJae Park <sj@kernel.org>
Cc: Brendan Higgins <brendanhiggins@google.com>
Cc: Shuah Khan <shuah@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 tools/testing/selftests/damon/debugfs_attrs.sh |    9 +++++++++
 1 file changed, 9 insertions(+)

--- a/tools/testing/selftests/damon/debugfs_attrs.sh~selftests-damon-test-damon-enabling-with-empty-target_ids-case
+++ a/tools/testing/selftests/damon/debugfs_attrs.sh
@@ -94,4 +94,13 @@ test_write_succ "$file" "" "$orig_conten
 test_content "$file" "$orig_content" "" "empty input written"
 echo "$orig_content" > "$file"
 
+# Test empty targets case
+# =======================
+
+orig_target_ids=$(cat "$DBGFS/target_ids")
+echo "" > "$DBGFS/target_ids"
+orig_monitor_on=$(cat "$DBGFS/monitor_on")
+test_write_fail "$DBGFS/monitor_on" "on" "orig_monitor_on" "empty target ids"
+echo "$orig_target_ids" > "$DBGFS/target_ids"
+
 echo "PASS"
_
