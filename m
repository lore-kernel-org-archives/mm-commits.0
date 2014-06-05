From: akpm@linux-foundation.org
Subject: [merged]
 mm-softdirty-dont-forget-to-save-file-map-softdiry-bit-on-unmap.patch
 removed from -mm tree
Date: Thu, 05 Jun 2014 12:48:53 -0700
Message-ID: <5390c9a5.nN09vZyRM+QuJ694%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:55711 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751900AbaFETsx (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 5 Jun 2014 15:48:53 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, xemul@parallels.com, hughd@google.com, gorcunov@openvz.org

Subject: [merged] mm-softdirty-dont-forget-to-save-file-map-softdiry-bit-on-unmap.patch removed from -mm tree
To: gorcunov@openvz.org,hughd@google.com,xemul@parallels.com,mm-commits@vger.kernel.org
From: akpm@linux-foundation.org
Date: Thu, 05 Jun 2014 12:48:53 -0700


The patch titled
     Subject: mm: softdirty: don't forget to save file map softdiry bit on unmap
has been removed from the -mm tree.  Its filename was
     mm-softdirty-dont-forget-to-save-file-map-softdiry-bit-on-unmap.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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
@@ -1361,7 +1361,7 @@ static int try_to_unmap_cluster(unsigned
 		if (page->index != linear_page_index(vma, address)) {
 			pte_t ptfile = pgoff_to_pte(page->index);
 			if (pte_soft_dirty(pteval))
-				pte_file_mksoft_dirty(ptfile);
+				ptfile = pte_file_mksoft_dirty(ptfile);
 			set_pte_at(mm, address, pte, ptfile);
 		}
 
_

Patches currently in -mm which might be from gorcunov@openvz.org are

origin.patch
linux-next.patch

