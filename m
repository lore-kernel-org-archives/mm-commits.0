From: akpm@linux-foundation.org
Subject: [wrecked] dma-mapping-dma-debug-fix-compiler-warnings-on-ia64.patch removed from -mm tree
Date: Thu, 18 Jun 2009 11:20:12 -0700
Message-ID: <200906181820.n5IIKC6d017725@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:59661 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751920AbZFRSUz (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 18 Jun 2009 14:20:55 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: fujita.tomonori@lab.ntt.co.jp, James.Bottomley@HansenPartnership.com, arnd@arndb.de, davem@davemloft.net, joerg.roedel@amd.com, mingo@elte.hu, tony.luck@intel.com, mm-commits@vger.kernel.org


The patch titled
     dma-mapping: dma-debug: fix compiler warnings on IA64
has been removed from the -mm tree.  Its filename was
     dma-mapping-dma-debug-fix-compiler-warnings-on-ia64.patch

This patch was dropped because other changes were merged, which wrecked this patch

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: dma-mapping: dma-debug: fix compiler warnings on IA64
From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>

Hopefully, we don't need such cast in the future (uses int-ll64.h) but for
now we get the following warnings:

lib/dma-debug.c: In function 'debug_dma_dump_mappings':
lib/dma-debug.c:233: warning: format '%Lx' expects type 'long long unsigned int', but argument 7 has type 'u64'
lib/dma-debug.c:233: warning: format '%Lx' expects type 'long long unsigned int', but argument 8 has type 'u64'
lib/dma-debug.c: In function 'check_unmap':
lib/dma-debug.c:553: warning: format '%016llx' expects type 'long long unsigned int', but argument 6 has type 'u64'
lib/dma-debug.c:553: warning: format '%llu' expects type 'long long unsigned int', but argument 7 has type 'u64'
lib/dma-debug.c:561: warning: format '%016llx' expects type 'long long unsigned int', but argument 6 has type 'u64'
lib/dma-debug.c:561: warning: format '%llu' expects type 'long long unsigned int', but argument 7 has type 'u64'
lib/dma-debug.c:561: warning: format '%llu' expects type 'long long unsigned int', but argument 8 has type 'u64'
lib/dma-debug.c:569: warning: format '%016llx' expects type 'long long unsigned int', but argument 6 has type 'u64'
lib/dma-debug.c:569: warning: format '%llu' expects type 'long long unsigned int', but argument 7 has type 'u64'
lib/dma-debug.c:577: warning: format '%016llx' expects type 'long long unsigned int', but argument 6 has type 'u64'
lib/dma-debug.c:577: warning: format '%llu' expects type 'long long unsigned int', but argument 7 has type 'u64'
lib/dma-debug.c:598: warning: format '%016llx' expects type 'long long unsigned int', but argument 6 has type 'u64'
lib/dma-debug.c:598: warning: format '%llu' expects type 'long long unsigned int', but argument 7 has type 'u64'
lib/dma-debug.c: In function 'check_for_illegal_area':
lib/dma-debug.c:634: warning: format '%llu' expects type 'long long unsigned int', but argument 7 has type 'u64'
lib/dma-debug.c: In function 'check_sync':
lib/dma-debug.c:657: warning: format '%llu' expects type 'long long unsigned int', but argument 7 has type 'u64'
lib/dma-debug.c:665: warning: format '%016llx' expects type 'long long unsigned int', but argument 6 has type 'u64'
lib/dma-debug.c:665: warning: format '%llu' expects type 'long long unsigned int', but argument 7 has type 'u64'
lib/dma-debug.c:665: warning: format '%llu' expects type 'long long unsigned int', but argument 8 has type 'u64'
lib/dma-debug.c:665: warning: format '%llu' expects type 'long long unsigned int', but argument 9 has type 'u64'
lib/dma-debug.c:674: warning: format '%llu' expects type 'long long unsigned int', but argument 7 has type 'u64'
lib/dma-debug.c:688: warning: format '%llu' expects type 'long long unsigned int', but argument 7 has type 'u64'
lib/dma-debug.c:698: warning: format '%llu' expects type 'long long unsigned int', but argument 7 has type 'u64'

Signed-off-by: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Acked-by: Joerg Roedel <joerg.roedel@amd.com>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: "Luck, Tony" <tony.luck@intel.com>
Cc: Arnd Bergmann <arnd@arndb.de>
Cc: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc; "David S. Miller" <davem@davemloft.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/dma-debug.c |   82 ++++++++++++++++++++++++++--------------------
 1 file changed, 48 insertions(+), 34 deletions(-)

diff -puN lib/dma-debug.c~dma-mapping-dma-debug-fix-compiler-warnings-on-ia64 lib/dma-debug.c
--- a/lib/dma-debug.c~dma-mapping-dma-debug-fix-compiler-warnings-on-ia64
+++ a/lib/dma-debug.c
@@ -234,7 +234,8 @@ void debug_dma_dump_mappings(struct devi
 					 "%s idx %d P=%Lx D=%Lx L=%Lx %s\n",
 					 type2name[entry->type], idx,
 					 (unsigned long long)entry->paddr,
-					 entry->dev_addr, entry->size,
+					 (unsigned long long)entry->dev_addr,
+					 (unsigned long long)entry->size,
 					 dir2name[entry->direction]);
 			}
 		}
