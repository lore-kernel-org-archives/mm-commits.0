From: akpm@linux-foundation.org
Subject: + page-flags-record-page-flag-overlays-explicitly.patch added to -mm tree
Date: Tue, 27 May 2008 22:01:13 -0700
Message-ID: <200805280501.m4S51Dc1029961@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:44205 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751707AbYE1FCn (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 28 May 2008 01:02:43 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: apw@shadowen.org, clameter@sgi.com, jeremy@goop.org, kamezawa.hiroyu@jp.fujitsu.com, kosaki.motohiro@jp.fujitsu.com, mpm@selenic.com, nickpiggin@yahoo.com.au, penberg@cs.helsinki.fi, riel@redhat.com


The patch titled
     page-flags: record page flag overlays explicitly
has been added to the -mm tree.  Its filename is
     page-flags-record-page-flag-overlays-explicitly.patch

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
Subject: page-flags: record page flag overlays explicitly
From: Andy Whitcroft <apw@shadowen.org>

With the recent page flag reorganisation we have a single enum which
defines the valid page flags and their values, nice and clear.  However
there are a number of bits which are overloaded by different subsystems. 
Firstly there is PG_owner_priv_1 which is used by filesystems and by XEN. 
Secondly both SLOB and SLUB use a couple of extra page bits to manage
internal state for pages they own; both overlay other bits.  All of these
"aliases" are scattered about the source making it very hard for a reader
to know if the bits are safe to rely on in all contexts; confusion here is
bad.

As we now have a single place where the bits are clearly assigned it makes
sense to clarify the reuse of bits by making the aliases explicit and
visible with the original bit assignments.  This patch creates explicit
aliases within the enum itself for the overloaded bits, creates standard
bit accessors PageFoo etc.  and uses those throughout.

This version pulls the bit manipulation out to standard named page bit
accessors as suggested by Christoph, it retains the explicit mapping to
the overlayed bits.  A fusion of both ideas.  This has been SLUB and SLOB
have been compile tested on x86_64 only, and SLUB boot tested.  If people
feel this is worth doing then I can run a fuller set of testing.


This patch:

Some page flags are used for more than one purpose, for example
PG_owner_priv_1.  Currently there are individual accessors for each user,
each built using the common flag name far away from the bit definitions. 
This makes it hard to see all possible uses of these bits.

Now that we have a single enum to generate the bit orders it makes sense
to express overlays in the same place.  So create per use aliases for this
bit in the main page-flags enum and use those in the accessors.

Signed-off-by: Andy Whitcroft <apw@shadowen.org>
Cc: Pekka Enberg <penberg@cs.helsinki.fi>
Cc: Christoph Lameter <clameter@sgi.com>
Cc: Matt Mackall <mpm@selenic.com>
Cc: Nick Piggin <nickpiggin@yahoo.com.au>
Cc: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Reviewed-by: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Cc: Rik van Riel <riel@redhat.com>
Cc: Jeremy Fitzhardinge <jeremy@goop.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/page-flags.h |   12 +++++++++---
 1 file changed, 9 insertions(+), 3 deletions(-)

diff -puN include/linux/page-flags.h~page-flags-record-page-flag-overlays-explicitly include/linux/page-flags.h
--- a/include/linux/page-flags.h~page-flags-record-page-flag-overlays-explicitly
+++ a/include/linux/page-flags.h
@@ -96,7 +96,13 @@ enum pageflags {
 #ifdef CONFIG_IA64_UNCACHED_ALLOCATOR
 	PG_uncached,		/* Page has been mapped as uncached */
 #endif
-	__NR_PAGEFLAGS
+	__NR_PAGEFLAGS,
+
+	/* Filesystems */
+	PG_checked = PG_owner_priv_1,
+
+	/* XEN */
+	PG_pinned = PG_owner_priv_1,
 };
 
 #ifndef __GENERATING_BOUNDS_H
@@ -155,8 +161,8 @@ PAGEFLAG(Dirty, dirty) TESTSCFLAG(Dirty,
 PAGEFLAG(LRU, lru) __CLEARPAGEFLAG(LRU, lru)
 PAGEFLAG(Active, active) __CLEARPAGEFLAG(Active, active)
 __PAGEFLAG(Slab, slab)
-PAGEFLAG(Checked, owner_priv_1)		/* Used by some filesystems */
-PAGEFLAG(Pinned, owner_priv_1) TESTSCFLAG(Pinned, owner_priv_1) /* Xen */
+PAGEFLAG(Checked, checked)		/* Used by some filesystems */
+PAGEFLAG(Pinned, pinned) TESTSCFLAG(Pinned, pinned) /* Xen */
 PAGEFLAG(Reserved, reserved) __CLEARPAGEFLAG(Reserved, reserved)
 PAGEFLAG(Private, private) __CLEARPAGEFLAG(Private, private)
 	__SETPAGEFLAG(Private, private)
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

