From: akpm@linux-foundation.org
Subject: + mm-pm-force-gfp_noio-during-suspend-hibernation-and-resume-fix-3.patch added to -mm tree
Date: Thu, 04 Feb 2010 12:02:46 -0800
Message-ID: <201002042002.o14K2kKM018776@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:46912 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932929Ab0BDUDW (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 4 Feb 2010 15:03:22 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: rjw@sisk.pl


The patch titled
     mm-pm-force-gfp_noio-during-suspend-hibernation-and-resume-fix-3
has been added to the -mm tree.  Its filename is
     mm-pm-force-gfp_noio-during-suspend-hibernation-and-resume-fix-3.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://userweb.kernel.org/~akpm/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: mm-pm-force-gfp_noio-during-suspend-hibernation-and-resume-fix-3
From: Rafael J. Wysocki <rjw@sisk.pl>

Signed-off-by: Rafael J. Wysocki <rjw@sisk.pl>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/page_alloc.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff -puN mm/page_alloc.c~mm-pm-force-gfp_noio-during-suspend-hibernation-and-resume-fix-3 mm/page_alloc.c
--- a/mm/page_alloc.c~mm-pm-force-gfp_noio-during-suspend-hibernation-and-resume-fix-3
+++ a/mm/page_alloc.c
@@ -77,7 +77,7 @@ unsigned long totalreserve_pages __read_
 int percpu_pagelist_fraction;
 gfp_t gfp_allowed_mask __read_mostly = GFP_BOOT_MASK;
 
-#ifdef CONFIG_PM
+#ifdef CONFIG_PM_SLEEP
 /*
  * The following functions are used by the suspend/hibernate code to temporarily
  * change gfp_allowed_mask in order to avoid using I/O during memory allocations
@@ -100,7 +100,7 @@ gfp_t clear_gfp_allowed_mask(gfp_t mask)
 	gfp_allowed_mask &= ~mask;
 	return ret;
 }
-#endif		/* CONFIG_PM */
+#endif /* CONFIG_PM_SLEEP */
 
 #ifdef CONFIG_HUGETLB_PAGE_SIZE_VARIABLE
 int pageblock_order __read_mostly;
_

Patches currently in -mm which might be from rjw@sisk.pl are

linux-next.patch
drivers-acpi-processor_idlec-add-two-laptops-to-the-c-state-dmi-table.patch
mm-pm-force-gfp_noio-during-suspend-hibernation-and-resume.patch
mm-pm-force-gfp_noio-during-suspend-hibernation-and-resume-fix-3.patch

