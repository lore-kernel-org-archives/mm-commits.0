Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 44D2D440A21;
	Tue, 13 Oct 2026 04:31:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791865902; cv=none; b=cwSocTjEaVRX6PXM0PwU2f9Vfik+MqUcOdJFGlt9hKWMYXOZ00zp/41xpb0lAG2nmgMSyzcTPIMTqsMtwQwLwIWlg3KRJFAKe8+gpPnPm7s7CMzJM4q59EM3jRm+vD9FsXRzlLqPp6ZAH6M9DeRGmDbBT8J8Re5/oQYUO6h2OUY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791865902; c=relaxed/simple;
	bh=lu2dJ6Z020YR/EMSvT0MMCG+QX/tSxwlx3jJFY5OLi4=;
	h=Date:To:From:Subject:Message-Id; b=heIut01l4T7yVMcimNaOZrAP4uDsEIXZzdiCq/7oYJokvWuwG8seN8/dURj0lzRfDVKNcM/YX5z+6ocFS503RaqtqbRGwG1nLx8Gr5FExzAhdwPXk4NodlpKdNmkWO5JnnI9qQ71xfl0eIIt3VWqrcWo4sdfQfNV59+L4YOBM04=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=sgct7qpk; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="sgct7qpk"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C9AC81F000FF;
	Tue, 13 Oct 2026 04:31:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1791865900;
	bh=k3pYH2TywVvkHlpcKMFyjaz6AcDePOcZV0IdEDriOjk=;
	h=Date:To:From:Subject;
	b=sgct7qpknGV4a9fA0oYHDyt8AwvNVPgsA7VtXHkIZCkjp72I8OfrzdLg+25A8aVWf
	 e7/rH3I3yO5Jq2w4GPmk/BpuyL772puIWDnDCO2uUPsVAVOSu6u/GUdIJv5xANG5r1
	 0t9yXpzQu/QVzIFKgvgbFjcCZr8osDugVbM0kKUU=
Date: Mon, 12 Oct 2026 21:31:40 -0700
To: mm-commits@vger.kernel.org,usamaarif642@gmail.com,stable@vger.kernel.org,kunwu.chan@gmail.com,davidgow@davidgow.net,brendan.higgins@linux.dev,sj@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-damon-core-return-an-error-from-damos_commit_filter_arg.patch removed from -mm tree
Message-Id: <20261013043140.C9AC81F000FF@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/damon/core: return an error from damos_commit_filter_arg()
has been removed from the -mm tree.  Its filename was
     mm-damon-core-return-an-error-from-damos_commit_filter_arg.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: SJ Park <sj@kernel.org>
Subject: mm/damon/core: return an error from damos_commit_filter_arg()
Date: Mon, 14 Sep 2026 07:23:20 -0700

damos_commit_filter_arg() is supposed to always succeed.  It may not in
future, for example, if the given filter is invalid.  Prepare the case by
modifying its signature to return an error when it failed.  Also pipe the
return value to its callers and let them handle the error.

Link: https://lore.kernel.org/20260914142327.92510-4-sj@kernel.org
Signed-off-by: SJ Park <sj@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Reviewed-by: Kunwu Chan <kunwu.chan@gmail.com>
Cc: Brendan Higgins <brendan.higgins@linux.dev>
Cc: David Gow <davidgow@davidgow.net>
Cc: Usama Arif <usamaarif642@gmail.com>
Cc: <stable@vger.kernel.org>
---

 mm/damon/core.c |   41 ++++++++++++++++++++++++++++-------------
 1 file changed, 28 insertions(+), 13 deletions(-)

--- a/mm/damon/core.c~mm-damon-core-return-an-error-from-damos_commit_filter_arg
+++ a/mm/damon/core.c
@@ -1317,7 +1317,7 @@ static struct damos_filter *damos_nth_op
 	return NULL;
 }
 
