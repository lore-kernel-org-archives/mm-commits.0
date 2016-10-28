From: akpm@linux-foundation.org
Subject: [patch 05/20] mm: page_alloc: use KERN_CONT where appropriate
Date: Thu, 27 Oct 2016 17:46:29 -0700
Message-ID: <58129fe5./TSGBtUt4TWA11zx%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:57804 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S936219AbcJ1Aqb (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 27 Oct 2016 20:46:31 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: torvalds@linux-foundation.org, mm-commits@vger.kernel.org, akpm@linux-foundation.org, joe@perches.com, mark.rutland@arm.com, mhocko@suse.com

From: Joe Perches <joe@perches.com>
Subject: mm: page_alloc: use KERN_CONT where appropriate

Recent changes to printk require KERN_CONT uses to continue logging
messages.  So add KERN_CONT where necessary.

[akpm@linux-foundation.org: coding-style fixes]
Fixes: 4bcc595ccd80 ("printk: reinstate KERN_CONT for printing continuation lines")
Link: http://lkml.kernel.org/r/c7df37c8665134654a17aaeb8b9f6ace1d6db58b.1476239034.git.joe@perches.com
Reported-by: Mark Rutland <mark.rutland@arm.com>
Signed-off-by: Joe Perches <joe@perches.com>
Acked-by: Michal Hocko <mhocko@suse.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/page_alloc.c |   16 +++++++++-------
 1 file changed, 9 insertions(+), 7 deletions(-)

diff -puN mm/page_alloc.c~mm-page_alloc-use-kern_cont-where-appropriate mm/page_alloc.c
--- a/mm/page_alloc.c~mm-page_alloc-use-kern_cont-where-appropriate
+++ a/mm/page_alloc.c
@@ -4224,7 +4224,7 @@ static void show_migration_types(unsigne
 	}
 
 	*p = '\0';
-	printk("(%s) ", tmp);
+	printk(KERN_CONT "(%s) ", tmp);
 }
 
 /*
@@ -4335,7 +4335,8 @@ void show_free_areas(unsigned int filter
 			free_pcp += per_cpu_ptr(zone->pageset, cpu)->pcp.count;
 
 		show_node(zone);
-		printk("%s"
+		printk(KERN_CONT
+			"%s"
 			" free:%lukB"
 			" min:%lukB"
 			" low:%lukB"
@@ -4382,8 +4383,8 @@ void show_free_areas(unsigned int filter
 			K(zone_page_state(zone, NR_FREE_CMA_PAGES)));
 		printk("lowmem_reserve[]:");
 		for (i = 0; i < MAX_NR_ZONES; i++)
-			printk(" %ld", zone->lowmem_reserve[i]);
-		printk("\n");
+			printk(KERN_CONT " %ld", zone->lowmem_reserve[i]);
+		printk(KERN_CONT "\n");
 	}
 
 	for_each_populated_zone(zone) {
@@ -4394,7 +4395,7 @@ void show_free_areas(unsigned int filter
 		if (skip_free_areas_node(filter, zone_to_nid(zone)))
 			continue;
 		show_node(zone);
-		printk("%s: ", zone->name);
+		printk(KERN_CONT "%s: ", zone->name);
 
 		spin_lock_irqsave(&zone->lock, flags);
 		for (order = 0; order < MAX_ORDER; order++) {
@@ -4412,11 +4413,12 @@ void show_free_areas(unsigned int filter
 		}
 		spin_unlock_irqrestore(&zone->lock, flags);
 		for (order = 0; order < MAX_ORDER; order++) {
-			printk("%lu*%lukB ", nr[order], K(1UL) << order);
+			printk(KERN_CONT "%lu*%lukB ",
+			       nr[order], K(1UL) << order);
 			if (nr[order])
 				show_migration_types(types[order]);
 		}
-		printk("= %lukB\n", K(total));
+		printk(KERN_CONT "= %lukB\n", K(total));
 	}
 
 	hugetlb_show_meminfo();
_
