From: akpm@linux-foundation.org
Subject: + slob-record-page-flag-overlays-explicitly.patch added to -mm tree
Date: Tue, 27 May 2008 22:01:18 -0700
Message-ID: <200805280501.m4S51IuQ029967@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:33373 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751682AbYE1FC7 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 28 May 2008 01:02:59 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: apw@shadowen.org, clameter@sgi.com, jeremy@goop.org, kosaki.motohiro@jp.fujitsu.com, mpm@selenic.com, nickpiggin@yahoo.com.au, penberg@cs.helsinki.fi, riel@redhat.com


The patch titled
     slob: record page flag overlays explicitly
has been added to the -mm tree.  Its filename is
     slob-record-page-flag-overlays-explicitly.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: slob: record page flag overlays explicitly
From: Andy Whitcroft <apw@shadowen.org>

SLOB reuses two page bits for internal purposes, it overlays PG_active and
PG_private.  This is hidden away in slob.c.  Document these overlays
explicitly in the main page-flags enum along with all the others.

Signed-off-by: Andy Whitcroft <apw@shadowen.org>
Cc: Pekka Enberg <penberg@cs.helsinki.fi>
Cc: Christoph Lameter <clameter@sgi.com>
Cc: Matt Mackall <mpm@selenic.com>
Cc: Nick Piggin <nickpiggin@yahoo.com.au>
Reviewed-by: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Cc: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Cc: Rik van Riel <riel@redhat.com>
Cc: Jeremy Fitzhardinge <jeremy@goop.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/page-flags.h |    7 +++++++
 mm/slob.c                  |   12 ++++++------
 2 files changed, 13 insertions(+), 6 deletions(-)

diff -puN include/linux/page-flags.h~slob-record-page-flag-overlays-explicitly include/linux/page-flags.h
--- a/include/linux/page-flags.h~slob-record-page-flag-overlays-explicitly
+++ a/include/linux/page-flags.h
@@ -104,6 +104,10 @@ enum pageflags {
 	/* XEN */
 	PG_pinned = PG_owner_priv_1,
 
+	/* SLOB */
+	PG_slob_page = PG_active,
+	PG_slob_free = PG_private,
+
 	/* SLUB */
 	PG_slub_frozen = PG_active,
 	PG_slub_debug = PG_error,
@@ -171,6 +175,9 @@ PAGEFLAG(Reserved, reserved) __CLEARPAGE
 PAGEFLAG(Private, private) __CLEARPAGEFLAG(Private, private)
 	__SETPAGEFLAG(Private, private)
 
+__PAGEFLAG(SlobPage, slob_page)
+__PAGEFLAG(SlobFree, slob_free)
+
 __PAGEFLAG(SlubFrozen, slub_frozen)
 __PAGEFLAG(SlubDebug, slub_debug)
 
diff -puN mm/slob.c~slob-record-page-flag-overlays-explicitly mm/slob.c
--- a/mm/slob.c~slob-record-page-flag-overlays-explicitly
+++ a/mm/slob.c
@@ -130,17 +130,17 @@ static LIST_HEAD(free_slob_large);
  */
 static inline int slob_page(struct slob_page *sp)
 {
-	return test_bit(PG_active, &sp->flags);
+	return PageSlobPage((struct page *)sp);
 }
 
 static inline void set_slob_page(struct slob_page *sp)
 {
-	__set_bit(PG_active, &sp->flags);
+	__SetPageSlobPage((struct page *)sp);
 }
 
 static inline void clear_slob_page(struct slob_page *sp)
 {
-	__clear_bit(PG_active, &sp->flags);
+	__ClearPageSlobPage((struct page *)sp);
 }
 
 /*
@@ -148,19 +148,19 @@ static inline void clear_slob_page(struc
  */
 static inline int slob_page_free(struct slob_page *sp)
 {
-	return test_bit(PG_private, &sp->flags);
+	return PageSlobFree((struct page *)sp);
 }
 
 static void set_slob_page_free(struct slob_page *sp, struct list_head *list)
 {
 	list_add(&sp->list, list);
-	__set_bit(PG_private, &sp->flags);
+	__SetPageSlobFree((struct page *)sp);
 }
 
 static inline void clear_slob_page_free(struct slob_page *sp)
 {
 	list_del(&sp->list);
-	__clear_bit(PG_private, &sp->flags);
+	__ClearPageSlobFree((struct page *)sp);
 }
 
 #define SLOB_UNIT sizeof(slob_t)
_

Patches currently in -mm which might be from apw@shadowen.org are

linux-next.patch
mm-add-a-basic-debugging-framework-for-memory-initialisation.patch
mm-add-a-basic-debugging-framework-for-memory-initialisation-fix.patch
mm-verify-the-page-links-and-memory-model.patch
mm-make-defensive-checks-around-pfn-values-registered-for-memory-usage.patch
mm-print-out-the-zonelists-on-request-for-manual-verification.patch
mm-move-bootmem-descriptors-definition-to-a-single-place.patch
mm-fix-free_all_bootmem_core-alignment-check.patch
mm-normalize-internal-argument-passing-of-bootmem-data.patch
mm-unexport-__alloc_bootmem_core.patch
buddy-clarify-comments-describing-buddy-merge.patch
page-flags-record-page-flag-overlays-explicitly.patch
slub-record-page-flag-overlays-explicitly.patch
slob-record-page-flag-overlays-explicitly.patch
update-checkpatchpl-to-version-019.patch
update-checkpatchpl-to-version-019-fix.patch
page-owner-tracking-leak-detector.patch

