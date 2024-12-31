Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4A2C8FC0B;
	Tue, 31 Dec 2024 01:59:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1735610387; cv=none; b=t0/WipMHBfUaUmaaVhmc+mngWoT1XDRgS5PBjVYHrn7vXXm0e84iyTG9U+ceuF9pu1CbQwPNCYlcT3bbmWo0UQrAkENKTD1G6O/BIcIST/u2AxU9vZ4CQV/+pSndphVxFenGPiAa0ZHiRqADhck2rQsBIK+X7F27nmtbFBpldSU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1735610387; c=relaxed/simple;
	bh=0XBblbSl4fAG3gtVQ9WjijmeJWth2Xf0a0JHxCPo5k0=;
	h=Date:To:From:Subject:Message-Id; b=UQOoSWwLVuobTkebls179qsHVAcol4JEG72hnK3Dp1vpppluNsZDu9foij9GhBeKyg3mqnyMov5Crrvy0kt3MqSc1hNr8ovqY9CFQD0yqntWI4jZpn4zKvlUiQzoF4TsWjPQg04PIqRFyRC/ceD6z9W0X+bTwx64a+G1BW76+Vc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=p+19iy9l; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="p+19iy9l"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B437BC4CED0;
	Tue, 31 Dec 2024 01:59:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1735610386;
	bh=0XBblbSl4fAG3gtVQ9WjijmeJWth2Xf0a0JHxCPo5k0=;
	h=Date:To:From:Subject:From;
	b=p+19iy9l5WsrZiF61lf/YZvhdKLHpiKx26rm/Hyb/1jygP8jWNcs3Vo/g1cRKXt4U
	 uS0r8URCggnUc5s80/W9c8STy62TCQ8vn9L4ji+i1oxfGX+eFf8r70/ZdFmWqHZm5g
	 XPR9rDyxoXw8wiodmOe2MHhGfPd11fLzpU634OQ4=
Date: Mon, 30 Dec 2024 17:59:46 -0800
To: mm-commits@vger.kernel.org,vbabka@suse.cz,torvalds@linux-foundation.org,stable@vger.kernel.org,shuah@kernel.org,Liam.Howlett@Oracle.com,ju.orth@gmail.com,jannh@google.com,lorenzo.stoakes@oracle.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-hotfixes-stable] mm-reinstate-ability-to-map-write-sealed-memfd-mappings-read-only.patch removed from -mm tree
Message-Id: <20241231015946.B437BC4CED0@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm: reinstate ability to map write-sealed memfd mappings read-only
has been removed from the -mm tree.  Its filename was
     mm-reinstate-ability-to-map-write-sealed-memfd-mappings-read-only.patch

This patch was dropped because it was merged into the mm-hotfixes-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Subject: mm: reinstate ability to map write-sealed memfd mappings read-only
Date: Thu, 28 Nov 2024 15:06:17 +0000

Patch series "mm: reinstate ability to map write-sealed memfd mappings
read-only".

