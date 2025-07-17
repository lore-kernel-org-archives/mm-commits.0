Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BA8871A2541
	for <mm-commits@vger.kernel.org>; Thu, 17 Jul 2025 23:12:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752793948; cv=none; b=NDcYI0rRfDpn0PxHSWqcUo4KIBWoMQ7ftub29tzWbbQS/Dm3K7KG9xF6xVLI9MSSx6decSxR6U3VwOeQho2VB2y9E2BsGBdaNizV9la9gd26SYFDpjUXrWtmGRtt0rDtHVS3K/8JF2gDFBYmEEK0VMIlfWb0kXlDbn2UzygGiRs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752793948; c=relaxed/simple;
	bh=NvtZ4IXJQFcCpbLqaJ/RLtmSbF7zA8sC+qk3ovN5TBA=;
	h=Date:To:From:Subject:Message-Id; b=MgLYVyHMhB5PWMs9ZQ1rBMuKuxFNC9AbvHwHOLoqUr+K9JK/SEbtZw+nwkX4qmaHX7RmiM5/pEP4cOvYgXJG7x1DiNN1Jv79jBK02A7BXvZxsarEHpSVl2lMa5dYVmhr9nUPB3Y//pludmsI/ZwlFuxK2jvYhpSb6ITSzOkDAUU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=zdbCa3vM; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="zdbCa3vM"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 74864C4CEE3;
	Thu, 17 Jul 2025 23:12:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1752793948;
	bh=NvtZ4IXJQFcCpbLqaJ/RLtmSbF7zA8sC+qk3ovN5TBA=;
	h=Date:To:From:Subject:From;
	b=zdbCa3vMZpcP/tv22u27m5MwRGJUPQR3xhbtO0Rj05sh/Ncf0rlzhHmAssIl+UCjY
	 0eASCu/WHevjOHm94S96f85ChgrySDSUkUZmSv2uTwResyllIek15W5tlpeuwq+11t
	 f4pC+CvME+y11bZyfdyPjH67dbZyEf2Qt/09oUpQ=
Date: Thu, 17 Jul 2025 16:12:27 -0700
To: mm-commits@vger.kernel.org,corbet@lwn.net,sj@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-damon-sysfs-implement-refresh_ms-file-internal-work.patch added to mm-new branch
Message-Id: <20250717231228.74864C4CEE3@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/damon/sysfs: implement refresh_ms file internal work
has been added to the -mm mm-new branch.  Its filename is
     mm-damon-sysfs-implement-refresh_ms-file-internal-work.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-damon-sysfs-implement-refresh_ms-file-internal-work.patch

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
Subject: mm/damon/sysfs: implement refresh_ms file internal work
Date: Wed, 16 Jul 2025 22:54:46 -0700

Only minimum file operations for refresh_ms file is implemented.  Further
implement its designed behavior, the periodic essential files content
update, using repeat mode damon_call().

If non-zero value is written to the file, update DAMON sysfs files for
auto-tuned monitoring intervals, DAMOS stats, and auto-tuned DAMOS quota
values, which are essential to be monitored in most DAMON use cases.  The
user-written non-zero value becomes the time delay between the update.  If
zero is written to the file, the periodic refresh is disabled.

Link: https://lkml.kernel.org/r/20250717055448.56976-3-sj@kernel.org
Signed-off-by: SeongJae Park <sj@kernel.org>
Cc: Jonathan Corbet <corbet@lwn.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/damon/sysfs.c |   29 +++++++++++++++++++++++++++++
 1 file changed, 29 insertions(+)

--- a/mm/damon/sysfs.c~mm-damon-sysfs-implement-refresh_ms-file-internal-work
+++ a/mm/damon/sysfs.c
@@ -1509,6 +1509,32 @@ static struct damon_ctx *damon_sysfs_bui
 	return ctx;
 }
 
