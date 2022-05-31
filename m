Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 83071C433EF
	for <mm-commits@archiver.kernel.org>; Tue, 31 May 2022 18:41:05 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234983AbiEaSlE (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 31 May 2022 14:41:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49086 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234460AbiEaSlD (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 31 May 2022 14:41:03 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EBEAF915BB
        for <mm-commits@vger.kernel.org>; Tue, 31 May 2022 11:41:02 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id AA7FEB81236
        for <mm-commits@vger.kernel.org>; Tue, 31 May 2022 18:41:01 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5D68DC385A9;
        Tue, 31 May 2022 18:41:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1654022460;
        bh=jDXjb2mgwKjx0o0D4EL48KMYUlzXopXbYmDj6X71D5c=;
        h=Date:To:From:Subject:From;
        b=RvHs/LoncCHwL7D8qh2cfrjmbB+G9NFiHUsjMBGpxYs42O5IGYSPPZp/LQiEwSbob
         HMZYD5AUL/Z5RxWqvYbNAqCJ8IUJlhkTQS3Ag8PaSnv53+1xyQ5cABIf/fPBKSzDRO
         TDNs71uIDTEJviYvgweJC/i7ihWgHphVCO/l32xI=
Date:   Tue, 31 May 2022 11:40:59 -0700
To:     mm-commits@vger.kernel.org, shuah@kernel.org,
        kalpana.shetty@amd.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + selftests-vm-add-protection_keys-tests-to-run_vmtests.patch added to mm-unstable branch
Message-Id: <20220531184100.5D68DC385A9@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: selftests/vm: add protection_keys tests to run_vmtests
has been added to the -mm mm-unstable branch.  Its filename is
     selftests-vm-add-protection_keys-tests-to-run_vmtests.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/selftests-vm-add-protection_keys-tests-to-run_vmtests.patch

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
Subject: selftests/vm: add protection_keys tests to run_vmtests
Date: Tue, 31 May 2022 15:55:56 +0530

Link: https://lkml.kernel.org/r/20220531102556.388-1-kalpana.shetty@amd.com
Signed-off-by: Kalpana Shetty <kalpana.shetty@amd.com>
Cc: Shuah Khan <shuah@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 tools/testing/selftests/vm/run_vmtests.sh |    7 +++++++
 1 file changed, 7 insertions(+)

--- a/tools/testing/selftests/vm/run_vmtests.sh~selftests-vm-add-protection_keys-tests-to-run_vmtests
+++ a/tools/testing/selftests/vm/run_vmtests.sh
@@ -179,4 +179,11 @@ run_test ./ksm_tests -N -m 1
 # KSM test with 2 NUMA nodes and merge_across_nodes = 0
 run_test ./ksm_tests -N -m 0
 
+# protection_keys tests
+if [ $VADDR64 -eq 0 ]; then
+	run_test ./protection_keys_32
+else
+	run_test ./protection_keys_64
+fi
+
 exit $exitcode
_

Patches currently in -mm which might be from kalpana.shetty@amd.com are

selftests-vm-add-protection_keys-tests-to-run_vmtests.patch