-static void damos_commit_filter_arg(
+static int damos_commit_filter_arg(
 		struct damos_filter *dst, struct damos_filter *src)
 {
 	switch (dst->type) {
@@ -1340,28 +1340,32 @@ static void damos_commit_filter_arg(
 	default:
 		break;
 	}
+	return 0;
 }
 
-static void damos_commit_filter(
+static int damos_commit_filter(
 		struct damos_filter *dst, struct damos_filter *src)
 {
 	dst->type = src->type;
 	dst->matching = src->matching;
 	dst->allow = src->allow;
-	damos_commit_filter_arg(dst, src);
+	return damos_commit_filter_arg(dst, src);
 }
 
 static int damos_commit_core_filters(struct damos *dst, struct damos *src)
 {
 	struct damos_filter *dst_filter, *next, *src_filter, *new_filter;
-	int i = 0, j = 0;
+	int i = 0, j = 0, err;
 
 	damos_for_each_core_filter_safe(dst_filter, next, dst) {
 		src_filter = damos_nth_core_filter(i++, src);
-		if (src_filter)
-			damos_commit_filter(dst_filter, src_filter);
-		else
+		if (src_filter) {
+			err = damos_commit_filter(dst_filter, src_filter);
+			if (err)
+				return err;
+		} else {
 			damos_destroy_filter(dst_filter);
+		}
 	}
 
 	damos_for_each_core_filter_safe(src_filter, next, src) {
@@ -1373,7 +1377,11 @@ static int damos_commit_core_filters(str
 				src_filter->allow);
 		if (!new_filter)
 			return -ENOMEM;
-		damos_commit_filter_arg(new_filter, src_filter);
+		err = damos_commit_filter_arg(new_filter, src_filter);
+		if (err) {
+			damos_destroy_filter(new_filter);
+			return err;
+		}
 		damos_add_filter(dst, new_filter);
 	}
 	return 0;
@@ -1382,14 +1390,17 @@ static int damos_commit_core_filters(str
 static int damos_commit_ops_filters(struct damos *dst, struct damos *src)
 {
 	struct damos_filter *dst_filter, *next, *src_filter, *new_filter;
-	int i = 0, j = 0;
+	int i = 0, j = 0, err;
 
 	damos_for_each_ops_filter_safe(dst_filter, next, dst) {
 		src_filter = damos_nth_ops_filter(i++, src);
-		if (src_filter)
-			damos_commit_filter(dst_filter, src_filter);
-		else
+		if (src_filter) {
+			err = damos_commit_filter(dst_filter, src_filter);
+			if (err)
+				return err;
+		} else {
 			damos_destroy_filter(dst_filter);
+		}
 	}
 
 	damos_for_each_ops_filter_safe(src_filter, next, src) {
@@ -1401,7 +1412,11 @@ static int damos_commit_ops_filters(stru
 				src_filter->allow);
 		if (!new_filter)
 			return -ENOMEM;
-		damos_commit_filter_arg(new_filter, src_filter);
+		err = damos_commit_filter_arg(new_filter, src_filter);
+		if (err) {
+			damos_destroy_filter(new_filter);
+			return err;
+		}
 		damos_add_filter(dst, new_filter);
 	}
 	return 0;
_

Patches currently in -mm which might be from sj@kernel.org are

mm-damon-core-introduce-damos_quota_goal-complement.patch
mm-damon-core-add-complement-argument-to-damos_new_quota_goal.patch
mm-damon-sysfs-schemes-support-quota-goal-complement-flag.patch
mm-damon-tests-core-kunit-test-quota_goal-complement-commit.patch
selftests-damon-sysfssh-test-quota-goal-complement-flag-file.patch
docs-mm-damon-design-document-damos-quota-goal-complement-flag.patch
docs-admin-guide-mm-damon-usage-update-for-quota-goal-complement-file.patch
docs-abi-damon-update-for-quota-goal-metric-complement-sysfs-file.patch

