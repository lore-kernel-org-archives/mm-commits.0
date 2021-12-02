Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EFF75C4332F
	for <mm-commits@archiver.kernel.org>; Thu,  2 Dec 2021 03:42:36 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232490AbhLBDp5 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 1 Dec 2021 22:45:57 -0500
Received: from ams.source.kernel.org ([145.40.68.75]:44852 "EHLO
        ams.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1355232AbhLBDoR (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 1 Dec 2021 22:44:17 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 5AE69B8221D
        for <mm-commits@vger.kernel.org>; Thu,  2 Dec 2021 03:40:43 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DDEBEC53FCC;
        Thu,  2 Dec 2021 03:40:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1638416442;
        bh=2ljZ9k0nUYc2jEdqRiQ5NOis7Uy+Qe0WxIbcNAA/Nss=;
        h=Date:From:To:Subject:From;
        b=C9ZYDkh55fxKhxWC64cWG20wt+a4Fu1xWjtdnd905ge0v6J6fIFJHehb4wtfmgm5j
         crDTEK1wqSZRVhZi0iDJMYOwGB/s02bd58sTmtfc60pJ7EgmozkvdD7SflcYNLozAF
         DpazsirHIOgRyAzPsU8nbDUd8/0e7YMEMN8WAAm4=
Date:   Wed, 01 Dec 2021 19:40:41 -0800
From:   akpm@linux-foundation.org
To:     brendanhiggins@google.com, mm-commits@vger.kernel.org,
        shuah@kernel.org, sj@kernel.org
Subject:  +
 selftests-damon-test-wrong-damos-condition-ranges-input.patch added to -mm
 tree
Message-ID: <20211202034041.95_2UvKW-%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: selftests/damon: test wrong DAMOS condition ranges input
has been added to the -mm tree.  Its filename is
     selftests-damon-test-wrong-damos-condition-ranges-input.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/selftests-damon-test-wrong-damos-condition-ranges-input.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/selftests-damon-test-wrong-damos-condition-ranges-input.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
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

Patches currently in -mm which might be from sj@kernel.org are

timers-implement-usleep_idle_range.patch
mm-damon-core-fix-fake-load-reports-due-to-uninterruptible-sleeps.patch
mm-damon-core-use-better-timer-mechanisms-selection-threshold.patch
mm-damon-dbgfs-remove-an-unnecessary-error-message.patch
mm-damon-core-remove-unnecessary-error-messages.patch
mm-damon-vaddr-remove-an-unnecessary-warning-message.patch
mm-damon-vaddr-test-split-a-test-function-having-1024-bytes-frame-size.patch
mm-damon-vaddr-test-remove-unnecessary-variables.patch
selftests-damon-skip-test-if-damon-is-running.patch
selftests-damon-test-damon-enabling-with-empty-target_ids-case.patch
selftests-damon-test-wrong-damos-condition-ranges-input.patch
selftests-damon-test-debugfs-file-reads-writes-with-huge-count.patch
selftests-damon-split-test-cases.patch
mm-damon-remove-some-no-need-func-definitions-in-damonh-file-fix.patch

