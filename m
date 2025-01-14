Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CC48123C70A
	for <mm-commits@vger.kernel.org>; Tue, 14 Jan 2025 06:44:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736837087; cv=none; b=Q2S0wzmVQfuaVOuYQ7kw0ZU1jrTi8kOvEU3BfhPslGuNT+NHvx585ST16Luk/LrFvxIN5Ke/TpZU57nk5Y5bE5c8X+RNremndWqtbBV6WBVwQZ69qDRhsW5fYuqj4eoJ504OHCgAEENppOHJOZ8js478lSPpUtfr/fDWLYxzq4U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736837087; c=relaxed/simple;
	bh=zWGtDuGMpfjLRNo4XQ5zEHgm7w2IFat2syCbKxius/I=;
	h=Date:To:From:Subject:Message-Id; b=AqK+A9TLtDkU5wJx47dXehptIkE/QCWdxq/+Hw4JRNjvygVC9P0xECWumJTwf3qgKfTuB2SPXF9Ojom5EJeJVpzVihg1+miCydhYFYvyh+HDGtB4Yd/kj9Lqlc1SoZFnyhhtEXrwRlqXgZPJIarFV73eIWdkE1sf/BehZU6s0wQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=dOPlHZMS; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="dOPlHZMS"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A278DC4CEDD;
	Tue, 14 Jan 2025 06:44:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1736837087;
	bh=zWGtDuGMpfjLRNo4XQ5zEHgm7w2IFat2syCbKxius/I=;
	h=Date:To:From:Subject:From;
	b=dOPlHZMSfM1/s2bLPo87wjV5y1gntJBZEtK69c2m0ZJ+IykcM43beewYes0kMUdgQ
	 uzqSqGafI7UEiCnuzs5FHXTQWECDiyUBZf1J+BPvHPih3GeTTzEGUR4hlFWNmAzbAU
	 6/r+znLxwXXayoQJs6nynLyJCm++2s0Y+IVPq0B0=
Date: Mon, 13 Jan 2025 22:44:47 -0800
To: mm-commits@vger.kernel.org,yangerkun@huawei.com,chuck.lever@oracle.com,brauner@kernel.org,Liam.Howlett@Oracle.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] test_maple_tree-test-exhausted-upper-limit-of-mtree_alloc_cyclic.patch removed from -mm tree
Message-Id: <20250114064447.A278DC4CEDD@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: test_maple_tree: test exhausted upper limit of mtree_alloc_cyclic()
has been removed from the -mm tree.  Its filename was
     test_maple_tree-test-exhausted-upper-limit-of-mtree_alloc_cyclic.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: "Liam R. Howlett" <Liam.Howlett@Oracle.com>
Subject: test_maple_tree: test exhausted upper limit of mtree_alloc_cyclic()
Date: Mon, 16 Dec 2024 14:01:13 -0500

When the upper bound of the search is exhausted, the maple state may be
returned in an error state of -EBUSY.  This means maple state needs to be
reset before the second search in mas_alloc_cylic() to ensure the search
happens.  This test ensures the issue is not recreated.

Link: https://lkml.kernel.org/r/20241216190113.1226145-3-Liam.Howlett@oracle.com
Signed-off-by: Liam R. Howlett <Liam.Howlett@Oracle.com>
Reviewed-by: Yang Erkun <yangerkun@huawei.com>
Cc: Christian Brauner <brauner@kernel.org>
Cc: Chuck Lever <chuck.lever@oracle.com> says:
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/test_maple_tree.c |   28 ++++++++++++++++++++++++++++
 1 file changed, 28 insertions(+)

--- a/lib/test_maple_tree.c~test_maple_tree-test-exhausted-upper-limit-of-mtree_alloc_cyclic
+++ a/lib/test_maple_tree.c
@@ -3738,6 +3738,34 @@ static noinline void __init alloc_cyclic
 	}
 
 	mtree_destroy(mt);
+
+	/*
+	 * Issue with reverse search was discovered
+	 * https://lore.kernel.org/all/20241216060600.287B4C4CED0@smtp.kernel.org/
+	 * Exhausting the allocation area and forcing the search to wrap needs a
+	 * mas_reset() in mas_alloc_cyclic().
+	 */
+	next = 0;
+	mt_init_flags(mt, MT_FLAGS_ALLOC_RANGE);
+	for (int i = 0; i < 1023; i++) {
+		mtree_alloc_cyclic(mt, &location, mt, 2, 1024, &next, GFP_KERNEL);
+		MT_BUG_ON(mt, i != location - 2);
+		MT_BUG_ON(mt, i != next - 3);
+		MT_BUG_ON(mt, mtree_load(mt, location) != mt);
+	}
+	mtree_erase(mt, 123);
+	MT_BUG_ON(mt, mtree_load(mt, 123) != NULL);
+	mtree_alloc_cyclic(mt, &location, mt, 2, 1024, &next, GFP_KERNEL);
+	MT_BUG_ON(mt, 123 != location);
+	MT_BUG_ON(mt, 124 != next);
+	MT_BUG_ON(mt, mtree_load(mt, location) != mt);
+	mtree_erase(mt, 100);
+	mtree_alloc_cyclic(mt, &location, mt, 2, 1024, &next, GFP_KERNEL);
+	MT_BUG_ON(mt, 100 != location);
+	MT_BUG_ON(mt, 101 != next);
+	MT_BUG_ON(mt, mtree_load(mt, location) != mt);
+	mtree_destroy(mt);
+
 	/* Overflow test */
 	next = ULONG_MAX - 1;
 	ret = mtree_alloc_cyclic(mt, &location, mt, 2, ULONG_MAX, &next, GFP_KERNEL);
_

Patches currently in -mm which might be from Liam.Howlett@Oracle.com are


