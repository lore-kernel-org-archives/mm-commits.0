Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 91C1CC4332F
	for <mm-commits@archiver.kernel.org>; Mon,  7 Nov 2022 20:08:37 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232682AbiKGUIf (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 7 Nov 2022 15:08:35 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47868 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232474AbiKGUId (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 7 Nov 2022 15:08:33 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5C33C62E6
        for <mm-commits@vger.kernel.org>; Mon,  7 Nov 2022 12:08:30 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 845D2612B7
        for <mm-commits@vger.kernel.org>; Mon,  7 Nov 2022 20:08:30 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DE084C433C1;
        Mon,  7 Nov 2022 20:08:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1667851710;
        bh=nbygQl/PG7NVQD0VagUfcjhAECfH/yxN193s3fDhkbQ=;
        h=Date:To:From:Subject:From;
        b=dNXmT3vnQCm66VBMlR9wuwImz6cEq/1OKRwtBWb/7j3orbBQ7tZTjGc9X204hx/k5
         rRUdotY8ezw7r3sAC3lq/ll5R99kadGdsWAH2LqEWE4YFGvbKVd7VnXypnpJJIqxyM
         ZMcbPB5DzXI0VHkyeEx/pO/a9V2V6EFknNuhMgK0=
Date:   Mon, 07 Nov 2022 12:08:29 -0800
To:     mm-commits@vger.kernel.org, sj@kernel.org,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + selftests-damon-test-non-context-inputs-to-rm_contexts-file.patch added to mm-unstable branch
Message-Id: <20221107200829.DE084C433C1@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: selftests/damon: test non-context inputs to rm_contexts file
has been added to the -mm mm-unstable branch.  Its filename is
     selftests-damon-test-non-context-inputs-to-rm_contexts-file.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/selftests-damon-test-non-context-inputs-to-rm_contexts-file.patch

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
Subject: selftests/damon: test non-context inputs to rm_contexts file
Date: Mon, 7 Nov 2022 16:50:01 +0000

There was a bug[1] that triggered by writing non-context DAMON debugfs
file names to the 'rm_contexts' DAMON debugfs file.  Add a selftest for
the bug to avoid it happen again.

[1] https://lore.kernel.org/damon/000000000000ede3ac05ec4abf8e@google.com/

Link: https://lkml.kernel.org/r/20221107165001.5717-3-sj@kernel.org
Signed-off-by: SeongJae Park <sj@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 tools/testing/selftests/damon/Makefile                   |    1 
 tools/testing/selftests/damon/debugfs_rm_non_contexts.sh |   19 ++++++++++
 2 files changed, 20 insertions(+)

--- /dev/null
+++ a/tools/testing/selftests/damon/debugfs_rm_non_contexts.sh
@@ -0,0 +1,19 @@
+#!/bin/bash
+# SPDX-License-Identifier: GPL-2.0
+
+source _debugfs_common.sh
+
+# Test putting non-ctx files/dirs to rm_contexts file
+# ===================================================
+
+dmesg -C
+
+for file in "$DBGFS/"*
+do
+	echo "$(basename "$f")" > "$DBGFS/rm_contexts"
+	if dmesg | grep -q BUG
+	then
+		dmesg
+		exit 1
+	fi
+done
--- a/tools/testing/selftests/damon/Makefile~selftests-damon-test-non-context-inputs-to-rm_contexts-file
+++ a/tools/testing/selftests/damon/Makefile
@@ -7,6 +7,7 @@ TEST_FILES = _chk_dependency.sh _debugfs
 TEST_PROGS = debugfs_attrs.sh debugfs_schemes.sh debugfs_target_ids.sh
 TEST_PROGS += debugfs_empty_targets.sh debugfs_huge_count_read_write.sh
 TEST_PROGS += debugfs_duplicate_context_creation.sh
+TEST_PROGS += debugfs_rm_non_contexts.sh
 TEST_PROGS += sysfs.sh
 TEST_PROGS += reclaim.sh lru_sort.sh
 
_

Patches currently in -mm which might be from sj@kernel.org are

mm-damon-dbgfs-check-if-rm_contexts-input-is-for-a-real-context.patch
mm-damon-core-split-out-damos-charged-region-skip-logic-into-a-new-function.patch
mm-damon-core-split-damos-application-logic-into-a-new-function.patch
mm-damon-core-split-out-scheme-stat-update-logic-into-a-new-function.patch
mm-damon-core-split-out-scheme-quota-adjustment-logic-into-a-new-function.patch
mm-damon-sysfs-use-damon_addr_range-for-regions-start-and-end-values.patch
mm-damon-sysfs-remove-parameters-of-damon_sysfs_region_alloc.patch
mm-damon-sysfs-move-sysfs_lock-to-common-module.patch
mm-damon-sysfs-move-unsigned-long-range-directory-to-common-module.patch
mm-damon-sysfs-split-out-kdamond-independent-schemes-stats-update-logic-into-a-new-function.patch
mm-damon-sysfs-split-out-schemes-directory-implementation-to-separate-file.patch
mm-damon-modules-deduplicate-init-steps-for-damon-context-setup.patch
mm-damon-reclaimlru_sort-remove-unnecessarily-included-headers.patch
mm-damon-reclaim-enable-and-disable-synchronously.patch
selftests-damon-add-tests-for-damon_reclaims-enabled-parameter.patch
mm-damon-lru_sort-enable-and-disable-synchronously.patch
selftests-damon-add-tests-for-damon_lru_sorts-enabled-parameter.patch
docs-admin-guide-mm-damon-usage-describe-the-rules-of-sysfs-region-directories.patch
docs-admin-guide-mm-damon-usage-fix-wrong-usage-example-of-init_regions-file.patch
mm-damon-core-add-a-callback-for-scheme-target-regions-check.patch
mm-damon-sysfs-schemes-implement-schemes-tried_regions-directory.patch
mm-damon-sysfs-schemes-implement-scheme-region-directory.patch
mm-damon-sysfs-implement-damos-tried-regions-update-command.patch
mm-damon-sysfs-schemes-implement-damos-tried-regions-clear-command.patch
tools-selftets-damon-sysfs-test-tried_regions-directory-existence.patch
docs-admin-guide-mm-damon-usage-document-schemes-s-tried_regions-sysfs-directory.patch
docs-abi-damon-document-schemes-s-tried_regions-sysfs-directory.patch
selftests-damon-test-non-context-inputs-to-rm_contexts-file.patch

