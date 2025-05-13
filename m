Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 09F0CEEA6
	for <mm-commits@vger.kernel.org>; Tue, 13 May 2025 01:18:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747099087; cv=none; b=WF+tJY56UUZsZG7w1zUtZcRqsfZ1GYRSsnHPWQGPQFZvghMeuSXKPu7uKNT48aobo4uPbiHY7n+vFMiHKNdSWL0LHV5i4DMug7F2Gf3OwR49jBC78/M48IA+ogJo+jMoyBZe6xH3GUpyM/6jHD9l9DdQyC4z5fRdKm/ySKv+cH4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747099087; c=relaxed/simple;
	bh=7m7Py/qg5inxkXXUuPQsze80AGO4G9jCkvFZQSPQJP4=;
	h=Date:To:From:Subject:Message-Id; b=ikTeI7OhO8EH4uEGMBxD5ZAf3pg3sZzZDsfjBR9TM/vI0378vt24tpvfpflzWDzyIkH5BQEXSkMeRpwN+8Zvws6lqkKis28TqyISxrjZjDFK/A4R1QMZVHoGdb++9du/l7KX4Lg11jXULUEt3YERj5rdkkpYoHuu6ZEmRXM7yE0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=FXzVLL2D; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="FXzVLL2D"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C0AF3C4CEE7;
	Tue, 13 May 2025 01:18:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1747099086;
	bh=7m7Py/qg5inxkXXUuPQsze80AGO4G9jCkvFZQSPQJP4=;
	h=Date:To:From:Subject:From;
	b=FXzVLL2DTVaJXpnuoap7EeQ30FsweQi5pq7YpfcVgwtNc4TA9cO05Wa2icn3IKQ14
	 86hm/kawCWASgb6LYM8tpfmZ+hdxdxosQQcMtP6tNCpaRKoqFIaVMZoqCxkHk8+2Ad
	 RHf/V+2KGufiZZRWOS25YWXIqf7u7wnT7mvffTHw=
Date: Mon, 12 May 2025 18:18:06 -0700
To: mm-commits@vger.kernel.org,shuah@kernel.org,davidgow@google.com,corbet@lwn.net,brendan.higgins@linux.dev,sj@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-damon-sysfs-schemes-fix-wrong-comment-on-damons_sysfs_quota_goal_metric_strs.patch added to mm-new branch
Message-Id: <20250513011806.C0AF3C4CEE7@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/damon/sysfs-schemes: fix wrong comment on damons_sysfs_quota_goal_metric_strs
has been added to the -mm mm-new branch.  Its filename is
     mm-damon-sysfs-schemes-fix-wrong-comment-on-damons_sysfs_quota_goal_metric_strs.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-damon-sysfs-schemes-fix-wrong-comment-on-damons_sysfs_quota_goal_metric_strs.patch

This patch will later appear in the mm-new branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Note, mm-new is a provisional staging ground for work-in-progress
patches, and acceptance into mm-new is a notification for others take
notice and to finish up reviews.  Please do not hesitate to respond to
review feedback and post updated versions to replace or incrementally
fixup patches in mm-new.

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
From: SeongJae Park <sj@kernel.org>
Subject: mm/damon/sysfs-schemes: fix wrong comment on damons_sysfs_quota_goal_metric_strs
Date: Mon, 12 May 2025 17:27:11 -0700

A comment on damos_sysfs_quota_goal_metric_strs is simply wrong, due to a
copy-and-paste error.  Fix it.

Link: https://lkml.kernel.org/r/20250513002715.40126-3-sj@kernel.org
Signed-off-by: SeongJae Park <sj@kernel.org>
Cc: Brendan Higgins <brendan.higgins@linux.dev>
Cc: David Gow <davidgow@google.com>
Cc: Jonathan Corbet <corbet@lwn.net>
Cc: Shuah Khan <shuah@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/damon/sysfs-schemes.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/mm/damon/sysfs-schemes.c~mm-damon-sysfs-schemes-fix-wrong-comment-on-damons_sysfs_quota_goal_metric_strs
+++ a/mm/damon/sysfs-schemes.c
@@ -940,7 +940,7 @@ struct damos_sysfs_quota_goal {
 	int nid;
 };
 
-/* This should match with enum damos_action */
+/* This should match with enum damos_quota_goal_metric */
 static const char * const damos_sysfs_quota_goal_metric_strs[] = {
 	"user_input",
 	"some_mem_psi_us",
_

Patches currently in -mm which might be from sj@kernel.org are

mm-damon-core-introduce-damos-quota-goal-metrics-for-memory-node-utilization.patch
mm-damon-sysfs-schemes-implement-file-for-quota-goal-nid-parameter.patch
mm-damon-sysfs-schemes-connect-damos_quota_goal-nid-with-core-layer.patch
docs-mm-damon-design-document-node_mem_usedfree_bp.patch
docs-admin-guide-mm-damon-usage-document-nid-file.patch
docs-abi-damon-document-nid-file.patch
samples-damon-implement-a-damon-module-for-memory-tiering.patch
samples-damon-implement-a-damon-module-for-memory-tiering-fix.patch
mm-damon-core-warn-and-fix-nr_accesses-corruption.patch
mm-damon-sysfs-schemes-fix-wrong-comment-on-damons_sysfs_quota_goal_metric_strs.patch
mm-damon-paddr-remove-unused-variable-folio_list-in-damon_pa_stat.patch
mm-damon-tests-core-kunit-add-a-test-for-damos_set_filters_default_reject.patch
selftests-damon-_damon_sysfs-read-tried-regions-directories-in-order.patch
docs-damon-update-titles-and-brief-introductions-to-explain-damos.patch

