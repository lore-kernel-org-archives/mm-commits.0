Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 76171C61DA4
	for <mm-commits@archiver.kernel.org>; Fri,  3 Feb 2023 06:35:41 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232124AbjBCGfk (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 3 Feb 2023 01:35:40 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36192 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232084AbjBCGfa (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 3 Feb 2023 01:35:30 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6E2962687A
        for <mm-commits@vger.kernel.org>; Thu,  2 Feb 2023 22:35:26 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id CFF4AB80966
        for <mm-commits@vger.kernel.org>; Fri,  3 Feb 2023 06:35:24 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7865DC433D2;
        Fri,  3 Feb 2023 06:35:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1675406123;
        bh=XXSqk4NLxqbbE+0rKNQClPlypPuTBYUJWlfGuEhdpNY=;
        h=Date:To:From:Subject:From;
        b=gDkRT+6lbhEm8iasm8Gb1zcUP/tECsH0Ht/satw8FiNwsmGdA60kSD/xmd3/qMM8j
         a0iq8g3ju4uXX8lNnt3ay4sK9oXq7vA82f6pXiUjFrnUibR4QLwxlGgbXZiC10lb5K
         gnPG9d8AdfPkjt1SLmC/V+mGXrClr1Aqeqw7Ux1I=
Date:   Thu, 02 Feb 2023 22:35:22 -0800
To:     mm-commits@vger.kernel.org, shuah@kernel.org, corbet@lwn.net,
        sj@kernel.org, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] selftests-damon-debugfs_rm_non_contexts-hide-expected-write-error-messages.patch removed from -mm tree
Message-Id: <20230203063523.7865DC433D2@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: selftests/damon/debugfs_rm_non_contexts: hide expected write error messages
has been removed from the -mm tree.  Its filename was
     selftests-damon-debugfs_rm_non_contexts-hide-expected-write-error-messages.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: SeongJae Park <sj@kernel.org>
Subject: selftests/damon/debugfs_rm_non_contexts: hide expected write error messages
Date: Tue, 10 Jan 2023 19:04:00 +0000

A selftest case for DAMON debugfs interface has a test for expected
failure.  To make the test output clean, hide the expected failure error
message.

Link: https://lkml.kernel.org/r/20230110190400.119388-9-sj@kernel.org
Signed-off-by: SeongJae Park <sj@kernel.org>
Cc: Jonathan Corbet <corbet@lwn.net>
Cc: Shuah Khan <shuah@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---


--- a/tools/testing/selftests/damon/debugfs_rm_non_contexts.sh~selftests-damon-debugfs_rm_non_contexts-hide-expected-write-error-messages
+++ a/tools/testing/selftests/damon/debugfs_rm_non_contexts.sh
@@ -10,7 +10,7 @@ dmesg -C
 
 for file in "$DBGFS/"*
 do
-	echo "$(basename "$f")" > "$DBGFS/rm_contexts"
+	(echo "$(basename "$f")" > "$DBGFS/rm_contexts") &> /dev/null
 	if dmesg | grep -q BUG
 	then
 		dmesg
_

Patches currently in -mm which might be from sj@kernel.org are

scripts-spelling-add-a-few-more-typos.patch

