Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0FE87C433FE
	for <mm-commits@archiver.kernel.org>; Thu, 14 Apr 2022 20:17:41 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346204AbiDNUUD (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 14 Apr 2022 16:20:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33204 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1346212AbiDNUT6 (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 14 Apr 2022 16:19:58 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 93BABEBAEF;
        Thu, 14 Apr 2022 13:17:32 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 289EF61EDC;
        Thu, 14 Apr 2022 20:17:32 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 77DAAC385A5;
        Thu, 14 Apr 2022 20:17:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1649967451;
        bh=vKKsSfNE+l/ghLPnJjWBCX4+UcBwoSBohEzKiUeKdMg=;
        h=Date:To:From:Subject:From;
        b=xlcMgSK2wRqqDuNIZR4ThI/+YOQp0+Cavc/2+mCuP1v6fp8i5Umb2rYSIKeeFu4wl
         uOJW6ljhTqn5BaBYLFBd0JGB5IsPnzHKlZ/yi85QTEAuHgAiHuLqMlBF8AXWAkmXNp
         h4/eATN7TcjCqlD2Edkch/hhj1sAXRhGmQ06J9q0=
Date:   Thu, 14 Apr 2022 13:17:30 -0700
To:     mm-commits@vger.kernel.org, stable@vger.kernel.org,
        shuah@kernel.org, sidhartha.kumar@oracle.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + selftest-vm-add-skip-support-to-mremap_test.patch added to -mm tree
Message-Id: <20220414201731.77DAAC385A5@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: selftest/vm: add skip support to mremap_test
has been added to the -mm tree.  Its filename is
     selftest-vm-add-skip-support-to-mremap_test.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/selftest-vm-add-skip-support-to-mremap_test.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/selftest-vm-add-skip-support-to-mremap_test.patch

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
Subject: selftest/vm: add skip support to mremap_test

Allow the mremap test to be skipped due to errors such as failing to find
a valid remap region and failure to parse the mmap_min_addr sysctl.

Link: https://lkml.kernel.org/r/20220414171529.62058-5-sidhartha.kumar@oracle.com
Signed-off-by: Sidhartha Kumar <sidhartha.kumar@oracle.com>
Cc: Shuah Khan <shuah@kernel.org>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---


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

Patches currently in -mm which might be from sidhartha.kumar@oracle.com are

selftest-vm-verify-mmap-addr-in-mremap_test.patch
selftest-vm-verify-remap-destination-address-in-mremap_test.patch
selftest-vm-support-xfail-in-mremap_test.patch
selftest-vm-add-skip-support-to-mremap_test.patch
selftest-vm-clarify-error-statement-in-gup_test.patch

