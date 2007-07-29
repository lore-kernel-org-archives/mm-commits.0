From: akpm@linux-foundation.org
Subject: + memoryless-node-allow-profiling-data-to-fall-back-to-other-nodes.patch added to -mm tree
Date: Sun, 29 Jul 2007 00:16:07 -0700
Message-ID: <200707290716.l6T7G7Qr013245@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:41376 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1760093AbXG2HQQ (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Sun, 29 Jul 2007 03:16:16 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: lee.schermerhorn@hp.com, bob.picco@hp.com, clameter@sgi.com, nacc@us.ibm.com


The patch titled
     Memoryless node: Allow profiling data to fall back to other nodes
has been added to the -mm tree.  Its filename is
     memoryless-node-allow-profiling-data-to-fall-back-to-other-nodes.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: Memoryless node: Allow profiling data to fall back to other nodes
From: Lee Schermerhorn <lee.schermerhorn@hp.com>

Processors on memoryless nodes must be able to fall back to remote nodes in
order to get a profiling buffer.  This may lead to excessive NUMA traffic but
I think we should allow this rather than failing.

Signed-off-by: Christoph Lameter <clameter@sgi.com>
Acked-by: Nishanth Aravamudan <nacc@us.ibm.com>
Acked-by: Lee Schermerhorn <lee.schermerhorn@hp.com>
Acked-by: Bob Picco <bob.picco@hp.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/profile.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff -puN kernel/profile.c~memoryless-node-allow-profiling-data-to-fall-back-to-other-nodes kernel/profile.c
--- a/kernel/profile.c~memoryless-node-allow-profiling-data-to-fall-back-to-other-nodes
+++ a/kernel/profile.c
@@ -346,7 +346,7 @@ static int __devinit profile_cpu_callbac
 		per_cpu(cpu_profile_flip, cpu) = 0;
 		if (!per_cpu(cpu_profile_hits, cpu)[1]) {
 			page = alloc_pages_node(node,
-					GFP_KERNEL | __GFP_ZERO | GFP_THISNODE,
+					GFP_KERNEL | __GFP_ZERO,
 					0);
 			if (!page)
 				return NOTIFY_BAD;
@@ -354,7 +354,7 @@ static int __devinit profile_cpu_callbac
 		}
 		if (!per_cpu(cpu_profile_hits, cpu)[0]) {
 			page = alloc_pages_node(node,
-					GFP_KERNEL | __GFP_ZERO | GFP_THISNODE,
+					GFP_KERNEL | __GFP_ZERO,
 					0);
 			if (!page)
 				goto out_free;
_

Patches currently in -mm which might be from lee.schermerhorn@hp.com are

numa-generic-management-of-nodemasks-for-various-purposes.patch
memoryless-nodes-introduce-mask-of-nodes-with-memory.patch
memoryless-nodes-fix-interleave-behavior.patch
oom-use-the-n_memory-map-instead-of-constructing-one-on-the-fly.patch
memoryless-nodes-no-need-for-kswapd.patch
memoryless-node-slab-support.patch
memoryless-nodes-slub-support.patch
uncached-allocator-handle-memoryless-nodes.patch
memoryless-node-allow-profiling-data-to-fall-back-to-other-nodes.patch
memoryless-nodes-update-memory-policy-and-page-migration.patch
add-n_cpu-node-state.patch
memoryless-nodes-fix-gfp_thisnode-behavior.patch
memoryless-nodes-use-node_memory_map-for-cpusets.patch
memoryless-nodes-drop-one-memoryless-node-boot-warning.patch
