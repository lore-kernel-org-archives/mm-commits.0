Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B0B7A155A3C
	for <mm-commits@vger.kernel.org>; Thu, 15 Aug 2024 22:47:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723762059; cv=none; b=UaPzkK9QejcSfYxBUzCrENO7h/KWNXDmX0dlTlE0kaAjS2djPJXDPNHdh+pM+V2ObJ8Jx1+QwEOUNsRw1uF6VUyhc4xwQ6u4msTYFD8HTp24hjzYmMNbDTa+6D6owZOO1CLpw6HtmL6XmNdSsziEI6+REQbTMDxYZ5KgOegv/QE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723762059; c=relaxed/simple;
	bh=gyrUbcri014XfXQgbdRXDFN6zzdlxuIDcZHBUhzAlig=;
	h=Date:To:From:Subject:Message-Id; b=I3oW5MK+IROpvIVq2Qh6H8ZcwWRP2h6VG1BY1FhPIOSxZCLezMqegJyGUyarBKGBAtMehXdAaqn+aozqUt0NXMlkg5w7SaU5iEHNgURbGvqlvPghP9TN5JDed1He5pTvMipmNjqyTnrwBCdnclsxWB2m8B7cYvO9OCJuOGMCWbI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=1PV6A9yJ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="1PV6A9yJ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0E48CC4AF15;
	Thu, 15 Aug 2024 22:47:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1723762059;
	bh=gyrUbcri014XfXQgbdRXDFN6zzdlxuIDcZHBUhzAlig=;
	h=Date:To:From:Subject:From;
	b=1PV6A9yJI4lOA9Awh2N8a+57zeu5F9LphifzUaCZKes+9IZJxvqM76fRJFbK5z5+P
	 q7DGi94kdYhBEdkImf3++4z6Db2lqvof/gkn3vJmBz3agiEIw6hwIqNJKI76zXxWB+
	 LQPWDWnnwJX//g68Jx9b1hM6EMC82BhAqBE8wyC0=
Date: Thu, 15 Aug 2024 15:47:38 -0700
To: mm-commits@vger.kernel.org,tjmercier@google.com,roman.gushchin@linux.dev,muchun.song@linux.dev,mhocko@kernel.org,hannes@cmpxchg.org,shakeel.butt@linux.dev,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + memcg-make-v1-only-functions-static.patch added to mm-unstable branch
Message-Id: <20240815224739.0E48CC4AF15@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: memcg: make v1 only functions static
has been added to the -mm mm-unstable branch.  Its filename is
     memcg-make-v1-only-functions-static.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/memcg-make-v1-only-functions-static.patch

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

memcg-increase-the-valid-index-range-for-memcg-stats.patch
memcg-replace-memcg-id-idr-with-xarray.patch
memcg-replace-memcg-id-idr-with-xarray-v2.patch
memcg-use-ratelimited-stats-flush-in-the-reclaim.patch
memcg-move-v1-only-percpu-stats-in-separate-struct.patch
memcg-move-mem_cgroup_event_ratelimit-to-v1-code.patch
memcg-move-mem_cgroup_charge_statistics-to-v1-code.patch
memcg-move-v1-events-and-statistics-code-to-v1-file.patch
memcg-make-v1-only-functions-static.patch
memcg-allocate-v1-event-percpu-only-on-v1-deployment.patch
memcg-make-pgpgin-and-pgpgout-v1-only.patch

