Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D4B2DE9371F
	for <mm-commits@archiver.kernel.org>; Mon,  9 Oct 2023 23:32:03 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1379049AbjJIXcD (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 9 Oct 2023 19:32:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56974 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1379043AbjJIXcD (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 9 Oct 2023 19:32:03 -0400
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E4E629E
        for <mm-commits@vger.kernel.org>; Mon,  9 Oct 2023 16:32:01 -0700 (PDT)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 19B1CC433C7;
        Mon,  9 Oct 2023 23:31:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1696894321;
        bh=SnDb5DiSQFr8aftpeIHBmAOsZQYkg+L/iX7lPdRrex8=;
        h=Date:To:From:Subject:From;
        b=mgU2J7AKIpDfE9vh6+v1qGjh3VGAb4xesnf0sucJGJKEAxCCTIuOnqmTRaiqP2yyf
         zT1NhhGCTP80ePH+MVVF792kL2cJI/S8D7oFOOebvusF6bdmSnMiJwyVfnzhyeQkCk
         ghwNK4rPvA6yqVDpHYeXhMtqlkbwddlpft+h4ak4=
Date:   Mon, 09 Oct 2023 16:31:50 -0700
To:     mm-commits@vger.kernel.org, shuah@kernel.org, hughd@google.com,
        adobriyan@gmail.com, swarupkotikalapudi@gmail.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [alternative-merged] selftests-proc-add-proc-pid-statm-output-validation.patch removed from -mm tree
Message-Id: <20231009233200.19B1CC433C7@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: selftests:proc add /proc/$(pid)/statm output validation
has been removed from the -mm tree.  Its filename was
     selftests-proc-add-proc-pid-statm-output-validation.patch

This patch was dropped because an alternative patch was or shall be merged

------------------------------------------------------
From: Swarup Laxman Kotiaklapudi <swarupkotikalapudi@gmail.com>
Subject: selftests:proc add /proc/$(pid)/statm output validation
Date: Tue, 10 Oct 2023 00:50:10 +0530

Add /proc/${pid}/statm validation

/proc/$(pid)/statm output is expected to be:
 "0 0 0 * 0 0 0\n"
Here * can be any value

Read output of /proc/$(pid)/statm
and check except for 4th position,
all other positions have value zero.

Link: https://lkml.kernel.org/r/20231009192010.10456-1-swarupkotikalapudi@gmail.com
Fixes: 5bc73bb3451b (proc: test how it holds up with mapping'less process)
Signed-off-by: Swarup Laxman Kotiaklapudi <swarupkotikalapudi@gmail.com>
Cc: Alexey Dobriyan <adobriyan@gmail.com>
Cc: Hugh Dickins <hughd@google.com>
Cc: Shuah Khan <shuah@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 tools/testing/selftests/proc/proc-empty-vm.c |   60 +++++++++++++++--
 1 file changed, 55 insertions(+), 5 deletions(-)

--- a/tools/testing/selftests/proc/proc-empty-vm.c~selftests-proc-add-proc-pid-statm-output-validation
+++ a/tools/testing/selftests/proc/proc-empty-vm.c
@@ -38,6 +38,8 @@
 #include <sys/wait.h>
 #include <unistd.h>
 
+#include "../kselftest.h"
+
 #ifdef __amd64__
 #define TEST_VSYSCALL
 #endif
@@ -303,6 +305,57 @@ static int test_proc_pid_smaps_rollup(pi
 	}
 }
 
+static int test_proc_pid_statm(pid_t pid)
+{
+	char buf[4096];
+	char *tok;
+	char *string, *p;
+	int non_zero_value_indx = 4;
+	int i = 1, len;
+        size_t left;
+
+	snprintf(buf, sizeof(buf), "/proc/%u/statm", pid);
+
+	/*
+	 *  Output can be "0 0 0 2 0 0 0\n" where "2" can be anything.
+	 */
+	int fd = open(buf, O_RDONLY);
+
+	if (fd == -1) {
+		if (errno == ENOENT) {
+			return EXIT_SUCCESS;
+		}
+		perror("open /proc/${pid}/statm");
+		return EXIT_FAILURE;
+	} else {
+		memset(buf, 0, sizeof(buf));
+		left = ARRAY_SIZE(buf);
+		p = buf;
+		while ((len = read(fd, p, left)) > 0) {
+			p += len;
+			left -= len;
+		}
+		close(fd);
+		string = buf;
+
+		while ((tok = strsep(&string, " ")) != NULL) {
+			if (i == non_zero_value_indx) {
+				if (!strncmp(tok, "0", 1))
+					goto err_statm;
+			} else {
+				if (strncmp(tok, "0", 1))
+					goto err_statm;
+			}
+			i++;
+		}
+	}
+
+	return EXIT_SUCCESS;
+
+err_statm:
+	assert(0);
+}
+
 int main(void)
 {
 	int rv = EXIT_SUCCESS;
@@ -389,11 +442,8 @@ int main(void)
 		if (rv == EXIT_SUCCESS) {
 			rv = test_proc_pid_smaps_rollup(pid);
 		}
-		/*
-		 * TODO test /proc/${pid}/statm, task_statm()
-		 * ->start_code, ->end_code aren't updated by munmap().
-		 * Output can be "0 0 0 2 0 0 0\n" where "2" can be anything.
-		 */
+		if (rv == EXIT_SUCCESS)
+			rv = test_proc_pid_statm(pid);
 
 		/* Cut the rope. */
 		int wstatus;
_

Patches currently in -mm which might be from swarupkotikalapudi@gmail.com are

proc-test-proc-pid-statm.patch

