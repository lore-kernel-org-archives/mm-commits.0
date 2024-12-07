Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7D3722E822
	for <mm-commits@vger.kernel.org>; Sat,  7 Dec 2024 04:40:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733546432; cv=none; b=aPBQBTPg93eDF8V4if88upQd3U7LMYDDs1FmqKqgCk4wXZvcIaWrEmUd7jWGPEwgoymJqrE0QzDM15Hy2iPpIS/36oIubEzNpaXDJRmftiWlngE74BSe2SHAYKfBNzBaxwcuCqOWRVbGv/0a6t3YI0KahRkMnpzggHe9WsA74xc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733546432; c=relaxed/simple;
	bh=SD1O4Hj6v3eL9j+K1GOaWE9y0ol9R2/gSTOqpBRifCk=;
	h=Date:To:From:Subject:Message-Id; b=COFWIBumiaqXYOCNgz7eOFlLCnuusy9lDhDGb6TskLSA+Q936QSY4WcrSdjXjQDdBW5oyvfjdDva0MI6SAT6CmLkKE9rlGaYULPXzvD2YnEySWZIQE22XLT7HMvuQCJcdAFkm664pu+R4LFPSX7JfVN3ODjlLhCoEGTs5AD7HOQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=d6vhT1Z8; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="d6vhT1Z8"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D5602C4CECD;
	Sat,  7 Dec 2024 04:40:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1733546431;
	bh=SD1O4Hj6v3eL9j+K1GOaWE9y0ol9R2/gSTOqpBRifCk=;
	h=Date:To:From:Subject:From;
	b=d6vhT1Z844VuiEmdFePg0QXWUgD2xwzTEo3rOHtvZBLFBm8z3B3YeCPCowLgAL64I
	 kpfGgC6S74I/R2nk5hPbLZaR5PNl2O/Lo/4OONUbo4yUkxk7q4n/EKE+sfLTRrgI6C
	 mttq90w4TkKsWhyXixD+kPI5brPdDYqqxVlg8Feo=
Date: Fri, 06 Dec 2024 20:40:31 -0800
To: mm-commits@vger.kernel.org,vbabka@suse.cz,muchun.song@linux.dev,Liam.Howlett@Oracle.com,kaleshsingh@google.com,jeffxu@chromium.org,jannh@google.com,isaacmanjarres@google.com,hughd@google.com,lorenzo.stoakes@oracle.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-perform-all-memfd-seal-checks-in-a-single-place.patch added to mm-unstable branch
Message-Id: <20241207044031.D5602C4CECD@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm: perform all memfd seal checks in a single place
has been added to the -mm mm-unstable branch.  Its filename is
     mm-perform-all-memfd-seal-checks-in-a-single-place.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-perform-all-memfd-seal-checks-in-a-single-place.patch

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
From: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Subject: mm: perform all memfd seal checks in a single place
Date: Fri, 6 Dec 2024 21:28:46 +0000

We no longer actually need to perform these checks in the f_op->mmap()
hook any longer.

