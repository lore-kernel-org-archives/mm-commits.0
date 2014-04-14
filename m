From: akpm@linux-foundation.org
Subject: +
 mm-softdirty-make-freshly-remapped-file-pages-being-softdirty-unconditionally.patch added to -mm tree
Date: Mon, 14 Apr 2014 15:28:33 -0700
Message-ID: <534c6111.D35wCZGdy5bI330B%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:52677 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755333AbaDNW2e (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 14 Apr 2014 18:28:34 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, xemul@parallels.com, hughd@google.com, gorcunov@openvz.org

Subject: + mm-softdirty-make-freshly-remapped-file-pages-being-softdirty-unconditionally.patch added to -mm tree
To: gorcunov@openvz.org,hughd@google.com,xemul@parallels.com
From: akpm@linux-foundation.org
Date: Mon, 14 Apr 2014 15:28:33 -0700


The patch titled
     Subject: mm: softdirty: make freshly remapped file pages being softdirty unconditionally
has been added to the -mm tree.  Its filename is
     mm-softdirty-make-freshly-remapped-file-pages-being-softdirty-unconditionally.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-softdirty-make-freshly-remapped-file-pages-being-softdirty-unconditionally.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-softdirty-make-freshly-remapped-file-pages-being-softdirty-unconditionally.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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

mm-softdirty-make-freshly-remapped-file-pages-being-softdirty-unconditionally.patch
mm-softdirty-dont-forget-to-save-file-map-softdiry-bit-on-unmap.patch
mm-softdirty-clear-vm_softdirty-flag-inside-clear_refs_write-instead-of-clear_soft_dirty.patch

