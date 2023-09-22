Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 107A4E7D0BC
	for <mm-commits@archiver.kernel.org>; Fri, 22 Sep 2023 01:34:49 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230137AbjIVBex (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 21 Sep 2023 21:34:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42670 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230133AbjIVBep (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 21 Sep 2023 21:34:45 -0400
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EBC9DCF
        for <mm-commits@vger.kernel.org>; Thu, 21 Sep 2023 18:34:38 -0700 (PDT)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8667BC433C7;
        Fri, 22 Sep 2023 01:34:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1695346478;
        bh=z8ygBXPm1SbwgxXRs8oRMBvxDDzDOTuEZmfo7TJ8LFg=;
        h=Date:To:From:Subject:From;
        b=Ve+jo8wLVqTzrqNlZiF5p9g+PeGJZ6KE1nys7lUGIkhcQegNntICmpLXtoUhUbDBs
         5xVdGRvqexp4LwWpciGdy+hVi8u2tVqEVf+wT/9Knfb+gifbLqQb7e9l/WR73t7CLn
         agcuFWE6r7IorqdVy9Kghxo9mRcAQGDMaP7I7oqE=
Date:   Thu, 21 Sep 2023 18:34:38 -0700
To:     mm-commits@vger.kernel.org, toiwoton@gmail.com,
        Szabolcs.Nagy@arm.com, ryan.roberts@arm.com, peterx@redhat.com,
        mhocko@suse.com, kpsingh@kernel.org, keescook@chromium.org,
        joey.gouly@arm.com, izbyshev@ispras.ru, gthelen@google.com,
        david@redhat.com, catalin.marinas@arm.com, broonie@kernel.org,
        ayush.jain3@amd.com, anshuman.khandual@arm.com,
        revest@chromium.org, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + kselftest-vm-add-tests-for-no-inherit-memory-deny-write-execute.patch added to mm-unstable branch
Message-Id: <20230922013438.8667BC433C7@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: kselftest: vm: add tests for no-inherit memory-deny-write-execute
has been added to the -mm mm-unstable branch.  Its filename is
     kselftest-vm-add-tests-for-no-inherit-memory-deny-write-execute.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/kselftest-vm-add-tests-for-no-inherit-memory-deny-write-execute.patch

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
Subject: kselftest: vm: add tests for no-inherit memory-deny-write-execute
Date: Mon, 28 Aug 2023 17:08:58 +0200

Add some tests to cover the new PR_MDWE_NO_INHERIT flag of the
PR_SET_MDWE prctl.

Check that:
- it can't be set without PR_SET_MDWE
- MDWE flags can't be unset
- when set, PR_SET_MDWE doesn't propagate to children

Link: https://lkml.kernel.org/r/20230828150858.393570-7-revest@chromium.org
Signed-off-by: Florent Revest <revest@chromium.org>
Acked-by: Catalin Marinas <catalin.marinas@arm.com>
Reviewed-by: Kees Cook <keescook@chromium.org>
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

 tools/testing/selftests/mm/mdwe_test.c |  114 +++++++++++++++++++++--
 1 file changed, 108 insertions(+), 6 deletions(-)

--- a/tools/testing/selftests/mm/mdwe_test.c~kselftest-vm-add-tests-for-no-inherit-memory-deny-write-execute
+++ a/tools/testing/selftests/mm/mdwe_test.c
@@ -22,6 +22,9 @@
 
 TEST(prctl_flags)
 {
+	EXPECT_LT(prctl(PR_SET_MDWE, PR_MDWE_NO_INHERIT, 0L, 0L, 7L), 0);
+	EXPECT_EQ(errno, EINVAL);
+
 	EXPECT_LT(prctl(PR_SET_MDWE, 7L, 0L, 0L, 0L), 0);
 	EXPECT_EQ(errno, EINVAL);
 	EXPECT_LT(prctl(PR_SET_MDWE, 0L, 7L, 0L, 0L), 0);
@@ -41,6 +44,84 @@ TEST(prctl_flags)
 	EXPECT_EQ(errno, EINVAL);
 }
 
+FIXTURE(consecutive_prctl_flags) {};
+FIXTURE_SETUP(consecutive_prctl_flags) {}
+FIXTURE_TEARDOWN(consecutive_prctl_flags) {}
+
+FIXTURE_VARIANT(consecutive_prctl_flags)
+{
+	unsigned long first_flags;
+	unsigned long second_flags;
+	bool should_work;
+};
+
+FIXTURE_VARIANT_ADD(consecutive_prctl_flags, can_keep_no_flags)
+{
+	.first_flags = 0,
+	.second_flags = 0,
+	.should_work = true,
+};
+
+FIXTURE_VARIANT_ADD(consecutive_prctl_flags, can_keep_exec_gain)
+{
+	.first_flags = PR_MDWE_REFUSE_EXEC_GAIN,
+	.second_flags = PR_MDWE_REFUSE_EXEC_GAIN,
+	.should_work = true,
+};
+
+FIXTURE_VARIANT_ADD(consecutive_prctl_flags, can_keep_both_flags)
+{
+	.first_flags = PR_MDWE_REFUSE_EXEC_GAIN | PR_MDWE_NO_INHERIT,
+	.second_flags = PR_MDWE_REFUSE_EXEC_GAIN | PR_MDWE_NO_INHERIT,
+	.should_work = true,
+};
+
+FIXTURE_VARIANT_ADD(consecutive_prctl_flags, cant_disable_mdwe)
+{
+	.first_flags = PR_MDWE_REFUSE_EXEC_GAIN,
+	.second_flags = 0,
+	.should_work = false,
+};
+
+FIXTURE_VARIANT_ADD(consecutive_prctl_flags, cant_disable_mdwe_no_inherit)
+{
+	.first_flags = PR_MDWE_REFUSE_EXEC_GAIN | PR_MDWE_NO_INHERIT,
+	.second_flags = 0,
+	.should_work = false,
+};
+
+FIXTURE_VARIANT_ADD(consecutive_prctl_flags, cant_disable_no_inherit)
+{
+	.first_flags = PR_MDWE_REFUSE_EXEC_GAIN | PR_MDWE_NO_INHERIT,
+	.second_flags = PR_MDWE_REFUSE_EXEC_GAIN,
+	.should_work = false,
+};
+
+FIXTURE_VARIANT_ADD(consecutive_prctl_flags, cant_enable_no_inherit)
+{
+	.first_flags = PR_MDWE_REFUSE_EXEC_GAIN,
+	.second_flags = PR_MDWE_REFUSE_EXEC_GAIN | PR_MDWE_NO_INHERIT,
+	.should_work = false,
+};
+
+TEST_F(consecutive_prctl_flags, two_prctls)
+{
+	int ret;
+
+	EXPECT_EQ(prctl(PR_SET_MDWE, variant->first_flags, 0L, 0L, 0L), 0);
+
+	ret = prctl(PR_SET_MDWE, variant->second_flags, 0L, 0L, 0L);
+	if (variant->should_work) {
+		EXPECT_EQ(ret, 0);
+
+		ret = prctl(PR_GET_MDWE, 0L, 0L, 0L, 0L);
+		ASSERT_EQ(ret, variant->second_flags);
+	} else {
+		EXPECT_NE(ret, 0);
+		ASSERT_EQ(errno, EPERM);
+	}
+}
+
 FIXTURE(mdwe)
 {
 	void *p;
@@ -53,28 +134,45 @@ FIXTURE_VARIANT(mdwe)
 {
 	bool enabled;
 	bool forked;
+	bool inherit;
 };
 
 FIXTURE_VARIANT_ADD(mdwe, stock)
 {
 	.enabled = false,
 	.forked = false,
+	.inherit = false,
 };
 
 FIXTURE_VARIANT_ADD(mdwe, enabled)
 {
 	.enabled = true,
 	.forked = false,
+	.inherit = true,
 };
 
-FIXTURE_VARIANT_ADD(mdwe, forked)
+FIXTURE_VARIANT_ADD(mdwe, inherited)
 {
 	.enabled = true,
 	.forked = true,
+	.inherit = true,
 };
 
+FIXTURE_VARIANT_ADD(mdwe, not_inherited)
+{
+	.enabled = true,
+	.forked = true,
+	.inherit = false,
+};
+
+static bool executable_map_should_fail(const FIXTURE_VARIANT(mdwe) *variant)
+{
+	return variant->enabled && (!variant->forked || variant->inherit);
+}
+
 FIXTURE_SETUP(mdwe)
 {
+	unsigned long mdwe_flags;
 	int ret, status;
 
 	self->p = NULL;
@@ -84,13 +182,17 @@ FIXTURE_SETUP(mdwe)
 	if (!variant->enabled)
 		return;
 
-	ret = prctl(PR_SET_MDWE, PR_MDWE_REFUSE_EXEC_GAIN, 0L, 0L, 0L);
+	mdwe_flags = PR_MDWE_REFUSE_EXEC_GAIN;
+	if (!variant->inherit)
+		mdwe_flags |= PR_MDWE_NO_INHERIT;
+
+	ret = prctl(PR_SET_MDWE, mdwe_flags, 0L, 0L, 0L);
 	ASSERT_EQ(ret, 0) {
 		TH_LOG("PR_SET_MDWE failed or unsupported");
 	}
 
 	ret = prctl(PR_GET_MDWE, 0L, 0L, 0L, 0L);
-	ASSERT_EQ(ret, 1);
+	ASSERT_EQ(ret, mdwe_flags);
 
 	if (variant->forked) {
 		self->pid = fork();
@@ -121,7 +223,7 @@ TEST_F(mdwe, mmap_READ_EXEC)
 TEST_F(mdwe, mmap_WRITE_EXEC)
 {
 	self->p = mmap(NULL, self->size, PROT_WRITE | PROT_EXEC, self->flags, 0, 0);
-	if (variant->enabled) {
+	if (executable_map_should_fail(variant)) {
 		EXPECT_EQ(self->p, MAP_FAILED);
 	} else {
 		EXPECT_NE(self->p, MAP_FAILED);
@@ -147,7 +249,7 @@ TEST_F(mdwe, mprotect_add_EXEC)
 	ASSERT_NE(self->p, MAP_FAILED);
 
 	ret = mprotect(self->p, self->size, PROT_READ | PROT_EXEC);
-	if (variant->enabled) {
+	if (executable_map_should_fail(variant)) {
 		EXPECT_LT(ret, 0);
 	} else {
 		EXPECT_EQ(ret, 0);
@@ -162,7 +264,7 @@ TEST_F(mdwe, mprotect_WRITE_EXEC)
 	ASSERT_NE(self->p, MAP_FAILED);
 
 	ret = mprotect(self->p, self->size, PROT_WRITE | PROT_EXEC);
-	if (variant->enabled) {
+	if (executable_map_should_fail(variant)) {
 		EXPECT_LT(ret, 0);
 	} else {
 		EXPECT_EQ(ret, 0);
_

Patches currently in -mm which might be from revest@chromium.org are

kselftest-vm-fix-tabs-spaces-inconsistency-in-the-mdwe-test.patch
kselftest-vm-fix-mdwes-mmap_fixed-test-case.patch
kselftest-vm-check-errnos-in-mdwe_test.patch
mm-make-pr_mdwe_refuse_exec_gain-an-unsigned-long.patch
mm-add-a-no_inherit-flag-to-the-pr_set_mdwe-prctl.patch
kselftest-vm-add-tests-for-no-inherit-memory-deny-write-execute.patch

