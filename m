Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6DEE9211499
	for <mm-commits@vger.kernel.org>; Mon, 17 Nov 2025 01:32:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763343126; cv=none; b=ur4dGcSRchON1atkSDe2Rh4nXpg+IGdNa9R1zsUdh+VdHWe7zBLJxezlUgH3HqPNCfSWBFIXUdN1olTyleWPBJ/Rjs3icAPiAs+IyQZl7NKrzEjc+H5nY1/ueIi7Qj13Qk0aOl819gf510o+RNu6IAvuiT0236eYQ++0c6//NAk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763343126; c=relaxed/simple;
	bh=u48qomYS6BJx7VEwz8l1Y4oEuA83bNVZ/9HenNA1UCA=;
	h=Date:To:From:Subject:Message-Id; b=tLOIk2jDRQT3AIepLDWxtpjdPgGecJ/p7iPgHLSolvpzmjtKvZIlB7Sbwo6/NEWOKaluUeSC221m2QpCCv+KNGEUrv6XGw+FmjFtDNthbV0M2/8K0+W4e72re+0ZdLkZM0dztSnKOUAkOhRYkA5QKNWf/2yHGzdmTOxnIwgjlb0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=COKwgWMh; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="COKwgWMh"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E419DC19423;
	Mon, 17 Nov 2025 01:32:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1763343126;
	bh=u48qomYS6BJx7VEwz8l1Y4oEuA83bNVZ/9HenNA1UCA=;
	h=Date:To:From:Subject:From;
	b=COKwgWMh8rZRkasQUxV3N8WtCSDOfNLnMzFhhNlobLAxOtkf1iH2wX0tw7ElsBuX4
	 80us8esByerBTGLDgbJFAPttTLIXWLwaBXo21FxuJ2JX8tQuVJaLGos/z1x40QF5A1
	 Y6pH/iMm8nL+badnGR6ooVmUqNmLgrfM0WtrfKAc=
Date: Sun, 16 Nov 2025 17:32:05 -0800
To: mm-commits@vger.kernel.org,ziy@nvidia.com,vbabka@suse.cz,surenb@google.com,mhocko@suse.com,liuye@kylinos.cn,jackmanb@google.com,hannes@cmpxchg.org,husong@kylinos.cn,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-page_owner-simplify-zone-iteration-logic-in-init_early_allocated_pages.patch removed from -mm tree
Message-Id: <20251117013205.E419DC19423@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/page_owner: simplify zone iteration logic in init_early_allocated_pages()
has been removed from the -mm tree.  Its filename was
     mm-page_owner-simplify-zone-iteration-logic-in-init_early_allocated_pages.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Song Hu <husong@kylinos.cn>
Subject: mm/page_owner: simplify zone iteration logic in init_early_allocated_pages()
Date: Tue, 30 Sep 2025 17:21:52 +0800

The current implementation uses nested loops: first iterating over all
online nodes, then over zones within each node.  This can be simplified by
using the for_each_populated_zone() macro which directly iterates through
all populated zones.

This change:
1. Removes the intermediate init_zones_in_node() function
2. Simplifies init_early_allocated_pages() to use direct zone iteration
3. Updates init_pages_in_zone() to take only zone parameter and access
   node_id via zone->zone_pgdat

The functionality remains identical, but the code is cleaner and more
maintainable.

Link: https://lkml.kernel.org/r/20250930092153.843109-2-husong@kylinos.cn
Signed-off-by: Song Hu <husong@kylinos.cn>
Reviewed-by: Vlastimil Babka <vbabka@suse.cz>
Reviewed-by: Ye Liu <liuye@kylinos.cn>
Acked-by: Vlastimil Babka <vbabka@suse.cz>
Cc: Brendan Jackman <jackmanb@google.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: Zi Yan <ziy@nvidia.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/page_owner.c |   23 +++++------------------
 1 file changed, 5 insertions(+), 18 deletions(-)

--- a/mm/page_owner.c~mm-page_owner-simplify-zone-iteration-logic-in-init_early_allocated_pages
+++ a/mm/page_owner.c
@@ -769,7 +769,7 @@ static loff_t lseek_page_owner(struct fi
 	return file->f_pos;
 }
 
-static void init_pages_in_zone(pg_data_t *pgdat, struct zone *zone)
+static void init_pages_in_zone(struct zone *zone)
 {
 	unsigned long pfn = zone->zone_start_pfn;
 	unsigned long end_pfn = zone_end_pfn(zone);
@@ -836,28 +836,15 @@ ext_put_continue:
 	}
 
 	pr_info("Node %d, zone %8s: page owner found early allocated %lu pages\n",
-		pgdat->node_id, zone->name, count);
-}
-
-static void init_zones_in_node(pg_data_t *pgdat)
-{
-	struct zone *zone;
-	struct zone *node_zones = pgdat->node_zones;
-
-	for (zone = node_zones; zone - node_zones < MAX_NR_ZONES; ++zone) {
-		if (!populated_zone(zone))
-			continue;
-
-		init_pages_in_zone(pgdat, zone);
-	}
+		zone->zone_pgdat->node_id, zone->name, count);
 }
 
 static void init_early_allocated_pages(void)
 {
-	pg_data_t *pgdat;
+	struct zone *zone;
 
-	for_each_online_pgdat(pgdat)
-		init_zones_in_node(pgdat);
+	for_each_populated_zone(zone)
+		init_pages_in_zone(zone);
 }
 
 static const struct file_operations page_owner_fops = {
_

Patches currently in -mm which might be from husong@kylinos.cn are


