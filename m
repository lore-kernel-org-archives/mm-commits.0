Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1B20423A115
	for <mm-commits@vger.kernel.org>; Tue, 14 Jan 2025 06:42:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736836971; cv=none; b=hltH0DlPR4FuOu2Hj9nU45fg/sxNvp1Op0DryyQjNLD6xiReKrVdF0Gh1B51sraMO9UZL7qj50hKDeFPWDHBewWYnbH6jIr4E0+JWrb9e41ASSU1oUlkBL2+2dzEK1jcl3EktyF/GPQtvNbvmeoAOhBiay2YgrDp85QnFCLdlgA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736836971; c=relaxed/simple;
	bh=lSeW45YEQmHV562YR3yErj3gYj2ITs0kR57U2oJP2uI=;
	h=Date:To:From:Subject:Message-Id; b=F7Cn6osbjQOwH04J7IrmTo9hDvebxv7Pm4oqEmSyctfXLSFvNega1kyN/9wOyTO4RKSqlFQSReUk7N7e6gssFQFZ8NY8rMIKa1Uu39ZORztChF6sbsNa8YdxOMYacxq70epPyzrUCBp0quP+rpWRJLsSFkuqSBas0/I9Q7QBeUk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=duoBxLXh; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="duoBxLXh"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E3BCAC4CEDD;
	Tue, 14 Jan 2025 06:42:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1736836971;
	bh=lSeW45YEQmHV562YR3yErj3gYj2ITs0kR57U2oJP2uI=;
	h=Date:To:From:Subject:From;
	b=duoBxLXhk4sgDGl8MAX5Gdxim0uUr5onyeU4iYPuEgsrov8kXAxv/SS0dKiyP0l0u
	 2McSb6zMNWedTE/KQUESjk5DI9fYk6K158nELnXMAGx/0P0JtZ+NbSrw3laN4UAhU5
	 jJ3JSwtHB1XZ8iA08REAlK+y37S55zbiJb1L+k4M=
Date: Mon, 13 Jan 2025 22:42:50 -0800
To: mm-commits@vger.kernel.org,gaoxiang17@xiaomi.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-page_alloc-add-some-detailed-comments-in-can_steal_fallback.patch removed from -mm tree
Message-Id: <20250114064250.E3BCAC4CEDD@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/page_alloc: add some detailed comments in can_steal_fallback
has been removed from the -mm tree.  Its filename was
     mm-page_alloc-add-some-detailed-comments-in-can_steal_fallback.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: gaoxiang17 <gaoxiang17@xiaomi.com>
Subject: mm/page_alloc: add some detailed comments in can_steal_fallback
Date: Fri, 20 Sep 2024 20:20:30 +0800

[akpm@linux-foundation.org: tweak grammar, fit to 80 cols]
Link: https://lkml.kernel.org/r/20240920122030.159751-1-gxxa03070307@gmail.com
Signed-off-by: gaoxiang17 <gaoxiang17@xiaomi.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/page_alloc.c |    8 ++++++++
 1 file changed, 8 insertions(+)

--- a/mm/page_alloc.c~mm-page_alloc-add-some-detailed-comments-in-can_steal_fallback
+++ a/mm/page_alloc.c
@@ -1855,6 +1855,14 @@ static bool can_steal_fallback(unsigned
 	if (order >= pageblock_order)
 		return true;
 
+	/*
+	 * Movable pages won't cause permanent fragmentation, so when you alloc
+	 * small pages, you just need to temporarily steal unmovable or
+	 * reclaimable pages that are closest to the request size.  After a
+	 * while, memory compaction may occur to form large contiguous pages,
+	 * and the next movable allocation may not need to steal.  Unmovable and
+	 * reclaimable allocations need to actually steal pages.
+	 */
 	if (order >= pageblock_order / 2 ||
 		start_mt == MIGRATE_RECLAIMABLE ||
 		start_mt == MIGRATE_UNMOVABLE ||
_

Patches currently in -mm which might be from gaoxiang17@xiaomi.com are


