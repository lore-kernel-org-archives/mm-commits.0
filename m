Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 76193CCA480
	for <mm-commits@archiver.kernel.org>; Mon, 18 Jul 2022 00:16:28 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231937AbiGRAQ1 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Sun, 17 Jul 2022 20:16:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56576 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229680AbiGRAQ0 (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Sun, 17 Jul 2022 20:16:26 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4B9B095BD
        for <mm-commits@vger.kernel.org>; Sun, 17 Jul 2022 17:16:25 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id F17B3B80EE6
        for <mm-commits@vger.kernel.org>; Mon, 18 Jul 2022 00:16:23 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A465EC341C0;
        Mon, 18 Jul 2022 00:16:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1658103382;
        bh=6/vVpx3O+Cxkcm6A3YXM0fXWeEZNblKdYemW7bO6Enw=;
        h=Date:To:From:Subject:From;
        b=tJVXObrwkjmmj0wtx6KSIHffzzZpYIgKeQ1Ca6FolMKgH376pIrMdBCp+Oq25Mj8j
         NNm0+EHphPbI5BP+BmaB1caGrezIG0PMR7imLRZV6wARePzcQjsSdFsLwXhT4KyyDC
         G+4dwAW4jrr3BJCYQg5x34aCd8BZHN69p5F45m3A=
Date:   Sun, 17 Jul 2022 17:16:21 -0700
To:     mm-commits@vger.kernel.org, shuah@kernel.org,
        kalpana.shetty@amd.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] selftests-vm-add-protection_keys-tests-to-run_vmtests.patch removed from -mm tree
Message-Id: <20220718001622.A465EC341C0@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: selftests/vm: add protection_keys tests to run_vmtests
has been removed from the -mm tree.  Its filename was
     selftests-vm-add-protection_keys-tests-to-run_vmtests.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Kalpana Shetty <kalpana.shetty@amd.com>
Subject: selftests/vm: add protection_keys tests to run_vmtests
Date: Tue, 31 May 2022 15:55:56 +0530

Add "protected_keys" tests to "run_vmtests.sh" would help run all VM
related tests from a single shell script.

[kalpana.shetty@amd.com: Shuah Khan's review comments incorporated, added -x executable check]
  Link: https://lkml.kernel.org/r/20220617202931.357-1-kalpana.shetty@amd.com
Link: https://lkml.kernel.org/r/20220610090704.296-1-kalpana.shetty@amd.com
Link: https://lkml.kernel.org/r/20220531102556.388-1-kalpana.shetty@amd.com
Signed-off-by: Kalpana Shetty <kalpana.shetty@amd.com>
Cc: Shuah Khan <shuah@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 tools/testing/selftests/vm/run_vmtests.sh |   11 +++++++++++
 1 file changed, 11 insertions(+)

--- a/tools/testing/selftests/vm/run_vmtests.sh~selftests-vm-add-protection_keys-tests-to-run_vmtests
+++ a/tools/testing/selftests/vm/run_vmtests.sh
@@ -179,4 +179,15 @@ run_test ./ksm_tests -N -m 1
 # KSM test with 2 NUMA nodes and merge_across_nodes = 0
 run_test ./ksm_tests -N -m 0
 
+# protection_keys tests
+if [ -x ./protection_keys_32 ]
+then
+	run_test ./protection_keys_32
+fi
+
+if [ -x ./protection_keys_64 ]
+then
+	run_test ./protection_keys_64
+fi
+
 exit $exitcode
_

Patches currently in -mm which might be from kalpana.shetty@amd.com are


