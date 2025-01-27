Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A694E1DC9AD
	for <mm-commits@vger.kernel.org>; Mon, 27 Jan 2025 23:21:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738020107; cv=none; b=bMID2nos9ti6fJO/eUFxJNrjrNJJ8Gvq+Ohe9geJtUxfICR2bnhK7p57yNwbHyv1B2A9cY1ZB/633RB8tKkkVIQ/2kP31eRJiQCjvGHXH0DcVo2yQwes+rsPwVRITtpA1OoCXfQfwJMVg6DLCCjArFVGr1sYRDDm4CRvdKl69Dk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738020107; c=relaxed/simple;
	bh=IHsQJLGRZcbWU6KmPam29NM+H2V5oOA0q7TdoNE+vOI=;
	h=Date:To:From:Subject:Message-Id; b=jQ+FPNUjDUi2iA2hLCBmQY1oO2tITBEzANpA+SmvbMzu6Cs1pPu3vyTMEw3mJJpVwvF4Qf1UKBp73q3sVzPaWzGuuPqsmRwXliFNFjoVROHCojzWQEJOCbi+saMP669sVIsJkk/xtUgeajg7Ww4HsYpdejHQ6ogTNhQ1s9WJY1U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=BILrpzwM; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="BILrpzwM"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EF15CC4CED2;
	Mon, 27 Jan 2025 23:21:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1738020107;
	bh=IHsQJLGRZcbWU6KmPam29NM+H2V5oOA0q7TdoNE+vOI=;
	h=Date:To:From:Subject:From;
	b=BILrpzwM/UseEenpWF0ICqAemAWFgz9haIVIjdrLEbGne0HIjrpOYHm6V/0127Oss
	 sUJedbXJ76av2QcRRwg1T3Q9b3gENhUEXiWTXMLXXfJAN6Xi75pUQPVFY/5Nyy6cLu
	 PfTCSEWQAuxikOd06jYzVGINTM6Mvc7dl5Cdk40Y=
Date: Mon, 27 Jan 2025 15:21:46 -0800
To: mm-commits@vger.kernel.org,songmuchun@bytedance.com,shakeel.butt@linux.dev,roman.gushchin@linux.dev,mhocko@suse.com,hannes@cmpxchg.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-memcontrol-move-stray-ratelimit-bits-to-v1.patch added to mm-unstable branch
Message-Id: <20250127232146.EF15CC4CED2@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm: memcontrol: move stray ratelimit bits to v1
has been added to the -mm mm-unstable branch.  Its filename is
     mm-memcontrol-move-stray-ratelimit-bits-to-v1.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-memcontrol-move-stray-ratelimit-bits-to-v1.patch

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
From: Johannes Weiner <hannes@cmpxchg.org>
Subject: mm: memcontrol: move stray ratelimit bits to v1
Date: Thu, 23 Jan 2025 23:38:59 -0500

41213dd0f816 ("memcg: move mem_cgroup_event_ratelimit to v1 code") left
this one behind.  There are no v2 references.

Link: https://lkml.kernel.org/r/20250124043859.18808-2-hannes@cmpxchg.org
Signed-off-by: Johannes Weiner <hannes@cmpxchg.org>
Acked-by: Roman Gushchin <roman.gushchin@linux.dev>
Acked-by: Shakeel Butt <shakeel.butt@linux.dev>
Acked-by: Michal Hocko <mhocko@suse.com>
Cc: Muchun Song <songmuchun@bytedance.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memcontrol-v1.c |   13 +++++++++++++
 mm/memcontrol-v1.h |   12 ------------
 2 files changed, 13 insertions(+), 12 deletions(-)

--- a/mm/memcontrol-v1.c~mm-memcontrol-move-stray-ratelimit-bits-to-v1
+++ a/mm/memcontrol-v1.c
@@ -490,6 +490,19 @@ static void mem_cgroup_threshold(struct
 }
 
 /* Cgroup1: threshold notifications & softlimit tree updates */
+
+/*
+ * Per memcg event counter is incremented at every pagein/pageout. With THP,
+ * it will be incremented by the number of pages. This counter is used
+ * to trigger some periodic events. This is straightforward and better
+ * than using jiffies etc. to handle periodic memcg event.
+ */
+enum mem_cgroup_events_target {
+	MEM_CGROUP_TARGET_THRESH,
+	MEM_CGROUP_TARGET_SOFTLIMIT,
+	MEM_CGROUP_NTARGETS,
+};
+
 struct memcg1_events_percpu {
 	unsigned long nr_page_events;
 	unsigned long targets[MEM_CGROUP_NTARGETS];
--- a/mm/memcontrol-v1.h~mm-memcontrol-move-stray-ratelimit-bits-to-v1
+++ a/mm/memcontrol-v1.h
@@ -28,18 +28,6 @@ static inline bool do_memsw_account(void
 	return !cgroup_subsys_on_dfl(memory_cgrp_subsys);
 }
 
-/*
- * Per memcg event counter is incremented at every pagein/pageout. With THP,
- * it will be incremented by the number of pages. This counter is used
- * to trigger some periodic events. This is straightforward and better
- * than using jiffies etc. to handle periodic memcg event.
- */
-enum mem_cgroup_events_target {
-	MEM_CGROUP_TARGET_THRESH,
-	MEM_CGROUP_TARGET_SOFTLIMIT,
-	MEM_CGROUP_NTARGETS,
-};
-
 unsigned long mem_cgroup_usage(struct mem_cgroup *memcg, bool swap);
 
 void drain_all_stock(struct mem_cgroup *root_memcg);
_

Patches currently in -mm which might be from hannes@cmpxchg.org are

mm-memcontrol-move-memsw-charge-callbacks-to-v1.patch
mm-memcontrol-unshare-v2-only-charge-api-bits-again.patch
mm-memcontrol-move-stray-ratelimit-bits-to-v1.patch