We already moved the operation which clears VM_MAYWRITE on a read-only
mapping of a write-sealed memfd in order to work around the restrictions
imposed by commit 5de195060b2e ("mm: resolve faulty mmap_region() error
path behaviour").

There is no reason for us not to simply go ahead and additionally check to
see if any pre-existing seals are in place here rather than defer this to
the f_op->mmap() hook.

By doing this we remove more logic from shmem_mmap() which doesn't belong
there, as well as doing the same for hugetlbfs_file_mmap().  We also
remove dubious shared logic in mm.h which simply does not belong there
either.

It makes sense to do these checks at the earliest opportunity, we know
these are shmem (or hugetlbfs) mappings whose relevant VMA flags will not
change from the invoking do_mmap() so there is simply no need to wait.

This also means the implementation of further memfd seal flags can be done
within mm/memfd.c and also have the opportunity to modify VMA flags as
necessary early in the mapping logic.

Link: https://lkml.kernel.org/r/20241206212846.210835-1-lorenzo.stoakes@oracle.com
Signed-off-by: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Cc: Hugh Dickins <hughd@google.com>
Cc: Isaac J. Manjarres <isaacmanjarres@google.com>
Cc: Jann Horn <jannh@google.com>
Cc: Kalesh Singh <kaleshsingh@google.com>
Cc: Liam R. Howlett <Liam.Howlett@Oracle.com>
Cc: Muchun Song <muchun.song@linux.dev>
Cc: Vlastimil Babka <vbabka@suse.cz>
Cc: Jeff Xu <jeffxu@chromium.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/hugetlbfs/inode.c  |    5 ---
 include/linux/memfd.h |   22 +++++++---------
 include/linux/mm.h    |   55 ----------------------------------------
 mm/memfd.c            |   44 +++++++++++++++++++++++++++++++-
 mm/mmap.c             |   12 ++++++--
 mm/shmem.c            |    6 ----
 6 files changed, 62 insertions(+), 82 deletions(-)

--- a/fs/hugetlbfs/inode.c~mm-perform-all-memfd-seal-checks-in-a-single-place
+++ a/fs/hugetlbfs/inode.c
@@ -99,7 +99,6 @@ static const struct fs_parameter_spec hu
 static int hugetlbfs_file_mmap(struct file *file, struct vm_area_struct *vma)
 {
 	struct inode *inode = file_inode(file);
-	struct hugetlbfs_inode_info *info = HUGETLBFS_I(inode);
 	loff_t len, vma_len;
 	int ret;
 	struct hstate *h = hstate_file(file);
@@ -116,10 +115,6 @@ static int hugetlbfs_file_mmap(struct fi
 	vm_flags_set(vma, VM_HUGETLB | VM_DONTEXPAND | VM_MTE_ALLOWED);
 	vma->vm_ops = &hugetlb_vm_ops;
 
-	ret = seal_check_write(info->seals, vma);
-	if (ret)
-		return ret;
-
 	/*
 	 * page based offset in vm_pgoff could be sufficiently large to
 	 * overflow a loff_t when converted to byte offset.  This can
--- a/include/linux/memfd.h~mm-perform-all-memfd-seal-checks-in-a-single-place
+++ a/include/linux/memfd.h
@@ -7,7 +7,14 @@
 #ifdef CONFIG_MEMFD_CREATE
 extern long memfd_fcntl(struct file *file, unsigned int cmd, unsigned int arg);
 struct folio *memfd_alloc_folio(struct file *memfd, pgoff_t idx);
-unsigned int *memfd_file_seals_ptr(struct file *file);
+/*
+ * Check for any existing seals on mmap, return an error if access is denied due
+ * to sealing, or 0 otherwise.
+ *
+ * We also update VMA flags if appropriate by manipulating the VMA flags pointed
+ * to by vm_flags_ptr.
+ */
+int memfd_check_seals_mmap(struct file *file, unsigned long *vm_flags_ptr);
 #else
 static inline long memfd_fcntl(struct file *f, unsigned int c, unsigned int a)
 {
@@ -17,19 +24,10 @@ static inline struct folio *memfd_alloc_
 {
 	return ERR_PTR(-EINVAL);
 }
-
-static inline unsigned int *memfd_file_seals_ptr(struct file *file)
+int memfd_check_seals_mmap(struct file *file, unsigned long *vm_flags)
 {
-	return NULL;
+	return 0;
 }
 #endif
 
-/* Retrieve memfd seals associated with the file, if any. */
-static inline unsigned int memfd_file_seals(struct file *file)
-{
-	unsigned int *sealsp = memfd_file_seals_ptr(file);
-
-	return sealsp ? *sealsp : 0;
-}
-
 #endif /* __LINUX_MEMFD_H */
--- a/include/linux/mm.h~mm-perform-all-memfd-seal-checks-in-a-single-place
+++ a/include/linux/mm.h
@@ -4154,61 +4154,6 @@ void mem_dump_obj(void *object);
 static inline void mem_dump_obj(void *object) {}
 #endif
 
-static inline bool is_write_sealed(int seals)
-{
-	return seals & (F_SEAL_WRITE | F_SEAL_FUTURE_WRITE);
-}
-
-/**
- * is_readonly_sealed - Checks whether write-sealed but mapped read-only,
- *                      in which case writes should be disallowing moving
- *                      forwards.
- * @seals: the seals to check
- * @vm_flags: the VMA flags to check
- *
- * Returns whether readonly sealed, in which case writess should be disallowed
- * going forward.
- */
-static inline bool is_readonly_sealed(int seals, vm_flags_t vm_flags)
-{
-	/*
-	 * Since an F_SEAL_[FUTURE_]WRITE sealed memfd can be mapped as
-	 * MAP_SHARED and read-only, take care to not allow mprotect to
-	 * revert protections on such mappings. Do this only for shared
-	 * mappings. For private mappings, don't need to mask
-	 * VM_MAYWRITE as we still want them to be COW-writable.
-	 */
-	if (is_write_sealed(seals) &&
-	    ((vm_flags & (VM_SHARED | VM_WRITE)) == VM_SHARED))
-		return true;
-
-	return false;
-}
-
-/**
- * seal_check_write - Check for F_SEAL_WRITE or F_SEAL_FUTURE_WRITE flags and
- *                    handle them.
- * @seals: the seals to check
- * @vma: the vma to operate on
- *
- * Check whether F_SEAL_WRITE or F_SEAL_FUTURE_WRITE are set; if so, do proper
- * check/handling on the vma flags.  Return 0 if check pass, or <0 for errors.
- */
-static inline int seal_check_write(int seals, struct vm_area_struct *vma)
-{
-	if (!is_write_sealed(seals))
-		return 0;
-
-	/*
-	 * New PROT_WRITE and MAP_SHARED mmaps are not allowed when
-	 * write seals are active.
-	 */
-	if ((vma->vm_flags & VM_SHARED) && (vma->vm_flags & VM_WRITE))
-		return -EPERM;
-
-	return 0;
-}
-
 #ifdef CONFIG_ANON_VMA_NAME
 int madvise_set_anon_name(struct mm_struct *mm, unsigned long start,
 			  unsigned long len_in,
--- a/mm/memfd.c~mm-perform-all-memfd-seal-checks-in-a-single-place
+++ a/mm/memfd.c
@@ -170,7 +170,7 @@ static int memfd_wait_for_pins(struct ad
 	return error;
 }
 
-unsigned int *memfd_file_seals_ptr(struct file *file)
+static unsigned int *memfd_file_seals_ptr(struct file *file)
 {
 	if (shmem_file(file))
 		return &SHMEM_I(file_inode(file))->seals;
@@ -327,6 +327,48 @@ static int check_sysctl_memfd_noexec(uns
 	return 0;
 }
 
+static inline bool is_write_sealed(unsigned int seals)
+{
+	return seals & (F_SEAL_WRITE | F_SEAL_FUTURE_WRITE);
+}
+
+static int check_write_seal(unsigned long *vm_flags_ptr)
+{
+	unsigned long vm_flags = *vm_flags_ptr;
+	unsigned long mask = vm_flags & (VM_SHARED | VM_WRITE);
+
+	/* If a private matting then writability is irrelevant. */
+	if (!(mask & VM_SHARED))
+		return 0;
+
+	/*
+	 * New PROT_WRITE and MAP_SHARED mmaps are not allowed when
+	 * write seals are active.
+	 */
+	if (mask & VM_WRITE)
+		return -EPERM;
+
+	/*
+	 * This is a read-only mapping, disallow mprotect() from making a
+	 * write-sealed mapping writable in future.
+	 */
+	*vm_flags_ptr &= ~VM_MAYWRITE;
+
+	return 0;
+}
+
+int memfd_check_seals_mmap(struct file *file, unsigned long *vm_flags_ptr)
+{
+	int err = 0;
+	unsigned int *seals_ptr = memfd_file_seals_ptr(file);
+	unsigned int seals = seals_ptr ? *seals_ptr : 0;
+
+	if (is_write_sealed(seals))
+		err = check_write_seal(vm_flags_ptr);
+
+	return err;
+}
+
 SYSCALL_DEFINE2(memfd_create,
 		const char __user *, uname,
 		unsigned int, flags)
--- a/mm/mmap.c~mm-perform-all-memfd-seal-checks-in-a-single-place
+++ a/mm/mmap.c
@@ -368,8 +368,8 @@ unsigned long do_mmap(struct file *file,
 
 	if (file) {
 		struct inode *inode = file_inode(file);
-		unsigned int seals = memfd_file_seals(file);
 		unsigned long flags_mask;
+		int err;
 
 		if (!file_mmap_ok(file, inode, pgoff, len))
 			return -EOVERFLOW;
@@ -409,8 +409,6 @@ unsigned long do_mmap(struct file *file,
 			vm_flags |= VM_SHARED | VM_MAYSHARE;
 			if (!(file->f_mode & FMODE_WRITE))
 				vm_flags &= ~(VM_MAYWRITE | VM_SHARED);
-			else if (is_readonly_sealed(seals, vm_flags))
-				vm_flags &= ~VM_MAYWRITE;
 			fallthrough;
 		case MAP_PRIVATE:
 			if (!(file->f_mode & FMODE_READ))
@@ -430,6 +428,14 @@ unsigned long do_mmap(struct file *file,
 		default:
 			return -EINVAL;
 		}
+
+		/*
+		 * Check to see if we are violating any seals and update VMA
+		 * flags if necessary to avoid future seal violations.
+		 */
+		err = memfd_check_seals_mmap(file, &vm_flags);
+		if (err)
+			return (unsigned long)err;
 	} else {
 		switch (flags & MAP_TYPE) {
 		case MAP_SHARED:
--- a/mm/shmem.c~mm-perform-all-memfd-seal-checks-in-a-single-place
+++ a/mm/shmem.c
@@ -2815,12 +2815,6 @@ out_nomem:
 static int shmem_mmap(struct file *file, struct vm_area_struct *vma)
 {
 	struct inode *inode = file_inode(file);
-	struct shmem_inode_info *info = SHMEM_I(inode);
-	int ret;
-
-	ret = seal_check_write(info->seals, vma);
-	if (ret)
-		return ret;
 
 	file_accessed(file);
 	/* This is anonymous shared memory if it is unlinked at the time of mmap */
_

Patches currently in -mm which might be from lorenzo.stoakes@oracle.com are

docs-mm-add-vma-locks-documentation.patch
mm-reinstate-ability-to-map-write-sealed-memfd-mappings-read-only.patch
selftests-memfd-add-test-for-mapping-write-sealed-memfd-read-only.patch
mm-correctly-reference-merged-vma.patch
mm-vma-move-brk-internals-to-mm-vmac.patch
mm-vma-move-brk-internals-to-mm-vmac-fix.patch
mm-vma-move-unmapped_area-internals-to-mm-vmac.patch
mm-abstract-get_arg_page-stack-expansion-and-mmap-read-lock.patch
mm-vma-move-stack-expansion-logic-to-mm-vmac.patch
mm-vma-move-__vm_munmap-to-mm-vmac.patch
selftests-mm-add-fork-cow-guard-page-test.patch
mm-enforce-__must_check-on-vma-merge-and-split.patch
mm-perform-all-memfd-seal-checks-in-a-single-place.patch

