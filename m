Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7864A34D4D8
	for <mm-commits@vger.kernel.org>; Fri,  6 Mar 2026 22:44:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772837073; cv=none; b=MmIamLHJRxYxhY2EOu9tnYHYl4DYem2ElXXbzYw/MyFUS12kggJdKc1TBKFvOF4VPCb1raEu2WoP2sCkhYpESzFpyedIc87qaufZVGj9xqVNH5wUbABck5zctSRLOWYOBD7znsktSsv/WuaAu7mimvZxwpSASY0Re0pnqaFT6Vo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772837073; c=relaxed/simple;
	bh=eLSuW/FksN7QJTjRODMjXt/LHr3JE/PpTUpE4YdO+Nk=;
	h=Date:To:From:Subject:Message-Id; b=JaqMrtmP7u84cHQNHxG/PHoiOZif+To7P6Z/7I70E7Wh8z22jZ64jtHf4TWNaVFv6K8a8hp66Qr2y6LxS3WbYTFjIIfXd2xxKieKz6DeSLhu5Uo0uGfEU5MSdy62NbdMSR0AzoFuVWQAbhqfQAIXirTKE5l49xNl50lFkwMz53w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=TKel21X1; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="TKel21X1"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1C146C4CEF7;
	Fri,  6 Mar 2026 22:44:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1772837073;
	bh=eLSuW/FksN7QJTjRODMjXt/LHr3JE/PpTUpE4YdO+Nk=;
	h=Date:To:From:Subject:From;
	b=TKel21X1yKRGBSEIzdTOx3qJHsEZjnF4L1HfOerTHK+X+QgJ1IUSSs5/6H0givk9W
	 57s57Lea3y/DE+69UL5eDb6pKTastbCbp6+zOrvTuWUM0LxOUelsM91Migbdt0NGTk
	 qWSXLqRo/Fh1pv9scbjDLHockl3k8+1kov7FkWxY=
Date: Fri, 06 Mar 2026 14:44:32 -0800
To: mm-commits@vger.kernel.org,shuah@kernel.org,davidgow@google.com,brendan.higgins@linux.dev,sj@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-damon-core-add-damon_nr_regions-debug_sanity-check.patch added to mm-new branch
Message-Id: <20260306224433.1C146C4CEF7@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/damon/core: add damon_nr_regions() debug_sanity check
has been added to the -mm mm-new branch.  Its filename is
     mm-damon-core-add-damon_nr_regions-debug_sanity-check.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-damon-core-add-damon_nr_regions-debug_sanity-check.patch

This patch will later appear in the mm-new branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Note, mm-new is a provisional staging ground for work-in-progress
patches, and acceptance into mm-new is a notification for others take
notice and to finish up reviews.  Please do not hesitate to respond to
review feedback and post updated versions to replace or incrementally
fixup patches in mm-new.

The mm-new branch of mm.git is not included in linux-next

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next via various
branches at git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
and is updated there most days

------------------------------------------------------
From: SeongJae Park <sj@kernel.org>
Subject: mm/damon/core: add damon_nr_regions() debug_sanity check
Date: Fri, 6 Mar 2026 07:29:07 -0800

damon_target->nr_regions is introduced to get the number quickly without
having to iterate regions always.  Add a sanity check for that under
CONFIG_DAMON_DEBUG_SANITY.

Link: https://lkml.kernel.org/r/20260306152914.86303-5-sj@kernel.org
Signed-off-by: SeongJae Park <sj@kernel.org>
Cc: Brendan Higgins <brendan.higgins@linux.dev>
Cc: David Gow <davidgow@google.com>
Cc: Shuah Khan <shuah@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/damon/core.c |   19 +++++++++++++++++++
 1 file changed, 19 insertions(+)

--- a/mm/damon/core.c~mm-damon-core-add-damon_nr_regions-debug_sanity-check
+++ a/mm/damon/core.c
@@ -545,8 +545,27 @@ void damon_destroy_target(struct damon_t
 	damon_free_target(t);
 }
 
+#ifdef CONFIG_DAMON_DEBUG_SANITY
+static void damon_verify_nr_regions(struct damon_target *t)
+{
+	struct damon_region *r;
+	unsigned int count = 0;
+
+	damon_for_each_region(r, t)
+		count++;
+	WARN_ONCE(count != t->nr_regions, "t->nr_regions (%u) != count (%u)\n",
+			t->nr_regions, count);
+}
+#else
+static void damon_verify_nr_regions(struct damon_target *t)
+{
+}
+#endif
+
 unsigned int damon_nr_regions(struct damon_target *t)
 {
+	damon_verify_nr_regions(t);
+
 	return t->nr_regions;
 }
 
_

Patches currently in -mm which might be from sj@kernel.org are

mm-damon-core-set-quota-score-histogram-with-core-filters.patch
mm-damon-core-do-non-safe-region-walk-on-kdamond_apply_schemes.patch
mm-damon-core-split-regions-for-min_nr_regions.patch
mm-damon-vaddr-do-not-split-regions-for-min_nr_regions.patch
mm-damon-test-core-kunit-add-damon_apply_min_nr_regions-test.patch
mm-damon-add-config_damon_debug_sanity.patch
mm-damon-core-add-damon_new_region-debug_sanity-check.patch
mm-damon-core-add-damon_del_region-debug_sanity-check.patch
mm-damon-core-add-damon_nr_regions-debug_sanity-check.patch
mm-damon-core-add-damon_merge_two_regions-debug_sanity-check.patch
mm-damon-core-add-damon_merge_regions_of-debug_sanity-check.patch
mm-damon-core-add-damon_split_region_at-debug_sanity-check.patch
mm-damon-core-add-damon_reset_aggregated-debug_sanity-check.patch
mm-damon-tests-kunitconifg-enable-damon_debug_sanity.patch
selftests-damon-config-enable-damon_debug_sanity.patch

