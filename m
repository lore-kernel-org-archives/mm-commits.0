Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E0B22C433EF
	for <mm-commits@archiver.kernel.org>; Mon,  4 Jul 2022 22:45:02 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230327AbiGDWpC (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 4 Jul 2022 18:45:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42610 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229456AbiGDWpB (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 4 Jul 2022 18:45:01 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 40EEEB52
        for <mm-commits@vger.kernel.org>; Mon,  4 Jul 2022 15:45:01 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id D09926179E
        for <mm-commits@vger.kernel.org>; Mon,  4 Jul 2022 22:45:00 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 29C29C3411E;
        Mon,  4 Jul 2022 22:45:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1656974700;
        bh=dlnSFCOZnWAvHdk0MUddg4oeB2FJnJg1sC2/o97Pofo=;
        h=Date:To:From:Subject:From;
        b=ue/oUhPi5Pu29Rdt+bCFWWTwP80LhrtjX+slxtn7IWaxLW23ssFLg9f+32KFgC9pz
         g/zTq7oEw8t2zMDXl9buTNNiokIsITH59MelzInk2I8qMcru9a11UlHnfuS5jd5u7S
         1aKJAvbRd9qElkzyT1a/Rapkk/fIiAnILeMetTkc=
Date:   Mon, 04 Jul 2022 15:44:59 -0700
To:     mm-commits@vger.kernel.org, void@manifault.com, shuah@kernel.org,
        adam@wowsignal.io, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + selftests-vm-skip-128tbswitch-on-unsupported-arch.patch added to mm-unstable branch
Message-Id: <20220704224500.29C29C3411E@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: selftests/vm: skip 128TBswitch on unsupported arch
has been added to the -mm mm-unstable branch.  Its filename is
     selftests-vm-skip-128tbswitch-on-unsupported-arch.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/selftests-vm-skip-128tbswitch-on-unsupported-arch.patch

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
From: Adam Sindelar <adam@wowsignal.io>
Subject: selftests/vm: skip 128TBswitch on unsupported arch
Date: Mon, 4 Jul 2022 14:38:13 +0200

The test va_128TBswitch.c exercises a feature only supported on PPC and
x86_64, but it's run on other 64-bit archs as well.  Before this patch,
the test did nothing and returned 0 for KSFT_PASS.  This patch makes it
return the KSFT codes from kselftest.h, including KSFT_SKIP when
appropriate.

Verified on arm64 and x86_64.

Link: https://lkml.kernel.org/r/20220704123813.427625-1-adam@wowsignal.io
Signed-off-by: Adam Sindelar <adam@wowsignal.io>
Cc: David Vernet <void@manifault.com>
Cc: Shuah Khan <shuah@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 tools/testing/selftests/vm/va_128TBswitch.c |    8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

--- a/tools/testing/selftests/vm/va_128TBswitch.c~selftests-vm-skip-128tbswitch-on-unsupported-arch
+++ a/tools/testing/selftests/vm/va_128TBswitch.c
@@ -231,7 +231,7 @@ static struct testcase hugetlb_testcases
 static int run_test(struct testcase *test, int count)
 {
 	void *p;
-	int i, ret = 0;
+	int i, ret = KSFT_PASS;
 
 	for (i = 0; i < count; i++) {
 		struct testcase *t = test + i;
@@ -242,13 +242,13 @@ static int run_test(struct testcase *tes
 
 		if (p == MAP_FAILED) {
 			printf("FAILED\n");
-			ret = 1;
+			ret = KSFT_FAIL;
 			continue;
 		}
 
 		if (t->low_addr_required && p >= (void *)(ADDR_SWITCH_HINT)) {
 			printf("FAILED\n");
-			ret = 1;
+			ret = KSFT_FAIL;
 		} else {
 			/*
 			 * Do a dereference of the address returned so that we catch
@@ -280,7 +280,7 @@ int main(int argc, char **argv)
 	int ret;
 
 	if (!supported_arch())
-		return 0;
+		return KSFT_SKIP;
 
 	ret = run_test(testcases, ARRAY_SIZE(testcases));
 	if (argc == 2 && !strcmp(argv[1], "--run-hugetlb"))
_

Patches currently in -mm which might be from adam@wowsignal.io are

selftests-vm-fix-errno-handling-in-mrelease_test.patch
selftests-vm-skip-128tbswitch-on-unsupported-arch.patch

