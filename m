Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DD4A213A403
	for <mm-commits@vger.kernel.org>; Tue, 23 Jul 2024 01:28:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721698138; cv=none; b=jYdwa1MBc41b9COIcefQiRrZoPhUOleiDjiuwnP5KcNqp+l67KVZIrINXd3dcv7BylbpFq7FfhQRN6UFrev/Xq/vksD7gfBv0zvZZ6JwZpm8MvGBeCdSiQboN1ElJsTVZV/lwubpXNl7dyxmr/B3lPW/RXcHfPfRzrbKdfzvnwI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721698138; c=relaxed/simple;
	bh=tvBDh26o25Ih7LUuoagSsDXy9gHUnhRQT0HFt2PVVhU=;
	h=Date:To:From:Subject:Message-Id; b=csanD55E8jyw9DyqVUANp3mVGl2JJ1kn32kJK3x51oPKeMg0UCaHNQevZVuTq0vrr1QPcpnnunnkRuwQsmlQmi4itesbs1hR9NyR4frfr1aHic/4l4Te4WxKZXKkP4RHH3DugxwYjqwGnMpMQPo0GmFMpDAc6+GKSMOWhDdTm84=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=mleZJHph; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="mleZJHph"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7089BC116B1;
	Tue, 23 Jul 2024 01:28:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1721698137;
	bh=tvBDh26o25Ih7LUuoagSsDXy9gHUnhRQT0HFt2PVVhU=;
	h=Date:To:From:Subject:From;
	b=mleZJHphzOf5mu1sImHtRukCl8NX+WqGJ12iFla/W03XH16GJoOPtxVIa8q5EqWBv
	 scJXmons5y25JHtor1eHYtOAghWtLGpIJ7BJgo+1dpuUIS7a4KHc6Hw3Zm/88HBmBt
	 rQJB/VZUs/hmxBfbKBTjRVTW6yS4iGNZ0UzxXvfA=
Date: Mon, 22 Jul 2024 18:28:56 -0700
To: mm-commits@vger.kernel.org,ying.huang@intel.com,wangkefeng.wang@huawei.com,david@redhat.com,baolin.wang@linux.alibaba.com,ziy@nvidia.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + memory-tiering-count-pgpromote_success-when-mem-tiering-is-enabled.patch added to mm-unstable branch
Message-Id: <20240723012857.7089BC116B1@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: memory tiering: count PGPROMOTE_SUCCESS when mem tiering is enabled.
has been added to the -mm mm-unstable branch.  Its filename is
     memory-tiering-count-pgpromote_success-when-mem-tiering-is-enabled.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/memory-tiering-count-pgpromote_success-when-mem-tiering-is-enabled.patch

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
From: Zi Yan <ziy@nvidia.com>
Subject: memory tiering: count PGPROMOTE_SUCCESS when mem tiering is enabled.
Date: Mon, 22 Jul 2024 13:29:17 -0400

memory tiering can be enabled/disabled at runtime and
sysctl_numa_balancing_mode & NUMA_BALANCING_MEMORY_TIERING is used to
check it.  In migrate_misplaced_folio(), the check is missing when
PGPROMOTE_SUCCESS is incremented.  Add the missing check.

Link: https://lkml.kernel.org/r/20240722172917.503370-3-ziy@nvidia.com
Fixes: 33024536bafd ("memory tiering: hot page selection with hint page fault latency")
Signed-off-by: Zi Yan <ziy@nvidia.com>
Reported-by: Kefeng Wang <wangkefeng.wang@huawei.com>
Closes: https://lore.kernel.org/linux-mm/f4ae2c9c-fe40-4807-bdb2-64cf2d716c1a@huawei.com/
Cc: Baolin Wang <baolin.wang@linux.alibaba.com>
Cc: David Hildenbrand <david@redhat.com>
Cc: "Huang, Ying" <ying.huang@intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/migrate.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

--- a/mm/migrate.c~memory-tiering-count-pgpromote_success-when-mem-tiering-is-enabled
+++ a/mm/migrate.c
@@ -2630,7 +2630,9 @@ int migrate_misplaced_folio(struct folio
 		putback_movable_pages(&migratepages);
 	if (nr_succeeded) {
 		count_vm_numa_events(NUMA_PAGE_MIGRATE, nr_succeeded);
-		if (!node_is_toptier(folio_nid(folio)) && node_is_toptier(node))
+		if ((sysctl_numa_balancing_mode & NUMA_BALANCING_MEMORY_TIERING)
+		    && !node_is_toptier(folio_nid(folio))
+		    && node_is_toptier(node))
 			mod_node_page_state(pgdat, PGPROMOTE_SUCCESS,
 					    nr_succeeded);
 	}
_

Patches currently in -mm which might be from ziy@nvidia.com are

memory-tiering-read-last_cpupid-correctly-in-do_huge_pmd_numa_page.patch
memory-tiering-introduce-folio_has_cpupid-check.patch
memory-tiering-count-pgpromote_success-when-mem-tiering-is-enabled.patch

