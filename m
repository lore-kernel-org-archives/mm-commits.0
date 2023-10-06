Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1994BE94104
	for <mm-commits@archiver.kernel.org>; Fri,  6 Oct 2023 19:20:20 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233461AbjJFTUS (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 6 Oct 2023 15:20:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57594 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233383AbjJFTUP (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 6 Oct 2023 15:20:15 -0400
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D00FADF
        for <mm-commits@vger.kernel.org>; Fri,  6 Oct 2023 12:20:08 -0700 (PDT)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2CA1DC433C7;
        Fri,  6 Oct 2023 19:20:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1696620008;
        bh=cBlO01avtgM/wfUA0SAu3jDceHtZ6dED67JSxzBYMgw=;
        h=Date:To:From:Subject:From;
        b=m5fMGYvvl+/qS2Jocq2ehQtsHStpyIkb3cvgf+XBGqKbMTHfZYHpJvbBIYoxVgRUt
         k0ujGbcjC0jA5TXb7zG9bEN3QlQHUkpyDBvcY/nVXBKeD5q6wKpAlJqpd6zZo1DsMI
         k3XvLHj20NJhyaHd7byYE6SyzADpdQ9WVWbenOTg=
Date:   Fri, 06 Oct 2023 12:20:06 -0700
To:     mm-commits@vger.kernel.org, sj@kernel.org, shuah@kernel.org,
        juntong.deng@outlook.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + selftests-damon-add-executable-permission-to-test-scripts.patch added to mm-unstable branch
Message-Id: <20231006192008.2CA1DC433C7@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: selftests/damon: add executable permission to test scripts
has been added to the -mm mm-unstable branch.  Its filename is
     selftests-damon-add-executable-permission-to-test-scripts.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/selftests-damon-add-executable-permission-to-test-scripts.patch

This patch will later appear in the mm-unstable branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next via the mm-everything
branch at git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
and is updated there every 2-3 working days

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

selftests-damon-add-executable-permission-to-test-scripts.patch

