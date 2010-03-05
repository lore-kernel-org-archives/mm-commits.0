From: akpm@linux-foundation.org
Subject: [folded] vmscan-factor-out-page-reference-checks-fix.patch removed from -mm tree
Date: Fri, 05 Mar 2010 13:20:56 -0800
Message-ID: <201003052120.o25LKuta028252@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:51708 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752622Ab0CEVVj (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 5 Mar 2010 16:21:39 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: hannes@cmpxchg.org, kosaki.motohiro@jp.fujitsu.com, lee.schermerhorn@hp.com, minchan.kim@gmail.com, riel@redhat.com, mm-commits@vger.kernel.org


The patch titled
     vmscan: improve comment on mlocked page in reclaim
has been removed from the -mm tree.  Its filename was
     vmscan-factor-out-page-reference-checks-fix.patch

This patch was dropped because it was folded into vmscan-factor-out-page-reference-checks.patch

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

vmscan-factor-out-page-reference-checks.patch
vmscan-factor-out-page-reference-checks-fix.patch
vmscan-drop-page_mapping_inuse.patch
vmscan-detect-mapped-file-pages-used-only-once.patch

