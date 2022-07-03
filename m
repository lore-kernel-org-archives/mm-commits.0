Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D9F2AC43334
	for <mm-commits@archiver.kernel.org>; Sun,  3 Jul 2022 22:53:25 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229866AbiGCWxZ (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Sun, 3 Jul 2022 18:53:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38354 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229904AbiGCWxY (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Sun, 3 Jul 2022 18:53:24 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D4045E98
        for <mm-commits@vger.kernel.org>; Sun,  3 Jul 2022 15:53:22 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 5DF98611B8
        for <mm-commits@vger.kernel.org>; Sun,  3 Jul 2022 22:53:22 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A7677C341C6;
        Sun,  3 Jul 2022 22:53:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1656888801;
        bh=GRO0s61hO4TEB9zFrx8oXU6TtD41ORj4cK2dFUdfzUg=;
        h=Date:To:From:Subject:From;
        b=Qz0ZtXwSlWnwrG7wczVuimQUpR62VkYXhx1JLOYteN4cTFxPeg5Bfc2IpMsT0zTcv
         K5tzomE5kzHNTSLlYZv1/jC+oWBKifdh2q5DzCG8mfZ7O409VWpUpQrVzXmuFEY0gF
         XmNKLxDB4BknSjviSgUvKjcI2JSeLv9Zh3rSYwwM=
Date:   Sun, 03 Jul 2022 15:53:21 -0700
To:     mm-commits@vger.kernel.org, shuah@kernel.org,
        kalpana.shetty@amd.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + selftests-vm-add-protection_keys-tests-to-run_vmtests-v4.patch added to mm-unstable branch
Message-Id: <20220703225321.A7677C341C6@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: selftests-vm-add-protection_keys-tests-to-run_vmtests-v4
has been added to the -mm mm-unstable branch.  Its filename is
     selftests-vm-add-protection_keys-tests-to-run_vmtests-v4.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/selftests-vm-add-protection_keys-tests-to-run_vmtests-v4.patch

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
From: Kalpana Shetty <kalpana.shetty@amd.com>
Subject: selftests-vm-add-protection_keys-tests-to-run_vmtests-v4
Date: Sat, 18 Jun 2022 01:59:31 +0530

Shuah Khan's review comments incorporated, added -x executable check

Link: https://lkml.kernel.org/r/20220617202931.357-1-kalpana.shetty@amd.com
Signed-off-by: Kalpana Shetty <kalpana.shetty@amd.com>
Cc: Shuah Khan <shuah@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 tools/testing/selftests/vm/run_vmtests.sh |    8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

--- a/tools/testing/selftests/vm/run_vmtests.sh~selftests-vm-add-protection_keys-tests-to-run_vmtests-v4
+++ a/tools/testing/selftests/vm/run_vmtests.sh
@@ -180,9 +180,13 @@ run_test ./ksm_tests -N -m 1
 run_test ./ksm_tests -N -m 0
 
 # protection_keys tests
-if [ $VADDR64 -eq 0 ]; then
+if [ -x ./protection_keys_32 ]
+then
 	run_test ./protection_keys_32
-else
+fi
+
+if [ -x ./protection_keys_64 ]
+then
 	run_test ./protection_keys_64
 fi
 
_

Patches currently in -mm which might be from kalpana.shetty@amd.com are

selftests-vm-add-protection_keys-tests-to-run_vmtests.patch
selftests-vm-add-protection_keys-tests-to-run_vmtests-v4.patch

