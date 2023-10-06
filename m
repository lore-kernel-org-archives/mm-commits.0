Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BCD6AE94104
	for <mm-commits@archiver.kernel.org>; Fri,  6 Oct 2023 19:20:31 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233497AbjJFTUa (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 6 Oct 2023 15:20:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57736 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233371AbjJFTUP (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 6 Oct 2023 15:20:15 -0400
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2ED3DF1
        for <mm-commits@vger.kernel.org>; Fri,  6 Oct 2023 12:20:12 -0700 (PDT)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4858EC433C8;
        Fri,  6 Oct 2023 19:20:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1696620011;
        bh=05wMFN4dYESxlFwjdGEVXDqgTmW7eEZ+dAp/wXUW5cU=;
        h=Date:To:From:Subject:From;
        b=AhNHHWBkC7poNcPcs8bFcnqD0yBKPzYosJ6VEY1LFA1fjO2dmvmdtwRFpTfcL6fcj
         K5KjsM/cl9R2Mm0G0lV7PIzXjJudmOJDG81bnbL/Z3ppbpdMikEOyVBme0jsLqd558
         HfNLNXq0YXMAZzbvfa2oFvM0s6riGnO47TA4UFZI=
Date:   Fri, 06 Oct 2023 12:20:08 -0700
To:     mm-commits@vger.kernel.org, sj@kernel.org, shuah@kernel.org,
        juntong.deng@outlook.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] selftests-damon-add-executable-permission-to-test-scripts.patch removed from -mm tree
Message-Id: <20231006192011.4858EC433C8@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: selftests/damon: add executable permission to test scripts
has been removed from the -mm tree.  Its filename was
     selftests-damon-add-executable-permission-to-test-scripts.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Juntong Deng <juntong.deng@outlook.com>
Subject: selftests/damon: add executable permission to test scripts
Date: Tue, 26 Sep 2023 04:35:52 +0800

When running the test for the damon subsystem, there are a lot of
warnings because test scripts do not have executable permission,
for example:

Warning: file debugfs_attrs.sh is not executable
Warning: file debugfs_schemes.sh is not executable
Warning: file debugfs_target_ids.sh is not executable
...

This patch adds executable permission to test scripts to eliminate
these warnings.

Link: https://lkml.kernel.org/r/VI1P193MB07529234393616AE94D58C7B99FCA@VI1P193MB0752.EURP193.PROD.OUTLOOK.COM
Signed-off-by: Juntong Deng <juntong.deng@outlook.com>
Reviewed-by: SeongJae Park <sj@kernel.org>
Cc: Shuah Khan <shuah@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 tools/testing/selftests/damon/debugfs_attrs.sh                    | 0
 .../testing/selftests/damon/debugfs_duplicate_context_creation.sh | 0
 tools/testing/selftests/damon/debugfs_empty_targets.sh            | 0
 tools/testing/selftests/damon/debugfs_huge_count_read_write.sh    | 0
 tools/testing/selftests/damon/debugfs_rm_non_contexts.sh          | 0
 tools/testing/selftests/damon/debugfs_schemes.sh                  | 0
 tools/testing/selftests/damon/debugfs_target_ids.sh               | 0
 tools/testing/selftests/damon/lru_sort.sh                         | 0
 tools/testing/selftests/damon/reclaim.sh                          | 0
 tools/testing/selftests/damon/sysfs.sh                            | 0
 tools/testing/selftests/damon/sysfs_update_removed_scheme_dir.sh  | 0
 11 files changed, 0 insertions(+), 0 deletions(-)
 mode change 100644 => 100755 tools/testing/selftests/damon/debugfs_attrs.sh
 mode change 100644 => 100755 tools/testing/selftests/damon/debugfs_duplicate_context_creation.sh
 mode change 100644 => 100755 tools/testing/selftests/damon/debugfs_empty_targets.sh
 mode change 100644 => 100755 tools/testing/selftests/damon/debugfs_huge_count_read_write.sh
 mode change 100644 => 100755 tools/testing/selftests/damon/debugfs_rm_non_contexts.sh
 mode change 100644 => 100755 tools/testing/selftests/damon/debugfs_schemes.sh
 mode change 100644 => 100755 tools/testing/selftests/damon/debugfs_target_ids.sh
 mode change 100644 => 100755 tools/testing/selftests/damon/lru_sort.sh
 mode change 100644 => 100755 tools/testing/selftests/damon/reclaim.sh
 mode change 100644 => 100755 tools/testing/selftests/damon/sysfs.sh
 mode change 100644 => 100755 tools/testing/selftests/damon/sysfs_update_removed_scheme_dir.sh

diff --git a/tools/testing/selftests/damon/debugfs_attrs.sh b/tools/testing/selftests/damon/debugfs_attrs.sh
old mode 100644
new mode 100755
diff --git a/tools/testing/selftests/damon/debugfs_duplicate_context_creation.sh b/tools/testing/selftests/damon/debugfs_duplicate_context_creation.sh
old mode 100644
new mode 100755
diff --git a/tools/testing/selftests/damon/debugfs_empty_targets.sh b/tools/testing/selftests/damon/debugfs_empty_targets.sh
old mode 100644
new mode 100755
diff --git a/tools/testing/selftests/damon/debugfs_huge_count_read_write.sh b/tools/testing/selftests/damon/debugfs_huge_count_read_write.sh
old mode 100644
new mode 100755
diff --git a/tools/testing/selftests/damon/debugfs_rm_non_contexts.sh b/tools/testing/selftests/damon/debugfs_rm_non_contexts.sh
old mode 100644
new mode 100755
diff --git a/tools/testing/selftests/damon/debugfs_schemes.sh b/tools/testing/selftests/damon/debugfs_schemes.sh
old mode 100644
new mode 100755
diff --git a/tools/testing/selftests/damon/debugfs_target_ids.sh b/tools/testing/selftests/damon/debugfs_target_ids.sh
old mode 100644
new mode 100755
diff --git a/tools/testing/selftests/damon/lru_sort.sh b/tools/testing/selftests/damon/lru_sort.sh
old mode 100644
new mode 100755
diff --git a/tools/testing/selftests/damon/reclaim.sh b/tools/testing/selftests/damon/reclaim.sh
old mode 100644
new mode 100755
diff --git a/tools/testing/selftests/damon/sysfs.sh b/tools/testing/selftests/damon/sysfs.sh
old mode 100644
new mode 100755
diff --git a/tools/testing/selftests/damon/sysfs_update_removed_scheme_dir.sh b/tools/testing/selftests/damon/sysfs_update_removed_scheme_dir.sh
old mode 100644
new mode 100755


Patches currently in -mm which might be from juntong.deng@outlook.com are


