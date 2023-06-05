Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 443A3C7EE2A
	for <mm-commits@archiver.kernel.org>; Mon,  5 Jun 2023 22:44:44 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231929AbjFEWon (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 5 Jun 2023 18:44:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40288 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232254AbjFEWoi (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 5 Jun 2023 18:44:38 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 740B3102
        for <mm-commits@vger.kernel.org>; Mon,  5 Jun 2023 15:44:37 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id F1B4B62B78
        for <mm-commits@vger.kernel.org>; Mon,  5 Jun 2023 22:44:36 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 33F1AC433A0;
        Mon,  5 Jun 2023 22:44:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1686005076;
        bh=d0G+Xsh+IyxbFoq7dfGiTfyVOXa3eCkNtpaRpLvfkuc=;
        h=Date:To:From:Subject:From;
        b=TB/aFLMFPWljieLLkkbeFDAHbqRLdmY1Oa9aAKqm+du7WNYuC3+sbyU4t01klVdom
         giJtnXe0D97Jys45UF9TlCJnEkQi6CitBfQdnTlekXt0NBORzNVijfRcy5XPa2ct/V
         6Nov1h8Db7+EhDMd8PXwehvpKVT79dNi3HlNGPCs=
Date:   Mon, 05 Jun 2023 15:44:35 -0700
To:     mm-commits@vger.kernel.org, usama.anjum@collabora.com,
        shuah@kernel.org, peterx@redhat.com, nathan@kernel.org,
        david@redhat.com, corbet@lwn.net, jhubbard@nvidia.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + selftests-mm-fix-invocation-of-tests-that-are-run-via-shell-scripts.patch added to mm-unstable branch
Message-Id: <20230605224436.33F1AC433A0@smtp.kernel.org>
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
Date: Fri, 2 Jun 2023 19:15:51 -0700

We cannot depend upon git to reliably retain the executable bit on shell
scripts, or so I was told several years ago while working on this same
run_vmtests.sh script. And sure enough, things such as test_hmm.sh are
lately failing to run, due to lacking execute permissions.

Fix this by explicitly adding "bash" to each of the shell script
invocations. Leave fixing the overall approach to another day.

Link: https://lkml.kernel.org/r/20230603021558.95299-5-jhubbard@nvidia.com
Signed-off-by: John Hubbard <jhubbard@nvidia.com>
Acked-by: David Hildenbrand <david@redhat.com>
Cc: Peter Xu <peterx@redhat.com>
Cc: Jonathan Corbet <corbet@lwn.net>
Cc: Muhammad Usama Anjum <usama.anjum@collabora.com>
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
selftests-mm-fix-uffd-unit-testsc-build-failure-due-to-missing-madv_collapse.patch
selftests-mm-move-psize-pshift-into-vm_utilsc.patch
selftests-mm-move-uffd-routines-from-vm_utilc-to-uffd-commonc.patch
documentation-kselftest-make-headers-is-a-prerequisite.patch
selftests-error-out-if-kernel-header-files-are-not-yet-built.patch

