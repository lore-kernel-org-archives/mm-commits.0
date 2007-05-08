From: akpm@linux-foundation.org
Subject: - slab-ensure-cache_alloc_refill-terminates.patch removed from -mm tree
Date: Mon, 07 May 2007 17:01:53 -0700
Message-ID: <200705080001.l4801rxe008803@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([65.172.181.25]:58062 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S967308AbXEHACK (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 7 May 2007 20:02:10 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: penberg@cs.helsinki.fi, clameter@sgi.com, mcr@sandelman.ca, mm-commits@vger.kernel.org


The patch titled
     slab: ensure cache_alloc_refill terminates
has been removed from the -mm tree.  Its filename was
     slab-ensure-cache_alloc_refill-terminates.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: slab: ensure cache_alloc_refill terminates
From: Pekka Enberg <penberg@cs.helsinki.fi>

If slab->inuse is corrupted, cache_alloc_refill can enter an infinite
loop as detailed by Michael Richardson in the following post:
<http://lkml.org/lkml/2007/2/16/292>. This adds a BUG_ON to catch
those cases.

Cc: Michael Richardson <mcr@sandelman.ca>
Acked-by: Christoph Lameter <clameter@sgi.com>
Signed-off-by: Pekka Enberg <penberg@cs.helsinki.fi>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/slab.c |    8 ++++++++
 1 file changed, 8 insertions(+)

diff -puN mm/slab.c~slab-ensure-cache_alloc_refill-terminates mm/slab.c
--- a/mm/slab.c~slab-ensure-cache_alloc_refill-terminates
+++ a/mm/slab.c
@@ -2990,6 +2990,14 @@ retry:
 		slabp = list_entry(entry, struct slab, list);
 		check_slabp(cachep, slabp);
 		check_spinlock_acquired(cachep);
+
+		/*
+		 * The slab was either on partial or free list so
+		 * there must be at least one object available for
+		 * allocation.
+		 */
+		BUG_ON(slabp->inuse < 0 || slabp->inuse >= cachep->num);
+
 		while (slabp->inuse < cachep->num && batchcount--) {
 			STATS_INC_ALLOCED(cachep);
 			STATS_INC_ACTIVE(cachep);
_

Patches currently in -mm which might be from penberg@cs.helsinki.fi are

origin.patch
unionfs-fix-slab-abuses-with-krealloc.patch
increase-slab-redzone-to-64bits.patch
module-use-krealloc.patch
slab-use-cpu_lock_.patch
separate-freezer-from-pm-code-rev-2.patch
introduce-freezer-flags-rev-2.patch
revoke-special-mmap-handling.patch
revoke-special-mmap-handling-vs-fault-vs-invalidate.patch
revoke-core-code.patch
revoke-core-code-misc-fixes.patch
revoke-core-code-fix-shared-mapping-revoke.patch
revoke-core-code-move-magic.patch
revoke-core-code-fs-revokec-cleanups-and-bugfix-for-64bit-systems.patch
revoke-core-code-revoke-no-revoke-for-nommu.patch
revoke-core-code-fix-shared-mapping-revoke-revoke-only-revoke-mappings-for-the-given-inode.patch
revoke-core-code-break-cow-for-private-mappings.patch
revoke-core-code-generic_file_revoke-stub-for-nommu.patch
revoke-core-code-break-cow-fixes.patch
revoke-core-code-mapping-revocation.patch
revoke-core-code-only-fput-unused-files.patch
revoke-core-code-rename-to-can_revoke_filevma.patch
revoke-core-code-change-revoke_table-to-fileset-and-revoke_details.patch
revoke-core-code-do_revoke-error-handling.patch
revoke-support-for-ext2-and-ext3.patch
revoke-add-documentation.patch
revoke-wire-up-i386-system-calls.patch
slab-leaks3-default-y.patch
