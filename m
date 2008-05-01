From: akpm@linux-foundation.org
Subject: - mm-remove-remaining-__function__-occurances.patch removed from -mm tree
Date: Thu, 01 May 2008 02:33:07 -0700
Message-ID: <200805010933.m419X71b031112@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:40941 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753811AbYEAJdJ (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 1 May 2008 05:33:09 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: harvey.harrison@gmail.com, mm-commits@vger.kernel.org


The patch titled
     mm: remove remaining __FUNCTION__ occurrences
has been removed from the -mm tree.  Its filename was
     mm-remove-remaining-__function__-occurances.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: mm: remove remaining __FUNCTION__ occurrences
From: Harvey Harrison <harvey.harrison@gmail.com>

__FUNCTION__ is gcc-specific, use __func__

Signed-off-by: Harvey Harrison <harvey.harrison@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/slab.c   |    4 ++--
 mm/sparse.c |    4 ++--
 mm/vmscan.c |    4 ++--
 3 files changed, 6 insertions(+), 6 deletions(-)

diff -puN mm/slab.c~mm-remove-remaining-__function__-occurances mm/slab.c
--- a/mm/slab.c~mm-remove-remaining-__function__-occurances
+++ a/mm/slab.c
@@ -861,7 +861,7 @@ static void cache_estimate(unsigned long
 	*left_over = slab_size - nr_objs*buffer_size - mgmt_size;
 }
 
-#define slab_error(cachep, msg) __slab_error(__FUNCTION__, cachep, msg)
+#define slab_error(cachep, msg) __slab_error(__func__, cachep, msg)
 
 static void __slab_error(const char *function, struct kmem_cache *cachep,
 			char *msg)
@@ -2156,7 +2156,7 @@ kmem_cache_create (const char *name, siz
 	 */
 	if (!name || in_interrupt() || (size < BYTES_PER_WORD) ||
 	    size > KMALLOC_MAX_SIZE) {
-		printk(KERN_ERR "%s: Early error in slab %s\n", __FUNCTION__,
+		printk(KERN_ERR "%s: Early error in slab %s\n", __func__,
 				name);
 		BUG();
 	}
diff -puN mm/sparse.c~mm-remove-remaining-__function__-occurances mm/sparse.c
--- a/mm/sparse.c~mm-remove-remaining-__function__-occurances
+++ a/mm/sparse.c
@@ -272,7 +272,7 @@ static unsigned long *__init sparse_earl
 	/* Stupid: suppress gcc warning for SPARSEMEM && !NUMA */
 	nid = 0;
 
-	printk(KERN_WARNING "%s: allocation failed\n", __FUNCTION__);
+	printk(KERN_WARNING "%s: allocation failed\n", __func__);
 	return NULL;
 }
 
@@ -302,7 +302,7 @@ struct page __init *sparse_early_mem_map
 		return map;
 
 	printk(KERN_ERR "%s: sparsemem memory map backing failed "
-			"some memory will not be available.\n", __FUNCTION__);
+			"some memory will not be available.\n", __func__);
 	ms->section_mem_map = 0;
 	return NULL;
 }
diff -puN mm/vmscan.c~mm-remove-remaining-__function__-occurances mm/vmscan.c
--- a/mm/vmscan.c~mm-remove-remaining-__function__-occurances
+++ a/mm/vmscan.c
@@ -191,7 +191,7 @@ unsigned long shrink_slab(unsigned long 
 		shrinker->nr += delta;
 		if (shrinker->nr < 0) {
 			printk(KERN_ERR "%s: nr=%ld\n",
-					__FUNCTION__, shrinker->nr);
+					__func__, shrinker->nr);
 			shrinker->nr = max_pass;
 		}
 
@@ -339,7 +339,7 @@ static pageout_t pageout(struct page *pa
 		if (PagePrivate(page)) {
 			if (try_to_free_buffers(page)) {
 				ClearPageDirty(page);
-				printk("%s: orphaned page\n", __FUNCTION__);
+				printk("%s: orphaned page\n", __func__);
 				return PAGE_CLEAN;
 			}
 		}
_

Patches currently in -mm which might be from harvey.harrison@gmail.com are

origin.patch
frv-unbreak-misalignment-handling-changes.patch
git-acpi.patch
cifs-remove-global_extern-macro.patch
input-replace-remaining-__function__-occurrences.patch
input-make-one-bit-signed-bitfields-unsigned.patch
git-kvm.patch
git-mips.patch
mmc-make-one-bit-signed-bitfields-unsigned.patch
nfs-replace-remaining-__function__-occurrences.patch
parisc-replace-remaining-__function__-occurences.patch
drivers-parisc-replace-remaining-__function__-occurrences.patch
git-sched.patch
scsi-replace-remaining-__function__-occurrences.patch
fusion-replace-remaining-__function__-occurrences.patch
scsi-replace-__inline-with-inline.patch
git-watchdog.patch
mac80211-michaelc-use-kernel-provided-infrastructure.patch
mac80211-introduce-struct-michael_mic_ctx-and-static-helpers.patch
mac80211-tkipc-use-kernel-provided-infrastructure.patch
mac80211-add-const-remove-unused-function-make-one-function-static.patch
mac80211-add-a-struct-to-hold-tkip-context.patch
mac80211-tkipc-use-struct-tkip_ctx-in-phase-1-key-mixing.patch
mac80211-tkipc-use-struct-tkip_ctx-in-phase-2-key-mixing.patch
git-xfs.patch
xtensa-replace-remaining-__function__-occurences.patch
pcmcia-replace-remaining-__function__-occurrences.patch
autofs4-fix-sparse-warning-in-waitqc-autofs4_expire_indirect.patch
ide-eliminate-fit-macro.patch
ata-remove-fit-macro.patch
b43-replace-limit_value-macro-with-clamp_val.patch
b43legacy-replace-limit_value-macro-with-clamp_val.patch
fuse-use-clamp-rather-than-nested-min-max.patch
ide-tape-use-clamp_t-rather-than-nested-min_t-max_t.patch
input-ff-memlessc-use-clamp_val-macro.patch
dccp-ccid2c-ccid3c-use-clamp-clamp_t.patch
block-remove-remaining-__function__-occurances.patch

