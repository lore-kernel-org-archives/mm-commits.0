Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id ECFE7FA3740
	for <mm-commits@archiver.kernel.org>; Thu, 27 Oct 2022 19:23:11 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236249AbiJ0TXL (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 27 Oct 2022 15:23:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49254 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234804AbiJ0TXK (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 27 Oct 2022 15:23:10 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0C04363D3E
        for <mm-commits@vger.kernel.org>; Thu, 27 Oct 2022 12:23:10 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 9C0A362431
        for <mm-commits@vger.kernel.org>; Thu, 27 Oct 2022 19:23:09 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D9700C433D6;
        Thu, 27 Oct 2022 19:23:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1666898589;
        bh=zd+V/yOyTulnAAL52DH2l4MT8fisJTpFSjGUdHeiqe8=;
        h=Date:To:From:Subject:From;
        b=Gj5n1fQqnPJMBYupT32WWCuvLHrg/DcLRrYAlyX6tWrazM0l4OWkIeZp0pSEqQ/Ty
         2f6OuF3lQf9fmi+XsRLx9/LVrUk3iuI87wlb+aIh3QNViUymSqNqdPPxwAgC/kpM40
         Oksg5Ar5hZK7kPwf80J/dnNUofvq8wcN00tUB5dA=
Date:   Thu, 27 Oct 2022 12:23:07 -0700
To:     mm-commits@vger.kernel.org, shuah@kernel.org, npache@redhat.com,
        jsavitz@redhat.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + selftests-vm-add-ksm-unmerge-tests-fix.patch added to mm-unstable branch
Message-Id: <20221027192308.D9700C433D6@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: selftests/vm: add CATEGORY for ksm_functional_tests
has been added to the -mm mm-unstable branch.  Its filename is
     selftests-vm-add-ksm-unmerge-tests-fix.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/selftests-vm-add-ksm-unmerge-tests-fix.patch

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
From: Joel Savitz <jsavitz@redhat.com>
Subject: selftests/vm: add CATEGORY for ksm_functional_tests
Date: Thu, 27 Oct 2022 13:00:43 -0400

commit ("selftests/vm: add KSM unmerge tests") in linux-next adds an entry
to run_vmtests.sh.  I recently submitted commit b5ba705c2608
("selftests/vm: enable running select groups of tests") to linux-next
which categorizes tests by functionality in order to allow more precise
selection of which tests are to be run.

Since this newest test targets ksm and does not require more than one numa
node, add 'CATEGORY="ksm"' to the invocation to group this test with the
other ksm tests.

Link: https://lkml.kernel.org/r/20221027170043.2363797-1-jsavitz@redhat.com
Signed-off-by: Joel Savitz <jsavitz@redhat.com>
Cc: Joel Savitz <jsavitz@redhat.com>
Cc: Nico Pache <npache@redhat.com>
Cc: Shuah Khan <shuah@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---


--- a/tools/testing/selftests/vm/run_vmtests.sh~selftests-vm-add-ksm-unmerge-tests-fix
+++ a/tools/testing/selftests/vm/run_vmtests.sh
@@ -252,7 +252,7 @@ CATEGORY="ksm_numa" run_test ./ksm_tests
 # KSM test with 2 NUMA nodes and merge_across_nodes = 0
 CATEGORY="ksm_numa" run_test ./ksm_tests -N -m 0
 
-run_test ./ksm_functional_tests
+CATEGORY="ksm" run_test ./ksm_functional_tests
 
 # protection_keys tests
 if [ -x ./protection_keys_32 ]
_

Patches currently in -mm which might be from jsavitz@redhat.com are

selftests-vm-enable-running-select-groups-of-tests.patch
selftests-vm-add-ksm-unmerge-tests-fix.patch

