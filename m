Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CCDA7C433EF
	for <mm-commits@archiver.kernel.org>; Thu, 11 Nov 2021 02:54:23 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id B5AF361108
	for <mm-commits@archiver.kernel.org>; Thu, 11 Nov 2021 02:54:23 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234635AbhKKC5L (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 10 Nov 2021 21:57:11 -0500
Received: from mail.kernel.org ([198.145.29.99]:60372 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234632AbhKKC5K (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Wed, 10 Nov 2021 21:57:10 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 7E123610A2;
        Thu, 11 Nov 2021 02:54:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1636599262;
        bh=bjjcKJUSVH9+jzgWqk4n3LMAXTJK719oSxZm1UmVcj8=;
        h=Date:From:To:Subject:From;
        b=SQeNMGgwFfUgGUWK7D8g9xhcI2MQgP0ovJPiLwiqoYWpQatt/cDXjviuaxuaBBtug
         FfaFVGLyh9J1SidxsIA4uDep3SIgPxKJkRjIMfBhARbqT/+akKUl6qpwcXBBJ/GqCX
         jAYFWcj9pGhp0vkOdCjEIoWHIJ4w2lzdjuswe1Xw=
Date:   Wed, 10 Nov 2021 18:54:22 -0800
From:   akpm@linux-foundation.org
To:     gregkh@linuxfoundation.org, mm-commits@vger.kernel.org,
        shuah@kernel.org, sjpark@amazon.de
Subject:  [merged]
 selftests-kselftest-runner-run_one-allow-running-non-executable-files.patch
 removed from -mm tree
Message-ID: <20211111025422.zU-3bkJ1K%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: selftests/kselftest/runner/run_one(): allow running non-executable files
has been removed from the -mm tree.  Its filename was
     selftests-kselftest-runner-run_one-allow-running-non-executable-files.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
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

Patches currently in -mm which might be from sjpark@amazon.de are


