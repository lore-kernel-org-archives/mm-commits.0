Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C731CCD68E0
	for <mm-commits@archiver.kernel.org>; Tue, 10 Oct 2023 00:52:23 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1379273AbjJJAwW (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 9 Oct 2023 20:52:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41442 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1379287AbjJJAwO (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 9 Oct 2023 20:52:14 -0400
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EA4B0181
        for <mm-commits@vger.kernel.org>; Mon,  9 Oct 2023 17:52:02 -0700 (PDT)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 119ACC433C7;
        Tue, 10 Oct 2023 00:52:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1696899122;
        bh=kP7PwiXyBC2yIaI5Bf7FiAHkgdjH3Qdh1PV1JLHozSM=;
        h=Date:To:From:Subject:From;
        b=Fbm/io8sppl8KQc7n1KOJmvB+F+lX9v+3zEJ7Rp7+irHr0xxZCQuL3BE2EP282rY7
         d1YDRVGYIrlAf7VJoHE/2AIU3qYat8vKpkk63ueRBs+r0QWO5BoExXQ4mmDVh5UA5U
         39WBxeHjS6ZiIHs51gNg+tyPJ+zMaFetpQ8Mq3Co=
Date:   Mon, 09 Oct 2023 17:51:51 -0700
To:     mm-commits@vger.kernel.org, willy@infradead.org,
        viro@zeniv.linux.org.uk, muchun.song@linux.dev,
        mike.kravetz@oracle.com, luto@kernel.org, jack@suse.cz,
        hughd@google.com, brauner@kernel.org, lstoakes@gmail.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-drop-the-assumption-that-vm_shared-always-implies-writable.patch added to mm-unstable branch
Message-Id: <20231010005201.119ACC433C7@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm: drop the assumption that VM_SHARED always implies writable
has been added to the -mm mm-unstable branch.  Its filename is
     mm-drop-the-assumption-that-vm_shared-always-implies-writable.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-drop-the-assumption-that-vm_shared-always-implies-writable.patch

This patch will later appear in the mm-unstable branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next via the mm-everything
branch at git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
and is updated there every 2-3 working days

------------------------------------------------------
From: Lorenzo Stoakes <lstoakes@gmail.com>
Subject: mm: drop the assumption that VM_SHARED always implies writable
Date: Sat, 7 Oct 2023 21:50:59 +0100

Patch series "permit write-sealed memfd read-only shared mappings", v3.

The man page for fcntl() describing memfd file seals states the following
about F_SEAL_WRITE:-

    Furthermore, trying to create new shared, writable memory-mappings via
    mmap(2) will also fail with EPERM.

With emphasis on 'writable'.  In turns out in fact that currently the
kernel simply disallows all new shared memory mappings for a memfd with
F_SEAL_WRITE applied, rendering this documentation inaccurate.

This matters because users are therefore unable to obtain a shared mapping
to a memfd after write sealing altogether, which limits their usefulness. 
This was reported in the discussion thread [1] originating from a bug
report [2].

This is a product of both using the struct address_space->i_mmap_writable
atomic counter to determine whether writing may be permitted, and the
kernel adjusting this counter when any VM_SHARED mapping is performed and
more generally implicitly assuming VM_SHARED implies writable.

It seems sensible that we should only update this mapping if VM_MAYWRITE
is specified, i.e.  whether it is possible that this mapping could at any
point be written to.

If we do so then all we need to do to permit write seals to function as
documented is to clear VM_MAYWRITE when mapping read-only.  It turns out
this functionality already exists for F_SEAL_FUTURE_WRITE - we can
therefore simply adapt this logic to do the same for F_SEAL_WRITE.

We then hit a chicken and egg situation in mmap_region() where the check
for VM_MAYWRITE occurs before we are able to clear this flag.  To work
around this, separate the check and its enforcement across call_mmap() -
allowing for this function to clear VM_MAYWRITE.

Thanks to Andy Lutomirski for the suggestion!

[1]:https://lore.kernel.org/all/20230324133646.16101dfa666f253c4715d965@linux-foundation.org/
[2]:https://bugzilla.kernel.org/show_bug.cgi?id=217238


This patch (of 3):

There is a general assumption that VMAs with the VM_SHARED flag set are
writable.  If the VM_MAYWRITE flag is not set, then this is simply not the
case.

Update those checks which affect the struct address_space->i_mmap_writable
field to explicitly test for this by introducing
[vma_]is_shared_maywrite() helper functions.

This remains entirely conservative, as the lack of VM_MAYWRITE guarantees
that the VMA cannot be written to.

Link: https://lkml.kernel.org/r/cover.1696709413.git.lstoakes@gmail.com
Link: https://lkml.kernel.org/r/e1bcbcba7ffbe421bbd262029a3a59178b52e3c5.1696709413.git.lstoakes@gmail.com
Signed-off-by: Lorenzo Stoakes <lstoakes@gmail.com>
Suggested-by: Andy Lutomirski <luto@kernel.org>
Cc: Alexander Viro <viro@zeniv.linux.org.uk>
Cc: Christian Brauner <brauner@kernel.org>
Cc: Hugh Dickins <hughd@google.com>
Cc: Jan Kara <jack@suse.cz>
Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: Mike Kravetz <mike.kravetz@oracle.com>
Cc: Muchun Song <muchun.song@linux.dev>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/fs.h |    4 ++--
 include/linux/mm.h |   11 +++++++++++
 kernel/fork.c      |    2 +-
 mm/filemap.c       |    2 +-
 mm/madvise.c       |    2 +-
 mm/mmap.c          |   12 ++++++------
 6 files changed, 22 insertions(+), 11 deletions(-)

--- a/include/linux/fs.h~mm-drop-the-assumption-that-vm_shared-always-implies-writable
+++ a/include/linux/fs.h
@@ -454,7 +454,7 @@ extern const struct address_space_operat
  *   It is also used to block modification of page cache contents through
  *   memory mappings.
  * @gfp_mask: Memory allocation flags to use for allocating pages.
- * @i_mmap_writable: Number of VM_SHARED mappings.
+ * @i_mmap_writable: Number of VM_SHARED, VM_MAYWRITE mappings.
  * @nr_thps: Number of THPs in the pagecache (non-shmem only).
  * @i_mmap: Tree of private and shared mappings.
  * @i_mmap_rwsem: Protects @i_mmap and @i_mmap_writable.
@@ -557,7 +557,7 @@ static inline int mapping_mapped(struct
 
 /*
  * Might pages of this file have been modified in userspace?
- * Note that i_mmap_writable counts all VM_SHARED vmas: do_mmap
+ * Note that i_mmap_writable counts all VM_SHARED, VM_MAYWRITE vmas: do_mmap
  * marks vma as VM_SHARED if it is shared, and the file was opened for
  * writing i.e. vma may be mprotected writable even if now readonly.
  *
--- a/include/linux/mm.h~mm-drop-the-assumption-that-vm_shared-always-implies-writable
+++ a/include/linux/mm.h
@@ -937,6 +937,17 @@ static inline bool vma_is_accessible(str
 	return vma->vm_flags & VM_ACCESS_FLAGS;
 }
 
+static inline bool is_shared_maywrite(vm_flags_t vm_flags)
+{
+	return (vm_flags & (VM_SHARED | VM_MAYWRITE)) ==
+		(VM_SHARED | VM_MAYWRITE);
+}
+
+static inline bool vma_is_shared_maywrite(struct vm_area_struct *vma)
+{
+	return is_shared_maywrite(vma->vm_flags);
+}
+
 static inline
 struct vm_area_struct *vma_find(struct vma_iterator *vmi, unsigned long max)
 {
--- a/kernel/fork.c~mm-drop-the-assumption-that-vm_shared-always-implies-writable
+++ a/kernel/fork.c
@@ -733,7 +733,7 @@ static __latent_entropy int dup_mmap(str
 
 			get_file(file);
 			i_mmap_lock_write(mapping);
-			if (tmp->vm_flags & VM_SHARED)
+			if (vma_is_shared_maywrite(tmp))
 				mapping_allow_writable(mapping);
 			flush_dcache_mmap_lock(mapping);
 			/* insert tmp into the share list, just after mpnt */
--- a/mm/filemap.c~mm-drop-the-assumption-that-vm_shared-always-implies-writable
+++ a/mm/filemap.c
@@ -3637,7 +3637,7 @@ int generic_file_mmap(struct file *file,
  */
 int generic_file_readonly_mmap(struct file *file, struct vm_area_struct *vma)
 {
-	if ((vma->vm_flags & VM_SHARED) && (vma->vm_flags & VM_MAYWRITE))
+	if (vma_is_shared_maywrite(vma))
 		return -EINVAL;
 	return generic_file_mmap(file, vma);
 }
--- a/mm/madvise.c~mm-drop-the-assumption-that-vm_shared-always-implies-writable
+++ a/mm/madvise.c
@@ -985,7 +985,7 @@ static long madvise_remove(struct vm_are
 			return -EINVAL;
 	}
 
-	if ((vma->vm_flags & (VM_SHARED|VM_WRITE)) != (VM_SHARED|VM_WRITE))
+	if (!vma_is_shared_maywrite(vma))
 		return -EACCES;
 
 	offset = (loff_t)(start - vma->vm_start)
--- a/mm/mmap.c~mm-drop-the-assumption-that-vm_shared-always-implies-writable
+++ a/mm/mmap.c
@@ -107,7 +107,7 @@ void vma_set_page_prot(struct vm_area_st
 static void __remove_shared_vm_struct(struct vm_area_struct *vma,
 		struct file *file, struct address_space *mapping)
 {
-	if (vma->vm_flags & VM_SHARED)
+	if (vma_is_shared_maywrite(vma))
 		mapping_unmap_writable(mapping);
 
 	flush_dcache_mmap_lock(mapping);
@@ -384,7 +384,7 @@ static unsigned long count_vma_pages_ran
 static void __vma_link_file(struct vm_area_struct *vma,
 			    struct address_space *mapping)
 {
-	if (vma->vm_flags & VM_SHARED)
+	if (vma_is_shared_maywrite(vma))
 		mapping_allow_writable(mapping);
 
 	flush_dcache_mmap_lock(mapping);
@@ -2845,7 +2845,7 @@ cannot_expand:
 	vma->vm_pgoff = pgoff;
 
 	if (file) {
-		if (vm_flags & VM_SHARED) {
+		if (is_shared_maywrite(vm_flags)) {
 			error = mapping_map_writable(file->f_mapping);
 			if (error)
 				goto free_vma;
@@ -2919,7 +2919,7 @@ cannot_expand:
 	mm->map_count++;
 	if (vma->vm_file) {
 		i_mmap_lock_write(vma->vm_file->f_mapping);
-		if (vma->vm_flags & VM_SHARED)
+		if (vma_is_shared_maywrite(vma))
 			mapping_allow_writable(vma->vm_file->f_mapping);
 
 		flush_dcache_mmap_lock(vma->vm_file->f_mapping);
@@ -2936,7 +2936,7 @@ cannot_expand:
 
 	/* Once vma denies write, undo our temporary denial count */
 unmap_writable:
-	if (file && vm_flags & VM_SHARED)
+	if (file && is_shared_maywrite(vm_flags))
 		mapping_unmap_writable(file->f_mapping);
 	file = vma->vm_file;
 	ksm_add_vma(vma);
@@ -2984,7 +2984,7 @@ unmap_and_free_vma:
 		unmap_region(mm, &vmi.mas, vma, prev, next, vma->vm_start,
 			     vma->vm_end, vma->vm_end, true);
 	}
-	if (file && (vm_flags & VM_SHARED))
+	if (file && is_shared_maywrite(vm_flags))
 		mapping_unmap_writable(file->f_mapping);
 free_vma:
 	vm_area_free(vma);
_

Patches currently in -mm which might be from lstoakes@gmail.com are

mm-filemap-clarify-filemap_fault-comments-for-not-uptodate-case.patch
mm-filemap-clarify-filemap_fault-comments-for-not-uptodate-case-fix.patch
mm-make-__access_remote_vm-static.patch
mm-gup-explicitly-define-and-check-internal-gup-flags-disallow-foll_touch.patch
mm-gup-make-failure-to-pin-an-error-if-foll_nowait-not-specified.patch
mm-gup-adapt-get_user_page_vma_remote-to-never-return-null.patch
mm-move-vma_policy-and-anon_vma_name-decls-to-mm_typesh.patch
mm-abstract-the-vma_merge-split_vma-pattern-for-mprotect-et-al.patch
mm-make-vma_merge-and-split_vma-internal.patch
mm-abstract-merge-for-new-vmas-into-vma_merge_new_vma.patch
mm-abstract-vma-merge-and-extend-into-vma_merge_extend-helper.patch
mm-drop-the-assumption-that-vm_shared-always-implies-writable.patch
mm-update-memfd-seal-write-check-to-include-f_seal_write.patch
mm-enforce-the-mapping_map_writable-check-after-call_mmap.patch

