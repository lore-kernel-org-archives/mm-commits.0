Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 829CFE7D0BB
	for <mm-commits@archiver.kernel.org>; Fri, 22 Sep 2023 01:34:40 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230056AbjIVBeo (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 21 Sep 2023 21:34:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53938 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230078AbjIVBeh (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 21 Sep 2023 21:34:37 -0400
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C9884CF
        for <mm-commits@vger.kernel.org>; Thu, 21 Sep 2023 18:34:31 -0700 (PDT)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 68CEEC433C7;
        Fri, 22 Sep 2023 01:34:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1695346471;
        bh=eZrYfGeGYLjqPvEj1ZCkIZ4xZ/OgAadwdzuHrg1ITMw=;
        h=Date:To:From:Subject:From;
        b=xTAviD6WQTEE0PguicWk3YRIlZhHt3qp5eHQwEKg1JQdkmxZFz4Yq0qszwKNm2yRg
         G5EVH5wcqsA1st26E46pmUDCxYkPXSAs7GP78y8hzZ7JdEin2lKtLtHiv+9id9BIdF
         bvhqLHF6DvX6jwemIAa2L9YmvsadUkTFp61+3DtY=
Date:   Thu, 21 Sep 2023 18:34:30 -0700
To:     mm-commits@vger.kernel.org, toiwoton@gmail.com,
        Szabolcs.Nagy@arm.com, ryan.roberts@arm.com, peterx@redhat.com,
        mhocko@suse.com, kpsingh@kernel.org, keescook@chromium.org,
        joey.gouly@arm.com, izbyshev@ispras.ru, gthelen@google.com,
        david@redhat.com, catalin.marinas@arm.com, broonie@kernel.org,
        ayush.jain3@amd.com, anshuman.khandual@arm.com,
        revest@chromium.org, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + kselftest-vm-check-errnos-in-mdwe_test.patch added to mm-unstable branch
Message-Id: <20230922013431.68CEEC433C7@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: kselftest: vm: check errnos in mdwe_test
has been added to the -mm mm-unstable branch.  Its filename is
     kselftest-vm-check-errnos-in-mdwe_test.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/kselftest-vm-check-errnos-in-mdwe_test.patch

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
Subject: kselftest: vm: check errnos in mdwe_test
Date: Mon, 28 Aug 2023 17:08:55 +0200

Invalid prctls return a negative code and set errno.  It's good practice
to check that errno is set as expected.

Link: https://lkml.kernel.org/r/20230828150858.393570-4-revest@chromium.org
Signed-off-by: Florent Revest <revest@chromium.org>
Reviewed-by: Kees Cook <keescook@chromium.org>
Acked-by: Catalin Marinas <catalin.marinas@arm.com>
Cc: Alexey Izbyshev <izbyshev@ispras.ru>
Cc: Anshuman Khandual <anshuman.khandual@arm.com>
Cc: Ayush Jain <ayush.jain3@amd.com>
Cc: David Hildenbrand <david@redhat.com>
Cc: Greg Thelen <gthelen@google.com>
Cc: Joey Gouly <joey.gouly@arm.com>
Cc: KP Singh <kpsingh@kernel.org>
Cc: Mark Brown <broonie@kernel.org>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Peter Xu <peterx@redhat.com>
Cc: Ryan Roberts <ryan.roberts@arm.com>
Cc: Szabolcs Nagy <Szabolcs.Nagy@arm.com>
Cc: Topi Miettinen <toiwoton@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 tools/testing/selftests/mm/mdwe_test.c |    8 ++++++++
 1 file changed, 8 insertions(+)

--- a/tools/testing/selftests/mm/mdwe_test.c~kselftest-vm-check-errnos-in-mdwe_test
+++ a/tools/testing/selftests/mm/mdwe_test.c
@@ -23,14 +23,22 @@
 TEST(prctl_flags)
 {
 	EXPECT_LT(prctl(PR_SET_MDWE, 7L, 0L, 0L, 0L), 0);
+	EXPECT_EQ(errno, EINVAL);
 	EXPECT_LT(prctl(PR_SET_MDWE, 0L, 7L, 0L, 0L), 0);
+	EXPECT_EQ(errno, EINVAL);
 	EXPECT_LT(prctl(PR_SET_MDWE, 0L, 0L, 7L, 0L), 0);
+	EXPECT_EQ(errno, EINVAL);
 	EXPECT_LT(prctl(PR_SET_MDWE, 0L, 0L, 0L, 7L), 0);
+	EXPECT_EQ(errno, EINVAL);
 
 	EXPECT_LT(prctl(PR_GET_MDWE, 7L, 0L, 0L, 0L), 0);
+	EXPECT_EQ(errno, EINVAL);
 	EXPECT_LT(prctl(PR_GET_MDWE, 0L, 7L, 0L, 0L), 0);
+	EXPECT_EQ(errno, EINVAL);
 	EXPECT_LT(prctl(PR_GET_MDWE, 0L, 0L, 7L, 0L), 0);
+	EXPECT_EQ(errno, EINVAL);
 	EXPECT_LT(prctl(PR_GET_MDWE, 0L, 0L, 0L, 7L), 0);
+	EXPECT_EQ(errno, EINVAL);
 }
 
 FIXTURE(mdwe)
_

Patches currently in -mm which might be from revest@chromium.org are

kselftest-vm-fix-tabs-spaces-inconsistency-in-the-mdwe-test.patch
kselftest-vm-fix-mdwes-mmap_fixed-test-case.patch
kselftest-vm-check-errnos-in-mdwe_test.patch
mm-make-pr_mdwe_refuse_exec_gain-an-unsigned-long.patch
mm-add-a-no_inherit-flag-to-the-pr_set_mdwe-prctl.patch
kselftest-vm-add-tests-for-no-inherit-memory-deny-write-execute.patch