In commit 158978945f31 ("mm: perform the mapping_map_writable() check
after call_mmap()") (and preceding changes in the same series) it became
possible to mmap() F_SEAL_WRITE sealed memfd mappings read-only.

Commit 5de195060b2e ("mm: resolve faulty mmap_region() error path
behaviour") unintentionally undid this logic by moving the
mapping_map_writable() check before the shmem_mmap() hook is invoked,
thereby regressing this change.

This series reworks how we both permit write-sealed mappings being mapped
read-only and disallow mprotect() from undoing the write-seal, fixing this
regression.

We also add a regression test to ensure that we do not accidentally
regress this in future.

Thanks to Julian Orth for reporting this regression.


This patch (of 2):

In commit 158978945f31 ("mm: perform the mapping_map_writable() check
after call_mmap()") (and preceding changes in the same series) it became
possible to mmap() F_SEAL_WRITE sealed memfd mappings read-only.

This was previously unnecessarily disallowed, despite the man page
documentation indicating that it would be, thereby limiting the usefulness
of F_SEAL_WRITE logic.

We fixed this by adapting logic that existed for the F_SEAL_FUTURE_WRITE
seal (one which disallows future writes to the memfd) to also be used for
F_SEAL_WRITE.

For background - the F_SEAL_FUTURE_WRITE seal clears VM_MAYWRITE for a
read-only mapping to disallow mprotect() from overriding the seal - an
operation performed by seal_check_write(), invoked from shmem_mmap(), the
f_op->mmap() hook used by shmem mappings.

By extending this to F_SEAL_WRITE and critically - checking
mapping_map_writable() to determine if we may map the memfd AFTER we
invoke shmem_mmap() - the desired logic becomes possible.  This is because
mapping_map_writable() explicitly checks for VM_MAYWRITE, which we will
have cleared.

Commit 5de195060b2e ("mm: resolve faulty mmap_region() error path
behaviour") unintentionally undid this logic by moving the
mapping_map_writable() check before the shmem_mmap() hook is invoked,
thereby regressing this change.

We reinstate this functionality by moving the check out of shmem_mmap()
and instead performing it in do_mmap() at the point at which VMA flags are
being determined, which seems in any case to be a more appropriate place
in which to make this determination.

In order to achieve this we rework memfd seal logic to allow us access to
this information using existing logic and eliminate the clearing of
VM_MAYWRITE from seal_check_write() which we are performing in do_mmap()
instead.

Link: https://lkml.kernel.org/r/99fc35d2c62bd2e05571cf60d9f8b843c56069e0.1732804776.git.lorenzo.stoakes@oracle.com
Fixes: 5de195060b2e ("mm: resolve faulty mmap_region() error path behaviour")
Signed-off-by: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Reported-by: Julian Orth <ju.orth@gmail.com>
Closes: https://lore.kernel.org/all/CAHijbEUMhvJTN9Xw1GmbM266FXXv=U7s4L_Jem5x3AaPZxrYpQ@mail.gmail.com/
Cc: Jann Horn <jannh@google.com>
Cc: Liam R. Howlett <Liam.Howlett@Oracle.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Shuah Khan <shuah@kernel.org>
Cc: Vlastimil Babka <vbabka@suse.cz>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/memfd.h |   14 +++++++++
 include/linux/mm.h    |   58 +++++++++++++++++++++++++++-------------
 mm/memfd.c            |    2 -
 mm/mmap.c             |    4 ++
 4 files changed, 59 insertions(+), 19 deletions(-)

--- a/include/linux/memfd.h~mm-reinstate-ability-to-map-write-sealed-memfd-mappings-read-only
+++ a/include/linux/memfd.h
@@ -7,6 +7,7 @@
 #ifdef CONFIG_MEMFD_CREATE
 extern long memfd_fcntl(struct file *file, unsigned int cmd, unsigned int arg);
 struct folio *memfd_alloc_folio(struct file *memfd, pgoff_t idx);
+unsigned int *memfd_file_seals_ptr(struct file *file);
 #else
 static inline long memfd_fcntl(struct file *f, unsigned int c, unsigned int a)
 {
@@ -16,6 +17,19 @@ static inline struct folio *memfd_alloc_
 {
 	return ERR_PTR(-EINVAL);
 }
+
+static inline unsigned int *memfd_file_seals_ptr(struct file *file)
+{
+	return NULL;
+}
 #endif
 
+/* Retrieve memfd seals associated with the file, if any. */
+static inline unsigned int memfd_file_seals(struct file *file)
+{
+	unsigned int *sealsp = memfd_file_seals_ptr(file);
+
+	return sealsp ? *sealsp : 0;
+}
+
 #endif /* __LINUX_MEMFD_H */
--- a/include/linux/mm.h~mm-reinstate-ability-to-map-write-sealed-memfd-mappings-read-only
+++ a/include/linux/mm.h
@@ -4101,6 +4101,37 @@ void mem_dump_obj(void *object);
 static inline void mem_dump_obj(void *object) {}
 #endif
 
+static inline bool is_write_sealed(int seals)
+{
+	return seals & (F_SEAL_WRITE | F_SEAL_FUTURE_WRITE);
+}
+
+/**
+ * is_readonly_sealed - Checks whether write-sealed but mapped read-only,
+ *                      in which case writes should be disallowing moving
+ *                      forwards.
+ * @seals: the seals to check
+ * @vm_flags: the VMA flags to check
+ *
+ * Returns whether readonly sealed, in which case writess should be disallowed
+ * going forward.
+ */
+static inline bool is_readonly_sealed(int seals, vm_flags_t vm_flags)
+{
+	/*
+	 * Since an F_SEAL_[FUTURE_]WRITE sealed memfd can be mapped as
+	 * MAP_SHARED and read-only, take care to not allow mprotect to
+	 * revert protections on such mappings. Do this only for shared
+	 * mappings. For private mappings, don't need to mask
+	 * VM_MAYWRITE as we still want them to be COW-writable.
+	 */
+	if (is_write_sealed(seals) &&
+	    ((vm_flags & (VM_SHARED | VM_WRITE)) == VM_SHARED))
+		return true;
+
+	return false;
+}
+
 /**
  * seal_check_write - Check for F_SEAL_WRITE or F_SEAL_FUTURE_WRITE flags and
  *                    handle them.
@@ -4112,24 +4143,15 @@ static inline void mem_dump_obj(void *ob
  */
 static inline int seal_check_write(int seals, struct vm_area_struct *vma)
 {
-	if (seals & (F_SEAL_WRITE | F_SEAL_FUTURE_WRITE)) {
-		/*
-		 * New PROT_WRITE and MAP_SHARED mmaps are not allowed when
-		 * write seals are active.
-		 */
-		if ((vma->vm_flags & VM_SHARED) && (vma->vm_flags & VM_WRITE))
-			return -EPERM;
-
-		/*
-		 * Since an F_SEAL_[FUTURE_]WRITE sealed memfd can be mapped as
-		 * MAP_SHARED and read-only, take care to not allow mprotect to
-		 * revert protections on such mappings. Do this only for shared
-		 * mappings. For private mappings, don't need to mask
-		 * VM_MAYWRITE as we still want them to be COW-writable.
-		 */
-		if (vma->vm_flags & VM_SHARED)
-			vm_flags_clear(vma, VM_MAYWRITE);
-	}
+	if (!is_write_sealed(seals))
+		return 0;
+
+	/*
+	 * New PROT_WRITE and MAP_SHARED mmaps are not allowed when
+	 * write seals are active.
+	 */
+	if ((vma->vm_flags & VM_SHARED) && (vma->vm_flags & VM_WRITE))
+		return -EPERM;
 
 	return 0;
 }
--- a/mm/memfd.c~mm-reinstate-ability-to-map-write-sealed-memfd-mappings-read-only
+++ a/mm/memfd.c
@@ -170,7 +170,7 @@ static int memfd_wait_for_pins(struct ad
 	return error;
 }
 
-static unsigned int *memfd_file_seals_ptr(struct file *file)
+unsigned int *memfd_file_seals_ptr(struct file *file)
 {
 	if (shmem_file(file))
 		return &SHMEM_I(file_inode(file))->seals;
--- a/mm/mmap.c~mm-reinstate-ability-to-map-write-sealed-memfd-mappings-read-only
+++ a/mm/mmap.c
@@ -47,6 +47,7 @@
 #include <linux/oom.h>
 #include <linux/sched/mm.h>
 #include <linux/ksm.h>
+#include <linux/memfd.h>
 
 #include <linux/uaccess.h>
 #include <asm/cacheflush.h>
@@ -368,6 +369,7 @@ unsigned long do_mmap(struct file *file,
 
 	if (file) {
 		struct inode *inode = file_inode(file);
+		unsigned int seals = memfd_file_seals(file);
 		unsigned long flags_mask;
 
 		if (!file_mmap_ok(file, inode, pgoff, len))
@@ -408,6 +410,8 @@ unsigned long do_mmap(struct file *file,
 			vm_flags |= VM_SHARED | VM_MAYSHARE;
 			if (!(file->f_mode & FMODE_WRITE))
 				vm_flags &= ~(VM_MAYWRITE | VM_SHARED);
+			else if (is_readonly_sealed(seals, vm_flags))
+				vm_flags &= ~VM_MAYWRITE;
 			fallthrough;
 		case MAP_PRIVATE:
 			if (!(file->f_mode & FMODE_READ))
_

Patches currently in -mm which might be from lorenzo.stoakes@oracle.com are

mm-vma-move-brk-internals-to-mm-vmac.patch
mm-vma-move-brk-internals-to-mm-vmac-fix.patch
mm-vma-move-unmapped_area-internals-to-mm-vmac.patch
mm-abstract-get_arg_page-stack-expansion-and-mmap-read-lock.patch
mm-vma-move-stack-expansion-logic-to-mm-vmac.patch
mm-vma-move-__vm_munmap-to-mm-vmac.patch
selftests-mm-add-fork-cow-guard-page-test.patch
mm-enforce-__must_check-on-vma-merge-and-split.patch
mm-perform-all-memfd-seal-checks-in-a-single-place.patch
mm-perform-all-memfd-seal-checks-in-a-single-place-fix.patch
maintainers-update-memory-mapping-section.patch
mm-assert-mmap-write-lock-held-on-do_mmap-mmap_region.patch
mm-add-comments-to-do_mmap-mmap_region-and-vm_mmap.patch
tools-testing-add-simple-__mmap_region-userland-test.patch

