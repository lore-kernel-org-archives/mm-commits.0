Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 27133C433FE
	for <mm-commits@archiver.kernel.org>; Wed, 20 Apr 2022 22:08:57 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241241AbiDTWLm (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 20 Apr 2022 18:11:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47422 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1355585AbiDTWLj (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 20 Apr 2022 18:11:39 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D808F1902A
        for <mm-commits@vger.kernel.org>; Wed, 20 Apr 2022 15:08:51 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 9AEE6B821B7
        for <mm-commits@vger.kernel.org>; Wed, 20 Apr 2022 22:08:50 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4A1D1C385A1;
        Wed, 20 Apr 2022 22:08:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1650492529;
        bh=Xq7qyzsSXtgYH/tBVix0yUOnxYH3OrQkfcSkvuk4+oQ=;
        h=Date:To:From:Subject:From;
        b=QfhAo6RlE3o3O/fF7ua/tTppkXmmwK7oQYIr5KOEChGzvCob19Plvtux8YDeQiFKd
         oWcVGV7HAgUPpPYz4N92u/EM3Zoqnor5kU8US4cLKwMdfzekL+x5avDWTJBj/KMKDQ
         8P1vOo8wmyrJzkPGDzwB1+3U3uyWgTX677TEDSic=
Date:   Wed, 20 Apr 2022 15:08:48 -0700
To:     mm-commits@vger.kernel.org, skhan@linuxfoundation.org,
        sidhartha.kumar@oracle.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + selftest-vm-support-xfail-in-mremap_test.patch added to -mm tree
Message-Id: <20220420220849.4A1D1C385A1@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: selftest/vm: support xfail in mremap_test
has been added to the -mm tree.  Its filename is
     selftest-vm-support-xfail-in-mremap_test.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/selftest-vm-support-xfail-in-mremap_test.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/selftest-vm-support-xfail-in-mremap_test.patch

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

selftest-vm-verify-mmap-addr-in-mremap_test.patch
selftest-vm-verify-remap-destination-address-in-mremap_test.patch
selftest-vm-support-xfail-in-mremap_test.patch
selftest-vm-add-skip-support-to-mremap_test.patch
selftest-vm-clarify-error-statement-in-gup_test.patch

