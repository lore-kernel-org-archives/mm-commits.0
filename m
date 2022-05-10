Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BF14BC4332F
	for <mm-commits@archiver.kernel.org>; Tue, 10 May 2022 04:12:49 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236128AbiEJEQm (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 10 May 2022 00:16:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44528 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236188AbiEJEPu (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 10 May 2022 00:15:50 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7005F132769
        for <mm-commits@vger.kernel.org>; Mon,  9 May 2022 21:11:45 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id E252261741
        for <mm-commits@vger.kernel.org>; Tue, 10 May 2022 04:11:44 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 47A14C385C2;
        Tue, 10 May 2022 04:11:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1652155904;
        bh=UWfrz6ROCuhffDJQN4K0+a7jlfhXzgZ/dJ9F8V8FDtg=;
        h=Date:To:From:Subject:From;
        b=PtdgvZdgMcyxeqax9JVoIg927L1rt8u1qOaFhPCuS8Rts+onRSJId6ca2+FILxcqz
         KcJ7HwswpHrlV+L+rQvB+ukcpMVH9SYjtq+5aH1Wujsl6CFMCY/1MskmwUtoadOPOS
         Ax4VvtoDDXET/JmamgPkRDx2CXw4nYF875HH3P60=
Date:   Mon, 09 May 2022 21:11:43 -0700
To:     mm-commits@vger.kernel.org, skhan@linuxfoundation.org,
        sidhartha.kumar@oracle.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] selftest-vm-clarify-error-statement-in-gup_test.patch removed from -mm tree
Message-Id: <20220510041144.47A14C385C2@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: tools/testing/selftests/vm/gup_test.c: clarify error statement
has been removed from the -mm tree.  Its filename was
     selftest-vm-clarify-error-statement-in-gup_test.patch

This patch was dropped because it was merged into mm-stable

------------------------------------------------------
From: Sidhartha Kumar <sidhartha.kumar@oracle.com>
Subject: tools/testing/selftests/vm/gup_test.c: clarify error statement

Print three possible reasons /sys/kernel/debug/gup_test cannot be opened
to help users of this test diagnose failures.

Link: https://lkml.kernel.org/r/20220405214809.3351223-1-sidhartha.kumar@oracle.com
Signed-off-by: Sidhartha Kumar <sidhartha.kumar@oracle.com>
Reviewed-by: Shuah Khan <skhan@linuxfoundation.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 tools/testing/selftests/vm/gup_test.c     |   22 ++++++++++++-
 tools/testing/selftests/vm/run_vmtests.sh |   33 ++++++++++++++------
 2 files changed, 44 insertions(+), 11 deletions(-)

--- a/tools/testing/selftests/vm/gup_test.c~selftest-vm-clarify-error-statement-in-gup_test
+++ a/tools/testing/selftests/vm/gup_test.c
@@ -1,7 +1,9 @@
 #include <fcntl.h>
+#include <errno.h>
 #include <stdio.h>
 #include <stdlib.h>
 #include <unistd.h>
+#include <dirent.h>
 #include <sys/ioctl.h>
 #include <sys/mman.h>
 #include <sys/stat.h>
@@ -9,6 +11,7 @@
 #include <pthread.h>
 #include <assert.h>
 #include "../../../../mm/gup_test.h"
+#include "../kselftest.h"
 
 #include "util.h"
 
@@ -206,8 +209,23 @@ int main(int argc, char **argv)
 
 	gup_fd = open("/sys/kernel/debug/gup_test", O_RDWR);
 	if (gup_fd == -1) {
-		perror("open");
-		exit(1);
+		switch (errno) {
+		case EACCES:
+			if (getuid())
+				printf("Please run this test as root\n");
+			break;
+		case ENOENT:
+			if (opendir("/sys/kernel/debug") == NULL) {
+				printf("mount debugfs at /sys/kernel/debug\n");
+				break;
+			}
+			printf("check if CONFIG_GUP_TEST is enabled in kernel config\n");
+			break;
+		default:
+			perror("failed to open /sys/kernel/debug/gup_test");
+			break;
+		}
+		exit(KSFT_SKIP);
 	}
 
 	p = mmap(NULL, size, PROT_READ | PROT_WRITE, flags, filed, 0);
--- a/tools/testing/selftests/vm/run_vmtests.sh~selftest-vm-clarify-error-statement-in-gup_test
+++ a/tools/testing/selftests/vm/run_vmtests.sh
@@ -162,22 +162,32 @@ echo "----------------------------------
 echo "running: gup_test -u # get_user_pages_fast() benchmark"
 echo "------------------------------------------------------"
 ./gup_test -u
-if [ $? -ne 0 ]; then
+ret_val=$?
+
+if [ $ret_val -eq 0 ]; then
+	echo "[PASS]"
+elif [ $ret_val -eq $ksft_skip ]; then
+	 echo "[SKIP]"
+	 exitcode=$ksft_skip
+else
 	echo "[FAIL]"
 	exitcode=1
-else
-	echo "[PASS]"
 fi
 
 echo "------------------------------------------------------"
 echo "running: gup_test -a # pin_user_pages_fast() benchmark"
 echo "------------------------------------------------------"
 ./gup_test -a
-if [ $? -ne 0 ]; then
+ret_val=$?
+
+if [ $ret_val -eq 0 ]; then
+	echo "[PASS]"
+elif [ $ret_val -eq $ksft_skip ]; then
+	 echo "[SKIP]"
+	 exitcode=$ksft_skip
+else
 	echo "[FAIL]"
 	exitcode=1
-else
-	echo "[PASS]"
 fi
 
 echo "------------------------------------------------------------"
@@ -185,11 +195,16 @@ echo "# Dump pages 0, 19, and 4096, usin
 echo "running: gup_test -ct -F 0x1 0 19 0x1000 # dump_page() test"
 echo "------------------------------------------------------------"
 ./gup_test -ct -F 0x1 0 19 0x1000
-if [ $? -ne 0 ]; then
+ret_val=$?
+
+if [ $ret_val -eq 0 ]; then
+	echo "[PASS]"
+elif [ $ret_val -eq $ksft_skip ]; then
+	 echo "[SKIP]"
+	 exitcode=$ksft_skip
+else
 	echo "[FAIL]"
 	exitcode=1
-else
-	echo "[PASS]"
 fi
 
 echo "-------------------"
_

Patches currently in -mm which might be from sidhartha.kumar@oracle.com are


