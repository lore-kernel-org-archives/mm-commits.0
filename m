Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BB881C7EE29
	for <mm-commits@archiver.kernel.org>; Wed,  7 Jun 2023 02:37:34 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240769AbjFGChd (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 6 Jun 2023 22:37:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50218 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240767AbjFGCh3 (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 6 Jun 2023 22:37:29 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 257981731
        for <mm-commits@vger.kernel.org>; Tue,  6 Jun 2023 19:37:28 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id AE6B962F11
        for <mm-commits@vger.kernel.org>; Wed,  7 Jun 2023 02:37:27 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0E011C433D2;
        Wed,  7 Jun 2023 02:37:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1686105447;
        bh=ITIitLZjz5zF6jRmICvGSd0ZP5y7baXBAPAp6izaFLg=;
        h=Date:To:From:Subject:From;
        b=0oTrSfv7YclLhDS+CHJ5JxgKTH+kafhM4LNgYZPbzR43NyQwejsq41eWRzNEHFXxf
         8AL7LfISvRve+rg0s3nwHx++m7LILEqwavKeubH5zyaz9dID277ZVDYAYpKaw11mKs
         EBmuGCEetNLSiFmKnz2pAfSYUlLrbjBcsDseuBIg=
Date:   Tue, 06 Jun 2023 19:37:26 -0700
To:     mm-commits@vger.kernel.org, usama.anjum@collabora.com,
        shuah@kernel.org, peterx@redhat.com, nathan@kernel.org,
        david@redhat.com, corbet@lwn.net, jhubbard@nvidia.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + selftests-mm-fix-two-wformat-security-warnings-in-uffd-builds.patch added to mm-unstable branch
Message-Id: <20230607023727.0E011C433D2@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: selftests/mm: fix two -Wformat-security warnings in uffd builds
has been added to the -mm mm-unstable branch.  Its filename is
     selftests-mm-fix-two-wformat-security-warnings-in-uffd-builds.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/selftests-mm-fix-two-wformat-security-warnings-in-uffd-builds.patch

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
Subject: selftests/mm: fix two -Wformat-security warnings in uffd builds
Date: Tue, 6 Jun 2023 00:16:32 -0700

The uffd tests generate two compile time warnings from clang's
-Wformat-security setting. These trigger at the call sites for
uffd_test_start() and uffd_test_skip().

1) Fix the uffd_test_start() issue by removing the intermediate
test_name variable (thanks to David Hildenbrand for showing how to do
this).

2) Fix the uffd_test_skip() issue by observing that there is no need for
a macro and a variable args approach, because all callers of
uffd_test_skip() pass in a simple char* string, without any format
specifiers. So just change uffd_test_skip() into a regular C function.

Link: https://lkml.kernel.org/r/20230606071637.267103-7-jhubbard@nvidia.com
Signed-off-by: John Hubbard <jhubbard@nvidia.com>
Reviewed-by: David Hildenbrand <david@redhat.com>
Reviewed-by: Peter Xu <peterx@redhat.com>
Tested-by: Muhammad Usama Anjum <usama.anjum@collabora.com>
Cc: Jonathan Corbet <corbet@lwn.net>
Cc: Nathan Chancellor <nathan@kernel.org>
Cc: Shuah Khan <shuah@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 tools/testing/selftests/mm/uffd-unit-tests.c |   16 ++++++----------
 1 file changed, 6 insertions(+), 10 deletions(-)

--- a/tools/testing/selftests/mm/uffd-unit-tests.c~selftests-mm-fix-two-wformat-security-warnings-in-uffd-builds
+++ a/tools/testing/selftests/mm/uffd-unit-tests.c
@@ -109,12 +109,11 @@ static void uffd_test_pass(void)
 		ksft_inc_fail_cnt();		\
 	} while (0)
 
-#define  uffd_test_skip(...)  do {		\
-		printf("skipped [reason: ");	\
-		printf(__VA_ARGS__);		\
-		printf("]\n");			\
-		ksft_inc_xskip_cnt();		\
-	} while (0)
+static void uffd_test_skip(const char *message)
+{
+	printf("skipped [reason: %s]\n", message);
+	ksft_inc_xskip_cnt();
+}
 
 /*
  * Returns 1 if specific userfaultfd supported, 0 otherwise.  Note, we'll
@@ -1149,7 +1148,6 @@ int main(int argc, char *argv[])
 	uffd_test_case_t *test;
 	mem_type_t *mem_type;
 	uffd_test_args_t args;
-	char test_name[128];
 	const char *errmsg;
 	int has_uffd, opt;
 	int i, j;
@@ -1192,10 +1190,8 @@ int main(int argc, char *argv[])
 			mem_type = &mem_types[j];
 			if (!(test->mem_targets & mem_type->mem_flag))
 				continue;
-			snprintf(test_name, sizeof(test_name),
-				 "%s on %s", test->name, mem_type->name);
 
-			uffd_test_start(test_name);
+			uffd_test_start("%s on %s", test->name, mem_type->name);
 			if (!uffd_feature_supported(test)) {
 				uffd_test_skip("feature missing");
 				continue;
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

