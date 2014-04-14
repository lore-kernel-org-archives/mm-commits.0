From: akpm@linux-foundation.org
Subject: +
 mm-softdirty-dont-forget-to-save-file-map-softdiry-bit-on-unmap.patch added to -mm tree
Date: Mon, 14 Apr 2014 15:28:34 -0700
Message-ID: <534c6112.UyAqMpBI1kfRMz0i%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:52685 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755368AbaDNW2f (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 14 Apr 2014 18:28:35 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, xemul@parallels.com, hughd@google.com, gorcunov@openvz.org

Subject: + mm-softdirty-dont-forget-to-save-file-map-softdiry-bit-on-unmap.patch added to -mm tree
To: gorcunov@openvz.org,hughd@google.com,xemul@parallels.com
From: akpm@linux-foundation.org
Date: Mon, 14 Apr 2014 15:28:34 -0700


The patch titled
     Subject: mm: softdirty: don't forget to save file map softdiry bit on unmap
has been added to the -mm tree.  Its filename is
     mm-softdirty-dont-forget-to-save-file-map-softdiry-bit-on-unmap.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-softdirty-dont-forget-to-save-file-map-softdiry-bit-on-unmap.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-softdirty-dont-forget-to-save-file-map-softdiry-bit-on-unmap.patch

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
Subject: mm: softdirty: don't forget to save file map softdiry bit on unmap

pte_file_mksoft_dirty operates with argument passed by a value and returns
modified result thus we need to assign @ptfile here, otherwise itis a no-op
which may lead to loss of the softdirty bit.

Signed-off-by: Cyrill Gorcunov <gorcunov@openvz.org>
Cc: Pavel Emelyanov <xemul@parallels.com>
Cc: Hugh Dickins <hughd@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/rmap.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN mm/rmap.c~mm-softdirty-dont-forget-to-save-file-map-softdiry-bit-on-unmap mm/rmap.c
--- a/mm/rmap.c~mm-softdirty-dont-forget-to-save-file-map-softdiry-bit-on-unmap
+++ a/mm/rmap.c
@@ -1359,7 +1359,7 @@ static int try_to_unmap_cluster(unsigned
 		if (page->index != linear_page_index(vma, address)) {
 			pte_t ptfile = pgoff_to_pte(page->index);
 			if (pte_soft_dirty(pteval))
-				pte_file_mksoft_dirty(ptfile);
+				ptfile = pte_file_mksoft_dirty(ptfile);
 			set_pte_at(mm, address, pte, ptfile);
 		}
 
_

Patches currently in -mm which might be from gorcunov@openvz.org are

mm-softdirty-make-freshly-remapped-file-pages-being-softdirty-unconditionally.patch
mm-softdirty-dont-forget-to-save-file-map-softdiry-bit-on-unmap.patch
mm-softdirty-clear-vm_softdirty-flag-inside-clear_refs_write-instead-of-clear_soft_dirty.patch

