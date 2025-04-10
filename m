Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2E0AFBA33
	for <mm-commits@vger.kernel.org>; Thu, 10 Apr 2025 01:32:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744248756; cv=none; b=AOv3elNUV3OPTMpexVvZJcfIjRZZNntOw0HMYkFQGiQQBwmFP+FGFkGxOcdzErQU6Cd0wIdoZH/OG7ifM1HEveTZnbrkvaNPnrv1mUD9aeCRTL9Oak2nHCeOvcoB5/wvIrQH6KUoy9ryAu0AuWhk7LN2RIEuBHTI1+YmQcEmInU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744248756; c=relaxed/simple;
	bh=wAM31qnwRQhW6rpCeRHEMhc5tiMFyvPnRfoJNy+49Ho=;
	h=Date:To:From:Subject:Message-Id; b=ErisnJ9WghdifCE94KHmLXC9nbslelChVbHJy3LPXpZg8Tg2z2tdUQqFoLZCQ5BW4C6YbkIKVabMncX1TiVPvlkw87aZ32CHs4z4Wd/F51Zg2DEAV5z+8W0slLmNc0lkvQNBywEQH8f15Pu5OVmcM6ZJmismJaLvatbgU/6C70Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=oTyZvP6g; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="oTyZvP6g"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6F8E7C4CEE2;
	Thu, 10 Apr 2025 01:32:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1744248755;
	bh=wAM31qnwRQhW6rpCeRHEMhc5tiMFyvPnRfoJNy+49Ho=;
	h=Date:To:From:Subject:From;
	b=oTyZvP6gi6dAykLW1q93pD00n2ogayb4YsADm1D8P2RqWuU6JmnkX6eNv0Uz1k/qZ
	 RivNOoS2rMhplOPFVhmoj27ploXwTWEfXmCAP7U6Wi61HVAQPQcaQR3eYez/TUcWQz
	 4k4ac3VtutsYMnI/8rUvyeJuFVTupXahreO1SPcY=
Date: Wed, 09 Apr 2025 18:32:34 -0700
To: mm-commits@vger.kernel.org,vbabka@suse.cz,mgorman@techsingularity.net,linyunsheng@huawei.com,jackmanb@google.com,carlos.song@nxp.com,hannes@cmpxchg.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-page_alloc-speed-up-fallbacks-in-rmqueue_bulk-fix-2.patch added to mm-hotfixes-unstable branch
Message-Id: <20250410013235.6F8E7C4CEE2@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm: page_alloc: speed up fallbacks in rmqueue_bulk() fix
has been added to the -mm mm-hotfixes-unstable branch.  Its filename is
     mm-page_alloc-speed-up-fallbacks-in-rmqueue_bulk-fix-2.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-page_alloc-speed-up-fallbacks-in-rmqueue_bulk-fix-2.patch

This patch will later appear in the mm-hotfixes-unstable branch at
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
From: Johannes Weiner <hannes@cmpxchg.org>
Subject: mm: page_alloc: speed up fallbacks in rmqueue_bulk() fix
Date: Wed, 9 Apr 2025 09:56:52 -0400

reset rmqueue_mode in rmqueue_buddy() error loop, per Yunsheng Lin

Link: https://lkml.kernel.org/r/20250409140023.GA2313@cmpxchg.org
Signed-off-by: Johannes Weiner <hannes@cmpxchg.org>
Cc: Brendan Jackman <jackmanb@google.com>
Cc: Carlos Song <carlos.song@nxp.com>
Cc: linyunsheng <linyunsheng@huawei.com>
Cc: Mel Gorman <mgorman@techsingularity.net>
Cc: Vlastimil Babka <vbabka@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/page_alloc.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/mm/page_alloc.c~mm-page_alloc-speed-up-fallbacks-in-rmqueue_bulk-fix-2
+++ a/mm/page_alloc.c
@@ -2979,7 +2979,6 @@ struct page *rmqueue_buddy(struct zone *
 {
 	struct page *page;
 	unsigned long flags;
-	enum rmqueue_mode rmqm = RMQUEUE_NORMAL;
 
 	do {
 		page = NULL;
@@ -2992,6 +2991,8 @@ struct page *rmqueue_buddy(struct zone *
 		if (alloc_flags & ALLOC_HIGHATOMIC)
 			page = __rmqueue_smallest(zone, order, MIGRATE_HIGHATOMIC);
 		if (!page) {
+			enum rmqueue_mode rmqm = RMQUEUE_NORMAL;
+
 			page = __rmqueue(zone, order, migratetype, alloc_flags, &rmqm);
 
 			/*
_

Patches currently in -mm which might be from hannes@cmpxchg.org are

mm-page_alloc-speed-up-fallbacks-in-rmqueue_bulk.patch
mm-page_alloc-speed-up-fallbacks-in-rmqueue_bulk-fix-2.patch
mm-page_alloc-tighten-up-find_suitable_fallback.patch

