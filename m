Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 37383286435
	for <mm-commits@vger.kernel.org>; Thu, 10 Jul 2025 05:46:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752126371; cv=none; b=OLh4YWTA5/j0GlDPSmor781DZJH9PB3xB7Sjpw/AYVhY2KBZGiIztn7iRiBzLiJDISHI0uT3Wvv7f6uQtaIPN73ZEd22PBDf/SQPM+VzWzyeAQyXrsu97qKP2usl6KhdF2n4xJzDw53ZsxDNaciEcBTCMlTeeB1gm7fuHRL7wW0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752126371; c=relaxed/simple;
	bh=OdoOVd+wXdqallBxDbD5VcnQmoaQag2uNa647522geU=;
	h=Date:To:From:Subject:Message-Id; b=tJOOKRTQ/xaK2r3RGZehzXQ1EBSwIFfr1WpwPzLZJEORcdpKWtFWNPTVNgQ/Cmb68Eq8tvWmTRRA7ni5SH9EUGRYOZjDTqIQ9ONXjL/T8hgL5F9zstLxR8oZv9xml6q5rhM8rP7oXQV1NNGchdHILcljHl7A9peKGZQMmCDUggU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=YKEztmK8; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="YKEztmK8"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AADE3C4CEE3;
	Thu, 10 Jul 2025 05:46:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1752126370;
	bh=OdoOVd+wXdqallBxDbD5VcnQmoaQag2uNa647522geU=;
	h=Date:To:From:Subject:From;
	b=YKEztmK8Gqa6iv6156ngUW/BE5rK+LaQdqGFwfp/quvx7lrOdw+YBuahxDpQAm4pD
	 Ym1M3lqtpJ4/8BxSR8/HcxX1zEr6yf/koImWfkzBqbuKVxJXpabo1YR1CjAob0659h
	 rRx1tgfStnaRE5vq5NB0zM+CcoveiKW7Uw36SdBo=
Date: Wed, 09 Jul 2025 22:46:10 -0700
To: mm-commits@vger.kernel.org,sj@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-damon-sysfs-schemes-decouple-from-damos_wmark_metric.patch removed from -mm tree
Message-Id: <20250710054610.AADE3C4CEE3@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/damon/sysfs-schemes: decouple from damos_wmark_metric
has been removed from the -mm tree.  Its filename was
     mm-damon-sysfs-schemes-decouple-from-damos_wmark_metric.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: SeongJae Park <sj@kernel.org>
Subject: mm/damon/sysfs-schemes: decouple from damos_wmark_metric
Date: Sun, 22 Jun 2025 14:37:57 -0700

Decouple DAMOS sysfs interface from damos_wmark_metric.  For this, define
and use new sysfs-schemes internal data structure that maps the user-space
keywords and damos_wmark_metric, instead of having the implicit and
unflexible array index rule.

Link: https://lkml.kernel.org/r/20250622213759.50930-4-sj@kernel.org
Signed-off-by: SeongJae Park <sj@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/damon/sysfs-schemes.c |   41 +++++++++++++++++++++++++++----------
 1 file changed, 31 insertions(+), 10 deletions(-)

--- a/mm/damon/sysfs-schemes.c~mm-damon-sysfs-schemes-decouple-from-damos_wmark_metric
+++ a/mm/damon/sysfs-schemes.c
@@ -785,10 +785,21 @@ static struct damon_sysfs_watermarks *da
 	return watermarks;
 }
 
-/* Should match with enum damos_wmark_metric */
-static const char * const damon_sysfs_wmark_metric_strs[] = {
-	"none",
-	"free_mem_rate",
+struct damos_sysfs_wmark_metric_name {
+	enum damos_wmark_metric metric;
+	char *name;
+};
+
+static const struct damos_sysfs_wmark_metric_name
+damos_sysfs_wmark_metric_names[] = {
+	{
+		.metric = DAMOS_WMARK_NONE,
+		.name = "none",
+	},
+	{
+		.metric = DAMOS_WMARK_FREE_MEM_RATE,
+		.name = "free_mem_rate",
+	},
 };
 
 static ssize_t metric_show(struct kobject *kobj, struct kobj_attribute *attr,
@@ -796,9 +807,16 @@ static ssize_t metric_show(struct kobjec
 {
 	struct damon_sysfs_watermarks *watermarks = container_of(kobj,
 			struct damon_sysfs_watermarks, kobj);
+	int i;
+
+	for (i = 0; i < ARRAY_SIZE(damos_sysfs_wmark_metric_names); i++) {
+		const struct damos_sysfs_wmark_metric_name *metric_name;
 
-	return sysfs_emit(buf, "%s\n",
-			damon_sysfs_wmark_metric_strs[watermarks->metric]);
+		metric_name = &damos_sysfs_wmark_metric_names[i];
+		if (metric_name->metric == watermarks->metric)
+			return sysfs_emit(buf, "%s\n", metric_name->name);
+	}
+	return -EINVAL;
 }
 
 static ssize_t metric_store(struct kobject *kobj, struct kobj_attribute *attr,
@@ -806,11 +824,14 @@ static ssize_t metric_store(struct kobje
 {
 	struct damon_sysfs_watermarks *watermarks = container_of(kobj,
 			struct damon_sysfs_watermarks, kobj);
-	enum damos_wmark_metric metric;
+	int i;
+
+	for (i = 0; i < ARRAY_SIZE(damos_sysfs_wmark_metric_names); i++) {
+		const struct damos_sysfs_wmark_metric_name *metric_name;
 
-	for (metric = 0; metric < NR_DAMOS_WMARK_METRICS; metric++) {
-		if (sysfs_streq(buf, damon_sysfs_wmark_metric_strs[metric])) {
-			watermarks->metric = metric;
+		metric_name = &damos_sysfs_wmark_metric_names[i];
+		if (sysfs_streq(buf, metric_name->name)) {
+			watermarks->metric = metric_name->metric;
 			return count;
 		}
 	}
_

Patches currently in -mm which might be from sj@kernel.org are

selftests-damon-add-drgn-script-for-extracting-damon-status.patch
selftests-damon-_damon_sysfs-set-kdamondpid-in-start.patch
selftests-damon-add-python-and-drgn-based-damon-sysfs-test.patch
selftests-damon-sysfspy-test-monitoring-attribute-parameters.patch
selftests-damon-sysfspy-test-adaptive-targets-parameter.patch
selftests-damon-sysfspy-test-damos-schemes-parameters-setup.patch
mm-damon-add-trace-event-for-auto-tuned-monitoring-intervals.patch
mm-damon-add-trace-event-for-effective-size-quota.patch
mm-damon-add-trace-event-for-effective-size-quota-fix.patch
mm-damon-add-trace-event-for-effective-size-quota-fix-2.patch
samples-damon-wsse-fix-boot-time-enable-handling.patch
samples-damon-prcl-fix-boot-time-enable-crash.patch
samples-damon-mtier-support-boot-time-enable-setup.patch
mm-damon-reclaim-reset-enabled-when-damon-start-failed.patch
mm-damon-lru_sort-reset-enabled-when-damon-start-failed.patch
mm-damon-reclaim-use-parameter-context-correctly.patch
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

