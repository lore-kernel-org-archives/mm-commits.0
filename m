Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9E673C4167B
	for <mm-commits@archiver.kernel.org>; Wed, 29 Nov 2023 22:26:43 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234683AbjK2W0f (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 29 Nov 2023 17:26:35 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52670 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231514AbjK2W0e (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 29 Nov 2023 17:26:34 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DB93010F5
        for <mm-commits@vger.kernel.org>; Wed, 29 Nov 2023 14:26:25 -0800 (PST)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 66A55C433C8;
        Wed, 29 Nov 2023 22:26:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1701296785;
        bh=YU+SVP4M7m3MpDfkNa+pe82PCZ6ZKHFK0ijg6IHvZVM=;
        h=Date:To:From:Subject:From;
        b=t+te4Xkg63z8vnkBD593jNfda57Dn1S9gG95tZwhEYNgUtQedJKtzcGtcS+MvpNKX
         hDNjIsi4UXIaipKPupKR1SD0h2OGooGzv5fROO2r6q4mFh6b3WuMHcPYAQyjY3j1wy
         LYw7dVOr7pGsXXsECi3gn3Okk2EUxKpFlwm6vdDA=
Date:   Wed, 29 Nov 2023 14:26:24 -0800
To:     mm-commits@vger.kernel.org, shuah@kernel.org, jsavitz@redhat.com,
        david@redhat.com, npache@redhat.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + selftests-mm-dont-run-ksm_functional_tests-twice.patch added to mm-unstable branch
Message-Id: <20231129222625.66A55C433C8@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: selftests/mm: dont run ksm_functional_tests twice
has been added to the -mm mm-unstable branch.  Its filename is
     selftests-mm-dont-run-ksm_functional_tests-twice.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/selftests-mm-dont-run-ksm_functional_tests-twice.patch

This patch will later appear in the mm-unstable branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next via the mm-everything
branch at git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
and is updated there every 2-3 working days

------------------------------------------------------
From: Nico Pache <npache@redhat.com>
Subject: selftests/mm: dont run ksm_functional_tests twice
Date: Wed, 29 Nov 2023 15:11:40 -0700

ksm functional test is already being run.  Remove the duplicate call to
./ksm_functional_tests.

Link: https://lkml.kernel.org/r/20231129221140.614713-1-npache@redhat.com
Fixes: 93fb70aa5904 ("selftests/vm: add KSM unmerge tests")
Signed-off-by: Nico Pache <npache@redhat.com>
Cc: David Hildenbrand <david@redhat.com>
Cc: Joel Savitz <jsavitz@redhat.com>
Cc: Shuah Khan <shuah@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 tools/testing/selftests/mm/run_vmtests.sh |    2 --
 1 file changed, 2 deletions(-)

--- a/tools/testing/selftests/mm/run_vmtests.sh~selftests-mm-dont-run-ksm_functional_tests-twice
+++ a/tools/testing/selftests/mm/run_vmtests.sh
@@ -334,8 +334,6 @@ CATEGORY="ksm_numa" run_test ./ksm_tests
 
 CATEGORY="ksm" run_test ./ksm_functional_tests
 
-run_test ./ksm_functional_tests
-
 # protection_keys tests
 if [ -x ./protection_keys_32 ]
 then
_

Patches currently in -mm which might be from npache@redhat.com are

selftests-mm-prevent-duplicate-runs-caused-by-test_gen_progs.patch
selftests-mm-dont-run-ksm_functional_tests-twice.patch

