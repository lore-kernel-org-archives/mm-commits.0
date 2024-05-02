Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7F83015B13D
	for <mm-commits@vger.kernel.org>; Thu,  2 May 2024 15:36:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714664170; cv=none; b=iUGxAM/r5RcgMLeCk3PJKXemxxMLnfVBra7G7/d0T0V5+VeZ27YU0t7LFHCGJiyWfASSpGfrjyX0En/LI2tDSUhapbBeiTXMK4KzrEtFYmuuEYCxPKZQIA/cGRZ+kWseRgvpWY/dU/QFUwt54NP+cVAsfSgCeRZWCSXOKdeHeVc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714664170; c=relaxed/simple;
	bh=2O2jjVthi2/UDqYafxRc1+qxpDDKPB4SpbMatbovy5g=;
	h=Date:To:From:Subject:Message-Id; b=QX3Dd9+txVuhBMA6pMXubOm8sfLhIhtkfh9cb+TMpN/vVeqCgdJj/DlqqemLzcLTWNZvGo9FArUUmSMoD9wliPKY51dWKoZ4A9CgswCU9FzpoLOG5f5yjoi4+UZBJLfkLGRnt97RQhMdV+gbF2FuOjvZ/bf+8MytFP7XIMaotSs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=rdVSo5dP; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="rdVSo5dP"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2D681C113CC;
	Thu,  2 May 2024 15:36:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1714664170;
	bh=2O2jjVthi2/UDqYafxRc1+qxpDDKPB4SpbMatbovy5g=;
	h=Date:To:From:Subject:From;
	b=rdVSo5dPRaS2Vdr2mdl/r0xO4WINX3blLswBBifOW5it+ddPWUA2QJRcSoG01B0aX
	 k6jYYguwCXUrp2o9Hgsz+4jqD3fS/g2nIcCbN5P2OG5ghfYj2qX9qdA03LXHEBTAhb
	 EVSXHAaVmBYSTvOTn/ZDPKXMfdcLa5avdd97eojc=
Date: Thu, 02 May 2024 08:36:08 -0700
To: mm-commits@vger.kernel.org,yosryahmed@google.com,tjmercier@google.com,roman.gushchin@linux.dev,muchun.song@linux.dev,mhocko@kernel.org,hannes@cmpxchg.org,shakeel.butt@linux.dev,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + memcg-use-proper-type-for-mod_memcg_state.patch added to mm-unstable branch
Message-Id: <20240502153610.2D681C113CC@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: memcg: use proper type for mod_memcg_state
has been added to the -mm mm-unstable branch.  Its filename is
     memcg-use-proper-type-for-mod_memcg_state.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/memcg-use-proper-type-for-mod_memcg_state.patch

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
From: Shakeel Butt <shakeel.butt@linux.dev>
Subject: memcg: use proper type for mod_memcg_state
Date: Wed, 1 May 2024 10:26:17 -0700

The memcg stats update functions can take arbitrary integer but the only
input which make sense is enum memcg_stat_item and we don't want these
functions to be called with arbitrary integer, so replace the parameter
type with enum memcg_stat_item and compiler will be able to warn if memcg
stat update functions are called with incorrect index value.

Link: https://lkml.kernel.org/r/20240501172617.678560-9-shakeel.butt@linux.dev
Signed-off-by: Shakeel Butt <shakeel.butt@linux.dev>
Reviewed-by: T.J. Mercier <tjmercier@google.com>
Reviewed-by: Roman Gushchin <roman.gushchin@linux.dev>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Michal Hocko <mhocko@kernel.org>
Cc: Muchun Song <muchun.song@linux.dev>
Cc: Yosry Ahmed <yosryahmed@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/memcontrol.h |   13 +++++++------
 mm/memcontrol.c            |    3 ++-
 2 files changed, 9 insertions(+), 7 deletions(-)

--- a/include/linux/memcontrol.h~memcg-use-proper-type-for-mod_memcg_state
+++ a/include/linux/memcontrol.h
@@ -974,7 +974,8 @@ void mem_cgroup_print_oom_group(struct m
 void folio_memcg_lock(struct folio *folio);
 void folio_memcg_unlock(struct folio *folio);
 
-void __mod_memcg_state(struct mem_cgroup *memcg, int idx, int val);
+void __mod_memcg_state(struct mem_cgroup *memcg, enum memcg_stat_item idx,
+		       int val);
 
 /* try to stablize folio_memcg() for all the pages in a memcg */
 static inline bool mem_cgroup_trylock_pages(struct mem_cgroup *memcg)
@@ -995,7 +996,7 @@ static inline void mem_cgroup_unlock_pag
 
 /* idx can be of type enum memcg_stat_item or node_stat_item */
 static inline void mod_memcg_state(struct mem_cgroup *memcg,
-				   int idx, int val)
+				   enum memcg_stat_item idx, int val)
 {
 	unsigned long flags;
 
@@ -1005,7 +1006,7 @@ static inline void mod_memcg_state(struc
 }
 
 static inline void mod_memcg_page_state(struct page *page,
-					int idx, int val)
+					enum memcg_stat_item idx, int val)
 {
 	struct mem_cgroup *memcg;
 
@@ -1491,19 +1492,19 @@ static inline void mem_cgroup_print_oom_
 }
 
 static inline void __mod_memcg_state(struct mem_cgroup *memcg,
-				     int idx,
+				     enum memcg_stat_item idx,
 				     int nr)
 {
 }
 
 static inline void mod_memcg_state(struct mem_cgroup *memcg,
-				   int idx,
+				   enum memcg_stat_item idx,
 				   int nr)
 {
 }
 
 static inline void mod_memcg_page_state(struct page *page,
-					int idx, int val)
+					enum memcg_stat_item idx, int val)
 {
 }
 
--- a/mm/memcontrol.c~memcg-use-proper-type-for-mod_memcg_state
+++ a/mm/memcontrol.c
@@ -955,7 +955,8 @@ static int memcg_state_val_in_pages(int
  * @idx: the stat item - can be enum memcg_stat_item or enum node_stat_item
  * @val: delta to add to the counter, can be negative
  */
-void __mod_memcg_state(struct mem_cgroup *memcg, int idx, int val)
+void __mod_memcg_state(struct mem_cgroup *memcg, enum memcg_stat_item idx,
+		       int val)
 {
 	int i = memcg_stats_index(idx);
 
_

Patches currently in -mm which might be from shakeel.butt@linux.dev are

memcg-simple-cleanup-of-stats-update-functions.patch
memcg-reduce-memory-size-of-mem_cgroup_events_index.patch
memcg-dynamically-allocate-lruvec_stats.patch
memcg-reduce-memory-for-the-lruvec-and-memcg-stats.patch
memcg-cleanup-__mod_memcg_lruvec_state.patch
mm-cleanup-workingset_nodes-in-workingset.patch
memcg-warn-for-unexpected-events-and-stats.patch
memcg-use-proper-type-for-mod_memcg_state.patch

