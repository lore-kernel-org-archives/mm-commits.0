Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 56FA11D8E18;
	Fri, 24 Jan 2025 06:20:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1737699651; cv=none; b=gxUEK7IuOieHt5rx4Qfm4t88w3Q2ZCPTVgRqEWB22rhjIZCIfA/FuNt34iqABWHfT6Hy68N2O1Ej/RnU9J1GB4n9YhRazMh2pOrfkEr0F4FsW8hNP6zUxhoHq/D3EjrMytEmb3qMfKda2J5YU06JkGKeuDRZ+vsdLVSheBhWFGE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1737699651; c=relaxed/simple;
	bh=pCyJzrkdVxtlkd9wVAvQcfEuH0nsOTmaX++PPy3Ww4s=;
	h=Date:To:From:Subject:Message-Id; b=DY6zB16pC5mJkif+rplf2oB7X93z8KWo6jP2cW2NBjhjE0GGfukoPMJXQTsGwwa0qiBtWL97Ys8ofgC1uULLmQu27GDCakgD80biTngLpd4kc7A2/CaF/jII3/3RTRSBU2doo5EnPP5YRQvxAjCEqB0QVhieAcAWqptc/CVPokE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=1ZNz8HEl; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="1ZNz8HEl"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B3235C4CED2;
	Fri, 24 Jan 2025 06:20:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1737699650;
	bh=pCyJzrkdVxtlkd9wVAvQcfEuH0nsOTmaX++PPy3Ww4s=;
	h=Date:To:From:Subject:From;
	b=1ZNz8HEl5qYR7NJ8UzNuV3KMqcoO9iS20Vc/QCvoJuWG4pQ6BFt8zLuEO2yeWaGLo
	 c0sjr2a5U+ny84a9iFZb2JL/g0hZEAmcCfy6ALddqNl72onZafHEo6NgTW0LZch9Tu
	 XXNTcWGFutUOr0NaXJawHru2S8TkYI6fWyvD4+Eo=
Date: Thu, 23 Jan 2025 22:20:50 -0800
To: mm-commits@vger.kernel.org,willy@infradead.org,wangkefeng.wang@huawei.com,sunnanyong@huawei.com,stable@vger.kernel.org,shikemeng@huaweicloud.com,mgorman@techsingularity.net,david@redhat.com,baolin.wang@linux.alibaba.com,liushixin2@huawei.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-compaction-fix-ubsan-shift-out-of-bounds-warning.patch added to mm-unstable branch
Message-Id: <20250124062050.B3235C4CED2@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/compaction: fix UBSAN shift-out-of-bounds warning
has been added to the -mm mm-unstable branch.  Its filename is
     mm-compaction-fix-ubsan-shift-out-of-bounds-warning.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-compaction-fix-ubsan-shift-out-of-bounds-warning.patch

This patch will later appear in the mm-unstable branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next via the mm-everything
branch at git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
and is updated there every 2-3 working days

------------------------------------------------------
From: Liu Shixin <liushixin2@huawei.com>
Subject: mm/compaction: fix UBSAN shift-out-of-bounds warning
Date: Thu, 23 Jan 2025 10:10:29 +0800

syzkaller reported a UBSAN shift-out-of-bounds warning of (1UL << order)
in isolate_freepages_block().  The bogus compound_order can be any value
because it is union with flags.  Add back the MAX_PAGE_ORDER check to fix
the warning.

Link: https://lkml.kernel.org/r/20250123021029.2826736-1-liushixin2@huawei.com
Fixes: 3da0272a4c7d ("mm/compaction: correctly return failure with bogus compound_order in strict mode")
Signed-off-by: Liu Shixin <liushixin2@huawei.com>
Cc: Baolin Wang <baolin.wang@linux.alibaba.com>
Cc: David Hildenbrand <david@redhat.com>
Cc: Kefeng Wang <wangkefeng.wang@huawei.com>
Cc: Kemeng Shi <shikemeng@huaweicloud.com>
Cc: Mattew Wilcox <willy@infradead.org> [English fixes]
Cc: Mel Gorman <mgorman@techsingularity.net>
Cc: Nanyong Sun <sunnanyong@huawei.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/compaction.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/mm/compaction.c~mm-compaction-fix-ubsan-shift-out-of-bounds-warning
+++ a/mm/compaction.c
@@ -631,7 +631,8 @@ static unsigned long isolate_freepages_b
 		if (PageCompound(page)) {
 			const unsigned int order = compound_order(page);
 
-			if (blockpfn + (1UL << order) <= end_pfn) {
+			if ((order <= MAX_PAGE_ORDER) &&
+			    (blockpfn + (1UL << order) <= end_pfn)) {
 				blockpfn += (1UL << order) - 1;
 				page += (1UL << order) - 1;
 				nr_scanned += (1UL << order) - 1;
_

Patches currently in -mm which might be from liushixin2@huawei.com are

mm-page_isolation-avoid-call-folio_hstate-without-hugetlb_lock.patch
mm-compaction-fix-ubsan-shift-out-of-bounds-warning.patch

