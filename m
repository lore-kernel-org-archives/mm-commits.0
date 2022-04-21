Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5955EC433F5
	for <mm-commits@archiver.kernel.org>; Thu, 21 Apr 2022 23:36:08 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1442568AbiDUXi5 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 21 Apr 2022 19:38:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40460 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1442591AbiDUXiu (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 21 Apr 2022 19:38:50 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C177A4617E
        for <mm-commits@vger.kernel.org>; Thu, 21 Apr 2022 16:35:59 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 5CE8261EB5
        for <mm-commits@vger.kernel.org>; Thu, 21 Apr 2022 23:35:59 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AFD30C385A7;
        Thu, 21 Apr 2022 23:35:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1650584158;
        bh=+PTbRr32hR/2e7Qt1ov+7DavlYZYTFl1RC97L9AIeqc=;
        h=Date:To:From:In-Reply-To:Subject:From;
        b=u8qnaDVtuV/1xHggVMild2b9lYpUk58aKt5nTvjiacQEB7UYlTVS0nFWdWbDsT+la
         Uqsacaowh+GIjaW3OIdD550W/m38H/OOceUTzQYD1IEV3iaS7d1yyb08Tu2xC7uAUM
         4V5jQiOLeoBiCNcoxUQ2LUPpGaycTPoqiRlHo6kA=
Date:   Thu, 21 Apr 2022 16:35:58 -0700
To:     skhan@linuxfoundation.org, sidhartha.kumar@oracle.com,
        akpm@linux-foundation.org, patches@lists.linux.dev,
        linux-mm@kvack.org, mm-commits@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
In-Reply-To: <20220421163508.66028a9ac2d9fb6ea05b1342@linux-foundation.org>
Subject: [patch 09/13] selftest/vm: add skip support to mremap_test
Message-Id: <20220421233558.AFD30C385A7@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

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
