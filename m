Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6CBD1C4321E
	for <mm-commits@archiver.kernel.org>; Thu,  1 Dec 2022 21:57:13 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230464AbiLAV5M (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 1 Dec 2022 16:57:12 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45616 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230256AbiLAV5G (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 1 Dec 2022 16:57:06 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 07D41C3FC2
        for <mm-commits@vger.kernel.org>; Thu,  1 Dec 2022 13:56:56 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id BE66BB81FC9
        for <mm-commits@vger.kernel.org>; Thu,  1 Dec 2022 21:56:12 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 766FDC433C1;
        Thu,  1 Dec 2022 21:56:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1669931771;
        bh=0V0qcXdQmgg7hniLTrUwAh/NU7SYXcaraFZI7HWdmHE=;
        h=Date:To:From:Subject:From;
        b=xUStz7fvkplIHEI58AjIYiNvB+PnDrb/uOcc2Qq2BbILCR4S8Cxa5fzXcq2vYoMAr
         ZIKFrmW02F1U8chVq7PGcMSd3h+gEV5S0RTuCQUxbKGaorp1VUpWJIMLsACORi6UQY
         HOlMIwHqNwc5A7A5Lpn87QVwOs7RrLGEOidAPDn4=
Date:   Thu, 01 Dec 2022 13:56:10 -0800
To:     mm-commits@vger.kernel.org, shuah@kernel.org, sj@kernel.org,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + selftests-damon-test-removed-scheme-sysfs-dir-access-bug.patch added to mm-unstable branch
Message-Id: <20221201215611.766FDC433C1@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: selftests/damon: test removed scheme sysfs dir access bug
has been added to the -mm mm-unstable branch.  Its filename is
     selftests-damon-test-removed-scheme-sysfs-dir-access-bug.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/selftests-damon-test-removed-scheme-sysfs-dir-access-bug.patch

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
From: SeongJae Park <sj@kernel.org>
Subject: selftests/damon: test removed scheme sysfs dir access bug
Date: Thu, 1 Dec 2022 17:08:34 +0000

A DAMON sysfs user could start DAMON with a scheme, remove the sysfs
directory for the scheme, and then ask stats or schemes tried regions
update.  The related logic were not aware of the already removed directory
situation, so it was able to results in invalid memory accesses.  The fix
has made with commit 8468b486612c ("mm/damon/sysfs-schemes: skip stats
update if the scheme directory is removed"), though.  Add a selftest to
avoid such kind of bugs be introduced again.

Link: https://lkml.kernel.org/r/20221201170834.62823-1-sj@kernel.org
Signed-off-by: SeongJae Park <sj@kernel.org>
Cc: Shuah Khan <shuah@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 tools/testing/selftests/damon/Makefile                           |    2 
 tools/testing/selftests/damon/sysfs_update_removed_scheme_dir.sh |   58 ++++++++++
 2 files changed, 59 insertions(+), 1 deletion(-)

--- a/tools/testing/selftests/damon/Makefile~selftests-damon-test-removed-scheme-sysfs-dir-access-bug
+++ a/tools/testing/selftests/damon/Makefile
@@ -8,7 +8,7 @@ TEST_PROGS = debugfs_attrs.sh debugfs_sc
 TEST_PROGS += debugfs_empty_targets.sh debugfs_huge_count_read_write.sh
 TEST_PROGS += debugfs_duplicate_context_creation.sh
 TEST_PROGS += debugfs_rm_non_contexts.sh
-TEST_PROGS += sysfs.sh
+TEST_PROGS += sysfs.sh sysfs_update_removed_scheme_dir.sh
 TEST_PROGS += reclaim.sh lru_sort.sh
 
 include ../lib.mk
--- /dev/null
+++ a/tools/testing/selftests/damon/sysfs_update_removed_scheme_dir.sh
@@ -0,0 +1,58 @@
+#!/bin/bash
+# SPDX-License-Identifier: GPL-2.0
+
+# Kselftest framework requirement - SKIP code is 4.
+ksft_skip=4
+
+if [ $EUID -ne 0 ]
+then
+	echo "Run as root"
+	exit $ksft_skip
+fi
+
+damon_sysfs="/sys/kernel/mm/damon/admin"
+if [ ! -d "$damon_sysfs" ]
+then
+	echo "damon sysfs not found"
+	exit $ksft_skip
+fi
+
+# clear log
+dmesg -C
+
+# start DAMON with a scheme
+echo 1 > "$damon_sysfs/kdamonds/nr_kdamonds"
+echo 1 > "$damon_sysfs/kdamonds/0/contexts/nr_contexts"
+echo "vaddr" > "$damon_sysfs/kdamonds/0/contexts/0/operations"
+echo 1 > "$damon_sysfs/kdamonds/0/contexts/0/targets/nr_targets"
+echo $$ > "$damon_sysfs/kdamonds/0/contexts/0/targets/0/pid_target"
+echo 1 > "$damon_sysfs/kdamonds/0/contexts/0/schemes/nr_schemes"
+scheme_dir="$damon_sysfs/kdamonds/0/contexts/0/schemes/0"
+echo 4096000 > "$scheme_dir/access_pattern/sz/max"
+echo 20 > "$scheme_dir/access_pattern/nr_accesses/max"
+echo 1024 > "$scheme_dir/access_pattern/age/max"
+echo "on" > "$damon_sysfs/kdamonds/0/state"
+sleep 0.3
+
+# remove scheme sysfs dir
+echo 0 > "$damon_sysfs/kdamonds/0/contexts/0/schemes/nr_schemes"
+
+# try to update stat of already removed scheme sysfs dir
+echo "update_schemes_stats" > "$damon_sysfs/kdamonds/0/state"
+if dmesg | grep -q BUG
+then
+	echo "update_schemes_stats triggers a kernel bug"
+	dmesg
+	exit 1
+fi
+
+# try to update tried regions of already removed scheme sysfs dir
+echo "update_schemes_tried_regions" > "$damon_sysfs/kdamonds/0/state"
+if dmesg | grep -q BUG
+then
+	echo "update_schemes_tried_regions triggers a kernel bug"
+	dmesg
+	exit 1
+fi
+
+echo "off" > "$damon_sysfs/kdamonds/0/state"
_

Patches currently in -mm which might be from sj@kernel.org are

selftests-damon-test-removed-scheme-sysfs-dir-access-bug.patch

