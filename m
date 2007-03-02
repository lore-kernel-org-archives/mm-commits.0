From: akpm@linux-foundation.org
Subject: + x86_64-disable-alien-cache-for-fake-numa.patch added to -mm tree
Date: Thu, 01 Mar 2007 17:03:39 -0800
Message-ID: <200703020103.l2213dM5028224@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:33153 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932690AbXCBBDt (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Thu, 1 Mar 2007 20:03:49 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: rientjes@google.com, ak@suse.de, clameter@engr.sgi.com, menage@google.com, pj@sgi.com


The patch titled
     x86_64: disable alien cache for fake numa
has been added to the -mm tree.  Its filename is
     x86_64-disable-alien-cache-for-fake-numa.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: x86_64: disable alien cache for fake numa
From: David Rientjes <rientjes@google.com>

Disables using alien cache for slab when NUMA emulation is being used.

Cc: Andi Kleen <ak@suse.de>
Signed-off-by: Paul Menage <menage@google.com>
Signed-off-by: David Rientjes <rientjes@google.com>
Cc: Paul Jackson <pj@sgi.com>
Cc: Christoph Lameter <clameter@engr.sgi.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/x86_64/mm/numa.c |    2 ++
 mm/slab.c             |    2 +-
 2 files changed, 3 insertions(+), 1 deletion(-)

diff -puN arch/x86_64/mm/numa.c~x86_64-disable-alien-cache-for-fake-numa arch/x86_64/mm/numa.c
--- a/arch/x86_64/mm/numa.c~x86_64-disable-alien-cache-for-fake-numa
+++ a/arch/x86_64/mm/numa.c
@@ -277,6 +277,7 @@ void __init numa_init_array(void)
 	PAGE_SHIFT)
 
 static struct bootnode physical_node_map[MAX_NUMNODES];
+extern int use_alien_caches;
 char *cmdline __initdata;
 int numa_emu;
 
@@ -509,6 +510,7 @@ out:
 						nodes[i].end >> PAGE_SHIFT);
  		setup_node_bootmem(i, nodes[i].start, nodes[i].end);
 	}
+	use_alien_caches = 0;
  	numa_init_array();
  	return 0;
 }
diff -puN mm/slab.c~x86_64-disable-alien-cache-for-fake-numa mm/slab.c
--- a/mm/slab.c~x86_64-disable-alien-cache-for-fake-numa
+++ a/mm/slab.c
@@ -889,7 +889,7 @@ static void __slab_error(const char *fun
  * line
   */
 
-static int use_alien_caches __read_mostly = 1;
+int use_alien_caches __read_mostly = 1;
 static int __init noaliencache_setup(char *s)
 {
 	use_alien_caches = 0;
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
