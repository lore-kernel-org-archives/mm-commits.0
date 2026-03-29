Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E24D6221DAD
	for <mm-commits@vger.kernel.org>; Sun, 29 Mar 2026 00:40:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774744820; cv=none; b=EI/eqIRwX0JSn1wG3QdpBZPEtEt9wmUtm0++L7lZlcz7vIYxwiBNCLElRYVX7NU0tTGA2cjeqJ9P/dOCtNkgg1Kw0dKGSqYyAVJZH2RqrrAqfyQv0RKwI8IygVobW5f7YH/+2sBcPER8Hzh3/s1FEy3kPUm+EPV5q7Wxvl4oMUE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774744820; c=relaxed/simple;
	bh=0KC16YVd7MhaXQZny4IVVYZjeBdmkWUPAVqBne+QqrE=;
	h=Date:To:From:Subject:Message-Id; b=T5Wzl7SzbH4UOfsWW75JFabCBq77F1mbIbcVKQuKC9qYjRiqRVDwsaxn4/CBFZn+pjjySwLgy6wd6OG6mddU/tN6Rck1tYBiZ0ETl9TVYmEAzOJo/vkmXWmLu8hWghKfIeFkxBLhB7Jki83hjYzd9DbG5R5gi9ujZBvO7dh0p88=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=DQQN7+O+; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="DQQN7+O+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B9AFAC4CEF7;
	Sun, 29 Mar 2026 00:40:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1774744819;
	bh=0KC16YVd7MhaXQZny4IVVYZjeBdmkWUPAVqBne+QqrE=;
	h=Date:To:From:Subject:From;
	b=DQQN7+O+9Wwao6hKuZB/m3kPNj0voqehLFQhj6s1yDLFaKRjrLuejw4LxPAoPthwO
	 uxy7zCPzL+Yvcq3l/FEvShs1iGZLnDnzAw1Q9QDgM+3xGQsaVo9gX5YAln4g4cZnCn
	 cwVw0DDHDsEiew1KFGL/McPOoSNTYzUmZ4ucwBHo=
Date: Sat, 28 Mar 2026 17:40:19 -0700
To: mm-commits@vger.kernel.org,shuah@kernel.org,davidgow@google.com,brendan.higgins@linux.dev,sj@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-damon-core-add-damon_del_region-debug_sanity-check.patch removed from -mm tree
Message-Id: <20260329004019.B9AFAC4CEF7@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/damon/core: add damon_del_region() debug_sanity check
has been removed from the -mm tree.  Its filename was
     mm-damon-core-add-damon_del_region-debug_sanity-check.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: SeongJae Park <sj@kernel.org>
Subject: mm/damon/core: add damon_del_region() debug_sanity check
Date: Fri, 6 Mar 2026 07:29:06 -0800

damon_del_region() should be called for targets that have one or more
regions.  Add a sanity check for that under CONFIG_DAMON_DEBUG_SANITY.

Link: https://lkml.kernel.org/r/20260306152914.86303-4-sj@kernel.org
Signed-off-by: SeongJae Park <sj@kernel.org>
Cc: Brendan Higgins <brendan.higgins@linux.dev>
Cc: David Gow <davidgow@google.com>
Cc: Shuah Khan <shuah@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/damon/core.c |   13 +++++++++++++
 1 file changed, 13 insertions(+)

--- a/mm/damon/core.c~mm-damon-core-add-damon_del_region-debug_sanity-check
+++ a/mm/damon/core.c
@@ -152,8 +152,21 @@ void damon_add_region(struct damon_regio
 	t->nr_regions++;
 }
 
+#ifdef CONFIG_DAMON_DEBUG_SANITY
+static void damon_verify_del_region(struct damon_target *t)
+{
+	WARN_ONCE(t->nr_regions == 0, "t->nr_regions == 0\n");
+}
+#else
+static void damon_verify_del_region(struct damon_target *t)
+{
+}
+#endif
+
 static void damon_del_region(struct damon_region *r, struct damon_target *t)
 {
+	damon_verify_del_region(t);
+
 	list_del(&r->list);
 	t->nr_regions--;
 }
_

Patches currently in -mm which might be from sj@kernel.org are

mm-damon-sysfs-dealloc-repeat_call_control-if-damon_call-fails.patch

