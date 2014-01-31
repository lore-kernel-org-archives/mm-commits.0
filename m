From: akpm@linux-foundation.org
Subject: [merged] mm-slubc-fix-page-_count-corruption-again.patch removed
 from -mm tree
Date: Fri, 31 Jan 2014 11:16:38 -0800
Message-ID: <52ebf696.bJpleHrPA363ggup%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:50649 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932651AbaAaTQj (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 31 Jan 2014 14:16:39 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, pshelar@nicira.com, penberg@kernel.org, mpm@selenic.com, cl@linux-foundation.org, dave.hansen@linux.intel.com

Subject: [merged] mm-slubc-fix-page-_count-corruption-again.patch removed from -mm tree
To: dave.hansen@linux.intel.com,cl@linux-foundation.org,mpm@selenic.com,penberg@kernel.org,pshelar@nicira.com,mm-commits@vger.kernel.org
From: akpm@linux-foundation.org
Date: Fri, 31 Jan 2014 11:16:38 -0800


The patch titled
     Subject: mm/slub.c: fix page->_count corruption (again)
has been removed from the -mm tree.  Its filename was
     mm-slubc-fix-page-_count-corruption-again.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Dave Hansen <dave.hansen@linux.intel.com>
Subject: mm/slub.c: fix page->_count corruption (again)

abca7c496 ("mm: fix slab->page _count corruption when using slub") notes
that we can not _set_ a page->counters directly, except when using a real
double-cmpxchg.  Doing so can lose updates to ->_count.

That an absolute rule:

        You may not *set* page->counters except via a cmpxchg.

abca7c496 fixed this for the folks who have the slub cmpxchg_double code
turned off at compile time, but it left the bad alone.  It can still be
reached, and the same bug triggered in two cases:

1. Turning on slub debugging at runtime, which is available on
   the distro kernels that I looked at.
2. On 64-bit CPUs with no CMPXCHG16B (some early AMD x86-64
   cpus, evidently)

There are at least 3 ways we could fix this:

1. Take all of the exising calls to cmpxchg_double_slab() and
   __cmpxchg_double_slab() and convert them to take an old, new
   and target 'struct page'.
2. Do (1), but with the newly-introduced 'slub_data'.
3. Do some magic inside the two cmpxchg...slab() functions to
   pull the counters out of new_counters and only set those
   fields in page->{inuse,frozen,objects}.

I've done (2) as well, but it's a bunch more code.  This patch is an
attempt at (3).  This was the most straightforward and foolproof way that
I could think to do this.

This would also technically allow us to get rid of the ugly

#if defined(CONFIG_HAVE_CMPXCHG_DOUBLE) && \
       defined(CONFIG_HAVE_ALIGNED_STRUCT_PAGE)

in 'struct page', but leaving it alone has the added benefit that
'counters' stays 'unsigned' instead of 'unsigned long', so all the copies
that the slub code does stay a bit smaller.

Signed-off-by: Dave Hansen <dave.hansen@linux.intel.com>
Cc: Christoph Lameter <cl@linux-foundation.org>
Cc: Pekka Enberg <penberg@kernel.org>
Cc: Matt Mackall <mpm@selenic.com>
Cc: Pravin B Shelar <pshelar@nicira.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/slub.c |   19 +++++++++++++++++--
 1 file changed, 17 insertions(+), 2 deletions(-)

diff -puN mm/slub.c~mm-slubc-fix-page-_count-corruption-again mm/slub.c
--- a/mm/slub.c~mm-slubc-fix-page-_count-corruption-again
+++ a/mm/slub.c
@@ -355,6 +355,21 @@ static __always_inline void slab_unlock(
 	__bit_spin_unlock(PG_locked, &page->flags);
 }
 
+static inline void set_page_slub_counters(struct page *page, unsigned long counters_new)
+{
+	struct page tmp;
+	tmp.counters = counters_new;
+	/*
+	 * page->counters can cover frozen/inuse/objects as well
+	 * as page->_count.  If we assign to ->counters directly
+	 * we run the risk of losing updates to page->_count, so
+	 * be careful and only assign to the fields we need.
+	 */
+	page->frozen  = tmp.frozen;
+	page->inuse   = tmp.inuse;
+	page->objects = tmp.objects;
+}
+
 /* Interrupts must be disabled (for the fallback code to work right) */
 static inline bool __cmpxchg_double_slab(struct kmem_cache *s, struct page *page,
 		void *freelist_old, unsigned long counters_old,
@@ -376,7 +391,7 @@ static inline bool __cmpxchg_double_slab
 		if (page->freelist == freelist_old &&
 					page->counters == counters_old) {
 			page->freelist = freelist_new;
-			page->counters = counters_new;
+			set_page_slub_counters(page, counters_new);
 			slab_unlock(page);
 			return 1;
 		}
@@ -415,7 +430,7 @@ static inline bool cmpxchg_double_slab(s
 		if (page->freelist == freelist_old &&
 					page->counters == counters_old) {
 			page->freelist = freelist_new;
-			page->counters = counters_new;
+			set_page_slub_counters(page, counters_new);
 			slab_unlock(page);
 			local_irq_restore(flags);
 			return 1;
_

Patches currently in -mm which might be from dave.hansen@linux.intel.com are

origin.patch
mm-slb-fix-misleading-comments.patch

