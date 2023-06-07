Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B1B4EC77B7A
	for <mm-commits@archiver.kernel.org>; Wed,  7 Jun 2023 02:37:29 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240764AbjFGCh2 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 6 Jun 2023 22:37:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50206 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240765AbjFGCh0 (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 6 Jun 2023 22:37:26 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9B788173B
        for <mm-commits@vger.kernel.org>; Tue,  6 Jun 2023 19:37:24 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 38AEA639DA
        for <mm-commits@vger.kernel.org>; Wed,  7 Jun 2023 02:37:24 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8C6FAC433EF;
        Wed,  7 Jun 2023 02:37:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1686105443;
        bh=q+ysixeWAIiVQ4sE3PdC/CjV7drp0d7mj7Zxh5omv4M=;
        h=Date:To:From:Subject:From;
        b=J3RrJxxN3KgCXZmY8q/d3+GKGX/JS9wVjnEFE8us3nptajc4lNKMTnTk7loxdb2jB
         I92BVHo1wK43Pc89qVn6x2o2+/aLmefaeVfR5HCH0VsoEniQ1AmlMLd6qfh5JDa6fD
         P5tP0pPyu/mtOKRVVXay+4h9Xre2XctCanJNyVY0=
Date:   Tue, 06 Jun 2023 19:37:22 -0700
To:     mm-commits@vger.kernel.org, usama.anjum@collabora.com,
        shuah@kernel.org, peterx@redhat.com, nathan@kernel.org,
        david@redhat.com, corbet@lwn.net, jhubbard@nvidia.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + selftests-mm-fix-invocation-of-tests-that-are-run-via-shell-scripts.patch added to mm-unstable branch
Message-Id: <20230607023723.8C6FAC433EF@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: selftests/mm: fix invocation of tests that are run via shell scripts
has been added to the -mm mm-unstable branch.  Its filename is
     selftests-mm-fix-invocation-of-tests-that-are-run-via-shell-scripts.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/selftests-mm-fix-invocation-of-tests-that-are-run-via-shell-scripts.patch

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
From: John Hubbard <jhubbard@nvidia.com>
Subject: selftests/mm: fix invocation of tests that are run via shell scripts
Date: Tue, 6 Jun 2023 00:16:30 -0700

We cannot depend upon git to reliably retain the executable bit on shell
scripts, or so I was told several years ago while working on this same
run_vmtests.sh script. And sure enough, things such as test_hmm.sh are
lately failing to run, due to lacking execute permissions.

Fix this by explicitly adding "bash" to each of the shell script
invocations. Leave fixing the overall approach to another day.

Link: https://lkml.kernel.org/r/20230606071637.267103-5-jhubbard@nvidia.com
Signed-off-by: John Hubbard <jhubbard@nvidia.com>
Acked-by: David Hildenbrand <david@redhat.com>
Tested-by: Muhammad Usama Anjum <usama.anjum@collabora.com>
Cc: Peter Xu <peterx@redhat.com>
Cc: Jonathan Corbet <corbet@lwn.net>
Cc: Nathan Chancellor <nathan@kernel.org>
Cc: Shuah Khan <shuah@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 tools/testing/selftests/mm/run_vmtests.sh |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

--- a/tools/testing/selftests/mm/run_vmtests.sh~selftests-mm-fix-invocation-of-tests-that-are-run-via-shell-scripts
+++ a/tools/testing/selftests/mm/run_vmtests.sh
@@ -244,18 +244,18 @@ if [ $VADDR64 -ne 0 ]; then
 	if [ "$ARCH" == "$ARCH_ARM64" ]; then
 		echo 6 > /proc/sys/vm/nr_hugepages
 	fi
-	CATEGORY="hugevm" run_test ./va_high_addr_switch.sh
+	CATEGORY="hugevm" run_test bash ./va_high_addr_switch.sh
 	if [ "$ARCH" == "$ARCH_ARM64" ]; then
 		echo $prev_nr_hugepages > /proc/sys/vm/nr_hugepages
 	fi
 fi # VADDR64
 
 # vmalloc stability smoke test
-CATEGORY="vmalloc" run_test ./test_vmalloc.sh smoke
+CATEGORY="vmalloc" run_test bash ./test_vmalloc.sh smoke
 
 CATEGORY="mremap" run_test ./mremap_dontunmap
 
-CATEGORY="hmm" run_test ./test_hmm.sh smoke
+CATEGORY="hmm" run_test bash ./test_hmm.sh smoke
 
 # MADV_POPULATE_READ and MADV_POPULATE_WRITE tests
 CATEGORY="madv_populate" run_test ./madv_populate
_

Patches currently in -mm which might be from jhubbard@nvidia.com are

selftests-mm-fix-uffd-stress-unused-function-warning.patch
selftests-mm-fix-unused-variable-warnings-in-hugetlb-madvisec-migrationc.patch
selftests-mm-fix-warning-expression-which-evaluates-to-zero-in-mlock2-testsc.patch
selftests-mm-fix-invocation-of-tests-that-are-run-via-shell-scripts.patch
selftests-mm-gitignore-add-mkdirty-va_high_addr_switch.patch
selftests-mm-fix-two-wformat-security-warnings-in-uffd-builds.patch
selftests-mm-fix-a-possibly-uninitialized-warning-in-pkey-x86h.patch
selftests-mm-fix-build-failures-due-to-missing-madv_collapse.patch
selftests-mm-move-certain-uffd-routines-from-vm_utilc-to-uffd-commonc.patch
documentation-kselftest-make-headers-is-a-prerequisite.patch
selftests-error-out-if-kernel-header-files-are-not-yet-built.patch
selftests-error-out-if-kernel-header-files-are-not-yet-built-fix.patch

