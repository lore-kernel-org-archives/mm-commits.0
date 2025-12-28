Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 920CBD531
	for <mm-commits@vger.kernel.org>; Sun, 28 Dec 2025 21:28:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1766957324; cv=none; b=tD9ArRCnEqWwp7eTGSMVHO+Bl4/TcXu1q9idmFRdpC4K9X7bHXF5iBY2MBINGXxszduEMiCl5admFnnTwsGUDZkeQ7VD/ldZ/ru0i+jCRLyDiYyV3ORxBNiaDPoApNwJZ7X77c5APipAbYtE8E9K3hb1pFpOjwAybOAdqSzD3OA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1766957324; c=relaxed/simple;
	bh=WryLTNUaXSFN9XG7U5DlUeUq9e96fWRUO7vbHyQZ0RU=;
	h=Date:To:From:Subject:Message-Id; b=AcYqqyDt2a2WDCIfZEHeUhKD8jXojacQ5GdZh3bwe42hBJbTp6Z9vPn7UWuPCjA9JL7F/0+BY8+QOTUwIjTG1UyHyCjYsF4RP3qkkgGmb1uFA7sN85CU1cdgyJaatCiSWR2FmAxrTRqOLUQZ2lPhTEUn3qqH5m1+gbby5zQ2JY0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=Ar3AgUBh; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="Ar3AgUBh"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EC856C4CEFB;
	Sun, 28 Dec 2025 21:28:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1766957324;
	bh=WryLTNUaXSFN9XG7U5DlUeUq9e96fWRUO7vbHyQZ0RU=;
	h=Date:To:From:Subject:From;
	b=Ar3AgUBhFzBc2mf2eKOii5zcr0gpRnRoM3BuYDyVER/7kxypLqdho8BjnZvkfeD+5
	 LqhIuLttNxPkv54HxmDBICsWAkN3TQxpfUIN7I0exvDzx5eXdjsmR0xQGKsyynTcPI
	 uqgC45t8aYGPr/GGyXeXtYvqRVbkTVxqLppV5aGQ=
Date: Sun, 28 Dec 2025 13:28:43 -0800
To: mm-commits@vger.kernel.org,joshua.hahnjy@gmail.com,richard.weiyang@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-vmstat-remove-unused-node-and-zone-state-helpers.patch added to mm-new branch
Message-Id: <20251228212843.EC856C4CEFB@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/vmstat: remove unused node and zone state helpers
has been added to the -mm mm-new branch.  Its filename is
     mm-vmstat-remove-unused-node-and-zone-state-helpers.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-vmstat-remove-unused-node-and-zone-state-helpers.patch

This patch will later appear in the mm-new branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Note, mm-new is a provisional staging ground for work-in-progress
patches, and acceptance into mm-new is a notification for others take
notice and to finish up reviews.  Please do not hesitate to respond to
review feedback and post updated versions to replace or incrementally
fixup patches in mm-new.

The mm-new branch of mm.git is not included in linux-next

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next via various
branches at git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
and is updated there most days

------------------------------------------------------
From: Wei Yang <richard.weiyang@gmail.com>
Subject: mm/vmstat: remove unused node and zone state helpers
Date: Thu, 25 Dec 2025 21:02:13 +0000

Several helper functions for managing node and zone states have become
obsolete and no longer have any callers within the kernel.

  inc_node_state()
  inc_zone_state()
  dec_zone_state()

This commit removes the dead code.

Link: https://lkml.kernel.org/r/20251225210213.2553-1-richard.weiyang@gmail.com
Signed-off-by: Wei Yang <richard.weiyang@gmail.com>
Reviewed-by: Joshua Hahn <joshua.hahnjy@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/vmstat.h |    6 ------
 mm/vmstat.c            |   15 ---------------
 2 files changed, 21 deletions(-)

--- a/include/linux/vmstat.h~mm-vmstat-remove-unused-node-and-zone-state-helpers
+++ a/include/linux/vmstat.h
@@ -286,10 +286,8 @@ void mod_node_page_state(struct pglist_d
 void inc_node_page_state(struct page *, enum node_stat_item);
 void dec_node_page_state(struct page *, enum node_stat_item);
 
-extern void inc_node_state(struct pglist_data *, enum node_stat_item);
 extern void __inc_zone_state(struct zone *, enum zone_stat_item);
 extern void __inc_node_state(struct pglist_data *, enum node_stat_item);
-extern void dec_zone_state(struct zone *, enum zone_stat_item);
 extern void __dec_zone_state(struct zone *, enum zone_stat_item);
 extern void __dec_node_state(struct pglist_data *, enum node_stat_item);
 
@@ -394,10 +392,6 @@ static inline void __dec_node_page_state
 #define dec_node_page_state __dec_node_page_state
 #define mod_node_page_state __mod_node_page_state
 
-#define inc_zone_state __inc_zone_state
-#define inc_node_state __inc_node_state
-#define dec_zone_state __dec_zone_state
-
 #define set_pgdat_percpu_threshold(pgdat, callback) { }
 
 static inline void refresh_zone_stat_thresholds(void) { }
--- a/mm/vmstat.c~mm-vmstat-remove-unused-node-and-zone-state-helpers
+++ a/mm/vmstat.c
@@ -672,11 +672,6 @@ void mod_node_page_state(struct pglist_d
 }
 EXPORT_SYMBOL(mod_node_page_state);
 
-void inc_node_state(struct pglist_data *pgdat, enum node_stat_item item)
-{
-	mod_node_state(pgdat, item, 1, 1);
-}
-
 void inc_node_page_state(struct page *page, enum node_stat_item item)
 {
 	mod_node_state(page_pgdat(page), item, 1, 1);
@@ -725,16 +720,6 @@ void dec_zone_page_state(struct page *pa
 }
 EXPORT_SYMBOL(dec_zone_page_state);
 
-void inc_node_state(struct pglist_data *pgdat, enum node_stat_item item)
-{
-	unsigned long flags;
-
-	local_irq_save(flags);
-	__inc_node_state(pgdat, item);
-	local_irq_restore(flags);
-}
-EXPORT_SYMBOL(inc_node_state);
-
 void mod_node_page_state(struct pglist_data *pgdat, enum node_stat_item item,
 					long delta)
 {
_

Patches currently in -mm which might be from richard.weiyang@gmail.com are

mm-vmstat-remove-unused-node-and-zone-state-helpers.patch

