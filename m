From: akpm@linux-foundation.org
Subject: + vmscan-factor-out-page-reference-checks-fix.patch added to -mm tree
Date: Wed, 24 Feb 2010 13:46:05 -0800
Message-ID: <201002242146.o1OLk542022147@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:58487 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758098Ab0BXVqc (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 24 Feb 2010 16:46:32 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: hannes@cmpxchg.org, kosaki.motohiro@jp.fujitsu.com, lee.schermerhorn@hp.com, minchan.kim@gmail.com, riel@redhat.com


The patch titled
     vmscan: improve comment on mlocked page in reclaim
has been added to the -mm tree.  Its filename is
     vmscan-factor-out-page-reference-checks-fix.patch

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
Subject: vmscan: improve comment on mlocked page in reclaim
From: Johannes Weiner <hannes@cmpxchg.org>

Signed-off-by: Johannes Weiner <hannes@cmpxchg.org>
Reviewed-by: Rik van Riel <riel@redhat.com>
Cc: Minchan Kim <minchan.kim@gmail.com>
Cc: OSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Cc: Lee Schermerhorn <lee.schermerhorn@hp.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/vmscan.c |    5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff -puN mm/vmscan.c~vmscan-factor-out-page-reference-checks-fix mm/vmscan.c
--- a/mm/vmscan.c~vmscan-factor-out-page-reference-checks-fix
+++ a/mm/vmscan.c
@@ -599,7 +599,10 @@ static enum page_references page_check_r
 	if (sc->order > PAGE_ALLOC_COSTLY_ORDER)
 		return PAGEREF_RECLAIM;
 
-	/* Mlock lost isolation race - let try_to_unmap() handle it */
+	/*
+	 * Mlock lost the isolation race with us.  Let try_to_unmap()
+	 * move the page to the unevictable list.
+	 */
 	if (vm_flags & VM_LOCKED)
 		return PAGEREF_RECLAIM;
 
_

Patches currently in -mm which might be from hannes@cmpxchg.org are

bootmem-avoid-dma32-zone-by-default.patch
vmscan-factor-out-page-reference-checks.patch
vmscan-factor-out-page-reference-checks-fix.patch
vmscan-drop-page_mapping_inuse.patch
vmscan-detect-mapped-file-pages-used-only-once.patch

