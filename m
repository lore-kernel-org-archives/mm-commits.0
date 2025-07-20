Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 66CE713C9D4
	for <mm-commits@vger.kernel.org>; Sun, 20 Jul 2025 02:01:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752976898; cv=none; b=Pf0w7YtfAAjEImvaS+AjrfWJm2bdRlozKRuXl8xCvPnGx2ccymrLmOqBEQtYpJ7S7S+j+a9zQh35+F1nCnxXA+8TTbRk1mwRetVbpmpgUq4VRcXRWe13V5YXp0VBijs0kWhUccUOl8xIY94UBILjGGqgIc4YhqzBwWwU1qzesps=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752976898; c=relaxed/simple;
	bh=/q9KXr8FbT7KDQS4j8VUXd9hO3HfeMXMn8oWkO/Ooss=;
	h=Date:To:From:Subject:Message-Id; b=BEWZ34fWuPpB/4mmBWhHiP1ZmFPC0Agv/95pkfxSpXKCNMSNUvNkWMmCfn+EGZyu7j2sVpPFjtgYilq1DmkXIHGDMZxCTl8yTaI1dqJQ9AguZOoikGekW8xxO9T2r920xJ73y43jJBQwv9Kh6XDdopkKu5nBdfAkeAGBI99fEaM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=WHRamcI7; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="WHRamcI7"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3A957C4CEE3;
	Sun, 20 Jul 2025 02:01:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1752976898;
	bh=/q9KXr8FbT7KDQS4j8VUXd9hO3HfeMXMn8oWkO/Ooss=;
	h=Date:To:From:Subject:From;
	b=WHRamcI7snkdXy8uc0/guc+TqfOQrwqq4EY1lw5fn4Ho10veRegLbnnVduYwhRscS
	 3JAip8CsU21AW9J1VSaBNkIFtb6y8jBSy3E3Zb/LblZAOABk6OK4pcVqquENJtGWNB
	 0Efl1Pc3zOtB9tMccmQPE1o7tq3iY0IkiCceJNIQ=
Date: Sat, 19 Jul 2025 19:01:37 -0700
To: mm-commits@vger.kernel.org,ravis.opensrc@micron.com,corbet@lwn.net,bijantabatab@micron.com,sj@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-damon-sysfs-schemes-set-damos-migrate_dests.patch removed from -mm tree
Message-Id: <20250720020138.3A957C4CEE3@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/damon/sysfs-schemes: set damos->migrate_dests
has been removed from the -mm tree.  Its filename was
     mm-damon-sysfs-schemes-set-damos-migrate_dests.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: SeongJae Park <sj@kernel.org>
Subject: mm/damon/sysfs-schemes: set damos->migrate_dests
Date: Tue, 8 Jul 2025 19:59:34 -0500

Pass user-specified multiple DAMOS action destinations and their weights
to DAMON core API, so that user requests can really work.

Link: https://lkml.kernel.org/r/20250709005952.17776-5-bijan311@gmail.com
Signed-off-by: SeongJae Park <sj@kernel.org>
Signed-off-by: Bijan Tabatabai <bijantabatab@micron.com>
Reviewed-by: SeongJae Park <sj@kernel.org>
Cc: Jonathan Corbet <corbet@lwn.net>
Cc: Ravi Shankar Jonnalagadda <ravis.opensrc@micron.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/damon/sysfs-schemes.c |   28 ++++++++++++++++++++++++++++
 1 file changed, 28 insertions(+)

--- a/mm/damon/sysfs-schemes.c~mm-damon-sysfs-schemes-set-damos-migrate_dests
+++ a/mm/damon/sysfs-schemes.c
@@ -2576,6 +2576,29 @@ void damos_sysfs_update_effective_quotas
 	}
 }
 
+static int damos_sysfs_add_migrate_dest(struct damos *scheme,
+		struct damos_sysfs_dests *sysfs_dests)
+{
+	struct damos_migrate_dests *dests = &scheme->migrate_dests;
+	int i;
+
+	dests->node_id_arr = kmalloc_array(sysfs_dests->nr,
+			sizeof(*dests->node_id_arr), GFP_KERNEL);
+	if (!dests->node_id_arr)
+		return -ENOMEM;
+	dests->weight_arr = kmalloc_array(sysfs_dests->nr,
+			sizeof(*dests->weight_arr), GFP_KERNEL);
+	if (!dests->weight_arr)
+		/* ->node_id_arr will be freed by scheme destruction */
+		return -ENOMEM;
+	for (i = 0; i < sysfs_dests->nr; i++) {
+		dests->node_id_arr[i] = sysfs_dests->dests_arr[i]->id;
+		dests->weight_arr[i] = sysfs_dests->dests_arr[i]->weight;
+	}
+	dests->nr_dests = sysfs_dests->nr;
+	return 0;
+}
+
 static struct damos *damon_sysfs_mk_scheme(
 		struct damon_sysfs_scheme *sysfs_scheme)
 {
@@ -2637,6 +2660,11 @@ static struct damos *damon_sysfs_mk_sche
 	if (err) {
 		damon_destroy_scheme(scheme);
 		return NULL;
+	}
+	err = damos_sysfs_add_migrate_dest(scheme, sysfs_scheme->dests);
+	if (err) {
+		damon_destroy_scheme(scheme);
+		return NULL;
 	}
 	return scheme;
 }
_

Patches currently in -mm which might be from sj@kernel.org are

mm-damon-core-commit-damos_quota_goal-nid.patch
mm-damon-sysfs-implement-refresh_ms-file-under-kdamond-directory.patch
mm-damon-sysfs-implement-refresh_ms-file-internal-work.patch
docs-admin-guide-mm-damon-usage-document-refresh_ms-file.patch
docs-abi-damon-update-for-refresh_ms.patch

