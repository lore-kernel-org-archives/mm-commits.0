Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1D9E610F2
	for <mm-commits@vger.kernel.org>; Sun, 29 Mar 2026 00:40:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774744821; cv=none; b=NCJyab7BJKCJVGaMwKaeAsOteNkMIDUx5/m0IhhDJftB6uzyyDguC4mwSHyuydQCP8QyBJdPQNIzxo9lo3w9TV5VeWv5DuE7zUhypfRvPDYK0rNraO2q185X5tPGamT3XVKPbN5XFZGcZC8wJt7qMht39MokMbVV/43jOhDxYpo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774744821; c=relaxed/simple;
	bh=lDrWyhx0zkXke3oBX5YhLlZ92Eezf8CMK42urmTFPtc=;
	h=Date:To:From:Subject:Message-Id; b=XunSxiA5zYokJVOHpXqKcAszMqvvNDnIGGzscr4Ru0Q3k+8zu2EJZ79D9Q6Au98cwXCVG/AGesxyUGSYawyD7PlHGxV/kjlRvKo6hXBY4ieu2DArQdmalIscAj3V8xuMREPvMojU1VAcE5f68xY2CLA5adSxxUUnoKGOQAHmPyo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=1uWoYBaB; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="1uWoYBaB"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E1C0AC4CEF7;
	Sun, 29 Mar 2026 00:40:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1774744821;
	bh=lDrWyhx0zkXke3oBX5YhLlZ92Eezf8CMK42urmTFPtc=;
	h=Date:To:From:Subject:From;
	b=1uWoYBaBpO9xy1lTnS1XhBZrYx1Htg9Akl9dYT8HX6DtIHDvxYwOt6iGhqKiiJ2RM
	 wNGJ4LUFekrO+a292eIs9iJaXncVKXw+fdIn/o9QhP0xAxvxlt2kBIcHqDVutWFiZw
	 GU8SZgq4brHS2VqHlMYVpM54/5vwMifRDVoJe7NM=
Date: Sat, 28 Mar 2026 17:40:20 -0700
To: mm-commits@vger.kernel.org,shuah@kernel.org,davidgow@google.com,brendan.higgins@linux.dev,sj@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-damon-core-add-damon_nr_regions-debug_sanity-check.patch removed from -mm tree
Message-Id: <20260329004020.E1C0AC4CEF7@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/damon/core: add damon_nr_regions() debug_sanity check
has been removed from the -mm tree.  Its filename was
     mm-damon-core-add-damon_nr_regions-debug_sanity-check.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: SeongJae Park <sj@kernel.org>
Subject: mm/damon/core: add damon_nr_regions() debug_sanity check
Date: Fri, 6 Mar 2026 07:29:07 -0800

damon_target->nr_regions is introduced to get the number quickly without
having to iterate regions always.  Add a sanity check for that under
CONFIG_DAMON_DEBUG_SANITY.

Link: https://lkml.kernel.org/r/20260306152914.86303-5-sj@kernel.org
Signed-off-by: SeongJae Park <sj@kernel.org>
Cc: Brendan Higgins <brendan.higgins@linux.dev>
Cc: David Gow <davidgow@google.com>
Cc: Shuah Khan <shuah@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/damon/core.c |   19 +++++++++++++++++++
 1 file changed, 19 insertions(+)

--- a/mm/damon/core.c~mm-damon-core-add-damon_nr_regions-debug_sanity-check
+++ a/mm/damon/core.c
@@ -545,8 +545,27 @@ void damon_destroy_target(struct damon_t
 	damon_free_target(t);
 }
 
+#ifdef CONFIG_DAMON_DEBUG_SANITY
+static void damon_verify_nr_regions(struct damon_target *t)
+{
+	struct damon_region *r;
+	unsigned int count = 0;
+
+	damon_for_each_region(r, t)
+		count++;
+	WARN_ONCE(count != t->nr_regions, "t->nr_regions (%u) != count (%u)\n",
+			t->nr_regions, count);
+}
+#else
+static void damon_verify_nr_regions(struct damon_target *t)
+{
+}
+#endif
+
 unsigned int damon_nr_regions(struct damon_target *t)
 {
+	damon_verify_nr_regions(t);
+
 	return t->nr_regions;
 }
 
_

Patches currently in -mm which might be from sj@kernel.org are

mm-damon-sysfs-dealloc-repeat_call_control-if-damon_call-fails.patch