@@ -553,7 +554,8 @@ static void check_unmap(struct dma_debug
 		err_printk(ref->dev, NULL, "DMA-API: device driver tries "
 			   "to free DMA memory it has not allocated "
 			   "[device address=0x%016llx] [size=%llu bytes]\n",
-			   ref->dev_addr, ref->size);
+			   (unsigned long long)ref->dev_addr,
+			   (unsigned long long)ref->size);
 		goto out;
 	}
 
@@ -562,7 +564,9 @@ static void check_unmap(struct dma_debug
 			   "DMA memory with different size "
 			   "[device address=0x%016llx] [map size=%llu bytes] "
 			   "[unmap size=%llu bytes]\n",
-			   ref->dev_addr, entry->size, ref->size);
+			   (unsigned long long)ref->dev_addr,
+			   (unsigned long long)entry->size,
+			   (unsigned long long)ref->size);
 	}
 
 	if (ref->type != entry->type) {
@@ -570,7 +574,8 @@ static void check_unmap(struct dma_debug
 			   "DMA memory with wrong function "
 			   "[device address=0x%016llx] [size=%llu bytes] "
 			   "[mapped as %s] [unmapped as %s]\n",
-			   ref->dev_addr, ref->size,
+			   (unsigned long long)ref->dev_addr,
+			   (unsigned long long)ref->size,
 			   type2name[entry->type], type2name[ref->type]);
 	} else if ((entry->type == dma_debug_coherent) &&
 		   (ref->paddr != entry->paddr)) {
@@ -578,7 +583,8 @@ static void check_unmap(struct dma_debug
 			   "DMA memory with different CPU address "
 			   "[device address=0x%016llx] [size=%llu bytes] "
 			   "[cpu alloc address=%p] [cpu free address=%p]",
-			   ref->dev_addr, ref->size,
+			   (unsigned long long)ref->dev_addr,
+			   (unsigned long long)ref->size,
 			   (void *)entry->paddr, (void *)ref->paddr);
 	}
 
@@ -599,7 +605,8 @@ static void check_unmap(struct dma_debug
 			   "DMA memory with different direction "
 			   "[device address=0x%016llx] [size=%llu bytes] "
 			   "[mapped with %s] [unmapped with %s]\n",
-			   ref->dev_addr, ref->size,
+			   (unsigned long long)ref->dev_addr,
+			   (unsigned long long)ref->size,
 			   dir2name[entry->direction],
 			   dir2name[ref->direction]);
 	}
