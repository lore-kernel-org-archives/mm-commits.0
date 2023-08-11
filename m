Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7714CC04E69
	for <mm-commits@archiver.kernel.org>; Fri, 11 Aug 2023 23:05:46 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236864AbjHKXFp (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 11 Aug 2023 19:05:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37514 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236244AbjHKXEK (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 11 Aug 2023 19:04:10 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5F56F3C13
        for <mm-commits@vger.kernel.org>; Fri, 11 Aug 2023 16:02:14 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id F331E631F5
        for <mm-commits@vger.kernel.org>; Fri, 11 Aug 2023 23:02:13 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 587B7C433C8;
        Fri, 11 Aug 2023 23:02:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1691794933;
        bh=P32VCAWsLIIGX90BMQumMekreeMG4rLQUs6LImypJXA=;
        h=Date:To:From:Subject:From;
        b=NNZB78BhyTWqR/jNhhwMWuV4mFBPXzQOu5fOFcxADWdGXXG3ArYs0KiZJBm3mpunY
         4d0192ZM/NG1xQJAqs7BoYcUZP08VCS69fRfvOD+VbKduHxUt+Ie6TxtYZGPhTIsM9
         OR6HcgA7F8he9ZAthvywIh9mMXWx2TpwAZvEBE2E=
Date:   Fri, 11 Aug 2023 16:02:12 -0700
To:     mm-commits@vger.kernel.org, shuah@kernel.org, revest@chromium.org,
        peterx@redhat.com, jhubbard@nvidia.com, jglisse@redhat.com,
        david@redhat.com, broonie@kernel.org, ryan.roberts@arm.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] selftests-line-buffer-test-programs-stdout.patch removed from -mm tree
Message-Id: <20230811230213.587B7C433C8@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: selftests: line buffer test program's stdout
has been removed from the -mm tree.  Its filename was
     selftests-line-buffer-test-programs-stdout.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Ryan Roberts <ryan.roberts@arm.com>
Subject: selftests: line buffer test program's stdout
Date: Mon, 24 Jul 2023 09:25:15 +0100

Patch series "selftests/mm fixes for arm64", v3.

Given my on-going work on large anon folios and contpte mappings, I
decided it would be a good idea to start running mm selftests to help
guard against regressions.  However, it soon became clear that I
couldn't get the suite to run cleanly on arm64 with a vanilla v6.5-rc1
kernel (perhaps I'm just doing it wrong??), so got stuck in a rabbit
hole trying to debug and fix all the issues.  Some were down to
misconfigurations, but I also found a number of issues with the tests
and even a couple of issues with the kernel.


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

[ryan.roberts@arm.com: add setvbuf() to set buffering mode]
  Link: https://lkml.kernel.org/r/20230726070655.2713530-1-ryan.roberts@arm.com
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

 tools/include/nolibc/stdio.h                |   24 ++++++++++++++++++
 tools/testing/selftests/kselftest.h         |    9 ++++++
 tools/testing/selftests/kselftest/runner.sh |    7 +++--
 3 files changed, 38 insertions(+), 2 deletions(-)

--- a/tools/include/nolibc/stdio.h~selftests-line-buffer-test-programs-stdout
+++ a/tools/include/nolibc/stdio.h
@@ -21,6 +21,11 @@
 #define EOF (-1)
 #endif
 
+/* Buffering mode used by setvbuf.  */
+#define _IOFBF 0	/* Fully buffered. */
+#define _IOLBF 1	/* Line buffered. */
+#define _IONBF 2	/* No buffering. */
+
 /* just define FILE as a non-empty type. The value of the pointer gives
  * the FD: FILE=~fd for fd>=0 or NULL for fd<0. This way positive FILE
  * are immediately identified as abnormal entries (i.e. possible copies
@@ -350,6 +355,25 @@ void perror(const char *msg)
 	fprintf(stderr, "%s%serrno=%d\n", (msg && *msg) ? msg : "", (msg && *msg) ? ": " : "", errno);
 }
 
+static __attribute__((unused))
+int setvbuf(FILE *stream, char *buf, int mode, size_t size)
+{
+	/*
+	 * nolibc does not support buffering so this is a nop. Just check mode
+	 * is valid as required by the spec.
+	 */
+	switch (mode) {
+	case _IOFBF:
+	case _IOLBF:
+	case _IONBF:
+		break;
+	default:
+		return EOF;
+	}
+
+	return 0;
+}
+
 /* make sure to include all global symbols */
 #include "nolibc.h"
 
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


