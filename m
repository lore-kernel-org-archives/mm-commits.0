From: akpm@linux-foundation.org
Subject: + fix-slab-kmem_list3-for-booting-on-machines-with-memoryless-nodes-full-revert-of-04231b3002ac53f8a64a7bd142fde3fa4b6808c6.patch added to -mm tree
Date: Sat, 26 Jan 2008 21:06:51 -0800
Message-ID: <200801270506.m0R56mLu030633@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:36903 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750792AbYA0FHW (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Sun, 27 Jan 2008 00:07:22 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: mel@csn.ul.ie, clameter@sgi.com, olaf@aepfle.de, penberg@cs.helsinki.fi, stable@kernel.org


The patch titled
     Fix SLAB kmem_list3 for booting on machines with memoryless nodes (full revert of 04231b3002ac53f8a64a7bd142fde3fa4b6808c6)
has been added to the -mm tree.  Its filename is
     fix-slab-kmem_list3-for-booting-on-machines-with-memoryless-nodes-full-revert-of-04231b3002ac53f8a64a7bd142fde3fa4b6808c6.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: Fix SLAB kmem_list3 for booting on machines with memoryless nodes (full revert of 04231b3002ac53f8a64a7bd142fde3fa4b6808c6)
From: Mel Gorman <mel@csn.ul.ie>

Complete the revert of the changes made by
04231b3002ac53f8a64a7bd142fde3fa4b6808c6 to the kmem_list3 management in slab.
 On a machine with a memoryless node, BUG_ONs are triggering related to lists
not being initialised and this affects 2.6.24 so should be considered a
candidate for the stable tree.  The intention was to fully revert with commit
9c09a95cf431fcf5720f2e408befa24b32b8cf4d but I mucked it up.

This patch partially addresses a problem in 2.6.24 where SLAB in use with a
machine with memoryless nodes fails to boot.  SLUB is not affected.  Pekka
Enberg has the remainder of the fix which alters when the lists are
initialised.

Signed-off-by: Mel Gorman <mel@csn.ul.ie>
Cc: Olaf Hering <olaf@aepfle.de>
Cc: Christoph Lameter <clameter@sgi.com>
Cc: Pekka Enberg <penberg@cs.helsinki.fi>
Cc: <stable@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/slab.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN mm/slab.c~fix-slab-kmem_list3-for-booting-on-machines-with-memoryless-nodes-full-revert-of-04231b3002ac53f8a64a7bd142fde3fa4b6808c6 mm/slab.c
--- a/mm/slab.c~fix-slab-kmem_list3-for-booting-on-machines-with-memoryless-nodes-full-revert-of-04231b3002ac53f8a64a7bd142fde3fa4b6808c6
+++ a/mm/slab.c
@@ -2099,7 +2099,7 @@ static int __init_refok setup_cpu_cache(
 			g_cpucache_up = PARTIAL_L3;
 		} else {
 			int node;
-			for_each_node_state(node, N_NORMAL_MEMORY) {
+			for_each_online_node(node) {
 				cachep->nodelists[node] =
 				    kmalloc_node(sizeof(struct kmem_list3),
 						GFP_KERNEL, node);
_

Patches currently in -mm which might be from mel@csn.ul.ie are

slab-partially-revert-list3-changes.patch
slab-fix-bootstrap-on-memoryless-node.patch
fix-slab-kmem_list3-for-booting-on-machines-with-memoryless-nodes-full-revert-of-04231b3002ac53f8a64a7bd142fde3fa4b6808c6.patch
git-x86.patch
memory-hotplug-add-removable-to-sysfs-to-show-memblock-removability.patch
page-allocator-clean-up-pcp-draining-functions.patch
page-allocator-get-rid-of-the-list-of-cold-pages.patch
page-allocator-get-rid-of-the-list-of-cold-pages-fix.patch
memcgroup-tidy-up-mem_cgroup_charge_common.patch
memcgroup-fix-hang-with-shmem-tmpfs.patch
page-owner-tracking-leak-detector.patch
add-debugging-aid-for-memory-initialisation-problems.patch
