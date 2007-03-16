From: akpm@linux-foundation.org
Subject: + revoke-core-code-fix-shared-mapping-revoke.patch added to -mm tree
Date: Fri, 16 Mar 2007 03:28:32 -0800
Message-ID: <200703161128.l2GBSWTX009957@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:41790 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753489AbXCPL2i (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Fri, 16 Mar 2007 07:28:38 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: penberg@cs.helsinki.fi, akpm@linux-foundation.org


The patch titled
     revoke: fix shared mapping revoke
has been added to the -mm tree.  Its filename is
     revoke-core-code-fix-shared-mapping-revoke.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: revoke: fix shared mapping revoke
From: Pekka Enberg <penberg@cs.helsinki.fi>

On 3/16/07, Andrew Morton <akpm@linux-foundation.org> wrote:
> This all looks very strange.  If the calling process expires its timeslice,
> the entire system call fails?

This changes revoke_mapping() to restart after cond_resched() to fix an
obvious goof made by me.

Signed-off-by: Pekka Enberg <penberg@cs.helsinki.fi>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/revoke.c |   49 ++++++++++++++++++++++++++++++-------------------
 1 file changed, 30 insertions(+), 19 deletions(-)

diff -puN fs/revoke.c~revoke-core-code-fix-shared-mapping-revoke fs/revoke.c
--- a/fs/revoke.c~revoke-core-code-fix-shared-mapping-revoke
+++ a/fs/revoke.c
@@ -194,34 +194,49 @@ static int revoke_vma(struct vm_area_str
 	return -EINTR;
 }
 
-static int revoke_mapping(struct address_space *mapping, struct file *to_exclude)
+static void revoke_mapping_tree(struct address_space *mapping,
+				struct file *to_exclude,
+				struct zap_details *details)
 {
 	struct vm_area_struct *vma;
 	struct prio_tree_iter iter;
-	struct zap_details details;
-	int err = 0;
-
-	details.i_mmap_lock = &mapping->i_mmap_lock;
 
-	spin_lock(&mapping->i_mmap_lock);
+  restart:
 	vma_prio_tree_foreach(vma, &iter, &mapping->i_mmap, 0, ULONG_MAX) {
 		if ((vma->vm_flags & VM_SHARED) && vma->vm_file != to_exclude) {
-			err = revoke_vma(vma, &details);
-			if (err)
-				goto out;
+			if (revoke_vma(vma, details))
+				goto restart;
 		}
 	}
+}
 
+static void revoke_mapping_list(struct address_space *mapping,
+				struct file *to_exclude,
+				struct zap_details *details)
+{
+	struct vm_area_struct *vma;
+
+  restart:
 	list_for_each_entry(vma, &mapping->i_mmap_nonlinear, shared.vm_set.list) {
 		if ((vma->vm_flags & VM_SHARED) && vma->vm_file != to_exclude) {
-			err = revoke_vma(vma, &details);
-			if (err)
-				goto out;
+			if (revoke_vma(vma, details))
+				goto restart;
 		}
 	}
-  out:
+}
+
+static void revoke_mapping(struct address_space *mapping, struct file *to_exclude)
+{
+	struct zap_details details;
+
+	details.i_mmap_lock = &mapping->i_mmap_lock;
+
+	spin_lock(&mapping->i_mmap_lock);
+	if (unlikely(!prio_tree_empty(&mapping->i_mmap)))
+		revoke_mapping_tree(mapping, to_exclude, &details);
+	if (unlikely(!list_empty(&mapping->i_mmap_nonlinear)))
+		revoke_mapping_list(mapping, to_exclude, &details);
 	spin_unlock(&mapping->i_mmap_lock);
-	return err;
 }
 
 static void restore_file(struct revokefs_inode_info *info)
@@ -441,11 +456,7 @@ static int do_revoke(struct inode *inode
 	/*
 	 * Take down shared memory mappings.
 	 */
-	err = revoke_mapping(inode->i_mapping, to_exclude);
-	if (err) {
-		restore_files(table);
-		goto out_free_table;
-	}
+	revoke_mapping(inode->i_mapping, to_exclude);
 
 	/*
 	 * Now, revoke the files for good.
_

Patches currently in -mm which might be from penberg@cs.helsinki.fi are

slab-introduce-krealloc.patch
slab-introduce-krealloc-fix.patch
unionfs-fix-slab-abuses-with-krealloc.patch
slab-ensure-cache_alloc_refill-terminates.patch
module-use-krealloc.patch
slab-use-cpu_lock_.patch
revoke-special-mmap-handling.patch
revoke-core-code.patch
revoke-core-code-misc-fixes.patch
revoke-core-code-fix-shared-mapping-revoke.patch
revoke-core-code-move-magic.patch
revoke-support-for-ext2-and-ext3.patch
revoke-add-documentation.patch
revoke-wire-up-i386-system-calls.patch
slab-leaks3-default-y.patch
