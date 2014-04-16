From: akpm@linux-foundation.org
Subject: + mm-mempool-warn-about-__gfp_zero-usage.patch added to -mm tree
Date: Wed, 16 Apr 2014 14:23:09 -0700
Message-ID: <534ef4bd.4ec9IPoHLo+NcP2S%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:46460 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756594AbaDPVXJ (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 16 Apr 2014 17:23:09 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, sebott@linux.vnet.ibm.com

Subject: + mm-mempool-warn-about-__gfp_zero-usage.patch added to -mm tree
To: sebott@linux.vnet.ibm.com
From: akpm@linux-foundation.org
Date: Wed, 16 Apr 2014 14:23:09 -0700


The patch titled
     Subject: mm/mempool: warn about __GFP_ZERO usage
has been added to the -mm tree.  Its filename is
     mm-mempool-warn-about-__gfp_zero-usage.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-mempool-warn-about-__gfp_zero-usage.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-mempool-warn-about-__gfp_zero-usage.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Sebastian Ott <sebott@linux.vnet.ibm.com>
Subject: mm/mempool: warn about __GFP_ZERO usage

Memory obtained via mempool_alloc is not always zeroed even when
called with __GFP_ZERO. Add a note and VM_BUG_ON statement to make
that clear.

Signed-off-by: Sebastian Ott <sebott@linux.vnet.ibm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/mempool.c |    2 ++
 1 file changed, 2 insertions(+)

diff -puN mm/mempool.c~mm-mempool-warn-about-__gfp_zero-usage mm/mempool.c
--- a/mm/mempool.c~mm-mempool-warn-about-__gfp_zero-usage
+++ a/mm/mempool.c
@@ -192,6 +192,7 @@ EXPORT_SYMBOL(mempool_resize);
  * returns NULL. Note that due to preallocation, this function
  * *never* fails when called from process contexts. (it might
  * fail if called from an IRQ context.)
+ * Note: using __GFP_ZERO is not supported.
  */
 void * mempool_alloc(mempool_t *pool, gfp_t gfp_mask)
 {
@@ -200,6 +201,7 @@ void * mempool_alloc(mempool_t *pool, gf
 	wait_queue_t wait;
 	gfp_t gfp_temp;
 
+	VM_BUG_ON(gfp_mask & __GFP_ZERO);
 	might_sleep_if(gfp_mask & __GFP_WAIT);
 
 	gfp_mask |= __GFP_NOMEMALLOC;	/* don't allocate emergency reserves */
_

Patches currently in -mm which might be from sebott@linux.vnet.ibm.com are

include-linux-mmdebugh-add-vm_warn_on-and-vm_warn_on_once.patch
mm-mempool-warn-about-__gfp_zero-usage.patch
mm-mempool-warn-about-__gfp_zero-usage-fix.patch

