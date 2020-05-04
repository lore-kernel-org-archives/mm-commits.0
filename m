From: akpm@linux-foundation.org
Subject: +
 mm-free_area_init-allow-defining-max_zone_pfn-in-descending-order-fix.patch
 added to -mm tree
Date: Mon, 04 May 2020 13:31:36 -0700
Message-ID: <20200504203136.QUnNo-Em2%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:44714 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726948AbgEDUbh (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Mon, 4 May 2020 16:31:37 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: bhe@redhat.com, borntraeger@de.ibm.com, linux@roeck-us.net, mm-commits@vger.kernel.org, rppt@kernel.org


The patch titled
     Subject: Re: mm: free_area_init: allow defining max_zone_pfn in descending order
has been added to the -mm tree.  Its filename is
     mm-free_area_init-allow-defining-max_zone_pfn-in-descending-order-fix.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-free_area_init-allow-defining-max_zone_pfn-in-descending-order-fix.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-free_area_init-allow-defining-max_zone_pfn-in-descending-order-fix.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Mike Rapoport <rppt@kernel.org>
Subject: Re: mm: free_area_init: allow defining max_zone_pfn in descending order

ARC fix

Link: http://lkml.kernel.org/r/20200504153901.GM14260@kernel.org
Reported-by: Guenter Roeck <linux@roeck-us.net>
Cc: Baoquan He <bhe@redhat.com>
Cc: Christian Borntraeger <borntraeger@de.ibm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/arc/mm/init.c |    5 +++++
 mm/page_alloc.c    |   20 +++++++++++---------
 2 files changed, 16 insertions(+), 9 deletions(-)

--- a/arch/arc/mm/init.c~mm-free_area_init-allow-defining-max_zone_pfn-in-descending-order-fix
+++ a/arch/arc/mm/init.c
@@ -77,6 +77,11 @@ void __init early_init_dt_add_memory_arc
 		base, TO_MB(size), !in_use ? "Not used":"");
 }
 
+bool arch_has_descending_max_zone_pfns(void)
+{
+	return true;
+}
+
 /*
  * First memory setup routine called from setup_arch()
  * 1. setup swapper's mm @init_mm
--- a/mm/page_alloc.c~mm-free_area_init-allow-defining-max_zone_pfn-in-descending-order-fix
+++ a/mm/page_alloc.c
@@ -7397,6 +7397,15 @@ static void check_for_memory(pg_data_t *
 	}
 }
 
+/*
+ * Some architecturs, e.g. ARC may have ZONE_HIGHMEM below ZONE_NORMAL. For
+ * such cases we allow max_zone_pfn sorted in the descending order
+ */
+bool __weak arch_has_descending_max_zone_pfns(void)
+{
+	return false;
+}
+
 /**
  * free_area_init - Initialise all pg_data_t and zone data
  * @max_zone_pfn: an array of max PFNs for each zone
@@ -7414,7 +7423,7 @@ void __init free_area_init(unsigned long
 {
 	unsigned long start_pfn, end_pfn;
 	int i, nid, zone;
-	bool descending = false;
+	bool descending;
 
 	/* Record where the zone boundaries are */
 	memset(arch_zone_lowest_possible_pfn, 0,
@@ -7423,14 +7432,7 @@ void __init free_area_init(unsigned long
 				sizeof(arch_zone_highest_possible_pfn));
 
 	start_pfn = find_min_pfn_with_active_regions();