+static int damon_sysfs_repeat_call_fn(void *data)
+{
+	struct damon_sysfs_kdamond *sysfs_kdamond = data;
+	static unsigned long next_update_jiffies;
+
+	if (!sysfs_kdamond->refresh_ms)
+		return 0;
+	if (time_before(jiffies, next_update_jiffies))
+		return 0;
+	next_update_jiffies = jiffies +
+		msecs_to_jiffies(sysfs_kdamond->refresh_ms);
+
+	if (!mutex_trylock(&damon_sysfs_lock))
+		return 0;
+	damon_sysfs_upd_tuned_intervals(sysfs_kdamond);
+	damon_sysfs_upd_schemes_stats(sysfs_kdamond);
+	damon_sysfs_upd_schemes_effective_quotas(sysfs_kdamond);
+	mutex_unlock(&damon_sysfs_lock);
+	return 0;
+}
+
+static struct damon_call_control damon_sysfs_repeat_call_control = {
+	.fn = damon_sysfs_repeat_call_fn,
+	.repeat = true,
+};
+
 static int damon_sysfs_turn_damon_on(struct damon_sysfs_kdamond *kdamond)
 {
 	struct damon_ctx *ctx;
@@ -1533,6 +1559,9 @@ static int damon_sysfs_turn_damon_on(str
 		return err;
 	}
 	kdamond->damon_ctx = ctx;
+
+	damon_sysfs_repeat_call_control.data = kdamond;
+	damon_call(ctx, &damon_sysfs_repeat_call_control);
 	return err;
 }
 
_

Patches currently in -mm which might be from sj@kernel.org are

samples-damon-wsse-rename-to-have-damon_sample_-prefix.patch
samples-damon-prcl-rename-to-have-damon_sample_-prefix.patch
samples-damon-mtier-rename-to-have-damon_sample_-prefix.patch
mm-damon-sysfs-use-damon-core-api-damon_is_running.patch
mm-damon-sysfs-dont-hold-kdamond_lock-in-before_terminate.patch
docs-mm-damon-maintainer-profile-update-for-mm-new-tree.patch
mm-damon-add-struct-damos_migrate_dests.patch
mm-damon-core-add-damos-migrate_dests-field.patch
mm-damon-sysfs-schemes-implement-damos-action-destinations-directory.patch
mm-damon-sysfs-schemes-set-damos-migrate_dests.patch
docs-abi-damon-document-schemes-dests-directory.patch
docs-admin-guide-mm-damon-usage-document-dests-directory.patch
mm-damon-accept-parallel-damon_call-requests.patch
mm-damon-core-introduce-repeat-mode-damon_call.patch
mm-damon-stat-use-damon_call-repeat-mode-instead-of-damon_callback.patch
mm-damon-reclaim-use-damon_call-repeat-mode-instead-of-damon_callback.patch
mm-damon-lru_sort-use-damon_call-repeat-mode-instead-of-damon_callback.patch
samples-damon-prcl-use-damon_call-repeat-mode-instead-of-damon_callback.patch
samples-damon-wsse-use-damon_call-repeat-mode-instead-of-damon_callback.patch
mm-damon-core-do-not-call-opscleanup-when-destroying-targets.patch
mm-damon-core-add-cleanup_target-ops-callback.patch
mm-damon-core-add-cleanup_target-ops-callback-fix.patch
mm-damon-core-add-cleanup_target-ops-callback-fix-2.patch
mm-damon-vaddr-put-pid-in-cleanup_target.patch
mm-damon-sysfs-remove-damon_sysfs_destroy_targets.patch
mm-damon-core-destroy-targets-when-kdamond_fn-finish.patch
mm-damon-sysfs-remove-damon_sysfs_before_terminate.patch
mm-damon-core-remove-damon_callback.patch
mm-damon-sysfs-implement-refresh_ms-file-under-kdamond-directory.patch
mm-damon-sysfs-implement-refresh_ms-file-internal-work.patch
docs-admin-guide-mm-damon-usage-document-refresh_ms-file.patch
docs-abi-damon-update-for-refresh_ms.patch

