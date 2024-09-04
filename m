Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B98667406F
	for <mm-commits@vger.kernel.org>; Wed,  4 Sep 2024 04:18:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725423498; cv=none; b=Szogc7UjcedQO14GqqOVc6lqUEhpjN+pnYEqoAPTLmER67VnyRoFINxDXNaG9vN6j7JHxu369kLc7wbC+xODtNzKcAk0+rwLQSxSkbAEhMfe+n0lnc3fwGzllZO5ftkSzJHvACT0CxzSoHeR8ZDXRfWcrMZv/XX7LdpXhdRZpxg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725423498; c=relaxed/simple;
	bh=DS4Rv3PPQk7NbWujbvHW6FKWvyetrOQzrbLXsVNHpOA=;
	h=Date:To:From:Subject:Message-Id; b=fjYee+Lm/SrjoUFfo2uUtYXKQG9KdRwLeq4snKywpJbcJzhplpnpVhTzwX3tkGLDN79G5ulxxqChhfsy4HM9u7ruWSESr7QmLnN4vFpXCUfXE0Zap1kVdE2ISlBez9pzGHtfD1ocqdgqJ1tBcN11bPE9xpMzYDHyF3WKKeG+AC8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=1xOJwQ5J; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="1xOJwQ5J"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8EF11C4CEC2;
	Wed,  4 Sep 2024 04:18:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1725423498;
	bh=DS4Rv3PPQk7NbWujbvHW6FKWvyetrOQzrbLXsVNHpOA=;
	h=Date:To:From:Subject:From;
	b=1xOJwQ5JlzTRxdMVh8V1hwwcXVOpmW48zAWuhwuVsZ9ABrsKOw+Kd9vKmfS4qtQlr
	 MywFLsN2+eD6VrhDB2qJt49BZHP2AUcdkkoCIP0IR4FBDYq2ISuNzrDh7IGt0QyRtj
	 Bx85/Mv+C8jhS4wI2Hx4MscDu5g+4H/S15L0qaM4=
Date: Tue, 03 Sep 2024 21:18:18 -0700
To: mm-commits@vger.kernel.org,peterx@redhat.com,oliver.sang@intel.com,fengwei.yin@intel.com,david@redhat.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-always-inline-_compound_head-with-config_hugetlb_page_optimize_vmemmap=y.patch removed from -mm tree
Message-Id: <20240904041818.8EF11C4CEC2@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm: always inline _compound_head() with CONFIG_HUGETLB_PAGE_OPTIMIZE_VMEMMAP=y
has been removed from the -mm tree.  Its filename was
     mm-always-inline-_compound_head-with-config_hugetlb_page_optimize_vmemmap=y.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: David Hildenbrand <david@redhat.com>
Subject: mm: always inline _compound_head() with CONFIG_HUGETLB_PAGE_OPTIMIZE_VMEMMAP=y
Date: Tue, 20 Aug 2024 14:22:10 +0200

We already force-inline page_fixed_fake_head(), page_is_fake_head() and
PageTail(), however the compiler might decide that _compound_head() is not
worthy to be inlined, because of page_fixed_fake_head().

The result is that, for example, PageAnonExclusive() now might involve a
function call when checking PageHuge(), which performs a
page_folio()->_compound_head() call.  This can lead to a slight regression
of the stress-ng.clone benchmark.

This is not super-urgent to fix, but always inlining _compound_head()
seems like the obvious thing to do for this primitive, similar to the
other ones.

This change restores the slight regression and a compilation with
CONFIG_HUGETLB_PAGE_OPTIMIZE_VMEMMAP=y shows no relevant bloat [2]:

	add/remove: 15/14 grow/shrink: 79/87 up/down: 12836/-13917 (-1081)
	...
	Total: Before=32786363, After=32785282, chg -0.00%

[1] https://lkml.kernel.org/r/817150f2-abf7-430f-9973-540bd6cdd26f@intel.com
[2] https://lore.kernel.org/all/116e117c-2821-401d-8e62-b85cdec37f4a@redhat.com/

Link: https://lkml.kernel.org/r/20240820122210.660140-1-david@redhat.com
Fixes: c0bff412e67b ("mm: allow anon exclusive check over hugetlb tail pages")
Signed-off-by: David Hildenbrand <david@redhat.com>
Reported-by: kernel test robot <oliver.sang@intel.com>
Closes: https://lore.kernel.org/oe-lkp/202407301049.5051dc19-oliver.sang@intel.com
Tested-by: Yin Fengwei <fengwei.yin@intel.com>
Cc: Peter Xu <peterx@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/page-flags.h |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/include/linux/page-flags.h~mm-always-inline-_compound_head-with-config_hugetlb_page_optimize_vmemmap=y
+++ a/include/linux/page-flags.h
@@ -232,7 +232,7 @@ static __always_inline int page_is_fake_
 	return page_fixed_fake_head(page) != page;
 }
 
-static inline unsigned long _compound_head(const struct page *page)
+static __always_inline unsigned long _compound_head(const struct page *page)
 {
 	unsigned long head = READ_ONCE(page->compound_head);
 
_

Patches currently in -mm which might be from david@redhat.com are


