From: akpm@linux-foundation.org
Subject: +
 radix-tree-replace-preallocated-node-array-with-linked-list.patch added to
 -mm tree
Date: Wed, 13 May 2015 14:23:51 -0700
Message-ID: <5553c0e7.6ta47o0o2UJr5gWZ%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:55899 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753298AbbEMVXw (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 13 May 2015 17:23:52 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: kirill.shutemov@linux.intel.com, mm-commits@vger.kernel.org


The patch titled
     Subject: radix-tree: replace preallocated node array with linked list
has been added to the -mm tree.  Its filename is
     radix-tree-replace-preallocated-node-array-with-linked-list.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/radix-tree-replace-preallocated-node-array-with-linked-list.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/radix-tree-replace-preallocated-node-array-with-linked-list.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>
Subject: radix-tree: replace preallocated node array with linked list

Currently we use per-cpu array to hold pointers to preallocated nodes. 
Let's replace it with linked list.  On x86_64 it saves 256 bytes in
per-cpu ELF section which may translate into freeing up 2MB of memory for
NR_CPUS==8192.

Signed-off-by: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/radix-tree.c |   27 ++++++++++++++++-----------
 1 file changed, 16 insertions(+), 11 deletions(-)

diff -puN lib/radix-tree.c~radix-tree-replace-preallocated-node-array-with-linked-list lib/radix-tree.c
--- a/lib/radix-tree.c~radix-tree-replace-preallocated-node-array-with-linked-list
+++ a/lib/radix-tree.c
@@ -65,7 +65,8 @@ static struct kmem_cache *radix_tree_nod
  */
 struct radix_tree_preload {
 	int nr;
-	struct radix_tree_node *nodes[RADIX_TREE_PRELOAD_SIZE];
+	/* nodes->private_data points to next prealocated node */
+	struct radix_tree_node *nodes;
 };
 static DEFINE_PER_CPU(struct radix_tree_preload, radix_tree_preloads) = { 0, };
 
@@ -197,8 +198,9 @@ radix_tree_node_alloc(struct radix_tree_
 		 */
 		rtp = this_cpu_ptr(&radix_tree_preloads);
 		if (rtp->nr) {
-			ret = rtp->nodes[rtp->nr - 1];
-			rtp->nodes[rtp->nr - 1] = NULL;
+			ret = rtp->nodes;
+			rtp->nodes = ret->private_data;
+			ret->private_data = NULL;
 			rtp->nr--;
 		}
 		/*
@@ -257,16 +259,18 @@ static int __radix_tree_preload(gfp_t gf
 
 	preempt_disable();
 	rtp = this_cpu_ptr(&radix_tree_preloads);
-	while (rtp->nr < ARRAY_SIZE(rtp->nodes)) {
+	while (rtp->nr < RADIX_TREE_PRELOAD_SIZE) {
 		preempt_enable();
 		node = kmem_cache_alloc(radix_tree_node_cachep, gfp_mask);
 		if (node == NULL)
 			goto out;
 		preempt_disable();
 		rtp = this_cpu_ptr(&radix_tree_preloads);
-		if (rtp->nr < ARRAY_SIZE(rtp->nodes))
-			rtp->nodes[rtp->nr++] = node;
-		else
+		if (rtp->nr < RADIX_TREE_PRELOAD_SIZE) {
+			node->private_data = rtp->nodes;
+			rtp->nodes = node;
+			rtp->nr++;
+		} else
 			kmem_cache_free(radix_tree_node_cachep, node);
 	}
 	ret = 0;
@@ -1463,15 +1467,16 @@ static int radix_tree_callback(struct no
 {
        int cpu = (long)hcpu;
        struct radix_tree_preload *rtp;
+       struct radix_tree_node *node;
 
        /* Free per-cpu pool of perloaded nodes */
        if (action == CPU_DEAD || action == CPU_DEAD_FROZEN) {
                rtp = &per_cpu(radix_tree_preloads, cpu);
                while (rtp->nr) {
-                       kmem_cache_free(radix_tree_node_cachep,
-                                       rtp->nodes[rtp->nr-1]);
-                       rtp->nodes[rtp->nr-1] = NULL;
-                       rtp->nr--;
+			node = rtp->nodes;
+			rtp->nodes = node->private_data;
+			kmem_cache_free(radix_tree_node_cachep, node);
+			rtp->nr--;
                }
        }
        return NOTIFY_OK;
_

Patches currently in -mm which might be from kirill.shutemov@linux.intel.com are

mm-fix-mprotect-behaviour-on-vm_locked-vmas.patch
mm-fix-mprotect-behaviour-on-vm_locked-vmas-fix.patch
mm-new-mm-hook-framework.patch
mm-new-arch_remap-hook.patch
powerpc-mm-tracking-vdso-remap.patch
mm-drop-bogus-vm_bug_on_page-assert-in-put_page-codepath.patch
mm-avoid-tail-page-refcounting-on-non-thp-compound-pages.patch
rmap-fix-theoretical-race-between-do_wp_page-and-shrink_active_list.patch
rmap-fix-theoretical-race-between-do_wp_page-and-shrink_active_list-fix.patch
rmap-fix-theoretical-race-between-do_wp_page-and-shrink_active_list-fix-fix.patch
mm-thp-split-out-pmd-collpase-flush-into-a-separate-functions.patch
mm-thp-split-out-pmd-collpase-flush-into-a-separate-functions-fix.patch
powerpc-mm-use-generic-version-of-pmdp_clear_flush.patch
mm-clarify-that-the-function-operateds-on-hugepage-pte.patch
page-flags-trivial-cleanup-for-pagetrans-helpers.patch
page-flags-introduce-page-flags-policies-wrt-compound-pages.patch
page-flags-define-pg_locked-behavior-on-compound-pages.patch
page-flags-define-behavior-of-fs-io-related-flags-on-compound-pages.patch
page-flags-define-behavior-of-lru-related-flags-on-compound-pages.patch
page-flags-define-behavior-of-lru-related-flags-on-compound-pages-fix.patch
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
include-linux-page-flagsh-rename-macros-to-avoid-collisions.patch
radix-tree-replace-preallocated-node-array-with-linked-list.patch
radix-tree-replace-preallocated-node-array-with-linked-list-fix.patch
linux-next.patch

