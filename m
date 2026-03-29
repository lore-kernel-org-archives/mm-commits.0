Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 78DE5246774
	for <mm-commits@vger.kernel.org>; Sun, 29 Mar 2026 00:40:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774744829; cv=none; b=hWBv+06uXfT1RI/qKpTNY3Uo3KhsBOQKAbwl9prv9pFmRVGGpa5u6AYl4sl9rgDVkT0MEC+D2fYDI/lxbhJbCfNinQ+ETtivFPNSHfBYQGb7EHRzTGr+nS6BQBz9ecIuI7Ow7QIMdi2LsVSFMKrJA0RJNYyf3FBtcK0HcELeZUE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774744829; c=relaxed/simple;
	bh=rmxfWuCpHJFKkVQVfc1VBGs7URO3QDGln2X20cntixc=;
	h=Date:To:From:Subject:Message-Id; b=JCvGZxnXUxXTXnOzCSr74/HmkAIQlfKwbUkkZ1IoXrrR249v8BntRbCncLroPVSVQHRYQ2KsPKMd1FT7AR5fLBhZgytH8bDgkVMjLIL2Bhznc6x1hwtsC/9wPR0ORfgZLg+yV/ISamCm5U9Sel6FaIn0e7mZ3EpdB+6XjnJZrAc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=KDVO7vYX; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="KDVO7vYX"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 16361C4CEF7;
	Sun, 29 Mar 2026 00:40:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1774744829;
	bh=rmxfWuCpHJFKkVQVfc1VBGs7URO3QDGln2X20cntixc=;
	h=Date:To:From:Subject:From;
	b=KDVO7vYX4WlwC80m3EZDFMcxbp1Zdgr19b5+8HUpGJbISJDqX7zFXsHbFE1JOzp/o
	 JzP+rWWdNlRJ0x0k0eFo8HsIPHOiE8JaKkBA+PJrX6Q3mBUMmvgk2G5GOmN3wHR6Jq
	 t5joz7aM60Ip4F8Nk9e+zSRQuP+2uPeWP2xKlSeU=
Date: Sat, 28 Mar 2026 17:40:28 -0700
To: mm-commits@vger.kernel.org,surenb@google.com,rppt@kernel.org,mhocko@suse.com,ljs@kernel.org,liam.howlett@oracle.com,david@kernel.org,davidgow@google.com,corbet@lwn.net,brendan.higgins@linux.dev,sj@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-damon-tests-core-kunit-add-a-test-for-damon_commit_ctx.patch removed from -mm tree
Message-Id: <20260329004029.16361C4CEF7@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/damon/tests/core-kunit: add a test for damon_commit_ctx()
has been removed from the -mm tree.  Its filename was
     mm-damon-tests-core-kunit-add-a-test-for-damon_commit_ctx.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: SeongJae Park <sj@kernel.org>
Subject: mm/damon/tests/core-kunit: add a test for damon_commit_ctx()
Date: Sat, 7 Mar 2026 11:42:20 -0800

Patch series "mm/damon: test and document power-of-2 min_region_sz
requirement".

Since commit c80f46ac228b ("mm/damon/core: disallow non-power of two
min_region_sz"), min_region_sz is always restricted to be a power of two. 
Add a kunit test to confirm the functionality.  Also, the change adds a
restriction to addr_unit parameter.  Clarify it on the document.


This patch (of 2):

Add a kunit test for confirming the change that is made on commit
c80f46ac228b ("mm/damon/core: disallow non-power of two min_region_sz")
functions as expected.

Link: https://lkml.kernel.org/r/20260307194222.202075-2-sj@kernel.org
Signed-off-by: SeongJae Park <sj@kernel.org>
Cc: Brendan Higgins <brendan.higgins@linux.dev>
Cc: David Gow <davidgow@google.com>
Cc: David Hildenbrand <david@kernel.org>
Cc: Jonathan Corbet <corbet@lwn.net>
Cc: Liam Howlett <liam.howlett@oracle.com>
Cc: Lorenzo Stoakes (Oracle) <ljs@kernel.org>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Mike Rapoport <rppt@kernel.org>
Cc: SeongJae Park <sj@kernel.org>
Cc: Suren Baghdasaryan <surenb@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/damon/tests/core-kunit.h |   22 ++++++++++++++++++++++
 1 file changed, 22 insertions(+)

--- a/mm/damon/tests/core-kunit.h~mm-damon-tests-core-kunit-add-a-test-for-damon_commit_ctx
+++ a/mm/damon/tests/core-kunit.h
@@ -1057,6 +1057,27 @@ static void damon_test_commit_target_reg
 			(unsigned long[][2]) {{3, 8}, {8, 10}}, 2);
 }
 
+static void damon_test_commit_ctx(struct kunit *test)
+{
+	struct damon_ctx *src, *dst;
+
+	src = damon_new_ctx();
+	if (!src)
+		kunit_skip(test, "src alloc fail");
+	dst = damon_new_ctx();
+	if (!dst) {
+		damon_destroy_ctx(src);
+		kunit_skip(test, "dst alloc fail");
+	}
+	/* Only power of two min_region_sz is allowed. */
+	src->min_region_sz = 4096;
+	KUNIT_EXPECT_EQ(test, damon_commit_ctx(dst, src), 0);
+	src->min_region_sz = 4095;
+	KUNIT_EXPECT_EQ(test, damon_commit_ctx(dst, src), -EINVAL);
+	damon_destroy_ctx(src);
+	damon_destroy_ctx(dst);
+}
+
 static void damos_test_filter_out(struct kunit *test)
 {
 	struct damon_target *t;
@@ -1313,6 +1334,7 @@ static struct kunit_case damon_test_case
 	KUNIT_CASE(damos_test_commit_pageout),
 	KUNIT_CASE(damos_test_commit_migrate_hot),
 	KUNIT_CASE(damon_test_commit_target_regions),
+	KUNIT_CASE(damon_test_commit_ctx),
 	KUNIT_CASE(damos_test_filter_out),
 	KUNIT_CASE(damon_test_feed_loop_next_input),
 	KUNIT_CASE(damon_test_set_filters_default_reject),
_

Patches currently in -mm which might be from sj@kernel.org are

mm-damon-sysfs-dealloc-repeat_call_control-if-damon_call-fails.patch

