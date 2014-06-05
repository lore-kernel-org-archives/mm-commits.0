From: akpm@linux-foundation.org
Subject: [merged]
 mm-softdirty-make-freshly-remapped-file-pages-being-softdirty-unconditionally.patch removed from -mm tree
Date: Thu, 05 Jun 2014 12:48:51 -0700
Message-ID: <5390c9a3.gEEoqZz1QvRyuOJH%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:55706 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751354AbaFETsw (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 5 Jun 2014 15:48:52 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, xemul@parallels.com, hughd@google.com, gorcunov@openvz.org

Subject: [merged] mm-softdirty-make-freshly-remapped-file-pages-being-softdirty-unconditionally.patch removed from -mm tree
To: gorcunov@openvz.org,hughd@google.com,xemul@parallels.com,mm-commits@vger.kernel.org
From: akpm@linux-foundation.org
Date: Thu, 05 Jun 2014 12:48:51 -0700


The patch titled
     Subject: mm: softdirty: make freshly remapped file pages being softdirty unconditionally
has been removed from the -mm tree.  Its filename was
     mm-softdirty-make-freshly-remapped-file-pages-being-softdirty-unconditionally.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Cyrill Gorcunov <gorcunov@openvz.org>
Subject: mm: softdirty: make freshly remapped file pages being softdirty unconditionally

Hugh reported:

 | I noticed your soft_dirty work in install_file_pte(): which looked
 | good at first, until I realized that it's propagating the soft_dirty
 | of a pte it's about to zap completely, to the unrelated entry it's
 | about to insert in its place.  Which seems very odd to me.

Indeed this code ends up being nop in result -- pte_file_mksoft_dirty()
operates with pte_t argument and returns new pte_t which were never used
after.  After looking more I think what we need is to soft-dirtify all
newely remapped file pages because it should look like a new mapping for
memory tracker.

Signed-off-by: Cyrill Gorcunov <gorcunov@openvz.org>
Reported-by: Hugh Dickins <hughd@google.com>
Cc: Pavel Emelyanov <xemul@parallels.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/fremap.c |    7 ++-----
 1 file changed, 2 insertions(+), 5 deletions(-)

diff -puN mm/fremap.c~mm-softdirty-make-freshly-remapped-file-pages-being-softdirty-unconditionally mm/fremap.c
--- a/mm/fremap.c~mm-softdirty-make-freshly-remapped-file-pages-being-softdirty-unconditionally
+++ a/mm/fremap.c
@@ -82,13 +82,10 @@ static int install_file_pte(struct mm_st
 
 	ptfile = pgoff_to_pte(pgoff);
 
-	if (!pte_none(*pte)) {
-		if (pte_present(*pte) && pte_soft_dirty(*pte))
-			pte_file_mksoft_dirty(ptfile);
+	if (!pte_none(*pte))
 		zap_pte(mm, vma, addr, pte);
-	}
 
-	set_pte_at(mm, addr, pte, ptfile);
+	set_pte_at(mm, addr, pte, pte_file_mksoft_dirty(ptfile));
 	/*
 	 * We don't need to run update_mmu_cache() here because the "file pte"
 	 * being installed by install_file_pte() is not a real pte - it's a
_

Patches currently in -mm which might be from gorcunov@openvz.org are

origin.patch
linux-next.patch

