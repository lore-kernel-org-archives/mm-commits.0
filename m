Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E7D0A1115
	for <mm-commits@vger.kernel.org>; Thu, 22 Feb 2024 00:02:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708560136; cv=none; b=cXfHHV3wsjRsP0JennY//mJVr7z63Aiwg2jjdG0Clcku6QMEQ57OSZOWandYmQundyacUnNp/WJsXmQPS6phm/g8dt/eizswSNT7Ax3icUYl3fmBcT+Zytxr+BXzbjvK5TPTCSSxdfU+Bnyn2sTdsc9QgKw6B31FCmJarMd1R6g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708560136; c=relaxed/simple;
	bh=LaTFCjzA8zDv+149lctZqshGzBenmmO40CJTPM4qDp0=;
	h=Date:To:From:Subject:Message-Id; b=FTgD2mu0vGMWbwXNp4hDqsYdw+nigJnmkzpvtk8hbnCnYvPkviL37lalX2+cayrvgpjtdBNpheF4tTdon5zHa8EAOlj3Y2yPyHVuMgAYZfRb47oF1rGYJzFHy9c/V8tOAHBSSsGKni2DjHPfGL4WInLN8lx2HpPjL8UNLamHsS8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=QWpBV+YW; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="QWpBV+YW"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BD04EC433F1;
	Thu, 22 Feb 2024 00:02:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1708560135;
	bh=LaTFCjzA8zDv+149lctZqshGzBenmmO40CJTPM4qDp0=;
	h=Date:To:From:Subject:From;
	b=QWpBV+YWhy7ofCZt31XDC5biVKI4Ia6kj1s9+QjiF4JvAvfycsj+2HAe4gJypUxAl
	 1FdIuKdf2WU4+XEQiMbVWzh2+sVr0G9Q8lZah1RXqiJFTFlX60dtzdIaV1GcrL0QeG
	 Q/HBrOy/xq1JkoC4tGHOz2jFHmhxRqz3DfEb6Ae8=
Date: Wed, 21 Feb 2024 16:02:15 -0800
To: mm-commits@vger.kernel.org,siyanteng@loongson.cn,shuah@kernel.org,corbet@lwn.net,alexs@kernel.org,2023002089@link.tyut.edu.cn,sj@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-damon-dbgfs-rename-monitor_on-file-to-monitor_on_deprecated.patch removed from -mm tree
Message-Id: <20240222000215.BD04EC433F1@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/damon/dbgfs: rename monitor_on file to monitor_on_DEPRECATED
has been removed from the -mm tree.  Its filename was
     mm-damon-dbgfs-rename-monitor_on-file-to-monitor_on_deprecated.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: SeongJae Park <sj@kernel.org>
Subject: mm/damon/dbgfs: rename monitor_on file to monitor_on_DEPRECATED
Date: Mon, 29 Jan 2024 17:35:46 -0800

Kernel builders could silently enable CONFIG_DAMON_DBGFS_DEPRECATED. 
Users who manually check the files under the DAMON debugfs directory could
notice the deprecation owing to the 'DEPRECATED' DAMON debugfs file, but
there could be users who doesn't manually check the files.

Make the deprecation cannot be ignored in the case by renaming
'monitor_on' file, which is essential for real use of DAMON on runtime, to
'monitor_on_DEPRECATED'.  Still users who control DAMON via only
user-space tool could ignore the deprecation, but that's what the tool
developers should take care of.  DAMON user-space tool, damo, has also
made a change[1] for the purpose.

[1] commit 935dae76f2aee ("_damon_args: Rename --damon_interface to
    --damon_interface_DEPRECATED") of https://github.com/awslabs/damo

Link: https://lkml.kernel.org/r/20240130013549.89538-8-sj@kernel.org
Signed-off-by: SeongJae Park <sj@kernel.org>
Cc: Alex Shi <alexs@kernel.org>
Cc: Hu Haowen <2023002089@link.tyut.edu.cn>
Cc: Jonathan Corbet <corbet@lwn.net>
Cc: Shuah Khan <shuah@kernel.org>
Cc: Yanteng Si <siyanteng@loongson.cn>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/damon/dbgfs.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/mm/damon/dbgfs.c~mm-damon-dbgfs-rename-monitor_on-file-to-monitor_on_deprecated
+++ a/mm/damon/dbgfs.c
@@ -1090,7 +1090,7 @@ static int __init __damon_dbgfs_init(voi
 {
 	struct dentry *dbgfs_root;
 	const char * const file_names[] = {"mk_contexts", "rm_contexts",
-		"monitor_on", "DEPRECATED"};
+		"monitor_on_DEPRECATED", "DEPRECATED"};
 	const struct file_operations *fops[] = {&mk_contexts_fops,
 		&rm_contexts_fops, &monitor_on_fops, &deprecated_fops};
 	int i;
_

Patches currently in -mm which might be from sj@kernel.org are

docs-mm-damon-maintainer-profile-fix-reference-links-for-mm-stable-tree.patch
docs-mm-damon-move-the-list-of-damos-actions-to-design-doc.patch
docs-mm-damon-move-damon-operation-sets-list-from-the-usage-to-the-design-document.patch
docs-mm-damon-move-damon-operation-sets-list-from-the-usage-to-the-design-document-fix.patch
docs-mm-damon-move-monitoring-target-regions-setup-detail-from-the-usage-to-the-design-document.patch
docs-admin-guide-mm-damon-usage-fix-wrong-quotas-diabling-condition.patch
mm-damon-core-set-damos_quota-esz-as-public-field-and-document.patch
mm-damon-sysfs-schemes-implement-quota-effective_bytes-file.patch
mm-damon-sysfs-implement-a-kdamond-command-for-updating-schemes-effective-quotas.patch
docs-abi-damon-document-effective_bytes-sysfs-file.patch
docs-admin-guide-mm-damon-usage-document-effective_bytes-file.patch
mm-damon-move-comments-and-fields-for-damos-quota-prioritization-to-the-end.patch
mm-damon-core-split-out-quota-goal-related-fields-to-a-struct.patch
mm-damon-core-add-multiple-goals-per-damos_quota-and-helpers-for-those.patch
mm-damon-sysfs-use-only-quota-goals.patch
mm-damon-core-remove-goal-field-of-damos_quota.patch
mm-damon-core-let-goal-specified-with-only-target-and-current-values.patch
mm-damon-core-support-multiple-metrics-for-quota-goal.patch
mm-damon-core-implement-psi-metric-damos-quota-goal.patch
mm-damon-sysfs-schemes-support-psi-based-quota-auto-tune.patch
docs-mm-damon-design-document-quota-goal-self-tuning.patch
docs-abi-damon-document-quota-goal-metric-file.patch
docs-admin-guide-mm-damon-usage-document-quota-goal-metric-file.patch
docs-admin-guide-mm-damon-usage-document-quota-goal-metric-file-fix.patch
mm-damon-reclaim-implement-user-feedback-driven-quota-auto-tuning.patch
mm-damon-reclaim-implement-memory-psi-driven-quota-self-tuning.patch
docs-admin-guide-mm-damon-reclaim-document-auto-tuning-parameters.patch

