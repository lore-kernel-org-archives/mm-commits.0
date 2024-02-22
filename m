Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8F5201854
	for <mm-commits@vger.kernel.org>; Thu, 22 Feb 2024 00:02:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708560133; cv=none; b=qjhk3NtSj0RzkutshEmMfI3Lxy5IW/agJkVsZgaWLQgHlee4Vrvi2CkAKrQAY9s/NC9K9BhWp4q27/rgMmZv/pqFLx2IuBgyENXzTiz2EIi08l5rkqFGdP8mMWk8vYfV9cj3T5fMmsYGSo7GnCWB18o+Tq5pUfEjPFNKOtqg/fE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708560133; c=relaxed/simple;
	bh=vs6F3RX/z8d8NsU8llWCEJ5W4duN8NTZd8rrj7EmFPI=;
	h=Date:To:From:Subject:Message-Id; b=eCUlxbHlLP/BoAfsp+z3avDRhj4Vi+xRpLiYyxdlfZ+Hidr+Mo8GClR9+HeR4yuR/7Uwhk/LokYq7UpcCwoi+EGWmEXMlWt06ahXO4JQrMOWukcT63vJENyocKH90vzL4AUJZzBUOpvr30QDcxNH2eUnTkyD7fTsJ13OasDHwDE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=K9JlguF0; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="K9JlguF0"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 19F27C433F1;
	Thu, 22 Feb 2024 00:02:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1708560133;
	bh=vs6F3RX/z8d8NsU8llWCEJ5W4duN8NTZd8rrj7EmFPI=;
	h=Date:To:From:Subject:From;
	b=K9JlguF0551dtfCGSkwiCzUnXDxnu8sd2ftgLUfNejBKBw0y1e5iB1jCwT/myLrbo
	 Fw22Z3nZvLU12tDlOAudZ7LIcimYrDMSkdxK0luZ4ZZCMwGY110OgROIZi4+mmUfL0
	 kWx3qc8kUanGAQ0EvZbRMk0Ho1bhNnuXR3c/H+uw=
Date: Wed, 21 Feb 2024 16:02:12 -0800
To: mm-commits@vger.kernel.org,siyanteng@loongson.cn,shuah@kernel.org,corbet@lwn.net,alexs@kernel.org,2023002089@link.tyut.edu.cn,sj@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-damon-dbgfs-make-debugfs-interface-deprecation-message-a-macro.patch removed from -mm tree
Message-Id: <20240222000213.19F27C433F1@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/damon/dbgfs: make debugfs interface deprecation message a macro
has been removed from the -mm tree.  Its filename was
     mm-damon-dbgfs-make-debugfs-interface-deprecation-message-a-macro.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: SeongJae Park <sj@kernel.org>
Subject: mm/damon/dbgfs: make debugfs interface deprecation message a macro
Date: Mon, 29 Jan 2024 17:35:43 -0800

DAMON debugfs interface deprecation message is written twice, once for the
warning, and again for DEPRECATED file's read output.  De-duplicate those
by defining the message as a macro and reuse.

[akpm@linux-foundation.org: s/comnst/const/]
Link: https://lkml.kernel.org/r/20240130013549.89538-5-sj@kernel.org
Signed-off-by: SeongJae Park <sj@kernel.org>
Cc: Alex Shi <alexs@kernel.org>
Cc: Hu Haowen <2023002089@link.tyut.edu.cn>
Cc: Jonathan Corbet <corbet@lwn.net>
Cc: Shuah Khan <shuah@kernel.org>
Cc: Yanteng Si <siyanteng@loongson.cn>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/damon/dbgfs.c |   15 +++++++--------
 1 file changed, 7 insertions(+), 8 deletions(-)

--- a/mm/damon/dbgfs.c~mm-damon-dbgfs-make-debugfs-interface-deprecation-message-a-macro
+++ a/mm/damon/dbgfs.c
@@ -15,6 +15,11 @@
 #include <linux/page_idle.h>
 #include <linux/slab.h>
 
+#define DAMON_DBGFS_DEPRECATION_NOTICE					\
+	"DAMON debugfs interface is deprecated, so users should move "	\
+	"to DAMON_SYSFS. If you cannot, please report your usecase to "	\
+	"damon@lists.linux.dev and linux-mm@kvack.org.\n"
+
 static struct damon_ctx **dbgfs_ctxs;
 static int dbgfs_nr_ctxs;
 static struct dentry **dbgfs_dirs;
@@ -22,10 +27,7 @@ static DEFINE_MUTEX(damon_dbgfs_lock);
 
 static void damon_dbgfs_warn_deprecation(void)
 {
-	pr_warn_once("DAMON debugfs interface is deprecated, "
-		     "so users should move to DAMON_SYSFS. If you cannot, "
-		     "please report your usecase to damon@lists.linux.dev and "
-		     "linux-mm@kvack.org.\n");
+	pr_warn_once(DAMON_DBGFS_DEPRECATION_NOTICE);
 }
 
 /*
@@ -808,10 +810,7 @@ static void dbgfs_destroy_ctx(struct dam
 static ssize_t damon_dbgfs_deprecated_read(struct file *file,
 		char __user *buf, size_t count, loff_t *ppos)
 {
-	static const char kbuf[512] = "DAMON debugfs interface is deprecated, "
-		     "so users should move to DAMON_SYSFS. If you cannot, "
-		     "please report your usecase to damon@lists.linux.dev and "
-		     "linux-mm@kvack.org.\n";
+	static const char kbuf[512] = DAMON_DBGFS_DEPRECATION_NOTICE;
 
 	return simple_read_from_buffer(buf, count, ppos, kbuf, strlen(kbuf));
 }
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

