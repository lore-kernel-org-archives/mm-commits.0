From: akpm@linux-foundation.org
Subject: +
 mempolicy-convert-the-shared_policy-lock-to-a-rwlock-fix-2.patch added to
 -mm tree
Date: Tue, 17 Nov 2015 14:03:25 -0800
Message-ID: <564ba42d.rMu2xHw5DTuH7ZUd%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:45216 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754864AbbKQWD0 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 17 Nov 2015 17:03:26 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, aneesh.kumar@linux.vnet.ibm.com, mgorman@suse.de, n-horiguchi@ah.jp.nec.com, nyc@holomorphy.com, nzimmer@sgi.com, rientjes@google.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mempolicy-convert-the-shared_policy-lock-to-a-rwlock-fix-2
has been added to the -mm tree.  Its filename is
     mempolicy-convert-the-shared_policy-lock-to-a-rwlock-fix-2.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mempolicy-convert-the-shared_policy-lock-to-a-rwlock-fix-2.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mempolicy-convert-the-shared_policy-lock-to-a-rwlock-fix-2.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: mempolicy-convert-the-shared_policy-lock-to-a-rwlock-fix-2

tidy up code comments

Cc: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
Cc: David Rientjes <rientjes@google.com>
Cc: Mel Gorman <mgorman@suse.de>
Cc: Nadia Yvette Chambers <nyc@holomorphy.com>
Cc: Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>
Cc: Nathan Zimmer <nzimmer@sgi.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/mempolicy.c |   12 ++++++++----
 1 file changed, 8 insertions(+), 4 deletions(-)

diff -puN mm/mempolicy.c~mempolicy-convert-the-shared_policy-lock-to-a-rwlock-fix-2 mm/mempolicy.c
--- a/mm/mempolicy.c~mempolicy-convert-the-shared_policy-lock-to-a-rwlock-fix-2
+++ a/mm/mempolicy.c
@@ -2146,8 +2146,10 @@ bool __mpol_equal(struct mempolicy *a, s
  * for any accesses to the tree.
  */
 
-/* lookup first element intersecting start-end */
-/* Caller holds sp->lock */
+/*
+ * lookup first element intersecting start-end.  Caller holds sp->lock for
+ * reading or for writing
+ */
 static struct sp_node *
 sp_lookup(struct shared_policy *sp, unsigned long start, unsigned long end)
 {
@@ -2178,8 +2180,10 @@ sp_lookup(struct shared_policy *sp, unsi
 	return rb_entry(n, struct sp_node, nd);
 }
 
-/* Insert a new shared policy into the list. */
-/* Caller holds the write of sp->lock */
+/*
+ * Insert a new shared policy into the list.  Caller holds sp->lock for
+ * writing.
+ */
 static void sp_insert(struct shared_policy *sp, struct sp_node *new)
 {
 	struct rb_node **p = &sp->root.rb_node;
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

arch-alpha-kernel-systblss-remove-debug-check.patch
drivers-gpu-drm-i915-intel_spritec-fix-build.patch
drivers-gpu-drm-i915-intel_tvc-fix-build.patch
ncpfs-dont-allow-negative-timeouts-fix.patch
mm.patch
slub-optimize-bulk-slowpath-free-by-detached-freelist-fix.patch
account-certain-kmem-allocations-to-memcg-checkpatch-fixes.patch
mm-mmapc-remove-redundant-local-variables-for-may_expand_vm-fix.patch
include-define-__phys_to_pfn-as-phys_pfn-fix.patch
mempolicy-convert-the-shared_policy-lock-to-a-rwlock-fix.patch
mempolicy-convert-the-shared_policy-lock-to-a-rwlock-fix-2.patch
page-flags-define-pg_locked-behavior-on-compound-pages-fix.patch
mm-rework-mapcount-accounting-to-enable-4k-mapping-of-thps-fix.patch
mm-hwpoison-adjust-for-new-thp-refcounting-fix.patch
mm-prepare-page_referenced-and-page_idle-to-new-thp-refcounting-checkpatch-fixes.patch
mm-increase-swap_cluster_max-to-batch-tlb-flushes-fix-fix.patch
do_shared_fault-check-that-mmap_sem-is-held.patch
kernel-forkc-export-kernel_thread-to-modules.patch
slab-leaks3-default-y.patch

