Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3C2EF370AD3
	for <mm-commits@vger.kernel.org>; Fri, 29 May 2026 04:07:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780027646; cv=none; b=YBwHfnByWoZZshAYKFHzP7tGWLIdoIHz16fRbyrbaXuAn32rsxRn0LV+rhPlm8IGCM+qcu3KNGLGTzRO5KKU8fbLJJ4R5bflebhGyUilOpA3U3/vMop073qUdgoa/DhElElncWxOufEK2H0meJgWdeeYD2R2d7JZ7V5C9jEGt6g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780027646; c=relaxed/simple;
	bh=YhSxY7bPmlwQi0SE7Yl6wcT0ob7O8vEVfdKUVStQYEg=;
	h=Date:To:From:Subject:Message-Id; b=q7LPr8wSpzRtWYos7HckHgoUySF2Z9l9dkQ1Eb6GEOWnhu5Sg3Fr88m8tLU9Wl906uFPUFKTIzVUMmsVf0khTcoiVoP0R/eCR2SiJi1pWBABFrRObfL8Stt9Y2Wyt/cuVhakubB4z3lXT/NIgBCb3ndhL26ueSt9Qxpel4v87UY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=kX6gy8p+; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="kX6gy8p+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0F2951F00893;
	Fri, 29 May 2026 04:07:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1780027645;
	bh=uplBDLNXeouzeW1CBb/c+aEg8lWV78ggikmGcuiKOJk=;
	h=Date:To:From:Subject;
	b=kX6gy8p+3FvS/xTInX4mh+fJ74WDL8PxmWNLRraW0QXeTsUO/dgq6/c4d2Yms19Tn
	 iZZfVAwybZnq91UiOmb0BUdL+EcjWqu3tcg9wQo26/XjLV0tOhBrbuXgHtJmG4ZTGD
	 fEwxBQImShr7Nchpl+NC7wpSXy9E8uF64wBQwfHI=
Date: Thu, 28 May 2026 21:07:24 -0700
To: mm-commits@vger.kernel.org,vbabka@kernel.org,surenb@google.com,skhan@linuxfoundation.org,sj@kernel.org,rppt@kernel.org,mhocko@suse.com,ljs@kernel.org,liam@infradead.org,hank20010209@gmail.com,gutierrez.asier@huawei-partners.com,david@kernel.org,corbet@lwn.net,aethernet65535@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-damon-add-synchronous-commit-for-commit_inputs.patch removed from -mm tree
Message-Id: <20260529040725.0F2951F00893@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/damon: add synchronous commit for commit_inputs
has been removed from the -mm tree.  Its filename was
     mm-damon-add-synchronous-commit-for-commit_inputs.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Liew Rui Yan <aethernet65535@gmail.com>
Subject: mm/damon: add synchronous commit for commit_inputs
Date: Sun, 26 Apr 2026 16:16:16 -0700

Problem
=======
Writing invalid parameters to sysfs followed by 'commit_inputs=Y' fails
silently (no error returned to shell), because the validation happens
asynchronously in the kdamond.

Solution
========
To fix this, the commit_inputs_store() callback now uses damon_call() to
synchronously commit parameters in the kdamond thread's safe context.
This ensures that validation errors are returned immediately to
userspace, following the pattern used by DAMON_SYSFS.

Changes
=======
1. Added commit_inputs_store() and commit_inputs_fn() to commit
   synchronously.
2. Removed handle_commit_inputs().

This change is motivated from another discussion [1].

Link: https://lore.kernel.org/20260426231619.107231-4-sj@kernel.org
Link: https://lore.kernel.org/20260318153731.97470-1-aethernet65535@gmail.com [1]
Signed-off-by: Liew Rui Yan <aethernet65535@gmail.com>
Reviewed-by: SeongJae Park <sj@kernel.org>
Signed-off-by: SeongJae Park <sj@kernel.org>
Cc: Asier Gutierrez <gutierrez.asier@huawei-partners.com>
Cc: Cheng-Han Wu <hank20010209@gmail.com>
Cc: David Hildenbrand <david@kernel.org>
Cc: Jonathan Corbet <corbet@lwn.net>
Cc: Liam R. Howlett <liam@infradead.org>
Cc: Lorenzo Stoakes <ljs@kernel.org>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Mike Rapoport <rppt@kernel.org>
Cc: Shuah Khan <skhan@linuxfoundation.org>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: Vlastimil Babka <vbabka@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/damon/lru_sort.c |   46 +++++++++++++++++++++++++++++++++++-------
 mm/damon/reclaim.c  |   46 +++++++++++++++++++++++++++++++++++-------
 2 files changed, 78 insertions(+), 14 deletions(-)

--- a/mm/damon/lru_sort.c~mm-damon-add-synchronous-commit-for-commit_inputs
+++ a/mm/damon/lru_sort.c
@@ -39,7 +39,6 @@ static bool enabled __read_mostly;
  * the re-reading, DAMON_LRU_SORT will be disabled.
  */
 static bool commit_inputs __read_mostly;
