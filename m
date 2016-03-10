From: akpm@linux-foundation.org
Subject: +
 mm-memcontrol-reclaim-when-shrinking-memoryhigh-below-usage.patch added to
 -mm tree
Date: Thu, 10 Mar 2016 13:30:42 -0800
Message-ID: <56e1e782.yvEF7wqp6ECjNSH6%akpm__32668.7215049335$1457645476$gmane$org@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:58083 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932180AbcCJVan (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 10 Mar 2016 16:30:43 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: hannes@cmpxchg.org, mhocko@suse.cz, stable@vger.kernel.org, vdavydov@virtuozzo.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm: memcontrol: reclaim when shrinking memory.high below usage
has been added to the -mm tree.  Its filename is
     mm-memcontrol-reclaim-when-shrinking-memoryhigh-below-usage.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-memcontrol-reclaim-when-shrinking-memoryhigh-below-usage.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-memcontrol-reclaim-when-shrinking-memoryhigh-below-usage.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Johannes Weiner <hannes@cmpxchg.org>
Subject: mm: memcontrol: reclaim when shrinking memory.high below usage

When setting memory.high below usage, nothing happens until the next
charge comes along, and then it will only reclaim its own charge and not
the now potentially huge excess of the new memory.high.  This can cause
groups to stay in excess of their memory.high indefinitely.

To fix that, when shrinking memory.high, kick off a reclaim cycle that
goes after the delta.

Signed-off-by: Johannes Weiner <hannes@cmpxchg.org>
Cc: Michal Hocko <mhocko@suse.cz>
Cc: Vladimir Davydov <vdavydov@virtuozzo.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memcontrol.c |    6 ++++++
 1 file changed, 6 insertions(+)

diff -puN mm/memcontrol.c~mm-memcontrol-reclaim-when-shrinking-memoryhigh-below-usage mm/memcontrol.c
--- a/mm/memcontrol.c~mm-memcontrol-reclaim-when-shrinking-memoryhigh-below-usage
+++ a/mm/memcontrol.c
@@ -4992,6 +4992,7 @@ static ssize_t memory_high_write(struct
 				 char *buf, size_t nbytes, loff_t off)
 {
 	struct mem_cgroup *memcg = mem_cgroup_from_css(of_css(of));
+	unsigned long nr_pages;
 	unsigned long high;
 	int err;
 
@@ -5002,6 +5003,11 @@ static ssize_t memory_high_write(struct
 
 	memcg->high = high;
 
+	nr_pages = page_counter_read(&memcg->memory);
+	if (nr_pages > high)
+		try_to_free_mem_cgroup_pages(memcg, nr_pages - high,
+					     GFP_KERNEL, true);
+
 	memcg_wb_domain_size_changed(memcg);
 	return nbytes;
 }
_

Patches currently in -mm which might be from hannes@cmpxchg.org are

mm-memcontrol-generalize-locking-for-the-page-mem_cgroup-binding.patch
mm-workingset-define-radix-entry-eviction-mask.patch
mm-workingset-separate-shadow-unpacking-and-refault-calculation.patch
mm-workingset-eviction-buckets-for-bigmem-lowbit-machines.patch
mm-workingset-per-cgroup-cache-thrash-detection.patch
mm-migrate-do-not-touch-page-mem_cgroup-of-live-pages.patch
mm-simplify-lock_page_memcg.patch
mm-remove-unnecessary-uses-of-lock_page_memcg.patch
mm-oom_kill-dont-ignore-oom-score-on-exiting-tasks.patch
mm-migrate-consolidate-mem_cgroup_migrate-calls.patch
mm-memcontrol-drop-unnecessary-lru-locking-from-mem_cgroup_migrate.patch
mm-scale-kswapd-watermarks-in-proportion-to-memory.patch
mm-scale-kswapd-watermarks-in-proportion-to-memory-v3.patch
mm-memcontrol-reclaim-when-shrinking-memoryhigh-below-usage.patch
mm-memcontrol-reclaim-and-oom-kill-when-shrinking-memorymax-below-usage.patch
mm-memcontrol-clarify-the-uncharge_list-loop.patch

