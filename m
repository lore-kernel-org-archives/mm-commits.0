Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 450C27E107
	for <mm-commits@vger.kernel.org>; Mon,  2 Sep 2024 03:30:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725247854; cv=none; b=A+vi5ntbw5qLzaH1VLUUUBUiIEXdWIMHf8nhvBHgCF3ZnJTp2zA4Ec2sKImX1VeMl6ODFp2OF4TIdlHyPMc4HAjAdROUEpWpvrs53xhf2exlrqFkTCHPliHPGDaM52VLJdd/pJSVWO9bkesR1Up6PKr+yxHzq9BdQGMFX+Fsnpg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725247854; c=relaxed/simple;
	bh=sW/RHmwDd0FB9aMChfoeZ0eRhtk4UXDOiIN1hTLGn2U=;
	h=Date:To:From:Subject:Message-Id; b=rRnQCVxeQbaZrV7iyEZ6zlcbk0NVnMOs4K2RcfZe4DP32si5LHU+tBfbYST7PPi9ElRLPStyM2w4K3HnYDLLDoUOYy4rUJrVtHkV1CDUR3OBaGato38ztpkgQNSFiWYjF6gxQqRQ20gKUh1vgLAu0UM6AfWfR7ZxN3tbHv4jtd0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=sz7c+jz2; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="sz7c+jz2"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 18DB6C4CEC2;
	Mon,  2 Sep 2024 03:30:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1725247854;
	bh=sW/RHmwDd0FB9aMChfoeZ0eRhtk4UXDOiIN1hTLGn2U=;
	h=Date:To:From:Subject:From;
	b=sz7c+jz2DIWc1KIN1WwPos/VL98lYOF6xims2ll5O+rS9uqzcjjQ/L/8SyPEwCVkB
	 phhpIjgTLDDSvXApMpetm1gQvQJKcpH4UeAv7vwtZW9Qf/3QiFZYYy62OmxrLXV5d/
	 8UzVwAedRtAqz35NowXFsIX3m44sWbfSV4I/atZg=
Date: Sun, 01 Sep 2024 20:30:53 -0700
To: mm-commits@vger.kernel.org,tjmercier@google.com,roman.gushchin@linux.dev,muchun.song@linux.dev,mhocko@kernel.org,hannes@cmpxchg.org,shakeel.butt@linux.dev,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] memcg-make-v1-only-functions-static.patch removed from -mm tree
Message-Id: <20240902033054.18DB6C4CEC2@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: memcg: make v1 only functions static
has been removed from the -mm tree.  Its filename was
     memcg-make-v1-only-functions-static.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Shakeel Butt <shakeel.butt@linux.dev>
Subject: memcg: make v1 only functions static
Date: Wed, 14 Aug 2024 22:04:51 -0700

The functions memcg1_charge_statistics() and memcg1_check_events() are
never used outside of v1 source file.  So, make them static.

Link: https://lkml.kernel.org/r/20240815050453.1298138-6-shakeel.butt@linux.dev
Signed-off-by: Shakeel Butt <shakeel.butt@linux.dev>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Michal Hocko <mhocko@kernel.org>
Cc: Muchun Song <muchun.song@linux.dev>
Cc: Roman Gushchin <roman.gushchin@linux.dev>
Cc: T.J. Mercier <tjmercier@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memcontrol-v1.c |    7 +++++--
 mm/memcontrol-v1.h |    6 ------
 2 files changed, 5 insertions(+), 8 deletions(-)

--- a/mm/memcontrol-v1.c~memcg-make-v1-only-functions-static
+++ a/mm/memcontrol-v1.c
@@ -742,6 +742,9 @@ static struct page *mc_handle_file_pte(s
 	return folio_file_page(folio, index);
 }
 
+static void memcg1_check_events(struct mem_cgroup *memcg, int nid);
+static void memcg1_charge_statistics(struct mem_cgroup *memcg, int nr_pages);
+
 /**
  * mem_cgroup_move_account - move account of the folio
  * @folio: The folio.
@@ -1439,7 +1442,7 @@ static void mem_cgroup_threshold(struct
 	}
 }
 
-void memcg1_charge_statistics(struct mem_cgroup *memcg, int nr_pages)
+static void memcg1_charge_statistics(struct mem_cgroup *memcg, int nr_pages)
 {
 	/* pagein of a big page is an event. So, ignore page size */
 	if (nr_pages > 0)
@@ -1484,7 +1487,7 @@ static bool memcg1_event_ratelimit(struc
  * Check events in order.
  *
  */
-void memcg1_check_events(struct mem_cgroup *memcg, int nid)
+static void memcg1_check_events(struct mem_cgroup *memcg, int nid)
 {
 	if (IS_ENABLED(CONFIG_PREEMPT_RT))
 		return;
--- a/mm/memcontrol-v1.h~memcg-make-v1-only-functions-static
+++ a/mm/memcontrol-v1.h
@@ -115,9 +115,6 @@ bool memcg1_oom_prepare(struct mem_cgrou
 void memcg1_oom_finish(struct mem_cgroup *memcg, bool locked);
 void memcg1_oom_recover(struct mem_cgroup *memcg);
 
-void memcg1_charge_statistics(struct mem_cgroup *memcg, int nr_pages);
-void memcg1_check_events(struct mem_cgroup *memcg, int nid);
-
 void memcg1_commit_charge(struct folio *folio, struct mem_cgroup *memcg);
 void memcg1_swapout(struct folio *folio, struct mem_cgroup *memcg);
 void memcg1_uncharge_batch(struct mem_cgroup *memcg, unsigned long pgpgout,
@@ -152,9 +149,6 @@ static inline bool memcg1_oom_prepare(st
 static inline void memcg1_oom_finish(struct mem_cgroup *memcg, bool locked) {}
 static inline void memcg1_oom_recover(struct mem_cgroup *memcg) {}
 
-static inline void memcg1_charge_statistics(struct mem_cgroup *memcg, int nr_pages) {}
-static inline void memcg1_check_events(struct mem_cgroup *memcg, int nid) {}
-
 static inline void memcg1_commit_charge(struct folio *folio,
 					struct mem_cgroup *memcg) {}
 
_

Patches currently in -mm which might be from shakeel.butt@linux.dev are


