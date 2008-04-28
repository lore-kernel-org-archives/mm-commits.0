From: akpm@linux-foundation.org
Subject: - mm-fix-possible-off-by-one-in-walk_pte_range.patch removed from -mm tree
Date: Mon, 28 Apr 2008 14:49:55 -0700
Message-ID: <200804282149.m3SLntKu017427@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:41327 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S934582AbYD1Vui (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 28 Apr 2008 17:50:38 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: hannes@saeurebad.de, 12o3l@tiscali.nl, mikpe@it.uu.se, mpm@selenic.com, schwab@suse.de, stable@kernel.org, mm-commits@vger.kernel.org


The patch titled
     mm: fix possible off-by-one in walk_pte_range()
has been removed from the -mm tree.  Its filename was
     mm-fix-possible-off-by-one-in-walk_pte_range.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: mm: fix possible off-by-one in walk_pte_range()
From: Johannes Weiner <hannes@saeurebad.de>

After the loop in walk_pte_range() pte might point to the first address after
the pmd it walks.  The pte_unmap() is then applied to something bad.

Spotted by Roel Kluin and Andreas Schwab.

Signed-off-by: Johannes Weiner <hannes@saeurebad.de>
Cc: Roel Kluin <12o3l@tiscali.nl>
Cc: Andreas Schwab <schwab@suse.de>
Acked-by: Matt Mackall <mpm@selenic.com>
Acked-by: Mikael Pettersson <mikpe@it.uu.se>
Cc: <stable@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/pagewalk.c |    8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

diff -puN mm/pagewalk.c~mm-fix-possible-off-by-one-in-walk_pte_range mm/pagewalk.c
--- a/mm/pagewalk.c~mm-fix-possible-off-by-one-in-walk_pte_range
+++ a/mm/pagewalk.c
@@ -9,11 +9,15 @@ static int walk_pte_range(pmd_t *pmd, un
 	int err = 0;
 
 	pte = pte_offset_map(pmd, addr);
-	do {
+	for (;;) {
 		err = walk->pte_entry(pte, addr, addr + PAGE_SIZE, private);
 		if (err)
 		       break;
-	} while (pte++, addr += PAGE_SIZE, addr != end);
+		addr += PAGE_SIZE;
+		if (addr == end)
+			break;
+		pte++;
+	}
 
 	pte_unmap(pte);
 	return err;
_

Patches currently in -mm which might be from hannes@saeurebad.de are

origin.patch
git-mips.patch
parisc-remove-redundant-display-of-free-swap-space-in-show_mem.patch
git-xtensa.patch
add-warn_on_secs-macro-simplification.patch
add-warn_on_secs-macro-simplification-fix.patch
add-warn_on_secs-macro-simplification-fix-fix.patch

