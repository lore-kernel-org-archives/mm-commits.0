Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DC93879DF
	for <mm-commits@vger.kernel.org>; Sun,  4 Feb 2024 07:20:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1707031234; cv=none; b=ZyyXEXkEw8XdvFLQWe14O7r218/PD9S01VXgApK9OlcFLHFCc8hONEzo/vTjo1x5R878hNtlCwWRaNlVMLETWbQdYxnVrus6UiMCD8mj7ox08Bz3+glupLhXoHIgoQAeYP55fbgLyk51gjppDYFPoYU/XKaSAzDtzyjmGy49u84=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1707031234; c=relaxed/simple;
	bh=82b6daHskYFWMn8gv3aGBcwLzXmYz0vXLrJckWpaMtA=;
	h=Date:To:From:Subject:Message-Id; b=ozSnZk77noSHTfdvrTdZcLUAsc1rcvmjCsmDiFJKjC/9ywbkGdkIZ1yN6dtoXMNqHnIWGiXovaW7DXQbC4JKtNTCMd604R/1WiquQ8Ybd23E2yzVaiXBZBH4iXkLDJ8YlsG5I1Zl9oF9jtsHaNBwtKa9IE3lU7kiDpWRtQK3Ink=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=mmwQHp43; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="mmwQHp43"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4052BC433C7;
	Sun,  4 Feb 2024 07:20:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1707031233;
	bh=82b6daHskYFWMn8gv3aGBcwLzXmYz0vXLrJckWpaMtA=;
	h=Date:To:From:Subject:From;
	b=mmwQHp434YZBq+W5+dR6wuHjsrZTtHZ/N+nD1KWH4pZ0vhVv51dVW9/XeZ1ul+cQb
	 hjgu4fC8ALGiX9TcoW6b8G5vlhwV9rqTsAcxK1jlg+W2nOHa7HkcWtYi2Z8y+l17S8
	 EQgUS0hJha87OWKwYHm9/rrBzeWPFRmIJPEGMY9o=
Date: Sat, 03 Feb 2024 23:20:32 -0800
To: mm-commits@vger.kernel.org,shakeelb@google.com,roman.gushchin@linux.dev,muchun.song@linux.dev,mhocko@kernel.org,hannes@cmpxchg.org,gthelen@google.com,yosryahmed@google.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-memcg-optimize-parent-iteration-in-memcg_rstat_updated-fix.patch added to mm-hotfixes-unstable branch
Message-Id: <20240204072033.4052BC433C7@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm: memcg: fix struct memcg_vmstats_percpu size and alignment
has been added to the -mm mm-hotfixes-unstable branch.  Its filename is
     mm-memcg-optimize-parent-iteration-in-memcg_rstat_updated-fix.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-memcg-optimize-parent-iteration-in-memcg_rstat_updated-fix.patch

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
From: Yosry Ahmed <yosryahmed@google.com>
Subject: mm: memcg: fix struct memcg_vmstats_percpu size and alignment
Date: Sat, 3 Feb 2024 04:46:12 +0000

Commit da10d7e140196 ("mm: memcg: optimize parent iteration in
memcg_rstat_updated()") added two additional pointers to the end of struct
memcg_vmstats_percpu with CACHELINE_PADDING to put them in a separate
cacheline.  This caused the struct size to increase from 1200 to 1280 on
my config (80 extra bytes instead of 16).

Upon revisiting, the relevant struct members do not need to be on a
separate cacheline, they just need to fit in a single one.  This is a
percpu struct, so there shouldn't be any contention on that cacheline
anyway.  Move the members to the beginning of the struct and make sure the
struct itself is cacheline aligned.  Add a comment about the members that
need to fit together in a cacheline.

The struct size is now 1216 on my config with this change.

Link: https://lkml.kernel.org/r/20240203044612.1234216-1-yosryahmed@google.com
Fixes: da10d7e14019 ("mm: memcg: optimize parent iteration in memcg_rstat_updated()")
Signed-off-by: Yosry Ahmed <yosryahmed@google.com>
Reported-by: Greg Thelen <gthelen@google.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Michal Hocko <mhocko@kernel.org>
Cc: Muchun Song <muchun.song@linux.dev>
Cc: Roman Gushchin <roman.gushchin@linux.dev>
Cc: Shakeel Butt <shakeelb@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memcontrol.c |   21 ++++++++++-----------
 1 file changed, 10 insertions(+), 11 deletions(-)

--- a/mm/memcontrol.c~mm-memcg-optimize-parent-iteration-in-memcg_rstat_updated-fix
+++ a/mm/memcontrol.c
@@ -621,6 +621,15 @@ static inline int memcg_events_index(enu
 }
 
 struct memcg_vmstats_percpu {
+	/* Stats updates since the last flush */
+	unsigned int			stats_updates;
+
+	/* Cached pointers for fast iteration in memcg_rstat_updated() */
+	struct memcg_vmstats_percpu	*parent;
+	struct memcg_vmstats		*vmstats;
+
+	/* The above should fit a single cacheline for memcg_rstat_updated() */
+
 	/* Local (CPU and cgroup) page state & events */
 	long			state[MEMCG_NR_STAT];
 	unsigned long		events[NR_MEMCG_EVENTS];
@@ -632,17 +641,7 @@ struct memcg_vmstats_percpu {
 	/* Cgroup1: threshold notifications & softlimit tree updates */
 	unsigned long		nr_page_events;
 	unsigned long		targets[MEM_CGROUP_NTARGETS];
-
-	/* Fit members below in a single cacheline for memcg_rstat_updated() */
-	CACHELINE_PADDING(_pad1_);
-
-	/* Stats updates since the last flush */
-	unsigned int		stats_updates;
-
-	/* Cached pointers for fast iteration in memcg_rstat_updated() */
-	struct memcg_vmstats_percpu	*parent;
-	struct memcg_vmstats		*vmstats;
-};
+} ____cacheline_aligned;
 
 struct memcg_vmstats {
 	/* Aggregated (CPU and subtree) page state & events */
_

Patches currently in -mm which might be from yosryahmed@google.com are

mm-memcg-optimize-parent-iteration-in-memcg_rstat_updated.patch
mm-memcg-optimize-parent-iteration-in-memcg_rstat_updated-fix.patch
mm-zswap-fix-missing-folio-cleanup-in-writeback-race-path.patch
mm-swap-enforce-updating-inuse_pages-at-the-end-of-swap_range_free.patch
mm-zswap-remove-unnecessary-trees-cleanups-in-zswap_swapoff.patch
mm-zswap-remove-unused-tree-argument-in-zswap_entry_put.patch
x86-mm-delete-unused-cpu-argument-to-leave_mm.patch
x86-mm-clarify-prev-usage-in-switch_mm_irqs_off.patch

