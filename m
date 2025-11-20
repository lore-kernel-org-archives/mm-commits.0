Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 24390368289
	for <mm-commits@vger.kernel.org>; Thu, 20 Nov 2025 21:45:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763675109; cv=none; b=hkMP1eKryG9wLr5SlDAL+umAeyBOqd1JlYAN+Fx3I2Sg6+vfSYq1coiNpcB5tgRGTO617HlIJkiwDx2WdID1lJ4Ua84rWMWHJoqmYw1dyb8xSd0d7mxhzbBQh5UL7Wo4M6HYAtiGAxd1bsScSGTUa9xTl1PV71053JdrEAE94XU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763675109; c=relaxed/simple;
	bh=utRKBbMLTbVtIKzN7RgLWy0UDyZHfZlHEyKwZD+Hpro=;
	h=Date:To:From:Subject:Message-Id; b=JMcZS02nWEgWMkLj7uvCoNj9B2DKoZY75unbe9DqPLe5E/Tk4fUXoIItZXfzOeDAsg2TNjR3M8rkRkvEJAzTGkx6UDPIiK1vLy5Q6I5X0OgDWNw7Vty0mFsS33g+G6lO7NbDZUgK4JvXMz19IsllNRkmq+8GTGQmSSA5M9dzFqY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=uEbguGuZ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="uEbguGuZ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A39B0C4CEF1;
	Thu, 20 Nov 2025 21:45:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1763675108;
	bh=utRKBbMLTbVtIKzN7RgLWy0UDyZHfZlHEyKwZD+Hpro=;
	h=Date:To:From:Subject:From;
	b=uEbguGuZr3L7bbziyWPg1n7zz7R3nRZszPGbTnS67TZpZGtdP359YGuGyTqcqRFez
	 JqE4+PJFjLlxsoc5LgBS/t6F5B0aU7nUP30DktaKuLMGjeDS2L6536eIbuRqCn+3fD
	 oOtCKn3jXsd1BaQK9WxVkKKWX9ZqiOsCEgVBwfRE=
Date: Thu, 20 Nov 2025 13:45:08 -0800
To: mm-commits@vger.kernel.org,davidgow@google.com,brendan.higgins@linux.dev,sj@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-damon-tests-core-kunit-extend-damos_test_commit_filter_for-for-union-fields.patch removed from -mm tree
Message-Id: <20251120214508.A39B0C4CEF1@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/damon/tests/core-kunit: extend damos_test_commit_filter_for() for union fields
has been removed from the -mm tree.  Its filename was
     mm-damon-tests-core-kunit-extend-damos_test_commit_filter_for-for-union-fields.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: SeongJae Park <sj@kernel.org>
Subject: mm/damon/tests/core-kunit: extend damos_test_commit_filter_for() for union fields
Date: Tue, 11 Nov 2025 10:44:02 -0800

damos_commit_filter() also updates union fields of 'struct damos_filter'. 
Extend damos_test_commit_filter_for() to cover the expectations of the
union fields.

Link: https://lkml.kernel.org/r/20251111184415.141757-4-sj@kernel.org
Signed-off-by: SeongJae Park <sj@kernel.org>
Cc: Brendan Higgins <brendan.higgins@linux.dev>
Cc: David Gow <davidgow@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/damon/tests/core-kunit.h |   20 ++++++++++++++++++++
 1 file changed, 20 insertions(+)

--- a/mm/damon/tests/core-kunit.h~mm-damon-tests-core-kunit-extend-damos_test_commit_filter_for-for-union-fields
+++ a/mm/damon/tests/core-kunit.h
@@ -504,6 +504,26 @@ static void damos_test_commit_filter_for
 	KUNIT_EXPECT_EQ(test, dst->type, src->type);
 	KUNIT_EXPECT_EQ(test, dst->matching, src->matching);
 	KUNIT_EXPECT_EQ(test, dst->allow, src->allow);
+	switch (src->type) {
+	case DAMOS_FILTER_TYPE_MEMCG:
+		KUNIT_EXPECT_EQ(test, dst->memcg_id, src->memcg_id);
+		break;
+	case DAMOS_FILTER_TYPE_ADDR:
+		KUNIT_EXPECT_EQ(test, dst->addr_range.start,
+				src->addr_range.start);
+		KUNIT_EXPECT_EQ(test, dst->addr_range.end,
+				src->addr_range.end);
+		break;
+	case DAMOS_FILTER_TYPE_TARGET:
+		KUNIT_EXPECT_EQ(test, dst->target_idx, src->target_idx);
+		break;
+	case DAMOS_FILTER_TYPE_HUGEPAGE_SIZE:
+		KUNIT_EXPECT_EQ(test, dst->sz_range.min, src->sz_range.min);
+		KUNIT_EXPECT_EQ(test, dst->sz_range.max, src->sz_range.max);
+		break;
+	default:
+		break;
+	}
 }
 
 static void damos_test_commit_filter(struct kunit *test)
_

Patches currently in -mm which might be from sj@kernel.org are


