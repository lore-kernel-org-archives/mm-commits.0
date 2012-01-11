From: akpm@linux-foundation.org
Subject: [merged] pm-hibernate-do-not-count-debug-pages-as-savable.patch removed from -mm tree
Date: Wed, 11 Jan 2012 13:27:04 -0800
Message-ID: <20120111212704.B55D11E004D@wpzn4.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-gx0-f202.google.com ([209.85.161.202]:48989 "EHLO
	mail-gx0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933502Ab2AKV1F (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 11 Jan 2012 16:27:05 -0500
Received: by mail-gx0-f202.google.com with SMTP id k3so134376ggn.1
        for <mm-commits@vger.kernel.org>; Wed, 11 Jan 2012 13:27:05 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: sgruszka@redhat.com, aarcange@redhat.com, cl@linux-foundation.org, mgorman@suse.de, penberg@cs.helsinki.fi, rjw@sisk.pl, mm-commits@vger.kernel.org


The patch titled
     Subject: PM/Hibernate: do not count debug pages as savable
has been removed from the -mm tree.  Its filename was
     pm-hibernate-do-not-count-debug-pages-as-savable.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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

Patches currently in -mm which might be from sgruszka@redhat.com are

origin.patch
linux-next.patch

