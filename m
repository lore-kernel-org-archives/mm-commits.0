From: akpm@linux-foundation.org
Subject: + mm-remove-remaining-__function__-occurances.patch added to -mm tree
Date: Mon, 03 Mar 2008 00:26:05 -0800
Message-ID: <200803030826.m238Q5lY006664@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:45403 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752796AbYCCI0i (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 3 Mar 2008 03:26:38 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: harvey.harrison@gmail.com


The patch titled
     mm: remove remaining __FUNCTION__ occurences
has been added to the -mm tree.  Its filename is
     mm-remove-remaining-__function__-occurances.patch

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
Subject: mm: remove remaining __FUNCTION__ occurences
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
@@ -862,7 +862,7 @@ static void cache_estimate(unsigned long
 	*left_over = slab_size - nr_objs*buffer_size - mgmt_size;
 }
 
-#define slab_error(cachep, msg) __slab_error(__FUNCTION__, cachep, msg)
+#define slab_error(cachep, msg) __slab_error(__func__, cachep, msg)
 
 static void __slab_error(const char *function, struct kmem_cache *cachep,
 			char *msg)
@@ -2158,7 +2158,7 @@ kmem_cache_create (const char *name, siz
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
@@ -250,7 +250,7 @@ static unsigned long *__init sparse_earl
 	/* Stupid: suppress gcc warning for SPARSEMEM && !NUMA */
 	nid = 0;
 
-	printk(KERN_WARNING "%s: allocation failed\n", __FUNCTION__);
+	printk(KERN_WARNING "%s: allocation failed\n", __func__);
 	return NULL;
 }
 
@@ -280,7 +280,7 @@ struct page __init *sparse_early_mem_map
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
@@ -198,7 +198,7 @@ unsigned long shrink_slab(unsigned long 
 		shrinker->nr += delta;
 		if (shrinker->nr < 0) {
 			printk(KERN_ERR "%s: nr=%ld\n",
-					__FUNCTION__, shrinker->nr);
+					__func__, shrinker->nr);
 			shrinker->nr = max_pass;
 		}
 
@@ -346,7 +346,7 @@ static pageout_t pageout(struct page *pa
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
specialixc-fix-possible-double-unlock.patch
git-x86.patch
git-alsa.patch
agp-fix-shadowed-variable-warning-in-amd-k7-agpc.patch
cifs-remove-global_extern-macro.patch
radeon-fix-integer-as-null-pointer-warnings-in-radeon_memc.patch
git-dvb.patch
git-dlm.patch
git-kvm.patch
pata_amd-fix-sparse-warning.patch
jffs2-include-function-prototype-for-jffs2_ioctl.patch
jffs2-fix-sparse-warning-in-nodemgmtc.patch
jffs2-fix-sparse-warning-in-writec.patch
jffs2-fix-sparse-warnings-in-gcc.patch
git-ubi.patch
git-nfsd.patch
block-fix-shadowed-variable-warning-in-blk-mapc.patch
block-remove-extern-on-function-definition.patch
kernel-add-clamp-and-clamp_t-macros.patch
kernel-add-clamp-and-clamp_t-macros-checkpatch-fixes.patch
kernel-add-clamp-and-clamp_t-macros-fix.patch
remove-sparse-warning-for-mmzoneh.patch
remove-sparse-warning-for-mmzoneh-checkpatch-fixes.patch
smack-fix-integer-as-null-pointer-warning-in-smack_lsmc.patch
adfs-work-around-bogus-sparse-warning.patch
coda-add-static-to-functions-in-dirc.patch
befs-fix-sparse-warning-in-linuxvfsc.patch
autofs4-fix-sparse-warning-in-rootc.patch
ncpfs-add-prototypes-to-ncp_fsh.patch
ncpfs-fix-sparse-warnings-in-ioctlc.patch
ncpfs-fix-sparse-warning-in-ncpsign_kernelc.patch
serial-remove-double-initializer.patch
char-make-functions-static-in-synclinkmpc.patch
kprobes-introduce-kprobe_handle_fault.patch
kprobes-introduce-kprobe_handle_fault-ia64-fix.patch
capi-fix-sparse-warnings-using-integer-as-null-pointer.patch
avm-fix-sparse-warning-using-integer-as-null-pointer.patch
eicon-fix-sparse-integer-as-null-pointer-warnings.patch
xen-make-blkif_getgeo-static.patch
fbcon-replace-mono_col-macro-with-static-inline.patch
fbcon-replace-mono_col-macro-with-static-inline-fix.patch
md-fix-integer-as-null-pointer-warnings-in-mdc.patch
jbd-sparse-warnings-in-revokec-journalc.patch
udf-fix-sparse-warning-in-nameic.patch
reiserfs-fix-sparse-warnings-in-fix_nodec.patch
reiserfs-fix-sparse-warnings-in-do_balanc.patch
reiserfs-fix-sparse-warning-in-nameic.patch
reiserfs-fix-sparse-warnings-in-lbalancec.patch
reiserfs-fix-sparse-warning-in-journalc.patch
reiserfs-fix-more-sparse-warnings-in-do_balanc.patch
cgroup-fix-sparse-warning-of-shadow-symbol-in-cgroupc.patch
char-fix-sparse-shadowed-variable-warnings-in-espc.patch
char-espc-fix-possible-double-unlock.patch
char-rocketc-fix-sparse-variable-shadowing-and-int-as-null-pointer.patch
cycladesc-fix-sparse-shadowed-variable-warnings.patch
epcac-static-functions-and-integer-as-null-pointer-fixes.patch
epcac-static-functions-and-integer-as-null-pointer-fixes-checkpatch-fixes.patch
mm-remove-remaining-__function__-occurances.patch
block-remove-remaining-__function__-occurances.patch
kernel-replace-remaining-__function__-occurances.patch
lib-replace-remaining-__function__-occurances.patch

