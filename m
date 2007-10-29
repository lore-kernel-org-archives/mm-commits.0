From: akpm@linux-foundation.org
Subject: + maps4-move-is_swap_pte.patch added to -mm tree
Date: Mon, 29 Oct 2007 14:57:28 -0700
Message-ID: <200710292157.l9TLvSXh025328@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:56363 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752539AbXJ2WCq (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 29 Oct 2007 18:02:46 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: mpm@selenic.com, haveblue@us.ibm.com


The patch titled
     maps4: move is_swap_pte
has been added to the -mm tree.  Its filename is
     maps4-move-is_swap_pte.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: maps4: move is_swap_pte
From: Matt Mackall <mpm@selenic.com>

Move is_swap_pte helper function to swapops.h for use by pagemap code

Signed-off-by: Matt Mackall <mpm@selenic.com>
Cc: Dave Hansen <haveblue@us.ibm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/swapops.h |    6 ++++++
 mm/migrate.c            |    5 -----
 2 files changed, 6 insertions(+), 5 deletions(-)

diff -puN include/linux/swapops.h~maps4-move-is_swap_pte include/linux/swapops.h
--- a/include/linux/swapops.h~maps4-move-is_swap_pte
+++ a/include/linux/swapops.h
@@ -42,6 +42,12 @@ static inline pgoff_t swp_offset(swp_ent
 	return entry.val & SWP_OFFSET_MASK(entry);
 }
 
+/* check whether a pte points to a swap entry */
+static inline int is_swap_pte(pte_t pte)
+{
+	return !pte_none(pte) && !pte_present(pte) && !pte_file(pte);
+}
+
 /*
  * Convert the arch-dependent pte representation of a swp_entry_t into an
  * arch-independent swp_entry_t.
diff -puN mm/migrate.c~maps4-move-is_swap_pte mm/migrate.c
--- a/mm/migrate.c~maps4-move-is_swap_pte
+++ a/mm/migrate.c
@@ -115,11 +115,6 @@ int putback_lru_pages(struct list_head *
 	return count;
 }
 
-static inline int is_swap_pte(pte_t pte)
-{
-	return !pte_none(pte) && !pte_present(pte) && !pte_file(pte);
-}
-
 /*
  * Restore a potential migration pte to a working pte entry
  */
_

Patches currently in -mm which might be from mpm@selenic.com are

maps4-add-proportional-set-size-accounting-in-smaps.patch
maps4-from-dave-hansen-haveblue-usibmcom.patch
maps4-move-is_swap_pte.patch
maps4-introduce-a-generic-page-walker.patch
maps4-use-pagewalker-in-clear_refs-and-smaps.patch
maps4-simplify-interdependence-of-maps-and-smaps.patch
maps4-move-clear_refs-code-to-task_mmuc.patch
maps4-regroup-task_mmu-by-interface.patch
maps4-add-proc-pid-pagemap-interface.patch
maps4-add-proc-kpagecount-interface.patch
maps4-add-proc-kpageflags-interface.patch
maps4-make-page-monitoring-proc-file-optional.patch
