From: akpm@linux-foundation.org
Subject: + mm-slubc-fix-page-_count-corruption-again.patch added to -mm
 tree
Date: Tue, 28 Jan 2014 15:27:20 -0800
Message-ID: <52e83cd8.acOTyuRa5s3psYFo%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:47899 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754574AbaA1X1V (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 28 Jan 2014 18:27:21 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, pshelar@nicira.com, penberg@kernel.org, mpm@selenic.com, cl@linux-foundation.org, dave.hansen@linux.intel.com

Subject: + mm-slubc-fix-page-_count-corruption-again.patch added to -mm tree
To: dave.hansen@linux.intel.com,cl@linux-foundation.org,mpm@selenic.com,penberg@kernel.org,pshelar@nicira.com
From: akpm@linux-foundation.org
Date: Tue, 28 Jan 2014 15:27:20 -0800


The patch titled
     Subject: mm/slub.c: fix page->_count corruption (again)
has been added to the -mm tree.  Its filename is
     mm-slubc-fix-page-_count-corruption-again.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-slubc-fix-page-_count-corruption-again.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-slubc-fix-page-_count-corruption-again.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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
mm-slub-do-not-vm_bug_on_page-for-temporary-on-stack-pages.patch
mm-slubc-fix-page-_count-corruption-again.patch
linux-next.patch

