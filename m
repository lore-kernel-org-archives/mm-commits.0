Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7425FC433F5
	for <mm-commits@archiver.kernel.org>; Sat, 21 May 2022 15:30:37 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245065AbiEUPaf (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Sat, 21 May 2022 11:30:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60700 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230448AbiEUPad (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Sat, 21 May 2022 11:30:33 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BC6519346F
        for <mm-commits@vger.kernel.org>; Sat, 21 May 2022 08:30:32 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id B33E9B8070D
        for <mm-commits@vger.kernel.org>; Sat, 21 May 2022 15:30:30 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 397B9C385B8;
        Sat, 21 May 2022 15:30:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1653147029;
        bh=fEmCqBUJkHEjdj1PxqgcQAXBOtp+vJOfPdqnONfyQy4=;
        h=Date:To:From:Subject:From;
        b=yGQSvL9CL/OOOvqyESKLaHeAoeI6w35S+sa3phNmOx6cw63rnv8pNj4mqaB9lynHD
         CVIwiQtzaeJQJ/aPfn3to9U1xUoHoMKYIHptk1IuRZ/LTA2HUf0hUwfutSRbv7zSIB
         m0u1tXxbrUdvxYSN1an2xxZsDJCK2BsexayTPUcY=
Date:   Sat, 21 May 2022 08:30:28 -0700
To:     mm-commits@vger.kernel.org, shuah@kernel.org,
        patrick.wang.shcn@gmail.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + selftests-vm-add-the-settings-file-with-timeout-variable.patch added to mm-unstable branch
Message-Id: <20220521153029.397B9C385B8@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: selftests: vm: add the "settings" file with timeout variable
has been added to the -mm mm-unstable branch.  Its filename is
     selftests-vm-add-the-settings-file-with-timeout-variable.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/selftests-vm-add-the-settings-file-with-timeout-variable.patch

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
From: Patrick Wang <patrick.wang.shcn@gmail.com>
Subject: selftests: vm: add the "settings" file with timeout variable
Date: Sat, 21 May 2022 16:38:25 +0800

The default "timeout" for one kselftest is 45 seconds, while some cases in
run_vmtests.sh require more time.  This will cause testing timeout like:

  not ok 4 selftests: vm: run_vmtests.sh # TIMEOUT 45 seconds

Therefore, add the "settings" file with timeout variable so users can set
the "timeout" value.

Link: https://lkml.kernel.org/r/20220521083825.319654-4-patrick.wang.shcn@gmail.com
Signed-off-by: Patrick Wang <patrick.wang.shcn@gmail.com>
Cc: Shuah Khan <shuah@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 tools/testing/selftests/vm/settings |    1 +
 1 file changed, 1 insertion(+)

--- /dev/null
+++ a/tools/testing/selftests/vm/settings
@@ -0,0 +1 @@
+timeout=45
_

Patches currently in -mm which might be from patrick.wang.shcn@gmail.com are

selftests-vm-check-numa_available-before-operating-merge_across_nodes-in-ksm_tests.patch
selftests-vm-add-test_hmmsh-to-test_files.patch
selftests-vm-add-the-settings-file-with-timeout-variable.patch

