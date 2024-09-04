Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EFA088002A
	for <mm-commits@vger.kernel.org>; Wed,  4 Sep 2024 04:20:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725423604; cv=none; b=qqCe9Nl6OcWfc456Rm1TgRgrnHiuXci59tjwYTVgwTcl6WJmgCU/D/ggzVkxmDZ6Anv3UQuHEcfdAx3n+w+4f/VM2iFcWh3L9jzgR7ly0eseDV9j3Ia1cy/ULfdqGC+U2c0Kl61NshnQzf8x+QM+pbrrKNX+chQPHQShDhFAjek=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725423604; c=relaxed/simple;
	bh=fs+DoIlTpnXfVK0Oiznb0GftkOhwAz2AhQTBUFmtX4o=;
	h=Date:To:From:Subject:Message-Id; b=YS/nh+F4bGojbD5X6gbTIEESLhcagOVx6msP669UjxKTgTjL37ruVXL9QknXqHUppK7RnbYZxUaEsIeKtbIN+H5MY+ltYTZmtfX0T98RaFsLsJk6PAIXH8XBRVQ0u9ibRJ6ANjEpBap+sf5uHVHmfDYJ9BvmYmWN1XUOu5/4H7k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=mZwj+xsM; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="mZwj+xsM"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C61EEC4CEC2;
	Wed,  4 Sep 2024 04:20:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1725423603;
	bh=fs+DoIlTpnXfVK0Oiznb0GftkOhwAz2AhQTBUFmtX4o=;
	h=Date:To:From:Subject:From;
	b=mZwj+xsMogoKZSGHgYN5zK9I08HB3BDst7GF3A/932k1VlWvuI3kVxDuXV+FLGGst
	 9HnGYEBCOYOs0r06o7a7TVeWb+uQ5JTtP/wdIPf5lb2fpVvCQ0SLBv/Ea+FbLwuqmP
	 jYhF80Afo6ZZlmCWXvGQUNF/J1CmTONjX6hm7RzM=
Date: Tue, 03 Sep 2024 21:20:03 -0700
To: mm-commits@vger.kernel.org,davidgow@google.com,brendanhiggins@google.com,sj@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-damon-core-test-fix-damon_test_ops_registration-for-damon_vaddr-unset-case.patch removed from -mm tree
Message-Id: <20240904042003.C61EEC4CEC2@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/damon/core-test: fix damon_test_ops_registration() for DAMON_VADDR unset case
has been removed from the -mm tree.  Its filename was
     mm-damon-core-test-fix-damon_test_ops_registration-for-damon_vaddr-unset-case.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: SeongJae Park <sj@kernel.org>
Subject: mm/damon/core-test: fix damon_test_ops_registration() for DAMON_VADDR unset case
Date: Mon, 26 Aug 2024 20:03:32 -0700

DAMON core kunit test can be executed without CONFIG_DAMON_VADDR.  In the
case, vaddr DAMON ops is not registered.  Meanwhile, ops registration
kunit test assumes the vaddr ops is registered.  Check and handle the case
by registrering fake vaddr ops inside the test code.

Link: https://lkml.kernel.org/r/20240827030336.7930-6-sj@kernel.org
Fixes: 4f540f5ab4f2 ("mm/damon/core-test: add a kunit test case for ops registration")
Signed-off-by: SeongJae Park <sj@kernel.org>
Cc: Brendan Higgins <brendanhiggins@google.com>
Cc: David Gow <davidgow@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/damon/core-test.h |   17 ++++++++++++++++-
 1 file changed, 16 insertions(+), 1 deletion(-)

--- a/mm/damon/core-test.h~mm-damon-core-test-fix-damon_test_ops_registration-for-damon_vaddr-unset-case
+++ a/mm/damon/core-test.h
@@ -247,8 +247,16 @@ static void damon_test_ops_registration(
 {
 	struct damon_ctx *c = damon_new_ctx();
 	struct damon_operations ops = {.id = DAMON_OPS_VADDR}, bak;
+	bool need_cleanup = false;
 
-	/* DAMON_OPS_VADDR is registered on subsys_initcall */
+	/* DAMON_OPS_VADDR is registered only if CONFIG_DAMON_VADDR is set */
+	if (!damon_is_registered_ops(DAMON_OPS_VADDR)) {
+		bak.id = DAMON_OPS_VADDR;
+		KUNIT_EXPECT_EQ(test, damon_register_ops(&bak), 0);
+		need_cleanup = true;
+	}
+
+	/* DAMON_OPS_VADDR is ensured to be registered */
 	KUNIT_EXPECT_EQ(test, damon_select_ops(c, DAMON_OPS_VADDR), 0);
 
 	/* Double-registration is prohibited */
@@ -274,6 +282,13 @@ static void damon_test_ops_registration(
 	KUNIT_EXPECT_EQ(test, damon_register_ops(&ops), -EINVAL);
 
 	damon_destroy_ctx(c);
+
+	if (need_cleanup) {
+		mutex_lock(&damon_ops_lock);
+		damon_registered_ops[DAMON_OPS_VADDR] =
+			(struct damon_operations){};
+		mutex_unlock(&damon_ops_lock);
+	}
 }
 
 static void damon_test_set_regions(struct kunit *test)
_

Patches currently in -mm which might be from sj@kernel.org are

mm-damon-core-intorduce-per-context-region-priorities-histogram-buffer.patch
mm-damon-core-replace-per-quota-regions-priority-histogram-buffer-usage-with-per-context-one.patch
mm-damon-core-remove-per-scheme-region-priority-histogram-buffer.patch
revert-mm-damon-lru_sort-adjust-local-variable-to-dynamic-allocation.patch
docs-damon-use-damonitor-github-organization-instead-of-awslabs.patch
docs-damon-maintainer-profile-add-links-in-place.patch
docs-damon-maintainer-profile-document-google-calendar-for-bi-weekly-meetups.patch

