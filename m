Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 74FE010F2
	for <mm-commits@vger.kernel.org>; Sun, 29 Mar 2026 00:40:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774744836; cv=none; b=uYIblbWNgLnE4PnuoR+jeBUKyXH20qXOesHsoP2ZhdkNQ+U7c6eNGcPfNJ85ZKEQGZIrXIBqI8vW5VAPdlV3zCkcv3WJ57qbHuc9a/HhS6kiwwtger466o+jJ3SPGOx5QO+dhmkoAa0MwJMo9w19+U6/OlXyg8TyAmgEOFiZ4Aw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774744836; c=relaxed/simple;
	bh=rHKC8xCJonUjL4UdQ9QyaMe6QUv2ZF4ZyEBzuBIBjdo=;
	h=Date:To:From:Subject:Message-Id; b=ocrM6J5W0+mZMh7U0jatKb3eFlBZDt5VNfj0uA9yqtISbbJRvS0jMMozfV/hsPBo+MzAxW8G8N10Yn18bhhgnC78Gcfkr+9Rk8QL4CWAxUxbry4Zsjccqwcn1I+rVpXl4jWoKc5KJ9Tm6BQc+b9CGH3dZsPcGqYp1eBRYaTd+O0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=pBlDgbQg; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="pBlDgbQg"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4EBA3C4CEF7;
	Sun, 29 Mar 2026 00:40:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1774744836;
	bh=rHKC8xCJonUjL4UdQ9QyaMe6QUv2ZF4ZyEBzuBIBjdo=;
	h=Date:To:From:Subject:From;
	b=pBlDgbQg6L/BdyIeIUEK4kZjinmLdGJfQGaJYUwNp10KSFPJsfpm8MU7uxvF5XRjm
	 H6oGj2dORGNb0qEcPecQAXSj9Lyt1LkCe1xvD/F0FXYgsFkw5rQmytNwvs1jA3Xm6W
	 XzRQnW4eLDWwsXIm9o2k34pCBwx6F4P4xzb9mjLY=
Date: Sat, 28 Mar 2026 17:40:35 -0700
To: mm-commits@vger.kernel.org,vbabka@kernel.org,surenb@google.com,skhan@linuxfoundation.org,rppt@kernel.org,mhocko@suse.com,ljs@kernel.org,lianux.mm@gmail.com,liam.howlett@oracle.com,david@kernel.org,davidgow@google.com,corbet@lwn.net,brendan.higgins@linux.dev,sj@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-damon-tests-core-kunit-add-a-test-for-damon_is_last_region.patch removed from -mm tree
Message-Id: <20260329004036.4EBA3C4CEF7@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/damon/tests/core-kunit: add a test for damon_is_last_region()
has been removed from the -mm tree.  Its filename was
     mm-damon-tests-core-kunit-add-a-test-for-damon_is_last_region.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: SeongJae Park <sj@kernel.org>
Subject: mm/damon/tests/core-kunit: add a test for damon_is_last_region()
Date: Sat, 7 Mar 2026 11:53:50 -0800

There was a bug [1] in damon_is_last_region().  Add a kunit test to not
reintroduce the bug.

Link: https://lkml.kernel.org/r/20260307195356.203753-3-sj@kernel.org
Link: https://lore.kernel.org/20260114152049.99727-1-sj@kernel.org/ [1]
Signed-off-by: SeongJae Park <sj@kernel.org>
Tested-by: wang lian <lianux.mm@gmail.com>
Reviewed-by: wang lian <lianux.mm@gmail.com>
Cc: Brendan Higgins <brendan.higgins@linux.dev>
Cc: David Gow <davidgow@google.com>
Cc: David Hildenbrand <david@kernel.org>
Cc: Jonathan Corbet <corbet@lwn.net>
Cc: Liam Howlett <liam.howlett@oracle.com>
Cc: Lorenzo Stoakes (Oracle) <ljs@kernel.org>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Mike Rapoport <rppt@kernel.org>
Cc: Shuah Khan <skhan@linuxfoundation.org>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: Vlastimil Babka <vbabka@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/damon/tests/core-kunit.h |   23 +++++++++++++++++++++++
 1 file changed, 23 insertions(+)

--- a/mm/damon/tests/core-kunit.h~mm-damon-tests-core-kunit-add-a-test-for-damon_is_last_region
+++ a/mm/damon/tests/core-kunit.h
@@ -1311,6 +1311,28 @@ static void damon_test_apply_min_nr_regi
 	damon_test_apply_min_nr_regions_for(test, 10, 2, 10, 2, 5);
 }
 
+static void damon_test_is_last_region(struct kunit *test)
+{
+	struct damon_region *r;
+	struct damon_target *t;
+	int i;
+
+	t = damon_new_target();
+	if (!t)
+		kunit_skip(test, "target alloc fail\n");
+
+	for (i = 0; i < 4; i++) {
+		r = damon_new_region(i * 2, (i + 1) * 2);
+		if (!r) {
+			damon_free_target(t);
+			kunit_skip(test, "region alloc %d fail\n", i);
+		}
+		damon_add_region(r, t);
+		KUNIT_EXPECT_TRUE(test, damon_is_last_region(r, t));
+	}
+	damon_free_target(t);
+}
+
 static struct kunit_case damon_test_cases[] = {
 	KUNIT_CASE(damon_test_target),
 	KUNIT_CASE(damon_test_regions),
@@ -1339,6 +1361,7 @@ static struct kunit_case damon_test_case
 	KUNIT_CASE(damon_test_feed_loop_next_input),
 	KUNIT_CASE(damon_test_set_filters_default_reject),
 	KUNIT_CASE(damon_test_apply_min_nr_regions),
+	KUNIT_CASE(damon_test_is_last_region),
 	{},
 };
 
_

Patches currently in -mm which might be from sj@kernel.org are

mm-damon-sysfs-dealloc-repeat_call_control-if-damon_call-fails.patch

