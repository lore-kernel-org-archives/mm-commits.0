Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EE9CAC433EF
	for <mm-commits@archiver.kernel.org>; Sat, 21 May 2022 15:30:30 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245063AbiEUPaa (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Sat, 21 May 2022 11:30:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60674 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230448AbiEUPa3 (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Sat, 21 May 2022 11:30:29 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 60D9293466
        for <mm-commits@vger.kernel.org>; Sat, 21 May 2022 08:30:28 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id EFC2C60C52
        for <mm-commits@vger.kernel.org>; Sat, 21 May 2022 15:30:27 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 31A37C385A5;
        Sat, 21 May 2022 15:30:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1653147027;
        bh=PqNwJeWtgd8Mql+gUJCjxIE6Ua6u7amhbnR85KpQKoU=;
        h=Date:To:From:Subject:From;
        b=PjwcTWyr9Z5/WEEvgLDoy+hlyrqn+gTvmd1CTq/hzpspEPE/ggKKcW81TzKjxAWr9
         RSIs9ydWZo351LbMKFoYv/7e8/Jys87GUR0fYrW3NZLNumV51+r5/0ujPziXtd5aBo
         lqFNgw734vMARWim+wPDQ91iio/d/6smljsMAC0w=
Date:   Sat, 21 May 2022 08:30:25 -0700
To:     mm-commits@vger.kernel.org, shuah@kernel.org,
        patrick.wang.shcn@gmail.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + selftests-vm-add-test_hmmsh-to-test_files.patch added to mm-unstable branch
Message-Id: <20220521153027.31A37C385A5@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: selftests: vm: add "test_hmm.sh" to TEST_FILES
has been added to the -mm mm-unstable branch.  Its filename is
     selftests-vm-add-test_hmmsh-to-test_files.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/selftests-vm-add-test_hmmsh-to-test_files.patch

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
Subject: selftests: vm: add "test_hmm.sh" to TEST_FILES
Date: Sat, 21 May 2022 16:38:24 +0800

The "test_hmm.sh" file used by run_vmtests.sh dose not be installed into
INSTALL_PATH.  Thus run_vmtests.sh can not call it in INSTALL_PATH:

  ---------------------------
  running ./test_hmm.sh smoke
  ---------------------------
  ./run_vmtests.sh: line 74: ./test_hmm.sh: No such file or directory
  [FAIL]
  -----------------------

Add "test_hmm.sh" to TEST_FILES so that it will be installed.

Link: https://lkml.kernel.org/r/20220521083825.319654-3-patrick.wang.shcn@gmail.com
Signed-off-by: Patrick Wang <patrick.wang.shcn@gmail.com>
Cc: Shuah Khan <shuah@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 tools/testing/selftests/vm/Makefile |    1 +
 1 file changed, 1 insertion(+)

--- a/tools/testing/selftests/vm/Makefile~selftests-vm-add-test_hmmsh-to-test_files
+++ a/tools/testing/selftests/vm/Makefile
@@ -92,6 +92,7 @@ endif
 TEST_PROGS := run_vmtests.sh
 
 TEST_FILES := test_vmalloc.sh
+TEST_FILES += test_hmm.sh
 
 KSFT_KHDR_INSTALL := 1
 include ../lib.mk
_

Patches currently in -mm which might be from patrick.wang.shcn@gmail.com are

selftests-vm-check-numa_available-before-operating-merge_across_nodes-in-ksm_tests.patch
selftests-vm-add-test_hmmsh-to-test_files.patch
selftests-vm-add-the-settings-file-with-timeout-variable.patch

