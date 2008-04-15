From: akpm@linux-foundation.org
Subject: + mm-fix-possible-off-by-one-in-walk_pte_range.patch added to -mm tree
Date: Tue, 15 Apr 2008 11:21:29 -0700
Message-ID: <200804151821.m3FILTA5008649@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:34991 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752230AbYDOSWa (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 15 Apr 2008 14:22:30 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: hannes@saeurebad.de, 12o3l@tiscali.nl, mikpe@it.uu.se, mpm@selenic.com, schwab@suse.de


The patch titled
     mm: fix possible off-by-one in walk_pte_range()
has been added to the -mm tree.  Its filename is
     mm-fix-possible-off-by-one-in-walk_pte_range.patch

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
Subject: mm: fix possible off-by-one in walk_pte_range()
From: Johannes Weiner <hannes@saeurebad.de>

After the loop in walk_pte_range() pte might point to the first address after
the pmd it walks.  The pte_unmap() is then applied to something bad.

Spotted by Roel Kluin and Andreas Schwab.

Signed-off-by: Johannes Weiner <hannes@saeurebad.de>
Cc: Roel Kluin <12o3l@tiscali.nl>
Cc: Andreas Schwab <schwab@suse.de>
Cc: Matt Mackall <mpm@selenic.com>
Cc: Mikael Pettersson <mikpe@it.uu.se>
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

git-x86.patch
arm-remove-redundant-display-of-free-swap-space-in-show_mem.patch
git-powerpc.patch
git-ia64.patch
git-mips.patch
parisc-remove-redundant-display-of-free-swap-space-in-show_mem.patch
git-s390.patch
git-xtensa.patch
mm-remove-unused-max_nodes_shift.patch
mm-fix-possible-off-by-one-in-walk_pte_range.patch
m68k-remove-redundant-display-of-free-swap-space-in-show_mem.patch
cris-remove-redundant-display-of-free-swap-space-in-show_mem.patch
add-warn_on_secs-macro-simplification.patch
add-warn_on_secs-macro-simplification-fix.patch
add-warn_on_secs-macro-simplification-fix-fix.patch

