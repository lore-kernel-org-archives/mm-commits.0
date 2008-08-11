From: akpm@linux-foundation.org
Subject: + doc-unevictable-lru-and-mlocked-pages-documentation-update-2.patch added to -mm tree
Date: Mon, 11 Aug 2008 14:53:24 -0700
Message-ID: <200808112153.m7BLrO1N023417@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:42337 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752811AbYHKVyR (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 11 Aug 2008 17:54:17 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: Lee.Schermerhorn@hp.com, kosaki.motohiro@jp.fujitsu.com, lee.schermerhorn@hp.com, riel@redhat.com


The patch titled
     Cleanup/rework Unevictable LRU and Mlocked Pages documentation
has been added to the -mm tree.  Its filename is
     doc-unevictable-lru-and-mlocked-pages-documentation-update-2.patch

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
Subject: Cleanup/rework Unevictable LRU and Mlocked Pages documentation
From: Lee Schermerhorn <Lee.Schermerhorn@hp.com>

Cleanup and rework of Documentation/vm/unevictable-lru.txt:

+ typos and such pointed out by Randy Dunlap
+ rework rationale for use of LRU list based on discussion with
  Christoph Lameter
+ a few other area of rewording suggested by the rationale rework.

Signed-off-by: Lee Schermerhorn <lee.schermerhorn@hp.com>
Cc: Rik van Riel <riel@redhat.com>
Cc: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/vm/unevictable-lru.txt |   62 ++++++++++++++-----------
 1 file changed, 35 insertions(+), 27 deletions(-)

diff -puN Documentation/vm/unevictable-lru.txt~doc-unevictable-lru-and-mlocked-pages-documentation-update-2 Documentation/vm/unevictable-lru.txt
--- a/Documentation/vm/unevictable-lru.txt~doc-unevictable-lru-and-mlocked-pages-documentation-update-2
+++ a/Documentation/vm/unevictable-lru.txt
@@ -38,32 +38,36 @@ The Unevictable LRU List
 
 The Unevictable LRU infrastructure consists of an additional, per-zone, LRU list
 called the "unevictable" list and an associated page flag, PG_unevictable, to
-indicate that the page is being managed on the unevictable list.  The PG_unevictable
-flag is analogous to, and mutually exclusive with, the PG_active flag in that
-it indicates on which LRU list a page resides when PG_lru is set.  The
-unevictable LRU list is source configurable based on the UNEVICTABLE_LRU Kconfig
-option.
-
-Why maintain unevictable pages on an additional LRU list?  Primarily because
-we want to be able to migrate unevictable pages between nodes--for memory
-deframentation, workload management and memory hotplug.  The linux kernel can
-only migrate pages that it can successfully isolate from the lru lists.
-Therefore, we want to keep the unevictable pages on an lru-like list, where
-they can be found by isolate_lru_page().
-
-Secondarily, the Linux memory management subsystem has well established
-protocols for managing pages on the LRU.  Vmscan is based on LRU lists.
-LRU list exist per zone, and we want to maintain pages relative to their
-"home zone".  All of these make the use of an additional list, parallel to
-the LRU active and inactive lists, a natural mechanism to employ.  Note,
-however, that the unevictable list does not differentiate between file backed
-and swap backed [anon] pages.  This differentiation is only important while
-the pages are, in fact, evictable.
+indicate that the page is being managed on the unevictable list.  The
+PG_unevictable flag is analogous to, and mutually exclusive with, the PG_active
+flag in that it indicates on which LRU list a page resides when PG_lru is set.
+The unevictable LRU list is source configurable based on the UNEVICTABLE_LRU
+Kconfig option.
+
+The Unevictable LRU infrastructure maintains unevictable pages on an additional
+LRU list for a few reasons:
+
+1) We get to "treat unevictable pages just like we treat other pages in the
+   system, which means we get to use the same code to manipulate them, the
+   same code to isolate them (for migrate, etc.), the same code to keep track
+   of the statistics, etc..." [Rik van Riel]
+
+2) We want to be able to migrate unevictable pages between nodes--for memory
+   defragmentation, workload management and memory hotplug.  The linux kernel
+   can only migrate pages that it can successfully isolate from the lru lists.
+   If we were to maintain pages elsewise than on an lru-like list, where they
+   can be found by isolate_lru_page(), we would prevent their migration, unless
+   we reworked migration code to find the unevictable pages.
+
+
+The unevictable LRU list does not differentiate between file backed and swap
+backed [anon] pages.  This differentiation is only important while the pages
+are, in fact, evictable.
 
 The unevictable LRU list benefits from the "arrayification" of the per-zone
 LRU lists and statistics originally proposed and posted by Christoph Lameter.
 
-Note that the unevictable list does not use the lru pagevec mechanism. Rather,
+The unevictable list does not use the lru pagevec mechanism. Rather,
 unevictable pages are placed directly on the page's zone's unevictable
 list under the zone lru_lock.  The reason for this is to prevent stranding
 of pages on the unevictable list when one task has the page isolated from the
@@ -156,14 +160,18 @@ Mlocked Page:  Prior Work
 
 The "Unevictable Mlocked Pages" infrastructure is based on work originally
 posted by Nick Piggin in an RFC patch entitled "mm: mlocked pages off LRU".
-Nick's posted his patch as an alternative to a patch posted by Christoph
+Nick posted his patch as an alternative to a patch posted by Christoph
 Lameter to achieve the same objective--hiding mlocked pages from vmscan.
 In Nick's patch, he used one of the struct page lru list link fields as a count
 of VM_LOCKED vmas that map the page.  This use of the link field for a count
-prevent the management of the pages on an LRU list.  When Nick's patch was
-integrated with the Unevictable LRU work, the count was replaced by walking the
-reverse map to determine whether any VM_LOCKED vmas mapped the page.  More on
-this below.
+prevented the management of the pages on an LRU list.  Thus, mlocked pages were
+not migratable as isolate_lru_page() could not find them and the lru list link
+field was not available to the migration subsystem.  Nick resolved this by
+putting mlocked pages back on the lru list before attempting to isolate them,
+thus abandoning the count of VM_LOCKED vmas.  When Nick's patch was integrated
+with the Unevictable LRU work, the count was replaced by walking the reverse
+map to determine whether any VM_LOCKED vmas mapped the page.  More on this
+below.
 
 
 Mlocked Pages:  Basic Management
_

Patches currently in -mm which might be from Lee.Schermerhorn@hp.com are

vmscan-move-isolate_lru_page-to-vmscanc.patch
vmscan-free-swap-space-on-swap-in-activation.patch
vmscan-split-lru-lists-into-anon-file-sets.patch
unevictable-lru-infrastructure.patch
unevictable-lru-page-statistics.patch
ramfs-and-ram-disk-pages-are-unevictable.patch
shm_locked-pages-are-unevictable.patch
doc-unevictable-lru-and-mlocked-pages-documentation-update.patch
doc-unevictable-lru-and-mlocked-pages-documentation-update-2.patch

