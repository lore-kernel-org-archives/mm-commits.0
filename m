Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B421B1EB9E3
	for <mm-commits@vger.kernel.org>; Tue, 13 May 2025 06:53:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747119203; cv=none; b=OM6KfhmK9I0694FgJth9FQsLVsfyEPvgaJR1nF3BdngStKFrAy5CxpjJolaMvo+3gRlDhs1i6S0sdJeq9N6r0TpgnDLK9dH3GlOZ/KEapsKyE+GkG9lzdM/PhpTGt4ecS4Fpt7MRX39Tr4173p+yRKpJ5jIo84wrvVoNtvvVZh8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747119203; c=relaxed/simple;
	bh=9+VdgWT53qOVTqiOkBa+AkW+RO1bkAF7JuqQErEVGDM=;
	h=Date:To:From:Subject:Message-Id; b=kmT5DXsQTdVOVFLNpEN0SpmRsfzdOd4c+v7uCe/RdrcUi13zRqflnq3VVBYILbTMBxyIyBNi6PZpA5IGx/rKdvdFFsmzB7utiGWvLolkfE+6NgIqSRFR8LaprolZQ5Wd+DOazOjCN4/wDMEi3JtdxpPuXfdPyKUTNWaQy8giFqc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=RKG1+iEQ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="RKG1+iEQ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1AD5AC4CEEF;
	Tue, 13 May 2025 06:53:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1747119203;
	bh=9+VdgWT53qOVTqiOkBa+AkW+RO1bkAF7JuqQErEVGDM=;
	h=Date:To:From:Subject:From;
	b=RKG1+iEQWdptGh5RDNvOEVkx9DGxlWodE+pwMOSDQpvGGksxoowqzfSgbJzH0irGu
	 bV56Qo/uSsWeGASC37d7N+IKXU3o1bkf1zblpPjkI5L0zsBV83cxoKuCdOdl8mP9iS
	 Dv83dYya+7O6cWgZi83KZt4hmxdeGvFvuY9dEs2o=
Date: Mon, 12 May 2025 23:53:22 -0700
To: mm-commits@vger.kernel.org,yunjeong.mun@sk.com,corbet@lwn.net,sj@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-damon-sysfs-schemes-connect-damos_quota_goal-nid-with-core-layer.patch removed from -mm tree
Message-Id: <20250513065323.1AD5AC4CEEF@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/damon/sysfs-schemes: connect damos_quota_goal nid with core layer
has been removed from the -mm tree.  Its filename was
     mm-damon-sysfs-schemes-connect-damos_quota_goal-nid-with-core-layer.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: SeongJae Park <sj@kernel.org>
Subject: mm/damon/sysfs-schemes: connect damos_quota_goal nid with core layer
Date: Sun, 20 Apr 2025 12:40:26 -0700

DAMON sysfs interface file for DAMOS quota goal's node id argument is not
passed to core layer.  Implement the link.

Link: https://lkml.kernel.org/r/20250420194030.75838-4-sj@kernel.org
Signed-off-by: SeongJae Park <sj@kernel.org>
Cc: Jonathan Corbet <corbet@lwn.net>
Cc: Yunjeong Mun <yunjeong.mun@sk.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/damon/sysfs-schemes.c |   11 ++++++++++-
 1 file changed, 10 insertions(+), 1 deletion(-)

--- a/mm/damon/sysfs-schemes.c~mm-damon-sysfs-schemes-connect-damos_quota_goal-nid-with-core-layer
+++ a/mm/damon/sysfs-schemes.c
@@ -2149,8 +2149,17 @@ static int damos_sysfs_add_quota_score(
 				sysfs_goal->target_value);
 		if (!goal)
 			return -ENOMEM;
-		if (sysfs_goal->metric == DAMOS_QUOTA_USER_INPUT)
+		switch (sysfs_goal->metric) {
+		case DAMOS_QUOTA_USER_INPUT:
 			goal->current_value = sysfs_goal->current_value;
+			break;
+		case DAMOS_QUOTA_NODE_MEM_USED_BP:
+		case DAMOS_QUOTA_NODE_MEM_FREE_BP:
+			goal->nid = sysfs_goal->nid;
+			break;
+		default:
+			break;
+		}
 		damos_add_quota_goal(quota, goal);
 	}
 	return 0;
_

Patches currently in -mm which might be from sj@kernel.org are

mm-damon-core-warn-and-fix-nr_accesses-corruption.patch
mm-damon-sysfs-schemes-fix-wrong-comment-on-damons_sysfs_quota_goal_metric_strs.patch
mm-damon-paddr-remove-unused-variable-folio_list-in-damon_pa_stat.patch
mm-damon-tests-core-kunit-add-a-test-for-damos_set_filters_default_reject.patch
selftests-damon-_damon_sysfs-read-tried-regions-directories-in-order.patch
docs-damon-update-titles-and-brief-introductions-to-explain-damos.patch

