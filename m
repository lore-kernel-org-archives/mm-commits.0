From: akpm@linux-foundation.org
Subject: - slob-record-page-flag-overlays-explicitly.patch removed from -mm tree
Date: Thu, 24 Jul 2008 16:22:10 -0700
Message-ID: <200807242322.m6ONMAmp010545@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:51028 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754231AbYGXXXf (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 24 Jul 2008 19:23:35 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: apw@shadowen.org, cl@linux-foundation.org, jeremy@goop.org, kosaki.motohiro@jp.fujitsu.com, mpm@selenic.com, nickpiggin@yahoo.com.au, penberg@cs.helsinki.fi, riel@redhat.com, mm-commi


The patch titled
     slob: record page flag overlays explicitly
has been removed from the -mm tree.  Its filename was
     slob-record-page-flag-overlays-explicitly.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: slob: record page flag overlays explicitly
From: Andy Whitcroft <apw@shadowen.org>

SLOB reuses two page bits for internal purposes, it overlays PG_active and
PG_private.  This is hidden away in slob.c.  Document these overlays
explicitly in the main page-flags enum along with all the others.

Signed-off-by: Andy Whitcroft <apw@shadowen.org>
Cc: Pekka Enberg <penberg@cs.helsinki.fi>
Cc: Christoph Lameter <cl@linux-foundation.org>
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
@@ -105,6 +105,10 @@ enum pageflags {
 	PG_pinned = PG_owner_priv_1,
 	PG_savepinned = PG_dirty,
 
+	/* SLOB */
+	PG_slob_page = PG_active,
+	PG_slob_free = PG_private,
+
 	/* SLUB */
 	PG_slub_frozen = PG_active,
 	PG_slub_debug = PG_error,
@@ -173,6 +177,9 @@ PAGEFLAG(Reserved, reserved) __CLEARPAGE
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

origin.patch
x86-implement-pte_special.patch
x86-implement-pte_special-fix.patch
mm-introduce-get_user_pages_fast.patch
mm-introduce-get_user_pages_fast-fix.patch
mm-introduce-get_user_pages_fast-checkpatch-fixes.patch
x86-lockless-get_user_pages_fast.patch
x86-lockless-get_user_pages_fast-checkpatch-fixes.patch
x86-lockless-get_user_pages_fast-fix.patch
x86-lockless-get_user_pages_fast-fix-2.patch
x86-lockless-get_user_pages_fast-fix-2-fix-fix.patch
x86-lockless-get_user_pages_fast-fix-warning.patch
dio-use-get_user_pages_fast.patch
splice-use-get_user_pages_fast.patch
page-owner-tracking-leak-detector.patch