-module_param(commit_inputs, bool, 0600);
 
 /*
  * Desired active to [in]active memory ratio in bp (1/10,000).
@@ -340,18 +339,51 @@ out:
 	return err;
 }
 
-static int damon_lru_sort_handle_commit_inputs(void)
+static int damon_lru_sort_commit_inputs_fn(void *arg)
 {
+	return damon_lru_sort_apply_parameters();
+}
+
+static int damon_lru_sort_commit_inputs_store(const char *val,
+					      const struct kernel_param *kp)
+{
+	bool commit_inputs_request;
 	int err;
+	struct damon_call_control control = {
+		.fn = damon_lru_sort_commit_inputs_fn,
+	};
+
+	if (!val) {
+		commit_inputs_request = true;
+	} else {
+		err = kstrtobool(val, &commit_inputs_request);
+		if (err)
+			return err;
+	}
 
-	if (!commit_inputs)
+	if (!commit_inputs_request)
 		return 0;
 
-	err = damon_lru_sort_apply_parameters();
-	commit_inputs = false;
-	return err;
+	/*
+	 * Skip damon_call() if ctx is not initialized to avoid
+	 * NULL pointer dereference.
+	 */
+	if (!ctx)
+		return -EINVAL;
+
+	err = damon_call(ctx, &control);
+
+	return err ? err : control.return_code;
 }
 
+static const struct kernel_param_ops commit_inputs_param_ops = {
+	.flags = KERNEL_PARAM_OPS_FL_NOARG,
+	.set = damon_lru_sort_commit_inputs_store,
+	.get = param_get_bool,
+};
+
+module_param_cb(commit_inputs, &commit_inputs_param_ops, &commit_inputs, 0600);
+
 static int damon_lru_sort_damon_call_fn(void *arg)
 {
 	struct damon_ctx *c = arg;
@@ -365,7 +397,7 @@ static int damon_lru_sort_damon_call_fn(
 			damon_lru_sort_cold_stat = s->stat;
 	}
 
-	return damon_lru_sort_handle_commit_inputs();
+	return 0;
 }
 
 static struct damon_call_control call_control = {
--- a/mm/damon/reclaim.c~mm-damon-add-synchronous-commit-for-commit_inputs
+++ a/mm/damon/reclaim.c
@@ -39,7 +39,6 @@ static bool enabled __read_mostly;
  * re-reading, DAMON_RECLAIM will be disabled.
  */
 static bool commit_inputs __read_mostly;
-module_param(commit_inputs, bool, 0600);
 
 /*
  * Time threshold for cold memory regions identification in microseconds.
@@ -246,18 +245,51 @@ out:
 	return err;
 }
 
-static int damon_reclaim_handle_commit_inputs(void)
+static int damon_reclaim_commit_inputs_fn(void *arg)
 {
+	return damon_reclaim_apply_parameters();
+}
+
+static int damon_reclaim_commit_inputs_store(const char *val,
+					     const struct kernel_param *kp)
+{
+	bool commit_inputs_request;
 	int err;
+	struct damon_call_control control = {
+		.fn = damon_reclaim_commit_inputs_fn,
+	};
+
+	if (!val) {
+		commit_inputs_request = true;
+	} else {
+		err = kstrtobool(val, &commit_inputs_request);
+		if (err)
+			return err;
+	}
 
-	if (!commit_inputs)
+	if (!commit_inputs_request)
 		return 0;
 
-	err = damon_reclaim_apply_parameters();
-	commit_inputs = false;
-	return err;
+	/*
+	 * Skip damon_call() if ctx is not initialized to avoid
+	 * NULL pointer dereference.
+	 */
+	if (!ctx)
+		return -EINVAL;
+
+	err = damon_call(ctx, &control);
+
+	return err ? err : control.return_code;
 }
 
+static const struct kernel_param_ops commit_inputs_param_ops = {
+	.flags = KERNEL_PARAM_OPS_FL_NOARG,
+	.set = damon_reclaim_commit_inputs_store,
+	.get = param_get_bool,
+};
+
+module_param_cb(commit_inputs, &commit_inputs_param_ops, &commit_inputs, 0600);
+
 static int damon_reclaim_damon_call_fn(void *arg)
 {
 	struct damon_ctx *c = arg;
@@ -267,7 +299,7 @@ static int damon_reclaim_damon_call_fn(v
 	damon_for_each_scheme(s, c)
 		damon_reclaim_stat = s->stat;
 
-	return damon_reclaim_handle_commit_inputs();
+	return 0;
 }
 
 static struct damon_call_control call_control = {
_

Patches currently in -mm which might be from aethernet65535@gmail.com are

mm-damon-lru_sort-validate-min_region_size-to-be-power-of-2.patch
mm-damon-reclaim-validate-min_region_size-to-be-power-of-2.patch

