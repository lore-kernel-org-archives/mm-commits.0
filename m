From: akpm@linux-foundation.org
Subject: + pm-hibernate-do-not-count-debug-pages-as-savable.patch added to -mm tree
Date: Tue, 22 Nov 2011 13:57:04 -0800
Message-ID: <201111222157.pAMLv43w003372@wpaz5.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-gx0-f202.google.com ([209.85.161.202]:50580 "EHLO
	mail-gx0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753007Ab1KVV5G (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 22 Nov 2011 16:57:06 -0500
Received: by ggdk5 with SMTP id k5so138387ggd.1
        for <mm-commits@vger.kernel.org>; Tue, 22 Nov 2011 13:57:06 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: sgruszka@redhat.com, aarcange@redhat.com, cl@linux-foundation.org, mgorman@suse.de, penberg@cs.helsinki.fi, rjw@sisk.pl


The patch titled
     Subject: PM/Hibernate: do not count debug pages as savable
has been added to the -mm tree.  Its filename is
     pm-hibernate-do-not-count-debug-pages-as-savable.patch

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
From: Stanislaw Gruszka <sgruszka@redhat.com>
Subject: PM/Hibernate: do not count debug pages as savable

When debugging with CONFIG_DEBUG_PAGEALLOC and debug_guardpage_minorder >
0, we have lot of free pages that are not marked so.  Snapshot code
account them as savable, what cause hibernate memory preallocation
failure.

It is pretty hard to make hibernate allocation succeed with
debug_guardpage_minorder=1.  This change at least make it possible when
system has relatively big amount of RAM.

Signed-off-by: Stanislaw Gruszka <sgruszka@redhat.com>
Acked-by: Rafael J. Wysocki <rjw@sisk.pl>
Cc: Andrea Arcangeli <aarcange@redhat.com>
Cc: Christoph Lameter <cl@linux-foundation.org>
Cc: Mel Gorman <mgorman@suse.de>
Cc: Pekka Enberg <penberg@cs.helsinki.fi>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/power/snapshot.c |    6 ++++++
 1 file changed, 6 insertions(+)

diff -puN kernel/power/snapshot.c~pm-hibernate-do-not-count-debug-pages-as-savable kernel/power/snapshot.c
--- a/kernel/power/snapshot.c~pm-hibernate-do-not-count-debug-pages-as-savable
+++ a/kernel/power/snapshot.c
@@ -858,6 +858,9 @@ static struct page *saveable_highmem_pag
 	    PageReserved(page))
 		return NULL;
 
+	if (page_is_guard(page))
+		return NULL;
+
 	return page;
 }
 
@@ -920,6 +923,9 @@ static struct page *saveable_page(struct
 	    && (!kernel_page_present(page) || pfn_is_nosave(pfn)))
 		return NULL;
 
+	if (page_is_guard(page))
+		return NULL;
+
 	return page;
 }
 
_
Subject: Subject: PM/Hibernate: do not count debug pages as savable

Patches currently in -mm which might be from sgruszka@redhat.com are

linux-next.patch
mm-more-intensive-memory-corruption-debug.patch
mm-more-intensive-memory-corruption-debug-fix.patch
pm-hibernate-do-not-count-debug-pages-as-savable.patch
slub-min-order-when-debug_guardpage_minorder-0.patch

