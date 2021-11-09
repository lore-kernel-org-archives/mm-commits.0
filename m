Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 63E79C433F5
	for <mm-commits@archiver.kernel.org>; Tue,  9 Nov 2021 02:35:58 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 4A544619E5
	for <mm-commits@archiver.kernel.org>; Tue,  9 Nov 2021 02:35:58 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239356AbhKICim (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 8 Nov 2021 21:38:42 -0500
Received: from mail.kernel.org ([198.145.29.99]:54162 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S238412AbhKICim (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Mon, 8 Nov 2021 21:38:42 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id F179B619A6;
        Tue,  9 Nov 2021 02:35:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1636425357;
        bh=Ulbi1NUz/S954JH65DW07Fjc2XcByVledStYEZaw8Jc=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=fLsQFTutLR9lQi3/fsCmu7r771Co2aJKxJ8mSbnjBuiBOAD+y+/hlh8TTtAsx9sY3
         6ojGsfmgkaju10JiKyGQHX/dO/FhvF6iARjzbftF0Y/W4FvBKUi1aTqYIm+fs7yTdU
         YZZhEBhHrAp4yHELQwfz9Fty4c0UKdii0WMRbKC4=
Date:   Mon, 08 Nov 2021 18:35:56 -0800
From:   Andrew Morton <akpm@linux-foundation.org>
To:     akpm@linux-foundation.org, gregkh@linuxfoundation.org,
        linux-mm@kvack.org, mm-commits@vger.kernel.org, shuah@kernel.org,
        sjpark@amazon.de, torvalds@linux-foundation.org
Subject:  [patch 85/87] selftests/kselftest/runner/run_one(): allow
 running non-executable files
Message-ID: <20211109023556.QHYswe1Gd%akpm@linux-foundation.org>
In-Reply-To: <20211108183057.809e428e841088b657a975ec@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

From: SeongJae Park <sjpark@amazon.de>
Subject: selftests/kselftest/runner/run_one(): allow running non-executable files

When running a test program, 'run_one()' checks if the program has the
execution permission and fails if it doesn't.  However, it's easy to
mistakenly lose the permissions, as some common tools like 'diff' don't
support the permission change well[1].  Compared to that, making mistakes
in the test program's path would only rare, as those are explicitly listed
in 'TEST_PROGS'.  Therefore, it might make more sense to resolve the
situation on our own and run the program.

For this reason, this commit makes the test program runner function still
print the warning message but to try parsing the interpreter of the
program and to explicitly run it with the interpreter, in this case.

[1] https://lore.kernel.org/mm-commits/YRJisBs9AunccCD4@kroah.com/

Link: https://lkml.kernel.org/r/20210810164534.25902-1-sj38.park@gmail.com
Signed-off-by: SeongJae Park <sjpark@amazon.de>
Suggested-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Shuah Khan <shuah@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 tools/testing/selftests/kselftest/runner.sh |   28 +++++++++++-------
 1 file changed, 18 insertions(+), 10 deletions(-)

--- a/tools/testing/selftests/kselftest/runner.sh~selftests-kselftest-runner-run_one-allow-running-non-executable-files
+++ a/tools/testing/selftests/kselftest/runner.sh
@@ -33,9 +33,9 @@ tap_timeout()
 {
 	# Make sure tests will time out if utility is available.
 	if [ -x /usr/bin/timeout ] ; then
-		/usr/bin/timeout --foreground "$kselftest_timeout" "$1"
+		/usr/bin/timeout --foreground "$kselftest_timeout" $1
 	else
-		"$1"
+		$1
 	fi
 }
 
@@ -65,17 +65,25 @@ run_one()
 
 	TEST_HDR_MSG="selftests: $DIR: $BASENAME_TEST"
 	echo "# $TEST_HDR_MSG"
-	if [ ! -x "$TEST" ]; then
-		echo -n "# Warning: file $TEST is "
-		if [ ! -e "$TEST" ]; then
-			echo "missing!"
-		else
-			echo "not executable, correct this."
-		fi
+	if [ ! -e "$TEST" ]; then
+		echo "# Warning: file $TEST is missing!"
 		echo "not ok $test_num $TEST_HDR_MSG"
 	else
+		cmd="./$BASENAME_TEST"
+		if [ ! -x "$TEST" ]; then
+			echo "# Warning: file $TEST is not executable"
+
+			if [ $(head -n 1 "$TEST" | cut -c -2) = "#!" ]
+			then
+				interpreter=$(head -n 1 "$TEST" | cut -c 3-)
+				cmd="$interpreter ./$BASENAME_TEST"
+			else
+				echo "not ok $test_num $TEST_HDR_MSG"
+				return
+			fi
+		fi
 		cd `dirname $TEST` > /dev/null
-		((((( tap_timeout ./$BASENAME_TEST 2>&1; echo $? >&3) |
+		((((( tap_timeout "$cmd" 2>&1; echo $? >&3) |
 			tap_prefix >&4) 3>&1) |
 			(read xs; exit $xs)) 4>>"$logfile" &&
 		echo "ok $test_num $TEST_HDR_MSG") ||
_