@@ -632,8 +639,9 @@ static void check_for_illegal_area(struc
 	if (overlap(addr, size, _text, _etext) ||
 	    overlap(addr, size, __start_rodata, __end_rodata))
 		err_printk(dev, NULL, "DMA-API: device driver maps "
-				"memory from kernel text or rodata "
-				"[addr=%p] [size=%llu]\n", addr, size);
+			   "memory from kernel text or rodata "
+			   "[addr=%p] [size=%llu]\n", addr,
+			   (unsigned long long)size);
 }
 
 static void check_sync(struct device *dev, dma_addr_t addr,
@@ -655,29 +663,33 @@ static void check_sync(struct device *de
 
 	if (!entry) {
 		err_printk(dev, NULL, "DMA-API: device driver tries "
-				"to sync DMA memory it has not allocated "
-				"[device address=0x%016llx] [size=%llu bytes]\n",
-				(unsigned long long)addr, size);
+			   "to sync DMA memory it has not allocated "
+			   "[device address=0x%016llx] [size=%llu bytes]\n",
+			   (unsigned long long)addr, (unsigned long long)size);
 		goto out;
 	}
 
 	if ((offset + size) > entry->size) {
 		err_printk(dev, entry, "DMA-API: device driver syncs"
-				" DMA memory outside allocated range "
-				"[device address=0x%016llx] "
-				"[allocation size=%llu bytes] [sync offset=%llu] "
-				"[sync size=%llu]\n", entry->dev_addr, entry->size,
-				offset, size);
+			   " DMA memory outside allocated range "
+			   "[device address=0x%016llx] "
+			   "[allocation size=%llu bytes] [sync offset=%llu] "
+			   "[sync size=%llu]\n",
+			   (unsigned long long)entry->dev_addr,
+			   (unsigned long long)entry->size,
+			   (unsigned long long)offset,
+			   (unsigned long long)size);
 	}
 
 	if (direction != entry->direction) {
 		err_printk(dev, entry, "DMA-API: device driver syncs "
-				"DMA memory with different direction "
-				"[device address=0x%016llx] [size=%llu bytes] "
-				"[mapped with %s] [synced with %s]\n",
-				(unsigned long long)addr, entry->size,
-				dir2name[entry->direction],
-				dir2name[direction]);
+			   "DMA memory with different direction "
+			   "[device address=0x%016llx] [size=%llu bytes] "
+			   "[mapped with %s] [synced with %s]\n",
+			   (unsigned long long)addr,
+			   (unsigned long long)entry->size,
+			   dir2name[entry->direction],
+			   dir2name[direction]);
 	}
 
 	if (entry->direction == DMA_BIDIRECTIONAL)
@@ -686,22 +698,24 @@ static void check_sync(struct device *de
 	if (to_cpu && !(entry->direction == DMA_FROM_DEVICE) &&
 		      !(direction == DMA_TO_DEVICE))
 		err_printk(dev, entry, "DMA-API: device driver syncs "
-				"device read-only DMA memory for cpu "
-				"[device address=0x%016llx] [size=%llu bytes] "
-				"[mapped with %s] [synced with %s]\n",
-				(unsigned long long)addr, entry->size,
-				dir2name[entry->direction],
-				dir2name[direction]);
+			   "device read-only DMA memory for cpu "
+			   "[device address=0x%016llx] [size=%llu bytes] "
+			   "[mapped with %s] [synced with %s]\n",
+			   (unsigned long long)addr,
+			   (unsigned long long)entry->size,
+			   dir2name[entry->direction],
+			   dir2name[direction]);
 
 	if (!to_cpu && !(entry->direction == DMA_TO_DEVICE) &&
 		       !(direction == DMA_FROM_DEVICE))
 		err_printk(dev, entry, "DMA-API: device driver syncs "
-				"device write-only DMA memory to device "
-				"[device address=0x%016llx] [size=%llu bytes] "
-				"[mapped with %s] [synced with %s]\n",
-				(unsigned long long)addr, entry->size,
-				dir2name[entry->direction],
-				dir2name[direction]);
+			   "device write-only DMA memory to device "
+			   "[device address=0x%016llx] [size=%llu bytes] "
+			   "[mapped with %s] [synced with %s]\n",
+			   (unsigned long long)addr,
+			   (unsigned long long)entry->size,
+			   dir2name[entry->direction],
+			   dir2name[direction]);
 
 out:
 	put_hash_bucket(bucket, &flags);
_

Patches currently in -mm which might be from fujita.tomonori@lab.ntt.co.jp are

origin.patch
dma-mapping-add-asm-generic-dma-mapping-commonh.patch
dma-mapping-x86-use-asm-generic-dma-mapping-commonh.patch
dma-mapping-ia64-use-asm-generic-dma-mapping-commonh.patch
dma-mapping-ia64-add-config_dma_api_debug-support.patch
linux-next.patch
ib-mthca-replace-dma_sync_single-with-dma_sync_single_for_cpu.patch
dma-mapping-mark-dma_nbits_mask-as-deprecated.patch
dma-mapping-mark-dma_sync_single-and-dma_sync_sg-as-deprecated.patch
dma-mapping-dma-debug-fix-compiler-warnings-on-ia64.patch

