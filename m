From: akpm@linux-foundation.org
Subject: + x86_64-split-remaining-fake-nodes-equally.patch added to -mm tree
Date: Thu, 01 Mar 2007 17:03:33 -0800
Message-ID: <200703020103.l2213XaT028215@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:33140 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932690AbXCBBDo (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Thu, 1 Mar 2007 20:03:44 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: rientjes@google.com, ak@suse.de, clameter@engr.sgi.com, pj@sgi.com


The patch titled
     x86_64: split remaining fake nodes equally
has been added to the -mm tree.  Its filename is
     x86_64-split-remaining-fake-nodes-equally.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: x86_64: split remaining fake nodes equally
From: David Rientjes <rientjes@google.com>

Extends the numa=fake x86_64 command-line option to split the remaining
system memory into equal-sized nodes.

For example:
numa=fake=2*512,4*	gives two 512M nodes and the remaining system
			memory is split into four approximately equal
			chunks.

This is beneficial for systems where the exact size of RAM is unknown or not
necessarily relevant, but the granularity with which nodes shall be allocated
is known.

Cc: Andi Kleen <ak@suse.de>
Signed-off-by: David Rientjes <rientjes@google.com>
Cc: Paul Jackson <pj@sgi.com>
Cc: Christoph Lameter <clameter@engr.sgi.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/x86_64/boot-options.txt |    4 +++-
 arch/x86_64/mm/numa.c                 |   22 ++++++++++++++++++----
 2 files changed, 21 insertions(+), 5 deletions(-)

diff -puN Documentation/x86_64/boot-options.txt~x86_64-split-remaining-fake-nodes-equally Documentation/x86_64/boot-options.txt
--- a/Documentation/x86_64/boot-options.txt~x86_64-split-remaining-fake-nodes-equally
+++ a/Documentation/x86_64/boot-options.txt
@@ -155,7 +155,9 @@ NUMA
 		depending on the sizes and coefficients listed.  For example:
 			numa=fake=2*512,1024,4*256
 		gives two 512M nodes, a 1024M node, and four 256M nodes.  The
-		remaining system RAM is allocated to an additional node.
+		remaining system RAM is allocated to an additional node.  If
+		the last character of CMDLINE is a *, the remaining system RAM
+		is instead divided up equally among its coefficient.
 
   numa=hotadd=percent
 		Only allow hotadd memory to preallocate page structures upto
diff -puN arch/x86_64/mm/numa.c~x86_64-split-remaining-fake-nodes-equally arch/x86_64/mm/numa.c
--- a/arch/x86_64/mm/numa.c~x86_64-split-remaining-fake-nodes-equally
+++ a/arch/x86_64/mm/numa.c
@@ -418,11 +418,25 @@ static int __init numa_emulation(unsigne
 done:
 	if (!num_nodes)
 		return -1;
-	/* Fill remainder of system RAM with a final node, if appropriate. */
+	/* Fill remainder of system RAM, if appropriate. */
 	if (addr < max_addr) {
-		setup_node_range(num_nodes, nodes, &addr, max_addr - addr,
-				 max_addr);
-		num_nodes++;
+		switch (*(cmdline - 1)) {
+		case '*':
+			/* Split remaining nodes into coeff chunks */
+			if (coeff <= 0)
+				break;
+			num_nodes += split_nodes_equally(nodes, &addr, max_addr,
+							 num_nodes, coeff);
+			break;
+		case ',':
+			/* Do not allocate remaining system RAM */
+			break;
+		default:
+			/* Give one final node */
+			setup_node_range(num_nodes, nodes, &addr,
+					 max_addr - addr, max_addr);
+			num_nodes++;
+		}
 	}
 out:
 	memnode_shift = compute_hash_shift(nodes, num_nodes);
_

Patches currently in -mm which might be from rientjes@google.com are

x86_64-configurable-fake-numa-node-sizes.patch
x86_64-split-remaining-fake-nodes-equally.patch
x86_64-fixed-size-remaining-fake-nodes.patch
x86_64-map-fake-nodes-to-real-nodes.patch
x86_64-disable-alien-cache-for-fake-numa.patch
x86_64-export-physnode-mapping-to-userspace.patch
x86_64-fake-numa-for-cpusets-document.patch
smaps-extract-pmd-walker-from-smaps-code.patch
smaps-add-pages-referenced-count-to-smaps.patch
smaps-add-clear_refs-file-to-clear-reference.patch
smaps-add-clear_refs-file-to-clear-reference-fix.patch
smaps-add-clear_refs-file-to-clear-reference-fix-fix.patch
smaps-add-clear_refs-file-to-clear-reference-docs.patch
