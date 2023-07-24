Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 815E3C001DF
	for <mm-commits@archiver.kernel.org>; Mon, 24 Jul 2023 16:39:17 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229485AbjGXQjQ (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 24 Jul 2023 12:39:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35024 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231405AbjGXQjQ (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 24 Jul 2023 12:39:16 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BD13A125
        for <mm-commits@vger.kernel.org>; Mon, 24 Jul 2023 09:39:14 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 534FA61280
        for <mm-commits@vger.kernel.org>; Mon, 24 Jul 2023 16:39:14 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A5010C433C8;
        Mon, 24 Jul 2023 16:39:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1690216753;
        bh=yWHdI0wG5L69s/06TA0m9PBqC7N+mUI2yA93ETsrNLQ=;
        h=Date:To:From:Subject:From;
        b=jNJdad8GMNZrJGqDDhnn2FERxalqDJ3M1bcMbc493NbjVJg09tTJXTPbC7tVrItUz
         0IqyDr5AEw3A80zAjyD17+Loqq+Nt1MQLH2Q0ZqsYUjwmGyQFJMczbOc2RKDm65YLA
         4H8WVz63Ecp5YT0vXqoFEbTqM3Qk1OpfUaBr/MBg=
Date:   Mon, 24 Jul 2023 09:39:13 -0700
To:     mm-commits@vger.kernel.org, shuah@kernel.org, revest@chromium.org,
        peterx@redhat.com, jhubbard@nvidia.com, jglisse@redhat.com,
        david@redhat.com, broonie@kernel.org, ryan.roberts@arm.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + selftests-line-buffer-test-programs-stdout.patch added to mm-unstable branch
Message-Id: <20230724163913.A5010C433C8@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: selftests: line buffer test program's stdout
has been added to the -mm mm-unstable branch.  Its filename is
     selftests-line-buffer-test-programs-stdout.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/selftests-line-buffer-test-programs-stdout.patch

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
From: Ryan Roberts <ryan.roberts@arm.com>
Subject: selftests: line buffer test program's stdout
Date: Mon, 24 Jul 2023 09:25:15 +0100

Patch series "selftests/mm fixes for arm64", v3.


This patch (of 8):

The selftests runner pipes the test program's stdout to tap_prefix.  The
presence of the pipe means that the test program sets its stdout to be
fully buffered (as aposed to line buffered when directly connected to the
terminal).  The block buffering means that there is often content in the
buffer at fork() time, which causes the output to end up duplicated.  This
was causing problems for mm:cow where test results were duplicated 20-30x.

Solve this by using `stdbuf`, when available to force the test program to
use line buffered mode.  This means previously printf'ed results are
flushed out of the program before any fork().

Additionally, explicitly set line buffer mode in ksft_print_header(),
which means that all test programs that use the ksft framework will
benefit even if stdbuf is not present on the system.

Link: https://lkml.kernel.org/r/20230724082522.1202616-1-ryan.roberts@arm.com
Link: https://lkml.kernel.org/r/20230724082522.1202616-2-ryan.roberts@arm.com
Signed-off-by: Ryan Roberts <ryan.roberts@arm.com>
Reviewed-by: Mark Brown <broonie@kernel.org>
Cc: David Hildenbrand <david@redhat.com>
Cc: Florent Revest <revest@chromium.org>
Cc: Jérôme Glisse <jglisse@redhat.com>
Cc: John Hubbard <jhubbard@nvidia.com>
Cc: Peter Xu <peterx@redhat.com>
Cc: Shuah Khan <shuah@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 tools/testing/selftests/kselftest.h         |    9 +++++++++
 tools/testing/selftests/kselftest/runner.sh |    7 +++++--
 2 files changed, 14 insertions(+), 2 deletions(-)

--- a/tools/testing/selftests/kselftest.h~selftests-line-buffer-test-programs-stdout
+++ a/tools/testing/selftests/kselftest.h
@@ -113,6 +113,15 @@ static inline int ksft_get_error_cnt(voi
 
 static inline void ksft_print_header(void)
 {
+	/*
+	 * Force line buffering; If stdout is not connected to a terminal, it
+	 * will otherwise default to fully buffered, which can cause output
+	 * duplication if there is content in the buffer when fork()ing. If
+	 * there is a crash, line buffering also means the most recent output
+	 * line will be visible.
+	 */
+	setvbuf(stdout, NULL, _IOLBF, 0);
+
 	if (!(getenv("KSFT_TAP_LEVEL")))
 		printf("TAP version 13\n");
 }
--- a/tools/testing/selftests/kselftest/runner.sh~selftests-line-buffer-test-programs-stdout
+++ a/tools/testing/selftests/kselftest/runner.sh
@@ -105,15 +105,18 @@ run_one()
 		echo "# Warning: file $TEST is missing!"
 		echo "not ok $test_num $TEST_HDR_MSG"
 	else
+		if [ -x /usr/bin/stdbuf ]; then
+			stdbuf="/usr/bin/stdbuf --output=L "
+		fi
 		eval kselftest_cmd_args="\$${kselftest_cmd_args_ref:-}"
-		cmd="./$BASENAME_TEST $kselftest_cmd_args"
+		cmd="$stdbuf ./$BASENAME_TEST $kselftest_cmd_args"
 		if [ ! -x "$TEST" ]; then
 			echo "# Warning: file $TEST is not executable"
 
 			if [ $(head -n 1 "$TEST" | cut -c -2) = "#!" ]
 			then
 				interpreter=$(head -n 1 "$TEST" | cut -c 3-)
-				cmd="$interpreter ./$BASENAME_TEST"
+				cmd="$stdbuf $interpreter ./$BASENAME_TEST"
 			else
 				echo "not ok $test_num $TEST_HDR_MSG"
 				return
_

Patches currently in -mm which might be from ryan.roberts@arm.com are

mm-allow-deferred-splitting-of-arbitrary-large-anon-folios.patch
mm-implement-folio_remove_rmap_range.patch
mm-batch-zap-large-anonymous-folio-pte-mappings.patch
selftests-line-buffer-test-programs-stdout.patch
selftests-mm-skip-soft-dirty-tests-on-arm64.patch
selftests-mm-enable-mrelease_test-for-arm64.patch
selftests-mm-fix-thuge-gen-test-bugs.patch
selftests-mm-va_high_addr_switch-should-skip-unsupported-arm64-configs.patch
selftests-mm-make-migration-test-robust-to-failure.patch
selftests-mm-optionally-pass-duration-to-transhuge-stress.patch
selftests-mm-run-all-tests-from-run_vmtestssh.patch

