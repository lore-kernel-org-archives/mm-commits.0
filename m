From: akpm@linux-foundation.org
Subject: + x86_64-fixed-size-remaining-fake-nodes.patch added to -mm tree
Date: Thu, 01 Mar 2007 17:03:35 -0800
Message-ID: <200703020103.l2213Z9S028218@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:33149 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932696AbXCBBDq (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Thu, 1 Mar 2007 20:03:46 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: rientjes@google.com, ak@suse.de, clameter@engr.sgi.com, pj@sgi.com


The patch titled
     x86_64: fixed size remaining fake nodes
has been added to the -mm tree.  Its filename is
     x86_64-fixed-size-remaining-fake-nodes.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: x86_64: fixed size remaining fake nodes
From: David Rientjes <rientjes@google.com>

Extends the numa=fake x86_64 command-line option to split the remaining system
memory into nodes of fixed size.  Any leftover memory is allocated to a final
node unless the command-line ends with a comma.

For example:
  numa=fake=2*512,*128	gives two 512M nodes and the remaining system
			memory is split into nodes of 128M each.

This is beneficial for systems where the exact size of RAM is unknown or not
necessarily relevant, but the size of the remaining nodes to be allocated is
known based on their capacity for resource management.

Cc: Andi Kleen <ak@suse.de>
Signed-off-by: David Rientjes <rientjes@google.com>
Cc: Paul Jackson <pj@sgi.com>
Cc: Christoph Lameter <clameter@engr.sgi.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/x86_64/boot-options.txt |   14 ++++---
 arch/x86_64/mm/numa.c                 |   47 ++++++++++++++++++------
 2 files changed, 46 insertions(+), 15 deletions(-)

diff -puN Documentation/x86_64/boot-options.txt~x86_64-fixed-size-remaining-fake-nodes Documentation/x86_64/boot-options.txt
--- a/Documentation/x86_64/boot-options.txt~x86_64-fixed-size-remaining-fake-nodes
+++ a/Documentation/x86_64/boot-options.txt
@@ -153,11 +153,15 @@ NUMA
 		If a number, fakes CMDLINE nodes and ignores NUMA setup of the
 		actual machine.  Otherwise, system memory is configured
 		depending on the sizes and coefficients listed.  For example:
-			numa=fake=2*512,1024,4*256
-		gives two 512M nodes, a 1024M node, and four 256M nodes.  The
-		remaining system RAM is allocated to an additional node.  If
-		the last character of CMDLINE is a *, the remaining system RAM
-		is instead divided up equally among its coefficient.
+			numa=fake=2*512,1024,4*256,*128
+		gives two 512M nodes, a 1024M node, four 256M nodes, and the
+		rest split into 128M chunks.  If the last character of CMDLINE
+		is a *, the remaining memory is divided up equally among its
+		coefficient:
+			numa=fake=2*512,2*
+		gives two 512M nodes and the rest split into two nodes.
+		Otherwise, the remaining system RAM is allocated to an
+		additional node.
 
   numa=hotadd=percent
 		Only allow hotadd memory to preallocate page structures upto
diff -puN arch/x86_64/mm/numa.c~x86_64-fixed-size-remaining-fake-nodes arch/x86_64/mm/numa.c
--- a/arch/x86_64/mm/numa.c~x86_64-fixed-size-remaining-fake-nodes
+++ a/arch/x86_64/mm/numa.c
@@ -362,6 +362,21 @@ static int __init split_nodes_equally(st
 }
 
 /*
+ * Splits the remaining system RAM into chunks of size.  The remaining memory is
+ * always assigned to a final node and can be asymmetric.  Returns the number of
+ * nodes split.
+ */
+static int __init split_nodes_by_size(struct bootnode *nodes, u64 *addr,
+				      u64 max_addr, int node_start, u64 size)
+{
+	int i = node_start;
+	size = (size << 20) & FAKE_NODE_MIN_HASH_MASK;
+	while (!setup_node_range(i++, nodes, addr, size, max_addr))
+		;
+	return i - node_start;
+}
+
+/*
  * Sets up the system RAM area from start_pfn to end_pfn according to the
  * numa=fake command-line option.
  */
@@ -370,9 +385,10 @@ static int __init numa_emulation(unsigne
 	struct bootnode nodes[MAX_NUMNODES];
 	u64 addr = start_pfn << PAGE_SHIFT;
 	u64 max_addr = end_pfn << PAGE_SHIFT;
-	unsigned int coeff;
-	unsigned int num = 0;
 	int num_nodes = 0;
+	int coeff_flag;
+	int coeff = -1;
+	int num = 0;
 	u64 size;
 	int i;
 
@@ -390,29 +406,34 @@ static int __init numa_emulation(unsigne
 	}
 
 	/* Parse the command line. */
-	for (coeff = 1; ; cmdline++) {
+	for (coeff_flag = 0; ; cmdline++) {
 		if (*cmdline && isdigit(*cmdline)) {
 			num = num * 10 + *cmdline - '0';
 			continue;
 		}
-		if (*cmdline == '*')
-			coeff = num;
+		if (*cmdline == '*') {
+			if (num > 0)
+				coeff = num;
+			coeff_flag = 1;
+		}
 		if (!*cmdline || *cmdline == ',') {
+			if (!coeff_flag)
+				coeff = 1;
 			/*
 			 * Round down to the nearest FAKE_NODE_MIN_SIZE.
 			 * Command-line coefficients are in megabytes.
 			 */
 			size = ((u64)num << 20) & FAKE_NODE_MIN_HASH_MASK;
-			if (size) {
+			if (size)
 				for (i = 0; i < coeff; i++, num_nodes++)
 					if (setup_node_range(num_nodes, nodes,
 						&addr, size, max_addr) < 0)
 						goto done;
-				coeff = 1;
-			}
+			if (!*cmdline)
+				break;
+			coeff_flag = 0;
+			coeff = -1;
 		}
-		if (!*cmdline)
-			break;
 		num = 0;
 	}
 done:
@@ -420,6 +441,12 @@ done:
 		return -1;
 	/* Fill remainder of system RAM, if appropriate. */
 	if (addr < max_addr) {
+		if (coeff_flag && coeff < 0) {
+			/* Split remaining nodes into num-sized chunks */
+			num_nodes += split_nodes_by_size(nodes, &addr, max_addr,
+							 num_nodes, num);
+			goto out;
+		}
 		switch (*(cmdline - 1)) {
 		case '*':
 			/* Split remaining nodes into coeff chunks */
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
