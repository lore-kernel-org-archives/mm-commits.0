Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 87790C433F5
	for <mm-commits@archiver.kernel.org>; Wed,  6 Apr 2022 21:46:43 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232887AbiDFVsg (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 6 Apr 2022 17:48:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35884 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237185AbiDFVrg (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 6 Apr 2022 17:47:36 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F3A6C17E21
        for <mm-commits@vger.kernel.org>; Wed,  6 Apr 2022 14:30:37 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 9077461B03
        for <mm-commits@vger.kernel.org>; Wed,  6 Apr 2022 21:30:37 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E2231C385A1;
        Wed,  6 Apr 2022 21:30:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1649280637;
        bh=EQoAssORQn5ZQ1tT7cmo8+WadhPDynIr5ilhBiad5eo=;
        h=Date:To:From:Subject:From;
        b=FsLnzr7rGk1ALyl2Hg9If0vVOSTbtpTOB77RU9xm8akbp1Ify82yZn0LNbdIjygpZ
         hC4bNvVRfMaG1dQ5gLSK+5gAnFH8lIchNLeAGFx83eps3G6K9Jhqawtkz2Eh5/pFDa
         AdQ1qL2oS1fE2OV30ojP6Wj0WHdhAQsE+1qjW+wQ=
Date:   Wed, 06 Apr 2022 14:30:36 -0700
To:     mm-commits@vger.kernel.org, skhan@linuxfoundation.org,
        sidhartha.kumar@oracle.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + selftest-vm-clarify-error-statement-in-gup_test.patch added to -mm tree
Message-Id: <20220406213036.E2231C385A1@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: tools/testing/selftests/vm/gup_test.c: clarify error statement
has been added to the -mm tree.  Its filename is
     selftest-vm-clarify-error-statement-in-gup_test.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/selftest-vm-clarify-error-statement-in-gup_test.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/selftest-vm-clarify-error-statement-in-gup_test.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Sidhartha Kumar <sidhartha.kumar@oracle.com>
Subject: tools/testing/selftests/vm/gup_test.c: clarify error statement

Print three possible reasons /sys/kernel/debug/gup_test
cannot be opened to help users of this test diagnose
failures.

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

selftest-vm-clarify-error-statement-in-gup_test.patch

