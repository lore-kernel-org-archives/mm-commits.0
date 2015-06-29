From: akpm@linux-foundation.org
Subject: [merged]
 documentation-vm-unevictable-lrutxt-clarify-map_locked-behavior.patch
 removed from -mm tree
Date: Mon, 29 Jun 2015 13:38:48 -0700
Message-ID: <5591acd8.C5ZWCRGOBF85QBqy%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:50476 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753124AbbF2Uit (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 29 Jun 2015 16:38:49 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mhocko@suse.cz, rientjes@google.com, mm-commits@vger.kernel.org


The patch titled
     Subject: Documentation/vm/unevictable-lru.txt: clarify MAP_LOCKED behavior
has been removed from the -mm tree.  Its filename was
     documentation-vm-unevictable-lrutxt-clarify-map_locked-behavior.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Michal Hocko <mhocko@suse.cz>
Subject: Documentation/vm/unevictable-lru.txt: clarify MAP_LOCKED behavior

There is a very subtle difference between mmap()+mlock() vs
mmap(MAP_LOCKED) semantic.  The former one fails if the population of the
area fails while the later one doesn't.  This basically means that
mmap(MAPLOCKED) areas might see major fault after mmap syscall returns
which is not the case for mlock.  mmap man page has already been altered
but Documentation/vm/unevictable-lru.txt deserves a clarification as well.

Signed-off-by: Michal Hocko <mhocko@suse.cz>
Reported-by: David Rientjes <rientjes@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/vm/unevictable-lru.txt |    8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)

diff -puN Documentation/vm/unevictable-lru.txt~documentation-vm-unevictable-lrutxt-clarify-map_locked-behavior Documentation/vm/unevictable-lru.txt
--- a/Documentation/vm/unevictable-lru.txt~documentation-vm-unevictable-lrutxt-clarify-map_locked-behavior
+++ a/Documentation/vm/unevictable-lru.txt
@@ -467,7 +467,13 @@ mmap(MAP_LOCKED) SYSTEM CALL HANDLING
 
 In addition the mlock()/mlockall() system calls, an application can request
 that a region of memory be mlocked supplying the MAP_LOCKED flag to the mmap()
-call.  Furthermore, any mmap() call or brk() call that expands the heap by a
+call. There is one important and subtle difference here, though. mmap() + mlock()
+will fail if the range cannot be faulted in (e.g. because mm_populate fails)
+and returns with ENOMEM while mmap(MAP_LOCKED) will not fail. The mmaped
+area will still have properties of the locked area - aka. pages will not get
+swapped out - but major page faults to fault memory in might still happen.
+
+Furthermore, any mmap() call or brk() call that expands the heap by a
 task that has previously called mlockall() with the MCL_FUTURE flag will result
 in the newly mapped memory being mlocked.  Before the unevictable/mlock
 changes, the kernel simply called make_pages_present() to allocate pages and
_

Patches currently in -mm which might be from mhocko@suse.cz are

origin.patch
mm-meminit-inline-some-helper-functions-fix2.patch
page-flags-trivial-cleanup-for-pagetrans-helpers.patch
page-flags-introduce-page-flags-policies-wrt-compound-pages.patch
page-flags-define-pg_locked-behavior-on-compound-pages.patch
page-flags-define-behavior-of-fs-io-related-flags-on-compound-pages.patch
page-flags-define-behavior-of-lru-related-flags-on-compound-pages.patch
page-flags-define-behavior-slb-related-flags-on-compound-pages.patch
page-flags-define-behavior-of-xen-related-flags-on-compound-pages.patch
page-flags-define-pg_reserved-behavior-on-compound-pages.patch
page-flags-define-pg_swapbacked-behavior-on-compound-pages.patch
page-flags-define-pg_swapcache-behavior-on-compound-pages.patch
page-flags-define-pg_mlocked-behavior-on-compound-pages.patch
page-flags-define-pg_uncached-behavior-on-compound-pages.patch
page-flags-define-pg_uptodate-behavior-on-compound-pages.patch
page-flags-look-on-head-page-if-the-flag-is-encoded-in-page-mapping.patch
mm-sanitize-page-mapping-for-tail-pages.patch
mm-vmscan-fix-the-page-state-calculation-in-too_many_isolated.patch
mm-page_isolation-check-pfn-validity-before-access.patch
mm-support-madvisemadv_free.patch
mm-support-madvisemadv_free-fix-2.patch
mm-dont-split-thp-page-when-syscall-is-called.patch
mm-dont-split-thp-page-when-syscall-is-called-fix-2.patch
mm-dont-split-thp-page-when-syscall-is-called-fix-3.patch
mm-move-lazy-free-pages-to-inactive-list.patch
mm-move-lazy-free-pages-to-inactive-list-fix.patch
mm-move-lazy-free-pages-to-inactive-list-fix-fix.patch
linux-next.patch

