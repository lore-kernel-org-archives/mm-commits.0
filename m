From: akpm@linux-foundation.org
Subject: + swiotlb-fix-oops-on-memory-exhaustion.patch added to -mm tree
Date: Thu, 11 Sep 2008 12:05:02 -0700
Message-ID: <200809111905.m8BJ52fe011499@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:54545 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752352AbYIKTFe (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 11 Sep 2008 15:05:34 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: daniel.blueman@gmail.com, fujita.tomonori@lab.ntt.co.jp, jbeulich@novell.com, jens.axboe@oracle.com, stable@kernel.org, tony.luck@intel.com


The patch titled
     swiotlb: fix oops on memory exhaustion
has been added to the -mm tree.  Its filename is
     swiotlb-fix-oops-on-memory-exhaustion.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://userweb.kernel.org/~akpm/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: swiotlb: fix oops on memory exhaustion
From: "Daniel J Blueman" <daniel.blueman@gmail.com>

With SWIOTLB being enabled and straight-forward page allocation failure
[1], the swiotlb_alloc_coherent fall-back path hits an issue [2],
resulting in my webcam failing to work.

At the time of oops, RDI is clearly a pointer to a structure which has
arrived as NULL, leading to the typo in swiotlb_map_single's callsite
arguments.

Correctly passing the device structure [3] addresses the issue and gets my
webcam working again (the allocation failure still occuring).

Signed-off-by: Daniel J Blueman <daniel.blueman@gmail.com>
Cc: Tony Luck <tony.luck@intel.com>
Cc: Jan Beulich <jbeulich@novell.com>
Cc: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Cc: Jens Axboe <jens.axboe@oracle.com>
Cc: <stable@kernel.org>		[2.6.25.x, 2.6.26.x]
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/swiotlb.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN lib/swiotlb.c~swiotlb-fix-oops-on-memory-exhaustion lib/swiotlb.c
--- a/lib/swiotlb.c~swiotlb-fix-oops-on-memory-exhaustion
+++ a/lib/swiotlb.c
@@ -491,7 +491,7 @@ swiotlb_alloc_coherent(struct device *hw
 		 * the lowest available address range.
 		 */
 		dma_addr_t handle;
-		handle = swiotlb_map_single(NULL, NULL, size, DMA_FROM_DEVICE);
+		handle = swiotlb_map_single(hwdev, NULL, size, DMA_FROM_DEVICE);
 		if (swiotlb_dma_mapping_error(hwdev, handle))
 			return NULL;
 
_

Patches currently in -mm which might be from daniel.blueman@gmail.com are

origin.patch
swiotlb-fix-oops-on-memory-exhaustion.patch

