From: akpm@linux-foundation.org
Subject: [merged] mm-slub-fix-alloc_slowpath-stat.patch removed from -mm
 tree
Date: Thu, 05 Jun 2014 12:43:18 -0700
Message-ID: <5390c856.JvI0M+KyF7wyfxcb%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:55677 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751708AbaFETnT (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 5 Jun 2014 15:43:19 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, rientjes@google.com, penberg@kernel.org, cl@linux.com, dave.hansen@linux.intel.com

Subject: [merged] mm-slub-fix-alloc_slowpath-stat.patch removed from -mm tree
To: dave.hansen@linux.intel.com,cl@linux.com,penberg@kernel.org,rientjes@google.com,mm-commits@vger.kernel.org
From: akpm@linux-foundation.org
Date: Thu, 05 Jun 2014 12:43:18 -0700


The patch titled
     Subject: mm: slub: fix ALLOC_SLOWPATH stat
has been removed from the -mm tree.  Its filename was
     mm-slub-fix-alloc_slowpath-stat.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Dave Hansen <dave.hansen@linux.intel.com>
Subject: mm: slub: fix ALLOC_SLOWPATH stat

There used to be only one path out of __slab_alloc(), and ALLOC_SLOWPATH
got bumped in that exit path.  Now there are two, and a bunch of gotos. 
ALLOC_SLOWPATH can now get set more than once during a single call to
__slab_alloc() which is pretty bogus.  Here's the sequence:

1. Enter __slab_alloc(), fall through all the way to the
   stat(s, ALLOC_SLOWPATH);
2. hit 'if (!freelist)', and bump DEACTIVATE_BYPASS, jump to
   new_slab (goto #1)
3. Hit 'if (c->partial)', bump CPU_PARTIAL_ALLOC, goto redo
   (goto #2)
4. Fall through in the same path we did before all the way to
   stat(s, ALLOC_SLOWPATH)
5. bump ALLOC_REFILL stat, then return

Doing this is obviously bogus.  It keeps us from being able to accurately
compare ALLOC_SLOWPATH vs.  ALLOC_FASTPATH.  It also means that the total
number of allocs always exceeds the total number of frees.

This patch moves stat(s, ALLOC_SLOWPATH) to be called from the same place
that __slab_alloc() is.  This makes it much less likely that
ALLOC_SLOWPATH will get botched again in the spaghetti-code inside
__slab_alloc().

Signed-off-by: Dave Hansen <dave.hansen@linux.intel.com>
Acked-by: Christoph Lameter <cl@linux.com>
Acked-by: David Rientjes <rientjes@google.com>
Cc: Pekka Enberg <penberg@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/slub.c |    8 +++-----
 1 file changed, 3 insertions(+), 5 deletions(-)

diff -puN mm/slub.c~mm-slub-fix-alloc_slowpath-stat mm/slub.c
--- a/mm/slub.c~mm-slub-fix-alloc_slowpath-stat
+++ a/mm/slub.c
@@ -2326,8 +2326,6 @@ redo:
 	if (freelist)
 		goto load_freelist;
 
-	stat(s, ALLOC_SLOWPATH);
-
 	freelist = get_freelist(s, page);
 
 	if (!freelist) {
@@ -2432,10 +2430,10 @@ redo:
 
 	object = c->freelist;
 	page = c->page;
-	if (unlikely(!object || !node_match(page, node)))
+	if (unlikely(!object || !node_match(page, node))) {
 		object = __slab_alloc(s, gfpflags, node, addr, c);
