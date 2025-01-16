Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 88F36172BD5
	for <mm-commits@vger.kernel.org>; Thu, 16 Jan 2025 05:44:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1737006285; cv=none; b=ecGbS3nwjyEFuiZ5AsxoY/Yr+iPuibF3tN0x05MeodivXujhO5RSxpf3oGveYFQKQx3SYbrYTYo8SRfIK5BVHOSdNvzHss6m9tkNLbpU18mZTfdTldTXOA6xa48H0LVaGbz1RAPsWsmDeDZx9xyyinKFMccPCkdiZgk98TJwdD0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1737006285; c=relaxed/simple;
	bh=6OgnnnYqbFtBXo2mQkGCUpV/ljhyErYNIIf05xizQjo=;
	h=Date:To:From:Subject:Message-Id; b=SaL89NPzClSp6XpVKZouZgrX36M/nscQ6BD77NfTpQ5gijEHYtk04SqD/xmAlYLcg1PCgE6FlTtbgX7KEvf2zFjIcW16RmWWSAtNxW5Nco/e2bdyM0wcOKiPEWGnaN68tHsJiX/fv1+30+YAteyREyA7WPV+gTz/qYoC4AXBTZ0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=K48HtB2p; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="K48HtB2p"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5DE00C4CED6;
	Thu, 16 Jan 2025 05:44:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1737006285;
	bh=6OgnnnYqbFtBXo2mQkGCUpV/ljhyErYNIIf05xizQjo=;
	h=Date:To:From:Subject:From;
	b=K48HtB2phJO9G60w1lWE0wCYtV2ZUf18C2gddLV79QBGNtARku4R80bsnTGdfoNE1
	 iOc1BkczQavfHhcQQ/YVZDUxH/SOmCTDt5ctV2Uf++yzXw6skpXyv8IzOSs3nT9DHN
	 5OXp8lx6LUFQ1YfnmU92qeKNTTHJAHBSyDAnUd2c=
Date: Wed, 15 Jan 2025 21:44:44 -0800
To: mm-commits@vger.kernel.org,ziy@nvidia.com,david@redhat.com,willy@infradead.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-remove-pagetranstail.patch removed from -mm tree
Message-Id: <20250116054445.5DE00C4CED6@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm: remove PageTransTail()
has been removed from the -mm tree.  Its filename was
     mm-remove-pagetranstail.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: "Matthew Wilcox (Oracle)" <willy@infradead.org>
Subject: mm: remove PageTransTail()
Date: Thu, 9 Jan 2025 15:22:21 +0000

The last caller was removed in October.  Also remove the FALSE definition
of PageTransCompoundMap(); the normal definition was removed a few years
ago.

Link: https://lkml.kernel.org/r/20250109152245.1591914-1-willy@infradead.org
Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
Acked-by: David Hildenbrand <david@redhat.com>
Acked-by: Zi Yan <ziy@nvidia.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/page-flags.h |   12 ------------
 1 file changed, 12 deletions(-)

--- a/include/linux/page-flags.h~mm-remove-pagetranstail
+++ a/include/linux/page-flags.h
@@ -894,21 +894,9 @@ static inline int PageTransCompound(cons
 {
 	return PageCompound(page);
 }
-
-/*
- * PageTransTail returns true for both transparent huge pages
- * and hugetlbfs pages, so it should only be called when it's known
- * that hugetlbfs pages aren't involved.
- */
-static inline int PageTransTail(const struct page *page)
-{
-	return PageTail(page);
-}
 #else
 TESTPAGEFLAG_FALSE(TransHuge, transhuge)
 TESTPAGEFLAG_FALSE(TransCompound, transcompound)
-TESTPAGEFLAG_FALSE(TransCompoundMap, transcompoundmap)
-TESTPAGEFLAG_FALSE(TransTail, transtail)
 #endif
 
 #if defined(CONFIG_MEMORY_FAILURE) && defined(CONFIG_TRANSPARENT_HUGEPAGE)
_

Patches currently in -mm which might be from willy@infradead.org are


