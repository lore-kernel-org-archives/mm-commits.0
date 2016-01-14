From: akpm@linux-foundation.org
Subject: [folded-merged]
 mempolicy-convert-the-shared_policy-lock-to-a-rwlock-fix-2.patch removed
 from -mm tree
Date: Thu, 14 Jan 2016 14:20:15 -0800
Message-ID: <56981f1f.sLngfCuflDcWOtPs%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:44130 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753907AbcANWUQ (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 14 Jan 2016 17:20:16 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, aneesh.kumar@linux.vnet.ibm.com, mgorman@suse.de, n-horiguchi@ah.jp.nec.com, nyc@holomorphy.com, nzimmer@sgi.com, rientjes@google.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mempolicy-convert-the-shared_policy-lock-to-a-rwlock-fix-2
has been removed from the -mm tree.  Its filename was
     mempolicy-convert-the-shared_policy-lock-to-a-rwlock-fix-2.patch

This patch was dropped because it was folded into mempolicy-convert-the-shared_policy-lock-to-a-rwlock.patch

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

include-linux-dcacheh-remove-semicolons-from-hash_len_declare.patch
mempolicy-convert-the-shared_policy-lock-to-a-rwlock.patch
mm-zonelist-enumerate-zonelists-array-index-checkpatch-fixes.patch
mm-zonelist-enumerate-zonelists-array-index-fix.patch
mm-get-rid-of-__alloc_pages_high_priority-checkpatch-fixes.patch
mm-vmalloc-remove-vm_vpages-fix.patch
fs-block_devc-bdev_write_page-use-blk_queue_enter-gfp_noio.patch
arm64-mm-support-arch_mmap_rnd_bits-fix.patch
page-flags-define-pg_locked-behavior-on-compound-pages-fix.patch
mm-rework-mapcount-accounting-to-enable-4k-mapping-of-thps-fix.patch
mm-hwpoison-adjust-for-new-thp-refcounting-fix.patch
thp-reintroduce-split_huge_page-fix.patch
mm-prepare-page_referenced-and-page_idle-to-new-thp-refcounting-checkpatch-fixes.patch
thp-add-debugfs-handle-to-split-all-huge-pages-fix.patch

