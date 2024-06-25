Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 04D7514373B
	for <mm-commits@vger.kernel.org>; Tue, 25 Jun 2024 05:02:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719291738; cv=none; b=UpCXxdw2p1p32SoqTV//K1uNU1FSoGRpouKE1gkiMPWB5Jza6qwFj1bgJIbm2S+fLYJFlnv96RMLZnU0ZpZSqv76ICOaNhV1jy9cyxnU8a6qJppDjYxZ1heWSfVFQiMuIDYeh1aAoNJN0970z8j+XnIsOJM/7mBuNQQEEegrVZ4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719291738; c=relaxed/simple;
	bh=9q8nFdcwKELotVPGPghM3W3nXjAMx75rw6w+0C6V7oU=;
	h=Date:To:From:Subject:Message-Id; b=Y5RdSUwTzBdblzXj3k5VXlCRhYGVrkrKHIU6zy+xQtCjolmyvFixOZh2NE8IFRVHqgg0Yh1PHEyqOvzRJes6KbfP4u2wvI4tKUe2dr+PMhXxaD2IVGBie+i8fZgbsmfdVDB6dxXJ6BlNB8ZvwnGH1DKhA967PnBZbXCKBh6M/ts=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=Dk1yazON; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="Dk1yazON"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7D333C4AF0A;
	Tue, 25 Jun 2024 05:02:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1719291737;
	bh=9q8nFdcwKELotVPGPghM3W3nXjAMx75rw6w+0C6V7oU=;
	h=Date:To:From:Subject:From;
	b=Dk1yazONmRFzmROAo2sjxobjDSZyc1HOhiJH36UXIaGBpPiy9Wk+W/drfmiiY652v
	 +RuVMRIQfMv7HVi960j1gsZymIe5K9UtXRzbTl75nY73fmTtp/Tsp7hXGn+UPWjKQA
	 zZFdcJ3L9MRkorIZrhICxiNngs3o9JeWYFUTLa6A=
Date: Mon, 24 Jun 2024 22:02:17 -0700
To: mm-commits@vger.kernel.org,sj@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-damon-sysfs-schemes-use-damos_commit_quota_goals.patch removed from -mm tree
Message-Id: <20240625050217.7D333C4AF0A@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/damon/sysfs-schemes: use damos_commit_quota_goals()
has been removed from the -mm tree.  Its filename was
     mm-damon-sysfs-schemes-use-damos_commit_quota_goals.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: SeongJae Park <sj@kernel.org>
Subject: mm/damon/sysfs-schemes: use damos_commit_quota_goals()
Date: Tue, 18 Jun 2024 11:18:01 -0700

DAMON_SYSFS manually manipulates the DAMOS quota structs for online quotal
goals parameter update.  Since the struct contains not only input
parameters but also internal status and operation results, it is not that
simple.  Now DAMON core layer provides a function for the usage, namely
damon_commit_quota_goals().  Replace the manual manipulation logic with
the function.  The core layer function could have its own bugs, but this
change removes a source of bugs.

Link: https://lkml.kernel.org/r/20240618181809.82078-5-sj@kernel.org
Signed-off-by: SeongJae Park <sj@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/damon/sysfs-schemes.c |   14 ++++++++++++--
 1 file changed, 12 insertions(+), 2 deletions(-)

--- a/mm/damon/sysfs-schemes.c~mm-damon-sysfs-schemes-use-damos_commit_quota_goals
+++ a/mm/damon/sysfs-schemes.c
@@ -1983,10 +1983,13 @@ int damos_sysfs_set_quota_scores(struct
 		struct damon_ctx *ctx)
 {
 	struct damos *scheme;
+	struct damos_quota quota = {};
 	int i = 0;
 
+	INIT_LIST_HEAD(&quota.goals);
 	damon_for_each_scheme(scheme, ctx) {
 		struct damon_sysfs_scheme *sysfs_scheme;
+		struct damos_quota_goal *g, *g_next;
 		int err;
 
 		/* user could have removed the scheme sysfs dir */
@@ -1995,9 +1998,16 @@ int damos_sysfs_set_quota_scores(struct
 
 		sysfs_scheme = sysfs_schemes->schemes_arr[i];
 		err = damos_sysfs_set_quota_score(sysfs_scheme->quotas->goals,
-				&scheme->quota);
+				&quota);
+		if (err) {
+			damos_for_each_quota_goal_safe(g, g_next, &quota)
+				damos_destroy_quota_goal(g);
+			return err;
+		}
+		err = damos_commit_quota_goals(&scheme->quota, &quota);
+		damos_for_each_quota_goal_safe(g, g_next, &quota)
+			damos_destroy_quota_goal(g);
 		if (err)
-			/* kdamond will clean up schemes and terminated */
 			return err;
 		i++;
 	}
_

Patches currently in -mm which might be from sj@kernel.org are

mm-damon-core-merge-regions-aggressively-when-max_nr_regions-is-unmet.patch
docs-mm-damon-maintainer-profile-introduce-hackermail.patch
docs-mm-damon-maintainer-profile-document-damon-community-meetups.patch

