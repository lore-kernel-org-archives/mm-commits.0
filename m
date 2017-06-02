From: akpm@linux-foundation.org
Subject: [patch 04/15] mm: clarify why we want kmalloc before falling
 backto vmallock
Date: Fri, 02 Jun 2017 14:46:19 -0700
Message-ID: <5931dcab.scLgxpnNznV5yyZ1%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:51414 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750971AbdFBVqU (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 2 Jun 2017 17:46:20 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: torvalds@linux-foundation.org, mm-commits@vger.kernel.org, akpm@linux-foundation.org, mhocko@suse.com, chris@chris-wilson.co.uk, vbabka@suse.cz

From: Michal Hocko <mhocko@suse.com>
Subject: mm: clarify why we want kmalloc before falling backto vmallock

While converting drm_[cm]alloc* helpers to kvmalloc* variants Chris Wilson
has wondered why we want to try kmalloc before vmalloc fallback even for
larger allocations requests.  Let's clarify that one larger physically
contiguous block is less likely to fragment memory than many scattered
pages which can prevent more large blocks from being created.

[akpm@linux-foundation.org: coding-style fixes]
Link: http://lkml.kernel.org/r/20170517080932.21423-1-mhocko@kernel.org
Signed-off-by: Michal Hocko <mhocko@suse.com>
Suggested-by: Chris Wilson <chris@chris-wilson.co.uk>
Reviewed-by: Chris Wilson <chris@chris-wilson.co.uk>
Acked-by: Vlastimil Babka <vbabka@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/util.c |    7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

diff -puN mm/util.c~mm-clarify-why-we-want-kmalloc-before-falling-backto-vmallock mm/util.c
--- a/mm/util.c~mm-clarify-why-we-want-kmalloc-before-falling-backto-vmallock
+++ a/mm/util.c
@@ -357,8 +357,11 @@ void *kvmalloc_node(size_t size, gfp_t f
 	WARN_ON_ONCE((flags & GFP_KERNEL) != GFP_KERNEL);
 
 	/*
-	 * Make sure that larger requests are not too disruptive - no OOM
-	 * killer and no allocation failure warnings as we have a fallback
+	 * We want to attempt a large physically contiguous block first because
+	 * it is less likely to fragment multiple larger blocks and therefore
+	 * contribute to a long term fragmentation less than vmalloc fallback.
+	 * However make sure that larger requests are not too disruptive - no
+	 * OOM killer and no allocation failure warnings as we have a fallback.
 	 */
 	if (size > PAGE_SIZE) {
 		kmalloc_flags |= __GFP_NOWARN;
_
