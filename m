Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 68A2E4685
	for <mm-commits@vger.kernel.org>; Thu, 22 Feb 2024 00:02:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708560132; cv=none; b=Rp6/zDrDPSltvN/KADdjpEG+rhIvnSCw7ZicKJSx+anjM8Th5DpAxd4xXJOIW7vvCcy3veJJLhMcFW1UaGF7mNklLCLhl7KIx6BOIntJMYgZwZX7JJCenRal/y8MXFtVjIaDpLum14HNOm6UsdS3JUMX3ofC//KBN432WsJ5A2U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708560132; c=relaxed/simple;
	bh=rZpGUT7yZyaJxrv7jScKGcsNoQp4PlWozsFtWcMaupo=;
	h=Date:To:From:Subject:Message-Id; b=cxgTVfXjoNOUPv1EsSRqVJO+/zgt9wyP7NREDeFRWqnHMT8V1v99tpmZwtM3EkX/7MuVwHRbLHrMJcnPCV/8lCbWjXxkaeLXuKRcic1Jq1YFYORwOTuqicTiZH8HzLc9Ro9AaA/8QnEjom1j/ljJwWwj5ciBOUxnA1FxyHITGuI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=proc7IqH; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="proc7IqH"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 30F28C433C7;
	Thu, 22 Feb 2024 00:02:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1708560132;
	bh=rZpGUT7yZyaJxrv7jScKGcsNoQp4PlWozsFtWcMaupo=;
	h=Date:To:From:Subject:From;
	b=proc7IqHuMwU6hQ4Jr9jLnWY5paudKoT97TPI9/H+aca6Qb7oZa1amWpSWb3KAu5W
	 WIFSYHBvOL/X9O6FEUWFOdmy/xQ+gNo61f/pFYraBm/MNM+z0T6OYpSPfFtFjBwtZ8
	 iVjTXC9fgJwVVBBcTvZraeHrsZ/ptZ/qDqJ859os=
Date: Wed, 21 Feb 2024 16:02:11 -0800
To: mm-commits@vger.kernel.org,siyanteng@loongson.cn,shuah@kernel.org,corbet@lwn.net,arnd@arndb.de,alexs@kernel.org,2023002089@link.tyut.edu.cn,sj@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-damon-dbgfs-implement-deprecation-notice-file.patch removed from -mm tree
Message-Id: <20240222000212.30F28C433C7@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/damon/dbgfs: implement deprecation notice file
has been removed from the -mm tree.  Its filename was
     mm-damon-dbgfs-implement-deprecation-notice-file.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: SeongJae Park <sj@kernel.org>
Subject: mm/damon/dbgfs: implement deprecation notice file
Date: Mon, 29 Jan 2024 17:35:42 -0800

Implement a read-only file for DAMON debugfs interface deprecation notice,
to let users who manually read/write the DAMON debugfs files from their
shell command line easily notice the fact.

[arnd@arndb.de: fix bogus string length]
  Link: https://lkml.kernel.org/r/20240202124339.892862-1-arnd@kernel.org
Link: https://lkml.kernel.org/r/20240130013549.89538-4-sj@kernel.org
Signed-off-by: SeongJae Park <sj@kernel.org>
Signed-off-by: Arnd Bergmann <arnd@arndb.de>
Cc: Alex Shi <alexs@kernel.org>
Cc: Hu Haowen <2023002089@link.tyut.edu.cn>
Cc: Jonathan Corbet <corbet@lwn.net>
Cc: Shuah Khan <shuah@kernel.org>
Cc: Yanteng Si <siyanteng@loongson.cn>
Cc: Arnd Bergmann <arnd@arndb.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/damon/dbgfs.c |   19 +++++++++++++++++--
 1 file changed, 17 insertions(+), 2 deletions(-)

--- a/mm/damon/dbgfs.c~mm-damon-dbgfs-implement-deprecation-notice-file
+++ a/mm/damon/dbgfs.c
@@ -805,6 +805,17 @@ static void dbgfs_destroy_ctx(struct dam
 	damon_destroy_ctx(ctx);
 }
 
+static ssize_t damon_dbgfs_deprecated_read(struct file *file,
+		char __user *buf, size_t count, loff_t *ppos)
+{
+	static const char kbuf[512] = "DAMON debugfs interface is deprecated, "
+		     "so users should move to DAMON_SYSFS. If you cannot, "
+		     "please report your usecase to damon@lists.linux.dev and "
+		     "linux-mm@kvack.org.\n";
+
+	return simple_read_from_buffer(buf, count, ppos, kbuf, strlen(kbuf));
+}
+
 /*
  * Make a context of @name and create a debugfs directory for it.
  *
@@ -1056,6 +1067,10 @@ static int damon_dbgfs_static_file_open(
 	return nonseekable_open(inode, file);
 }
 
+static const struct file_operations deprecated_fops = {
+	.read = damon_dbgfs_deprecated_read,
+};
+
 static const struct file_operations mk_contexts_fops = {
 	.open = damon_dbgfs_static_file_open,
 	.write = dbgfs_mk_context_write,
@@ -1076,9 +1091,9 @@ static int __init __damon_dbgfs_init(voi
 {
 	struct dentry *dbgfs_root;
 	const char * const file_names[] = {"mk_contexts", "rm_contexts",
-		"monitor_on"};
+		"monitor_on", "DEPRECATED"};
 	const struct file_operations *fops[] = {&mk_contexts_fops,
-		&rm_contexts_fops, &monitor_on_fops};
+		&rm_contexts_fops, &monitor_on_fops, &deprecated_fops};
 	int i;
 
 	dbgfs_root = debugfs_create_dir("damon", NULL);
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

