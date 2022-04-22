Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4A89BC433FE
	for <mm-commits@archiver.kernel.org>; Fri, 22 Apr 2022 18:26:10 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231241AbiDVS3A (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 22 Apr 2022 14:29:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41704 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231891AbiDVS17 (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 22 Apr 2022 14:27:59 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 93FA810521D
        for <mm-commits@vger.kernel.org>; Fri, 22 Apr 2022 11:25:00 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 4798A617FE
        for <mm-commits@vger.kernel.org>; Fri, 22 Apr 2022 18:24:53 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9C336C385A9;
        Fri, 22 Apr 2022 18:24:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1650651892;
        bh=X5RiNeEJ9XGn+jqU8qFkpTO+01SOMdTyz5DFkbZDnmQ=;
        h=Date:To:From:Subject:From;
        b=HX/syqGMYZFuY4hpyzCIAQVKkwsF7ADDFXxLLq4d2p7qAAJHyW7awle2Waoov9Ab0
         kfg7GujDIgj49WiPNQwL4pg4qbv+I/rpms/gERAp+i2I9yR2yHBc484wMjO2PdSNzF
         yed/TTBG1myKY04P32sFVRS2oVlSJwI1mddUfcXY=
Date:   Fri, 22 Apr 2022 11:24:52 -0700
To:     mm-commits@vger.kernel.org, skhan@linuxfoundation.org,
        sidhartha.kumar@oracle.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged] selftest-vm-support-xfail-in-mremap_test.patch removed from -mm tree
Message-Id: <20220422182452.9C336C385A9@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: selftest/vm: support xfail in mremap_test
has been removed from the -mm tree.  Its filename was
     selftest-vm-support-xfail-in-mremap_test.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Sidhartha Kumar <sidhartha.kumar@oracle.com>
Subject: selftest/vm: support xfail in mremap_test

Use ksft_test_result_xfail for the tests which are expected to fail.

Link: https://lkml.kernel.org/r/20220420215721.4868-3-sidhartha.kumar@oracle.com
Signed-off-by: Sidhartha Kumar <sidhartha.kumar@oracle.com>
Reviewed-by: Shuah Khan <skhan@linuxfoundation.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 tools/testing/selftests/vm/mremap_test.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/tools/testing/selftests/vm/mremap_test.c~selftest-vm-support-xfail-in-mremap_test
+++ a/tools/testing/selftests/vm/mremap_test.c
@@ -268,7 +268,7 @@ static void run_mremap_test_case(struct
 
 	if (remap_time < 0) {
 		if (test_case.expect_failure)
-			ksft_test_result_pass("%s\n\tExpected mremap failure\n",
+			ksft_test_result_xfail("%s\n\tExpected mremap failure\n",
 					      test_case.name);
 		else {
 			ksft_test_result_fail("%s\n", test_case.name);
_

Patches currently in -mm which might be from sidhartha.kumar@oracle.com are

selftest-vm-clarify-error-statement-in-gup_test.patch

