Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5E6FA54654
	for <mm-commits@vger.kernel.org>; Fri,  6 Mar 2026 22:44:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772837072; cv=none; b=F9qIZpDRmOpJaTlZrx5jUSAFSm0QeZyxAcTbZoia35EKUDORTX/d5utAkQByXYUknXyKVAK4TUsr+66LMsGWh8PSHDT3ffP5Ij8tddNGpOEmwIZ4SMb/MbFJIfefDFh8SjFC5L4Sl5TpOZxrAF9hfPOmF5AhUU6J4R6AbDZY+0k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772837072; c=relaxed/simple;
	bh=tGcxLKYxlj4uagIMh7zFQg9TQ0a2FT8xbHsqOe++xco=;
	h=Date:To:From:Subject:Message-Id; b=dRarJtHsA5RD/eQPT/+5ir0ILYa1YWI01sakGRgssuELSNZ2Nou4EFFDZrsGtdPsJ1iiZZ9so/z4xnnnGlzSpYhzf0448mCdjPiSay302WuMXqK/VA2nzfnuymoP1tU7+sfjZfWwSUxC1kDOKTuKVg3K9scB2DPcNenMyxlsLBM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=OZLkbJ6D; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="OZLkbJ6D"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E5254C4CEF7;
	Fri,  6 Mar 2026 22:44:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1772837072;
	bh=tGcxLKYxlj4uagIMh7zFQg9TQ0a2FT8xbHsqOe++xco=;
	h=Date:To:From:Subject:From;
	b=OZLkbJ6DoIRkOCYJeT7r6D33HT+YNIYdJG33we/OZXhM0fs4BFohOW7OkJ5d9IrCg
	 dBHWWPDy4ggpTtojxTo6V8hf+WeOMjgYAzHnK1v4KpWYpxQtLcU35IQ6PcizEnxhgl
	 XXqyXKTqetaQFl+PqP0U15cmx3xy7zaE3uCQnHpg=
Date: Fri, 06 Mar 2026 14:44:31 -0800
To: mm-commits@vger.kernel.org,shuah@kernel.org,davidgow@google.com,brendan.higgins@linux.dev,sj@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-damon-core-add-damon_del_region-debug_sanity-check.patch added to mm-new branch
Message-Id: <20260306224431.E5254C4CEF7@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/damon/core: add damon_del_region() debug_sanity check
has been added to the -mm mm-new branch.  Its filename is
     mm-damon-core-add-damon_del_region-debug_sanity-check.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-damon-core-add-damon_del_region-debug_sanity-check.patch

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
Subject: mm/damon/core: add damon_del_region() debug_sanity check
Date: Fri, 6 Mar 2026 07:29:06 -0800

damon_del_region() should be called for targets that have one or more
regions.  Add a sanity check for that under CONFIG_DAMON_DEBUG_SANITY.

Link: https://lkml.kernel.org/r/20260306152914.86303-4-sj@kernel.org
Signed-off-by: SeongJae Park <sj@kernel.org>
Cc: Brendan Higgins <brendan.higgins@linux.dev>
Cc: David Gow <davidgow@google.com>
Cc: Shuah Khan <shuah@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/damon/core.c |   13 +++++++++++++
 1 file changed, 13 insertions(+)

--- a/mm/damon/core.c~mm-damon-core-add-damon_del_region-debug_sanity-check
+++ a/mm/damon/core.c
@@ -152,8 +152,21 @@ void damon_add_region(struct damon_regio
 	t->nr_regions++;
 }
 
+#ifdef CONFIG_DAMON_DEBUG_SANITY
+static void damon_verify_del_region(struct damon_target *t)
+{
+	WARN_ONCE(t->nr_regions == 0, "t->nr_regions == 0\n");
+}
+#else
+static void damon_verify_del_region(struct damon_target *t)
+{
+}
+#endif
+
 static void damon_del_region(struct damon_region *r, struct damon_target *t)
 {
+	damon_verify_del_region(t);
+
 	list_del(&r->list);
 	t->nr_regions--;
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

