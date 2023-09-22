Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F2258E7D0BD
	for <mm-commits@archiver.kernel.org>; Fri, 22 Sep 2023 01:34:32 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230010AbjIVBeh (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 21 Sep 2023 21:34:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53932 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230153AbjIVBeg (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 21 Sep 2023 21:34:36 -0400
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0620E102
        for <mm-commits@vger.kernel.org>; Thu, 21 Sep 2023 18:34:30 -0700 (PDT)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 99A2DC433C9;
        Fri, 22 Sep 2023 01:34:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1695346469;
        bh=J1ZIA4jrgxOxPHOvxF0lYZNbYOdyW7jcFoQ2wh3mxEU=;
        h=Date:To:From:Subject:From;
        b=NWV32X1Qt/EQyH7TokrcECcBt7RaQBO/aeOqmeffsn7UN35hwVzVL0xdkTIsZ/Bvn
         skPFKmwzqZO3KQSnt3p+qZhZt5T69k/cn2soGThbTrhAnrRTFaUTbBSZBuvm2IM4fu
         qOnKZZnk+lUz3jBsDigk5hNu4eyN8I0c9tYrM7bo=
Date:   Thu, 21 Sep 2023 18:34:29 -0700
To:     mm-commits@vger.kernel.org, toiwoton@gmail.com,
        Szabolcs.Nagy@arm.com, ryan.roberts@arm.com, peterx@redhat.com,
        mhocko@suse.com, kpsingh@kernel.org, keescook@chromium.org,
        joey.gouly@arm.com, izbyshev@ispras.ru, gthelen@google.com,
        david@redhat.com, catalin.marinas@arm.com, broonie@kernel.org,
        ayush.jain3@amd.com, anshuman.khandual@arm.com,
        revest@chromium.org, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + kselftest-vm-fix-mdwes-mmap_fixed-test-case.patch added to mm-unstable branch
Message-Id: <20230922013429.99A2DC433C9@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: kselftest: vm: fix mdwe's mmap_FIXED test case
has been added to the -mm mm-unstable branch.  Its filename is
     kselftest-vm-fix-mdwes-mmap_fixed-test-case.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/kselftest-vm-fix-mdwes-mmap_fixed-test-case.patch

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
From: Florent Revest <revest@chromium.org>
Subject: kselftest: vm: fix mdwe's mmap_FIXED test case
Date: Mon, 28 Aug 2023 17:08:54 +0200

I checked with the original author, the mmap_FIXED test case wasn't
properly tested and fails.  Currently, it maps two consecutive (non
overlapping) pages and expects the second mapping to be denied by MDWE but
these two pages have nothing to do with each other so MDWE is actually out
of the picture here.

What the test actually intended to do was to remap a virtual address using
MAP_FIXED.  However, this operation unmaps the existing mapping and
creates a new one so the va is backed by a new page and MDWE is again out
of the picture, all remappings should succeed.

This patch keeps the test case to make it clear that this situation is
expected to work: MDWE shouldn't block a MAP_FIXED replacement.

Link: https://lkml.kernel.org/r/20230828150858.393570-3-revest@chromium.org
Fixes: 4cf1fe34fd18 ("kselftest: vm: add tests for memory-deny-write-execute")
Signed-off-by: Florent Revest <revest@chromium.org>
Reviewed-by: David Hildenbrand <david@redhat.com>
Reviewed-by: Kees Cook <keescook@chromium.org>
Reviewed-by: Catalin Marinas <catalin.marinas@arm.com>
Reviewed-by: Ryan Roberts <ryan.roberts@arm.com>
Tested-by: Ryan Roberts <ryan.roberts@arm.com>
Tested-by: Ayush Jain <ayush.jain3@amd.com>
Cc: Alexey Izbyshev <izbyshev@ispras.ru>
Cc: Anshuman Khandual <anshuman.khandual@arm.com>
Cc: Greg Thelen <gthelen@google.com>
Cc: Joey Gouly <joey.gouly@arm.com>
Cc: KP Singh <kpsingh@kernel.org>
Cc: Mark Brown <broonie@kernel.org>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Peter Xu <peterx@redhat.com>
Cc: Szabolcs Nagy <Szabolcs.Nagy@arm.com>
Cc: Topi Miettinen <toiwoton@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 tools/testing/selftests/mm/mdwe_test.c |    9 +++------
 1 file changed, 3 insertions(+), 6 deletions(-)

--- a/tools/testing/selftests/mm/mdwe_test.c~kselftest-vm-fix-mdwes-mmap_fixed-test-case
+++ a/tools/testing/selftests/mm/mdwe_test.c
@@ -168,13 +168,10 @@ TEST_F(mdwe, mmap_FIXED)
 	self->p = mmap(NULL, self->size, PROT_READ, self->flags, 0, 0);
 	ASSERT_NE(self->p, MAP_FAILED);
 
-	p = mmap(self->p + self->size, self->size, PROT_READ | PROT_EXEC,
+	/* MAP_FIXED unmaps the existing page before mapping which is allowed */
+	p = mmap(self->p, self->size, PROT_READ | PROT_EXEC,
 		 self->flags | MAP_FIXED, 0, 0);
-	if (variant->enabled) {
-		EXPECT_EQ(p, MAP_FAILED);
-	} else {
-		EXPECT_EQ(p, self->p);
-	}
+	EXPECT_EQ(p, self->p);
 }
 
 TEST_F(mdwe, arm64_BTI)
_

Patches currently in -mm which might be from revest@chromium.org are

kselftest-vm-fix-tabs-spaces-inconsistency-in-the-mdwe-test.patch
kselftest-vm-fix-mdwes-mmap_fixed-test-case.patch
kselftest-vm-check-errnos-in-mdwe_test.patch
mm-make-pr_mdwe_refuse_exec_gain-an-unsigned-long.patch
mm-add-a-no_inherit-flag-to-the-pr_set_mdwe-prctl.patch
kselftest-vm-add-tests-for-no-inherit-memory-deny-write-execute.patch

