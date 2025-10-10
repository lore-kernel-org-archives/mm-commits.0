Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D0F76288AD
	for <mm-commits@vger.kernel.org>; Fri, 10 Oct 2025 01:52:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760061174; cv=none; b=qKji0NzrQiVZjl/yK8kmG7QKaOhKbdfwL2zW0FfSoKkbENM5mZDjjutH5kjeHSkTNC0aFh9+Bdbs0/DJ2sLj7L0AnO6a3r5LhsiDOUWdKy02ljc8HlJJIYf7jqsAvYrFCa9lG/+/sMRPUjMv+UjrRM6KgLU4UMOUQrGj7Ov1K9A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760061174; c=relaxed/simple;
	bh=Bih6j/+J01TRzEG4/YHf5Yoh3Ua1SCCWZPm4iatd6T8=;
	h=Date:To:From:Subject:Message-Id; b=aCxAS8S5YRoSW9HEUr9D6mHhk5EhzRcvx5cEUm3pUy0mWwgoWzJsjGBbE+eDVVwsZEEVb4j6lW9BJe7pNT74dnFDBe30ANOtK36gVCr/kIQGkTzzeGXdrxzzkOYWDewt2hd6Q11qiDWM1XUinbXUlR7zItLLHdKB/zSG5F33xm4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=ledJ9tf1; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="ledJ9tf1"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 871B2C4CEE7;
	Fri, 10 Oct 2025 01:52:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1760061174;
	bh=Bih6j/+J01TRzEG4/YHf5Yoh3Ua1SCCWZPm4iatd6T8=;
	h=Date:To:From:Subject:From;
	b=ledJ9tf1oO0SCcxIpUQm2up/4JUzcKgZDe5NLVmMTibiOiYerWDxIFIZA/YHgSybF
	 CsUMdV9s4GJuX/6JNgStuFTMP8VlorBMyrM94iXMV9rwBAl8cVH4cSs6epm+SzdLvo
	 l5h2ecRKomuZJkY28nQUAoddk7cQT8RdkhPum8Vk=
Date: Thu, 09 Oct 2025 18:52:54 -0700
To: mm-commits@vger.kernel.org,ziy@nvidia.com,vbabka@suse.cz,surenb@google.com,mhocko@suse.com,liuye@kylinos.cn,jackmanb@google.com,hannes@cmpxchg.org,husong@kylinos.cn,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-page_owner-simplify-zone-iteration-logic-in-init_early_allocated_pages.patch added to mm-new branch
Message-Id: <20251010015254.871B2C4CEE7@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/page_owner: simplify zone iteration logic in init_early_allocated_pages()
has been added to the -mm mm-new branch.  Its filename is
     mm-page_owner-simplify-zone-iteration-logic-in-init_early_allocated_pages.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-page_owner-simplify-zone-iteration-logic-in-init_early_allocated_pages.patch

This patch will later appear in the mm-new branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Note, mm-new is a provisional staging ground for work-in-progress
patches, and acceptance into mm-new is a notification for others take
notice and to finish up reviews.  Please do not hesitate to respond to
review feedback and post updated versions to replace or incrementally
fixup patches in mm-new.

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

mm-page_owner-rename-proc-prefixed-variables-for-clarity.patch
mm-page_owner-simplify-zone-iteration-logic-in-init_early_allocated_pages.patch

