Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id ACA6FE936E2
	for <mm-commits@archiver.kernel.org>; Wed,  4 Oct 2023 20:23:15 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244639AbjJDUXQ (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 4 Oct 2023 16:23:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59028 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244664AbjJDUWs (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 4 Oct 2023 16:22:48 -0400
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6DD8310A
        for <mm-commits@vger.kernel.org>; Wed,  4 Oct 2023 13:22:44 -0700 (PDT)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CA004C433C7;
        Wed,  4 Oct 2023 20:22:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1696450964;
        bh=GtuTmBKNjWqD9Z6502nbHpheIb2hNoU73YpEFQLdTII=;
        h=Date:To:From:Subject:From;
        b=hHK6yj8OBSC14aFBsc4YIomBu6vZX+0Dedw+4hzsE0IFuxqlSS1cT1UqpqAqamY0R
         0Huh/nZMQ4q3sXxo8XaUmSohcCyV5wPGfyBMZnWcUDAiQwJujcBmjchyIN/SC1vNpr
         TjwEjvBRqfM55ypNQn3cWcukygDIiIi7xD52msWc=
Date:   Wed, 04 Oct 2023 13:22:42 -0700
To:     mm-commits@vger.kernel.org, shuah@kernel.org, rostedt@goodmis.org,
        corbet@lwn.net, sj@kernel.org, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] selftests-damon-sysfs-test-damos-apply-intervals.patch removed from -mm tree
Message-Id: <20231004202243.CA004C433C7@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: selftests/damon/sysfs: test DAMOS apply intervals
has been removed from the -mm tree.  Its filename was
     selftests-damon-sysfs-test-damos-apply-intervals.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: SeongJae Park <sj@kernel.org>
Subject: selftests/damon/sysfs: test DAMOS apply intervals
Date: Sat, 16 Sep 2023 02:09:43 +0000

Update DAMON selftests to test existence of the file for reading/writing
DAMOS apply interval under each scheme directory.

Link: https://lkml.kernel.org/r/20230916020945.47296-8-sj@kernel.org
Signed-off-by: SeongJae Park <sj@kernel.org>
Cc: Jonathan Corbet <corbet@lwn.net>
Cc: Shuah Khan <shuah@kernel.org>
Cc: Steven Rostedt (Google) <rostedt@goodmis.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 tools/testing/selftests/damon/sysfs.sh |    1 +
 1 file changed, 1 insertion(+)

--- a/tools/testing/selftests/damon/sysfs.sh~selftests-damon-sysfs-test-damos-apply-intervals
+++ a/tools/testing/selftests/damon/sysfs.sh
@@ -175,6 +175,7 @@ test_scheme()
 	ensure_dir "$scheme_dir" "exist"
 	ensure_file "$scheme_dir/action" "exist" "600"
 	test_access_pattern "$scheme_dir/access_pattern"
+	ensure_file "$scheme_dir/apply_interval_us" "exist" "600"
 	test_quotas "$scheme_dir/quotas"
 	test_watermarks "$scheme_dir/watermarks"
 	test_filters "$scheme_dir/filters"
_

Patches currently in -mm which might be from sj@kernel.org are


