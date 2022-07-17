Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E1A6AC433EF
	for <mm-commits@archiver.kernel.org>; Sun, 17 Jul 2022 23:24:33 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229573AbiGQXYd (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Sun, 17 Jul 2022 19:24:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38026 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229536AbiGQXYc (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Sun, 17 Jul 2022 19:24:32 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E4021120AC
        for <mm-commits@vger.kernel.org>; Sun, 17 Jul 2022 16:24:31 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id BA0ACB80E4E
        for <mm-commits@vger.kernel.org>; Sun, 17 Jul 2022 23:24:29 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 40EBCC3411E;
        Sun, 17 Jul 2022 23:24:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1658100268;
        bh=onyXTkjErXzEZFjQ70SYlBCJc/lFUOQLYSoSndfSBAM=;
        h=Date:To:From:Subject:From;
        b=uanvbUbFZX/ANcwrmxxbeyOVwoC3VAvPP3e40wa38gh9EghCpjWkrII4VdqzZwe1H
         jdeVLurAoMxkNB66vEridbYtqK+URATy4MfKTEVLcnFznOFtd+Mtn/Dzz7i//2UvYl
         GF4N8OVpwdKwFmJgGziKFkR5jFddYglvno4S84AY=
Date:   Sun, 17 Jul 2022 16:24:27 -0700
To:     mm-commits@vger.kernel.org, shuah@kernel.org,
        kalpana.shetty@amd.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [folded-merged] selftests-vm-add-protection_keys-tests-to-run_vmtests-v4.patch removed from -mm tree
Message-Id: <20220717232428.40EBCC3411E@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: selftests-vm-add-protection_keys-tests-to-run_vmtests-v4
has been removed from the -mm tree.  Its filename was
     selftests-vm-add-protection_keys-tests-to-run_vmtests-v4.patch

This patch was dropped because it was folded into selftests-vm-add-protection_keys-tests-to-run_vmtests.patch

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

