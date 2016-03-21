From: akpm@linux-foundation.org
Subject: [merged]
 mm-memcontrol-reclaim-when-shrinking-memoryhigh-below-usage.patch removed
 from -mm tree
Date: Mon, 21 Mar 2016 11:40:22 -0700
Message-ID: <56f04016.D7KgV+GEz+DE3Oso%akpm__49502.5540156805$1458590233$gmane$org@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:53451 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932341AbcCUT43 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 21 Mar 2016 15:56:29 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: hannes@cmpxchg.org, mhocko@suse.com, stable@vger.kernel.org, vdavydov@virtuozzo.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm: memcontrol: reclaim when shrinking memory.high below usage
has been removed from the -mm tree.  Its filename was
     mm-memcontrol-reclaim-when-shrinking-memoryhigh-below-usage.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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
Acked-by: Michal Hocko <mhocko@suse.com>
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


