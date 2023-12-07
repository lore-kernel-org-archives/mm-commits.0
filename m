Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 53DFBC10F07
	for <mm-commits@archiver.kernel.org>; Thu,  7 Dec 2023 00:13:42 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1442031AbjLGANe (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 6 Dec 2023 19:13:34 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43666 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1442082AbjLGAN2 (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 6 Dec 2023 19:13:28 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0CB1ED51
        for <mm-commits@vger.kernel.org>; Wed,  6 Dec 2023 16:13:35 -0800 (PST)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9C3EAC433C7;
        Thu,  7 Dec 2023 00:13:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1701908014;
        bh=0bklYcwDDDVtCUTpgSRe+OfXY1AVYlhhd1Ci0Ll7Lz8=;
        h=Date:To:From:Subject:From;
        b=ZlGS4Wj1WYn6qr0uh1pK5viwchWIku28WtAvieMTtY/vo27f3jlNvbuRv9go81p/J
         uJEDA7venagg5qeKr3/OYx2VBcwvsz28eLcoUxNrDWslcLhjhV6Go30ZwJrPeJQ+Bn
         pRwNK+Po+gK3JYvGCfl+p02EkDyAwFB4YilxuMg8=
Date:   Wed, 06 Dec 2023 16:13:34 -0800
To:     mm-commits@vger.kernel.org, shuah@kernel.org, jsavitz@redhat.com,
        david@redhat.com, npache@redhat.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-hotfixes-stable] selftests-mm-prevent-duplicate-runs-caused-by-test_gen_progs.patch removed from -mm tree
Message-Id: <20231207001334.9C3EAC433C7@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: selftests/mm: prevent duplicate runs caused by TEST_GEN_PROGS
has been removed from the -mm tree.  Its filename was
     selftests-mm-prevent-duplicate-runs-caused-by-test_gen_progs.patch

This patch was dropped because it was merged into the mm-hotfixes-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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
Reviewed-by: David Hildenbrand <david@redhat.com>
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

selftests-mm-dont-run-ksm_functional_tests-twice.patch

