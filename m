Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 33708EB64DD
	for <mm-commits@archiver.kernel.org>; Tue, 11 Jul 2023 19:21:10 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229983AbjGKTVJ (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 11 Jul 2023 15:21:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52110 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229512AbjGKTVI (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 11 Jul 2023 15:21:08 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E5C1410C2
        for <mm-commits@vger.kernel.org>; Tue, 11 Jul 2023 12:21:06 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 84641615BF
        for <mm-commits@vger.kernel.org>; Tue, 11 Jul 2023 19:21:06 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CEFC7C433C8;
        Tue, 11 Jul 2023 19:21:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1689103265;
        bh=ZZRWKwRS1rb0R1kRc9+oTEmsVHclsuU3INOebOK23lA=;
        h=Date:To:From:Subject:From;
        b=ZrLei6pdlMu/dwljHvi6jyqDLdJZcV2Y7B3tad8gxof6HfHHbtQvbDZYZptpPz46t
         /21RKvaiKSeqrKOp0mb8jcH6BXBJyDX5o+YNFfKm1Zt51AHaqcsITn0js5UtiB5sR5
         XQXX20nfXSHwbcSJ1FywNT/+XshV4HZzQ9wKSp1o=
Date:   Tue, 11 Jul 2023 12:21:05 -0700
To:     mm-commits@vger.kernel.org, usama.anjum@collabora.com,
        shuah@kernel.org, peterx@redhat.com, nathan@kernel.org,
        david@redhat.com, corbet@lwn.net, broonie@kernel.org,
        anders.roxell@linaro.org, jhubbard@nvidia.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + selftests-arm64-fix-build-failure-during-the-emit_tests-step.patch added to mm-hotfixes-unstable branch
Message-Id: <20230711192105.CEFC7C433C8@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: selftests/arm64: fix build failure during the "emit_tests" step
has been added to the -mm mm-hotfixes-unstable branch.  Its filename is
     selftests-arm64-fix-build-failure-during-the-emit_tests-step.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/selftests-arm64-fix-build-failure-during-the-emit_tests-step.patch

This patch will later appear in the mm-hotfixes-unstable branch at
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
Subject: selftests/arm64: fix build failure during the "emit_tests" step
Date: Mon, 10 Jul 2023 17:56:29 -0700

The build failure reported in [1] occurred because commit 9fc96c7c19df
("selftests: error out if kernel header files are not yet built") added a
new "kernel_header_files" dependency to "all", and that triggered another,
pre-existing problem.  Specifically, the arm64 selftests override the
emit_tests target, and that override improperly declares itself to depend
upon the "all" target.

This is a problem because the "emit_tests" target in lib.mk was not
intended to be overridden.  emit_tests is a very simple, sequential build
target that was originally invoked from the "install" target, which in
turn, depends upon "all".

That approach worked for years.  But with 9fc96c7c19df in place,
emit_tests failed, because it does not set up all of the elaborate things
that "install" does.  And that caused the new "kernel_header_files" target
(which depends upon $(KBUILD_OUTPUT) being correct) to fail.

Some detail: The "all" target is .PHONY.  Therefore, each target that
depends on "all" will cause it to be invoked again, and because
dependencies are managed quite loosely in the selftests Makefiles, many
things will run, even "all" is invoked several times in immediate
succession.  So this is not a "real" failure, as far as build steps go:
everything gets built, but "all" reports a problem when invoked a second
time from a bad environment.

To fix this, simply remove the unnecessary "all" dependency from the
overridden emit_tests target.  The dependency is still effectively
honored, because again, invocation is via "install", which also depends
upon "all".

An alternative approach would be to harden the emit_tests target so that
it can depend upon "all", but that's a lot more complicated and hard to
get right, and doesn't seem worth it, especially given that emit_tests
should probably not be overridden at all.

[1] https://lore.kernel.org/20230710-kselftest-fix-arm64-v1-1-48e872844f25@kernel.org

Link: https://lkml.kernel.org/r/20230711005629.2547838-1-jhubbard@nvidia.com
Fixes: 9fc96c7c19df ("selftests: error out if kernel header files are not yet built")
Signed-off-by: John Hubbard <jhubbard@nvidia.com>
Reported-by: Mark Brown <broonie@kernel.org>
Tested-by: Mark Brown <broonie@kernel.org>
Cc: Anders Roxell <anders.roxell@linaro.org>
Cc: David Hildenbrand <david@redhat.com>
Cc: Jonathan Corbet <corbet@lwn.net>
Cc: Muhammad Usama Anjum <usama.anjum@collabora.com>
Cc: Nathan Chancellor <nathan@kernel.org>
Cc: Peter Xu <peterx@redhat.com>
Cc: Shuah Khan <shuah@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 tools/testing/selftests/arm64/Makefile |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/tools/testing/selftests/arm64/Makefile~selftests-arm64-fix-build-failure-during-the-emit_tests-step
+++ a/tools/testing/selftests/arm64/Makefile
@@ -42,7 +42,7 @@ run_tests: all
 	done
 
 # Avoid any output on non arm64 on emit_tests
-emit_tests: all
+emit_tests:
 	@for DIR in $(ARM64_SUBTARGETS); do				\
 		BUILD_TARGET=$(OUTPUT)/$$DIR;			\
 		make OUTPUT=$$BUILD_TARGET -C $$DIR $@;		\
_

Patches currently in -mm which might be from jhubbard@nvidia.com are

selftests-arm64-fix-build-failure-during-the-emit_tests-step.patch

