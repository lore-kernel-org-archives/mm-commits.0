Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2629BC61DA4
	for <mm-commits@archiver.kernel.org>; Fri,  3 Feb 2023 06:35:33 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231871AbjBCGfc (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 3 Feb 2023 01:35:32 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36224 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232054AbjBCGfZ (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 3 Feb 2023 01:35:25 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 854B855BD
        for <mm-commits@vger.kernel.org>; Thu,  2 Feb 2023 22:35:23 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 1F18661D9B
        for <mm-commits@vger.kernel.org>; Fri,  3 Feb 2023 06:35:23 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 75DA4C433D2;
        Fri,  3 Feb 2023 06:35:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1675406122;
        bh=0+khSoR4FdP7PPoV//ISoYgABVSDzG2jRXDHjRAAIeg=;
        h=Date:To:From:Subject:From;
        b=m+0tzkpnAGGx0g9hi8vBnhyaRcdRg0z3aov1U9FMbktoQcGIyPZBZ0xJEpko3UAll
         US/0SkSQMeO5JVOD4VBPWYDQUjQcv5VeI3X+qXgil9aiLykvlSJLxzK8xGMQ60HC+P
         29lXUv7weDPaCk4EFQgUqcQ8nWCf9wnoP771JqSw=
Date:   Thu, 02 Feb 2023 22:35:21 -0800
To:     mm-commits@vger.kernel.org, shuah@kernel.org, corbet@lwn.net,
        sj@kernel.org, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] selftests-damon-sysfs-hide-expected-write-failures.patch removed from -mm tree
Message-Id: <20230203063522.75DA4C433D2@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: selftests/damon/sysfs: hide expected write failures
has been removed from the -mm tree.  Its filename was
     selftests-damon-sysfs-hide-expected-write-failures.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: SeongJae Park <sj@kernel.org>
Subject: selftests/damon/sysfs: hide expected write failures
Date: Tue, 10 Jan 2023 19:03:59 +0000

DAMON selftests for sysfs (sysfs.sh) tests if some writes to DAMON sysfs
interface files fails as expected.  It makes the test results noisy with
the failure error message because it tests a number of such failures. 
Redirect the expected failure error messages to /dev/null to make the
results clean.

Link: https://lkml.kernel.org/r/20230110190400.119388-8-sj@kernel.org
Signed-off-by: SeongJae Park <sj@kernel.org>
Cc: Jonathan Corbet <corbet@lwn.net>
Cc: Shuah Khan <shuah@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---


--- a/tools/testing/selftests/damon/sysfs.sh~selftests-damon-sysfs-hide-expected-write-failures
+++ a/tools/testing/selftests/damon/sysfs.sh
@@ -24,7 +24,7 @@ ensure_write_fail()
 	content=$2
 	reason=$3
 
-	if echo "$content" > "$file"
+	if (echo "$content" > "$file") 2> /dev/null
 	then
 		echo "writing $content to $file succeed ($fail_reason)"
 		echo "expected failure because $reason"
_

Patches currently in -mm which might be from sj@kernel.org are

scripts-spelling-add-a-few-more-typos.patch

