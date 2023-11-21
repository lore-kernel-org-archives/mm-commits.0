Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 51C30C61D97
	for <mm-commits@archiver.kernel.org>; Tue, 21 Nov 2023 23:44:09 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229660AbjKUXoL (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 21 Nov 2023 18:44:11 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55330 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229794AbjKUXoK (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 21 Nov 2023 18:44:10 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 36340D1
        for <mm-commits@vger.kernel.org>; Tue, 21 Nov 2023 15:44:07 -0800 (PST)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 967AFC433C8;
        Tue, 21 Nov 2023 23:44:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1700610246;
        bh=pYD0qAiiOpsRr3uBcFAEOqyNQELwwN5t/XpR1zoZTZM=;
        h=Date:To:From:Subject:From;
        b=VTUHMn63jiBut/2vsEbVe4ir+tBwoRlrivSxLAxIdV5aIDHrCwz8TZycB06YMx6XY
         GRbh0NYCXOSuZTtAYuH6qk2EtCYNtDimxXCXBw3sFLpdifNUp8sliMYdn/Cz2ms/T4
         XAET/n4y4pkdosZeCGEPInl9B+MkaBqcWfZXCc5w=
Date:   Tue, 21 Nov 2023 15:44:06 -0800
To:     mm-commits@vger.kernel.org, shuah@kernel.org, jsavitz@redhat.com,
        npache@redhat.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + selftests-mm-prevent-duplicate-runs-caused-by-test_gen_progs.patch added to mm-hotfixes-unstable branch
Message-Id: <20231121234406.967AFC433C8@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: selftests/mm: prevent duplicate runs caused by TEST_GEN_PROGS
has been added to the -mm mm-hotfixes-unstable branch.  Its filename is
     selftests-mm-prevent-duplicate-runs-caused-by-test_gen_progs.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/selftests-mm-prevent-duplicate-runs-caused-by-test_gen_progs.patch

This patch will later appear in the mm-hotfixes-unstable branch at
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
Subject: selftests/mm: prevent duplicate runs caused by TEST_GEN_PROGS
Date: Mon, 20 Nov 2023 15:29:08 -0700

Commit 05f1edac8009 ("selftests/mm: run all tests from run_vmtests.sh")
fixed the inconsistency caused by tests being defined as TEST_GEN_PROGS. 
This issue was leading to tests not being executed via run_vmtests.sh and
furthermore some tests running twice due to the kselftests wrapper also
executing them.

Fix the definition of two tests (soft-dirty and pagemap_ioctl) that are
still incorrectly defined.

Link: https://lkml.kernel.org/r/20231120222908.28559-1-npache@redhat.com
Signed-off-by: Nico Pache <npache@redhat.com>
Cc: Joel Savitz <jsavitz@redhat.com>
Cc: Shuah Khan <shuah@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 tools/testing/selftests/mm/Makefile |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/tools/testing/selftests/mm/Makefile~selftests-mm-prevent-duplicate-runs-caused-by-test_gen_progs
+++ a/tools/testing/selftests/mm/Makefile
@@ -60,7 +60,7 @@ TEST_GEN_FILES += mrelease_test
 TEST_GEN_FILES += mremap_dontunmap
 TEST_GEN_FILES += mremap_test
 TEST_GEN_FILES += on-fault-limit
-TEST_GEN_PROGS += pagemap_ioctl
+TEST_GEN_FILES += pagemap_ioctl
 TEST_GEN_FILES += thuge-gen
 TEST_GEN_FILES += transhuge-stress
 TEST_GEN_FILES += uffd-stress
@@ -72,7 +72,7 @@ TEST_GEN_FILES += mdwe_test
 TEST_GEN_FILES += hugetlb_fault_after_madv
 
 ifneq ($(ARCH),arm64)
-TEST_GEN_PROGS += soft-dirty
+TEST_GEN_FILES += soft-dirty
 endif
 
 ifeq ($(ARCH),x86_64)
_

Patches currently in -mm which might be from npache@redhat.com are

selftests-mm-prevent-duplicate-runs-caused-by-test_gen_progs.patch

