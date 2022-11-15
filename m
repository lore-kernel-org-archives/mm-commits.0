Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9F480C4332F
	for <mm-commits@archiver.kernel.org>; Tue, 15 Nov 2022 00:34:14 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232180AbiKOAeM (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 14 Nov 2022 19:34:12 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40510 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230334AbiKOAeL (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 14 Nov 2022 19:34:11 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 60BA8BC1E
        for <mm-commits@vger.kernel.org>; Mon, 14 Nov 2022 16:34:09 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id BD20A614E2
        for <mm-commits@vger.kernel.org>; Tue, 15 Nov 2022 00:34:08 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F20F1C433D7;
        Tue, 15 Nov 2022 00:34:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1668472448;
        bh=Rmr7ccYwrBNNJ1Inq5drnA1VJO4JCZpxOFL0yoVnCXM=;
        h=Date:To:From:Subject:From;
        b=vKe7OB9iJv3PXuso4jUt97QGPUzBG+9B+Rs/Ky43YCs2vOuJgXF4e84uO/HnYEmfW
         OGGvHs+6OnSVjPL97UesOAj+HMgvhi55xbPMdYXyDg5eGYrQuF+24VL1ZuMgaRfAw4
         zNsmh4DYk5CkMehxr5dHCzAutWYWt5eqliHxroSM=
Date:   Mon, 14 Nov 2022 16:34:07 -0800
To:     mm-commits@vger.kernel.org, yuzhao@google.com, willy@infradead.org,
        vincent.whitchurch@axis.com, vbabka@suse.cz, shy828301@gmail.com,
        seanjc@google.com, rppt@kernel.org, peterx@redhat.com,
        paul.gortmaker@windriver.com, liam.howlett@oracle.com,
        kirill@shutemov.name, hughd@google.com, hannes@cmpxchg.org,
        david@redhat.com, corbet@lwn.net, cgel.zte@gmail.com,
        ccross@google.com, bagasdotme@gmail.com, arnd@arndb.de,
        pasha.tatashin@soleen.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [failures] mm-anonymous-shared-memory-naming.patch removed from -mm tree
Message-Id: <20221115003407.F20F1C433D7@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: mm: anonymous shared memory naming
has been removed from the -mm tree.  Its filename was
     mm-anonymous-shared-memory-naming.patch

This patch was dropped because it had testing failures

------------------------------------------------------
From: Pasha Tatashin <pasha.tatashin@soleen.com>
Subject: mm: anonymous shared memory naming
Date: Mon, 7 Nov 2022 18:47:15 +0000

Since commit 9a10064f5625 ("mm: add a field to store names for private
anonymous memory"), name for private anonymous memory, but not shared
anonymous, can be set.  However, naming shared anonymous memory is just
as useful for tracking purposes.

Extend the functionality to be able to set names for shared anon.

Sample output:
  /* Create shared anonymous segment */
  anon_shmem = mmap(NULL, SIZE, PROT_READ | PROT_WRITE,
                    MAP_SHARED | MAP_ANONYMOUS, -1, 0);
  /* Name the segment: "MY-NAME" */
  rv = prctl(PR_SET_VMA, PR_SET_VMA_ANON_NAME,
             anon_shmem, SIZE, "MY-NAME");

cat /proc/<pid>/maps (and smaps):
7fc8e2b4c000-7fc8f2b4c000 rw-s 00000000 00:01 1024 [anon_shmem:MY-NAME]

Link: https://lkml.kernel.org/r/20221107184715.3950621-1-pasha.tatashin@soleen.com
Signed-off-by: Pasha Tatashin <pasha.tatashin@soleen.com>
Cc: Arnd Bergmann <arnd@arndb.de>
Cc: Bagas Sanjaya <bagasdotme@gmail.com>
Cc: Colin Cross <ccross@google.com>
Cc: David Hildenbrand <david@redhat.com>
Cc: Hugh Dickins <hughd@google.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Jonathan Corbet <corbet@lwn.net>
Cc: "Kirill A . Shutemov" <kirill@shutemov.name>
Cc: Liam Howlett <liam.howlett@oracle.com>
Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: Mike Rapoport <rppt@kernel.org>
Cc: Paul Gortmaker <paul.gortmaker@windriver.com>
Cc: Peter Xu <peterx@redhat.com>
Cc: Sean Christopherson <seanjc@google.com>
Cc: Vincent Whitchurch <vincent.whitchurch@axis.com>
Cc: Vlastimil Babka <vbabka@suse.cz>
Cc: xu xin <cgel.zte@gmail.com>
Cc: Yang Shi <shy828301@gmail.com>
Cc: Yu Zhao <yuzhao@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/filesystems/proc.rst |    8 +++++---
 fs/proc/task_mmu.c                 |   14 ++++++++++----
 include/linux/mm.h                 |    2 ++
 include/linux/mm_types.h           |   27 +++++++++++++--------------
 mm/madvise.c                       |    7 ++-----
 mm/shmem.c                         |   20 ++++++++++++++++++--
 6 files changed, 50 insertions(+), 28 deletions(-)

--- a/Documentation/filesystems/proc.rst~mm-anonymous-shared-memory-naming
+++ a/Documentation/filesystems/proc.rst
@@ -426,14 +426,16 @@ with the memory region, as the case woul
 The "pathname" shows the name associated file for this mapping.  If the mapping
 is not associated with a file:
 
- =============              ====================================
+ ===================        ===========================================
  [heap]                     the heap of the program
  [stack]                    the stack of the main process
  [vdso]                     the "virtual dynamic shared object",
                             the kernel system call handler
- [anon:<name>]              an anonymous mapping that has been
+ [anon:<name>]              a private anonymous mapping that has been
                             named by userspace
- =============              ====================================
+ [anon_shmem:<name>]        an anonymous shared memory mapping that has
+                            been named by userspace
+ ===================        ===========================================
 
  or if empty, the mapping is anonymous.
 
--- a/fs/proc/task_mmu.c~mm-anonymous-shared-memory-naming
+++ a/fs/proc/task_mmu.c
@@ -277,6 +277,7 @@ show_map_vma(struct seq_file *m, struct
 	struct mm_struct *mm = vma->vm_mm;
 	struct file *file = vma->vm_file;
 	vm_flags_t flags = vma->vm_flags;
+	struct anon_vma_name *anon_name;
 	unsigned long ino = 0;
 	unsigned long long pgoff = 0;
 	unsigned long start, end;
@@ -293,6 +294,7 @@ show_map_vma(struct seq_file *m, struct
 	start = vma->vm_start;
 	end = vma->vm_end;
 	show_vma_header_prefix(m, start, end, flags, pgoff, dev, ino);
+	anon_name = anon_vma_name(vma);
 
 	/*
 	 * Print the dentry name for named mappings, and a
@@ -300,7 +302,14 @@ show_map_vma(struct seq_file *m, struct
 	 */
 	if (file) {
 		seq_pad(m, ' ');
-		seq_file_path(m, file, "\n");
+		/*
+		 * If user named this anon shared memory via
+		 * prctl(PR_SET_VMA ..., use the provided name.
+		 */
+		if (anon_name)
+			seq_printf(m, "[anon_shmem:%s]", anon_name->name);
+		else
+			seq_file_path(m, file, "\n");
 		goto done;
 	}
 
@@ -312,8 +321,6 @@ show_map_vma(struct seq_file *m, struct
 
 	name = arch_vma_name(vma);
 	if (!name) {
-		struct anon_vma_name *anon_name;
-
 		if (!mm) {
 			name = "[vdso]";
 			goto done;
@@ -330,7 +337,6 @@ show_map_vma(struct seq_file *m, struct
 			goto done;
 		}
 
-		anon_name = anon_vma_name(vma);
 		if (anon_name) {
 			seq_pad(m, ' ');
 			seq_printf(m, "[anon:%s]", anon_name->name);
--- a/include/linux/mm.h~mm-anonymous-shared-memory-naming
+++ a/include/linux/mm.h
@@ -700,8 +700,10 @@ static inline unsigned long vma_iter_add
  * paths in userfault.
  */
 bool vma_is_shmem(struct vm_area_struct *vma);
+bool vma_is_anon_shmem(struct vm_area_struct *vma);
 #else
 static inline bool vma_is_shmem(struct vm_area_struct *vma) { return false; }
+static inline bool vma_is_anon_shmem(struct vm_area_struct *vma) { return false; }
 #endif
 
 int vma_is_stack_for_current(struct vm_area_struct *vma);
--- a/include/linux/mm_types.h~mm-anonymous-shared-memory-naming
+++ a/include/linux/mm_types.h
@@ -517,21 +517,11 @@ struct vm_area_struct {
 	 * For areas with an address space and backing store,
 	 * linkage into the address_space->i_mmap interval tree.
 	 *
-	 * For private anonymous mappings, a pointer to a null terminated string
-	 * containing the name given to the vma, or NULL if unnamed.
 	 */
-
-	union {
-		struct {
-			struct rb_node rb;
-			unsigned long rb_subtree_last;
-		} shared;
-		/*
-		 * Serialized by mmap_sem. Never use directly because it is
-		 * valid only when vm_file is NULL. Use anon_vma_name instead.
-		 */
-		struct anon_vma_name *anon_name;
-	};
+	struct {
+		struct rb_node rb;
+		unsigned long rb_subtree_last;
+	} shared;
 
 	/*
 	 * A file's MAP_PRIVATE vma can be in both i_mmap tree and anon_vma
@@ -541,6 +531,7 @@ struct vm_area_struct {
 	 */
 	struct list_head anon_vma_chain; /* Serialized by mmap_lock &
 					  * page_table_lock */
+
 	struct anon_vma *anon_vma;	/* Serialized by page_table_lock */
 
 	/* Function pointers to deal with this struct. */
@@ -552,6 +543,14 @@ struct vm_area_struct {
 	struct file * vm_file;		/* File we map to (can be NULL). */
 	void * vm_private_data;		/* was vm_pte (shared mem) */
 
+#ifdef CONFIG_ANON_VMA_NAME
+	/*
+	 * For private and shared anonymous mappings, a pointer to a null
+	 * terminated string containing the name given to the vma, or NULL if
+	 * unnamed. Serialized by mmap_sem. Use anon_vma_name to access.
+	 */
+	struct anon_vma_name *anon_name;
+#endif
 #ifdef CONFIG_SWAP
 	atomic_long_t swap_readahead_info;
 #endif
--- a/mm/madvise.c~mm-anonymous-shared-memory-naming
+++ a/mm/madvise.c
@@ -95,9 +95,6 @@ struct anon_vma_name *anon_vma_name(stru
 {
 	mmap_assert_locked(vma->vm_mm);
 
-	if (vma->vm_file)
-		return NULL;
-
 	return vma->anon_name;
 }
 
@@ -183,7 +180,7 @@ success:
 	 * vm_flags is protected by the mmap_lock held in write mode.
 	 */
 	vma->vm_flags = new_flags;
-	if (!vma->vm_file) {
+	if (!vma->vm_file || vma_is_anon_shmem(vma)) {
 		error = replace_anon_vma_name(vma, anon_name);
 		if (error)
 			return error;
@@ -1273,7 +1270,7 @@ static int madvise_vma_anon_name(struct
 	int error;
 
 	/* Only anonymous mappings can be named */
-	if (vma->vm_file)
+	if (vma->vm_file && !vma_is_anon_shmem(vma))
 		return -EBADF;
 
 	error = madvise_update_vma(vma, prev, start, end, vma->vm_flags,
--- a/mm/shmem.c~mm-anonymous-shared-memory-naming
+++ a/mm/shmem.c
@@ -237,11 +237,17 @@ static const struct inode_operations shm
 static const struct inode_operations shmem_dir_inode_operations;
 static const struct inode_operations shmem_special_inode_operations;
 static const struct vm_operations_struct shmem_vm_ops;
+static const struct vm_operations_struct shmem_anon_vm_ops;
 static struct file_system_type shmem_fs_type;
 
+bool vma_is_anon_shmem(struct vm_area_struct *vma)
+{
+	return vma->vm_ops == &shmem_anon_vm_ops;
+}
+
 bool vma_is_shmem(struct vm_area_struct *vma)
 {
-	return vma->vm_ops == &shmem_vm_ops;
+	return vma_is_anon_shmem(vma) || vma->vm_ops == &shmem_vm_ops;
 }
 
 static LIST_HEAD(shmem_swaplist);
@@ -3988,6 +3994,15 @@ static const struct vm_operations_struct
 #endif
 };
 
+static const struct vm_operations_struct shmem_anon_vm_ops = {
+	.fault		= shmem_fault,
+	.map_pages	= filemap_map_pages,
+#ifdef CONFIG_NUMA
+	.set_policy     = shmem_set_policy,
+	.get_policy     = shmem_get_policy,
+#endif
+};
+
 int shmem_init_fs_context(struct fs_context *fc)
 {
 	struct shmem_options *ctx;
@@ -4163,6 +4178,7 @@ void shmem_truncate_range(struct inode *
 EXPORT_SYMBOL_GPL(shmem_truncate_range);
 
 #define shmem_vm_ops				generic_file_vm_ops
+#define shmem_anon_vm_ops			generic_file_vm_ops
 #define shmem_file_operations			ramfs_file_operations
 #define shmem_get_inode(sb, dir, mode, dev, flags)	ramfs_get_inode(sb, dir, mode, dev)
 #define shmem_acct_size(flags, size)		0
@@ -4268,7 +4284,7 @@ int shmem_zero_setup(struct vm_area_stru
 	if (vma->vm_file)
 		fput(vma->vm_file);
 	vma->vm_file = file;
-	vma->vm_ops = &shmem_vm_ops;
+	vma->vm_ops = &shmem_anon_vm_ops;
 
 	return 0;
 }
_

Patches currently in -mm which might be from pasha.tatashin@soleen.com are


