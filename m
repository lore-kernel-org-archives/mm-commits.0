Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 81979C433F5
	for <mm-commits@archiver.kernel.org>; Fri, 22 Apr 2022 18:26:09 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231196AbiDVS26 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 22 Apr 2022 14:28:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41728 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231911AbiDVS17 (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 22 Apr 2022 14:27:59 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B989D10522A
        for <mm-commits@vger.kernel.org>; Fri, 22 Apr 2022 11:25:01 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id EC1DFB8321B
        for <mm-commits@vger.kernel.org>; Fri, 22 Apr 2022 18:24:54 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A5EDAC385A0;
        Fri, 22 Apr 2022 18:24:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1650651893;
        bh=MCqOwe3GcVx1lcQqqEAISZ1+CkrvEr3CubFadS7hNnU=;
        h=Date:To:From:Subject:From;
        b=cztV+QpL/sHVSnsHyjqchShHO5GyR43OiG7fLGhw7i718ySJag5ta7S6l8xVx8MPr
         isSfvAN6H/ygqoES+LkGaSDXQM7564bjgqDAqnFS4tDFfkNWRjqYeT6SEGbgGd8TrR
         Fl3RiV09y5g/PpJK+FQgWQaR3tRQrGOP46xbhUC4=
Date:   Fri, 22 Apr 2022 11:24:53 -0700
To:     mm-commits@vger.kernel.org, skhan@linuxfoundation.org,
        sidhartha.kumar@oracle.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged] selftest-vm-add-skip-support-to-mremap_test.patch removed from -mm tree
Message-Id: <20220422182453.A5EDAC385A0@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: selftest/vm: add skip support to mremap_test
has been removed from the -mm tree.  Its filename was
     selftest-vm-add-skip-support-to-mremap_test.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Sidhartha Kumar <sidhartha.kumar@oracle.com>
Subject: selftest/vm: add skip support to mremap_test

Allow the mremap test to be skipped due to errors such as failing to parse
the mmap_min_addr sysctl.

Link: https://lkml.kernel.org/r/20220420215721.4868-4-sidhartha.kumar@oracle.com
Signed-off-by: Sidhartha Kumar <sidhartha.kumar@oracle.com>
Reviewed-by: Shuah Khan <skhan@linuxfoundation.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 tools/testing/selftests/vm/run_vmtests.sh |   11 ++++++++---
 1 file changed, 8 insertions(+), 3 deletions(-)

--- a/tools/testing/selftests/vm/run_vmtests.sh~selftest-vm-add-skip-support-to-mremap_test
+++ a/tools/testing/selftests/vm/run_vmtests.sh
@@ -291,11 +291,16 @@ echo "-------------------"
 echo "running mremap_test"
 echo "-------------------"
 ./mremap_test
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
 
 echo "-----------------"
_

Patches currently in -mm which might be from sidhartha.kumar@oracle.com are

selftest-vm-clarify-error-statement-in-gup_test.patch

