Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4C0E37F57B
	for <mm-commits@vger.kernel.org>; Tue, 12 Dec 2023 18:59:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="m/OPU0W8"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 15FFBC433C8;
	Tue, 12 Dec 2023 18:59:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1702407571;
	bh=l4x2wW9z+Wtl4ohu5ScdpI9Va9Uk9PSISuDLwtbAdUc=;
	h=Date:To:From:Subject:From;
	b=m/OPU0W8YPBxisu7K/wLeHHIbxbVnBJ343o1DYwm4PFndyhGr7i3gOlPMZ8UvIq2F
	 Aka2jj21iNdF0SKgls5oG0LrwS2FIijC5FB2dOeZjRchJePPt4nCj0THHRBxbBay70
	 eLr8kq6I3ovBtet9UvQoVBCbqYcktxrABEqFPxdE=
Date: Tue, 12 Dec 2023 10:59:30 -0800
To: mm-commits@vger.kernel.org,shuah@kernel.org,davidgow@google.com,corbet@lwn.net,brendanhiggins@google.com,sj@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-damon-sysfs-schemes-commit-damos-quota-goals-user-input-to-damos.patch removed from -mm tree
Message-Id: <20231212185931.15FFBC433C8@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/damon/sysfs-schemes: commit damos quota goals user input to DAMOS
has been removed from the -mm tree.  Its filename was
     mm-damon-sysfs-schemes-commit-damos-quota-goals-user-input-to-damos.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: SeongJae Park <sj@kernel.org>
Subject: mm/damon/sysfs-schemes: commit damos quota goals user input to DAMOS
Date: Thu, 30 Nov 2023 02:36:46 +0000

Make DAMON sysfs interface to read the user inputs for DAMOS quota goals
and pass those to DAMOS, so that the users can use the quota auto-tuning
feature.  It uses the DAMON sysfs interface's user input commit mechanism,
which applies all user inputs for initial starting of DAMON and online
input updates, which can be done by writing 'on' and 'commit' to the
kdamond's 'state' file, respectively.  In other words, the user should
periodically write appropriate value to 'current_value' files and 'commit'
command to the 'state' file.  'target_value' files could also be similarly
updated at any time.

Note that the interface is supporting multiple goals while the core logic
supports only one goal.  DAMON sysfs interface passes only best feedback
among the given inputs, to avoid making DAMOS too aggressive.

Link: https://lkml.kernel.org/r/20231130023652.50284-4-sj@kernel.org
Signed-off-by: SeongJae Park <sj@kernel.org>
Cc: Brendan Higgins <brendanhiggins@google.com>
Cc: David Gow <davidgow@google.com>
Cc: Jonathan Corbet <corbet@lwn.net>
Cc: Shuah Khan <shuah@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/damon/sysfs-schemes.c |   32 ++++++++++++++++++++++++++++++++
 1 file changed, 32 insertions(+)

--- a/mm/damon/sysfs-schemes.c~mm-damon-sysfs-schemes-commit-damos-quota-goals-user-input-to-damos
+++ a/mm/damon/sysfs-schemes.c
@@ -1868,6 +1868,34 @@ static int damon_sysfs_set_scheme_filter
 	return 0;
 }
 
+static unsigned long damos_sysfs_get_quota_score(void *arg)
+{
+	return (unsigned long)arg;
+}
+
+static void damos_sysfs_set_quota_score(
+		struct damos_sysfs_quota_goals *sysfs_goals,
+		struct damos_quota *quota)
+{
+	struct damos_sysfs_quota_goal *sysfs_goal;
+	int i;
+
+	quota->get_score = NULL;
+	quota->get_score_arg = (void *)0;
+	for (i = 0; i < sysfs_goals->nr; i++) {
+		sysfs_goal = sysfs_goals->goals_arr[i];
+		if (!sysfs_goal->target_value)
+			continue;
+
+		/* Higher score makes scheme less aggressive */
+		quota->get_score_arg = (void *)max(
+				(unsigned long)quota->get_score_arg,
+				sysfs_goal->current_value * 10000 /
+				sysfs_goal->target_value);
+		quota->get_score = damos_sysfs_get_quota_score;
+	}
+}
+
 static struct damos *damon_sysfs_mk_scheme(
 		struct damon_sysfs_scheme *sysfs_scheme)
 {
@@ -1905,6 +1933,8 @@ static struct damos *damon_sysfs_mk_sche
 		.low = sysfs_wmarks->low,
 	};
 
+	damos_sysfs_set_quota_score(sysfs_quotas->goals, &quota);
+
 	scheme = damon_new_scheme(&pattern, sysfs_scheme->action,
 			sysfs_scheme->apply_interval_us, &quota, &wmarks);
 	if (!scheme)
@@ -1945,6 +1975,8 @@ static void damon_sysfs_update_scheme(st
 	scheme->quota.weight_nr_accesses = sysfs_weights->nr_accesses;
 	scheme->quota.weight_age = sysfs_weights->age;
 
+	damos_sysfs_set_quota_score(sysfs_quotas->goals, &scheme->quota);
+
 	scheme->wmarks.metric = sysfs_wmarks->metric;
 	scheme->wmarks.interval = sysfs_wmarks->interval_us;
 	scheme->wmarks.high = sysfs_wmarks->high;
_

Patches currently in -mm which might be from sj@kernel.org are

mm-damon-core-make-damon_start-waits-until-kdamond_fn-starts.patch

