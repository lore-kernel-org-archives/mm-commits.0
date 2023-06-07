Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DA029C7EE37
	for <mm-commits@archiver.kernel.org>; Wed,  7 Jun 2023 02:37:27 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240766AbjFGCh0 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 6 Jun 2023 22:37:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50198 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240764AbjFGChX (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 6 Jun 2023 22:37:23 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B266FE78
        for <mm-commits@vger.kernel.org>; Tue,  6 Jun 2023 19:37:22 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 4ECC2639D9
        for <mm-commits@vger.kernel.org>; Wed,  7 Jun 2023 02:37:22 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9DCECC433EF;
        Wed,  7 Jun 2023 02:37:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1686105441;
        bh=QPVitCzSYnimZTLeqkWMvkhK4aebxvbOHzVlc0K268w=;
        h=Date:To:From:Subject:From;
        b=QSIpGG3C+DbgkBYomt31779TCBFnHtn6OVYCWv52Psu1ubYgMzPcPW6AAFhx0HwQZ
         M7NcdfSMshG/M3Yh5p6Es8fWdohhYYwZ8Gue9ucNP1zepSkp9sFfltBpnxjtceHHzz
         dSnABxy1CqlPAWIWGHxjOX0bAJ9zf3GBS3Kw/73I=
Date:   Tue, 06 Jun 2023 19:37:20 -0700
To:     mm-commits@vger.kernel.org, usama.anjum@collabora.com,
        shuah@kernel.org, peterx@redhat.com, nathan@kernel.org,
        david@redhat.com, corbet@lwn.net, jhubbard@nvidia.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + selftests-mm-fix-warning-expression-which-evaluates-to-zero-in-mlock2-testsc.patch added to mm-unstable branch
Message-Id: <20230607023721.9DCECC433EF@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: selftests/mm: fix "warning: expression which evaluates to zero..." in mlock2-tests.c
has been added to the -mm mm-unstable branch.  Its filename is
     selftests-mm-fix-warning-expression-which-evaluates-to-zero-in-mlock2-testsc.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/selftests-mm-fix-warning-expression-which-evaluates-to-zero-in-mlock2-testsc.patch

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
Subject: selftests/mm: fix "warning: expression which evaluates to zero..." in mlock2-tests.c
Date: Tue, 6 Jun 2023 00:16:29 -0700

The stop variable is a char*, and the code was assigning a char value to
it. This was generating a warning when compiling with clang.

However, as both David and Peter pointed out, stop is not even used
after the problematic assignment to a char type. So just delete that
line entirely.

Link: https://lkml.kernel.org/r/20230606071637.267103-4-jhubbard@nvidia.com
Signed-off-by: John Hubbard <jhubbard@nvidia.com>
Reviewed-by: David Hildenbrand <david@redhat.com>
Reviewed-by: Peter Xu <peterx@redhat.com>
Tested-by: Muhammad Usama Anjum <usama.anjum@collabora.com>
Cc: Jonathan Corbet <corbet@lwn.net>
Cc: Nathan Chancellor <nathan@kernel.org>
Cc: Shuah Khan <shuah@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 tools/testing/selftests/mm/mlock2-tests.c |    1 -
 1 file changed, 1 deletion(-)

--- a/tools/testing/selftests/mm/mlock2-tests.c~selftests-mm-fix-warning-expression-which-evaluates-to-zero-in-mlock2-testsc
+++ a/tools/testing/selftests/mm/mlock2-tests.c
@@ -50,7 +50,6 @@ static int get_vm_area(unsigned long add
 			printf("cannot parse /proc/self/maps\n");
 			goto out;
 		}
-		stop = '\0';
 
 		sscanf(line, "%lx", &start);
 		sscanf(end_addr, "%lx", &end);
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

