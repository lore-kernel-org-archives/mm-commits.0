Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 13C1BE94125
	for <mm-commits@archiver.kernel.org>; Fri,  6 Oct 2023 21:48:06 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233696AbjJFVsF (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 6 Oct 2023 17:48:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41696 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233840AbjJFVrx (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 6 Oct 2023 17:47:53 -0400
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7DD96CE
        for <mm-commits@vger.kernel.org>; Fri,  6 Oct 2023 14:47:51 -0700 (PDT)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BDF6CC433CA;
        Fri,  6 Oct 2023 21:47:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1696628871;
        bh=7UctPAl3BEB+FInAo4As1o2N3yhyCplE1gbVZUUER/c=;
        h=Date:To:From:Subject:From;
        b=0y05uqtWQeqO9GcDvdfhJSGIqHQWse+RganjF0D9mB1nJuEbdziLuKHM+zioI6Nrs
         QHZErUEppIQTnYxTrmhxG0kDsuMCpD1C9Bh7m2RglhqtXzpxHC1IIjXe8zuPw8dOxR
         nCs/qqM3EEE/jtYt4GNHPuxIbYlbjUxRjbYNUWWs=
Date:   Fri, 06 Oct 2023 14:47:48 -0700
To:     mm-commits@vger.kernel.org, toiwoton@gmail.com,
        Szabolcs.Nagy@arm.com, ryan.roberts@arm.com, peterx@redhat.com,
        mhocko@suse.com, kpsingh@kernel.org, keescook@chromium.org,
        joey.gouly@arm.com, izbyshev@ispras.ru, gthelen@google.com,
        david@redhat.com, catalin.marinas@arm.com, broonie@kernel.org,
        ayush.jain3@amd.com, anshuman.khandual@arm.com,
        revest@chromium.org, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] kselftest-vm-add-tests-for-no-inherit-memory-deny-write-execute.patch removed from -mm tree
Message-Id: <20231006214750.BDF6CC433CA@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: kselftest: vm: add tests for no-inherit memory-deny-write-execute
has been removed from the -mm tree.  Its filename was
     kselftest-vm-add-tests-for-no-inherit-memory-deny-write-execute.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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


