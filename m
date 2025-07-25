Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 49B7F212F98
	for <mm-commits@vger.kernel.org>; Fri, 25 Jul 2025 02:14:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753409688; cv=none; b=ajsGrMeGnko5N6oFSlQOLaKvjpE5DLuSLHqVmM+YXlp4i6aNjdp/3Gc2pXFgSFa0bHGPus1OgrrZKrCTiMrMaRIi1vE5gUpD9NDATiMBajJO4IUb9iPhtxTWbEOXe+xTg5s10YOEE1rVCxJcZMExwydTM5hgN5FpS58y/GulzCk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753409688; c=relaxed/simple;
	bh=frmFhW7nnR4jCWy/+AZDlm4+uEx47CgeDx2CTg4wpV8=;
	h=Date:To:From:Subject:Message-Id; b=rjGxfAjHUbtdWqbb8K3tAUAbYE7JEkpNcr4wfb6xQgBmQm2A9C8h049X8m+KlR7VCAL+qc3NFwd3CvJvmigII9a2URt2Z7Ey174aFGpb1sJt9En5WAg28V3zxq+2Dhm3Lpv31JoN5wIOOI19/QFQVJ8cQAJKxd0BBPmEY1cOtXg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=l0kfMhlw; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="l0kfMhlw"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1C391C4CEED;
	Fri, 25 Jul 2025 02:14:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1753409688;
	bh=frmFhW7nnR4jCWy/+AZDlm4+uEx47CgeDx2CTg4wpV8=;
	h=Date:To:From:Subject:From;
	b=l0kfMhlwNb5iKuJi1xEwuUgHKgBnSJvkdX/io7pnMj19QGHQFMKpQuoRoPIYkoIR8
	 /64qoLeaF9B2KQwxHW/PCD0ECcI386/DTAOfeja24rco0A61q5ecz/ZPJebBRxhExe
	 C4qAaStg1GvXCXUPfI0iIgqeWVzcQMnPkK62eDL4=
Date: Thu, 24 Jul 2025 19:14:47 -0700
To: mm-commits@vger.kernel.org,corbet@lwn.net,sj@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-damon-sysfs-implement-refresh_ms-file-internal-work.patch removed from -mm tree
Message-Id: <20250725021448.1C391C4CEED@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/damon/sysfs: implement refresh_ms file internal work
has been removed from the -mm tree.  Its filename was
     mm-damon-sysfs-implement-refresh_ms-file-internal-work.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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

selftests-damon-sysfspy-stop-damon-for-dumping-failures.patch
selftests-damon-_damon_sysfs-support-damos-watermarks-setup.patch
selftests-damon-_damon_sysfs-support-damos-filters-setup.patch
selftests-damon-_damon_sysfs-support-monitoring-intervals-goal-setup.patch
selftests-damon-_damon_sysfs-support-damos-quota-weights-setup.patch
selftests-damon-_damon_sysfs-support-damos-quota-goal-nid-setup.patch
selftests-damon-_damon_sysfs-support-damos-action-dests-setup.patch
selftests-damon-_damon_sysfs-support-damos-target_nid-setup.patch
selftests-damon-_damon_sysfs-use-232-1-as-max-nr_accesses-and-age.patch
selftests-damon-drgn_dump_damon_status-dump-damos-migrate_dests.patch
selftests-damon-drgn_dump_damon_status-dump-ctx-opsid.patch
selftests-damon-drgn_dump_damon_status-dump-damos-filters.patch
selftests-damon-sysfspy-generalize-damos-watermarks-commit-assertion.patch
selftests-damon-sysfspy-generalize-damosquota-commit-assertion.patch
selftests-damon-sysfspy-test-quota-goal-commitment.patch
selftests-damon-sysfspy-test-damos-destinations-commitment.patch
selftests-damon-sysfspy-generalize-damos-scheme-commit-assertion.patch
selftests-damon-sysfspy-test-damos-filters-commitment.patch
selftests-damon-sysfspy-generalize-damos-schemes-commit-assertion.patch
selftests-damon-sysfspy-generalize-monitoring-attributes-commit-assertion.patch
selftests-damon-sysfspy-generalize-damon-context-commit-assertion.patch
selftests-damon-sysfspy-test-non-default-parameters-runtime-commit.patch
selftests-damon-sysfspy-test-runtime-reduction-of-damon-parameters.patch

