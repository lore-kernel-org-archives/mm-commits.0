Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E948F37C921
	for <mm-commits@vger.kernel.org>; Wed, 11 Mar 2026 20:41:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773261698; cv=none; b=stEfBxw+pM6AQFFwnQo4FA+IIxsPrd0snHDRXGp4Tw0/2xqddVUmZhBbA3Y4DuhcVviSfdt2s9DBfDftXZmjToUKqYXbpdC+V+MnxT9AJkwMGaApz+gMzewXei9S5feCW7IkJ0z0KdFPVhGdWn1Pkd7gpmWWWHj4egdXpY4BseQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773261698; c=relaxed/simple;
	bh=ohbzzByJiZ26SWIRGUNk36cshoJdm+A3d+Sf3ZA69R8=;
	h=Date:To:From:Subject:Message-Id; b=F6j10oeC2OUq52asZfwI93AJD5CUIF5PtxPbaR89UE2WSblX8U5yDvOJiUBJ6dp5vUNoF7/eAJ/rRAHFpoUmfoeMwBntyUX3a2sfk3VnHB7j3fXpIESVre6JjEQRmu/vhgvHuw0UOJW7K/5HBguXA7AHt1nqUC0jVQxT/fObRkk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=GupwIl7D; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="GupwIl7D"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8931EC4CEF7;
	Wed, 11 Mar 2026 20:41:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1773261697;
	bh=ohbzzByJiZ26SWIRGUNk36cshoJdm+A3d+Sf3ZA69R8=;
	h=Date:To:From:Subject:From;
	b=GupwIl7DWDNfsk+lZmoYI+il2aOE7JxKUOmtdEm7RtnGFFHvSgxTh+eOEaKI6LEPV
	 DpK+iyXSd3InbvJ2xrwUdX4zUFJ1XygZqxfqiN2/a6oKwAxn8Ds+Zv+9UrYQL5wCNK
	 XzZGFLuA9kq1wtAtS1ADntV1Yo5OE0OPZbogo+i0=
Date: Wed, 11 Mar 2026 13:41:36 -0700
To: mm-commits@vger.kernel.org,vbabka@kernel.org,surenb@google.com,rppt@kernel.org,pfalcato@suse.de,osalvador@suse.de,mhocko@suse.com,luckd0g@163.com,liam.howlett@oracle.com,jannh@google.com,ljs@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-abstract-reading-sysctl_max_map_count-and-read_once.patch added to mm-new branch
Message-Id: <20260311204137.8931EC4CEF7@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm: abstract reading sysctl_max_map_count, and READ_ONCE()
has been added to the -mm mm-new branch.  Its filename is
     mm-abstract-reading-sysctl_max_map_count-and-read_once.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-abstract-reading-sysctl_max_map_count-and-read_once.patch

This patch will later appear in the mm-new branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Note, mm-new is a provisional staging ground for work-in-progress
patches, and acceptance into mm-new is a notification for others take
notice and to finish up reviews.  Please do not hesitate to respond to
review feedback and post updated versions to replace or incrementally
fixup patches in mm-new.

The mm-new branch of mm.git is not included in linux-next

If a few days of testing in mm-new is successful, the patch will me moved
into mm.git's mm-unstable branch, which is included in linux-next

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next via various
branches at git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
and is updated there most days

------------------------------------------------------
From: "Lorenzo Stoakes (Oracle)" <ljs@kernel.org>
Subject: mm: abstract reading sysctl_max_map_count, and READ_ONCE()
Date: Wed, 11 Mar 2026 17:24:37 +0000

Concurrent reads and writes of sysctl_max_map_count are possible, so we
should READ_ONCE() and WRITE_ONCE().

The sysctl procfs logic already enforces WRITE_ONCE(), so abstract the
read side with get_sysctl_max_map_count().

While we're here, also move the field to mm/internal.h and add the getter
there since only mm interacts with it, there's no need for anybody else to
have access.

Finally, update the VMA userland tests to reflect the change.

Link: https://lkml.kernel.org/r/0715259eb37cbdfde4f9e5db92a20ec7110a1ce5.1773249037.git.ljs@kernel.org
Signed-off-by: Lorenzo Stoakes (Oracle) <ljs@kernel.org>
Cc: Jann Horn <jannh@google.com>
Cc: Jianzhou Zhao <luckd0g@163.com>
Cc: Liam Howlett <liam.howlett@oracle.com>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Mike Rapoport <rppt@kernel.org>
Cc: Oscar Salvador <osalvador@suse.de>
Cc: Pedro Falcato <pfalcato@suse.de>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: Vlastimil Babka <vbabka@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/mm.h                 |    2 --
 mm/internal.h                      |    6 ++++++
 mm/mmap.c                          |    2 +-
 mm/mremap.c                        |    4 ++--
 mm/nommu.c                         |    2 +-
 mm/vma.c                           |    6 +++---
 tools/testing/vma/include/custom.h |    3 ---
 tools/testing/vma/include/dup.h    |    9 +++++++++
 tools/testing/vma/main.c           |    2 ++
 9 files changed, 24 insertions(+), 12 deletions(-)

--- a/include/linux/mm.h~mm-abstract-reading-sysctl_max_map_count-and-read_once
+++ a/include/linux/mm.h
@@ -207,8 +207,6 @@ static inline void __mm_zero_struct_page
 #define MAPCOUNT_ELF_CORE_MARGIN	(5)
 #define DEFAULT_MAX_MAP_COUNT	(USHRT_MAX - MAPCOUNT_ELF_CORE_MARGIN)
 
-extern int sysctl_max_map_count;
-
 extern unsigned long sysctl_user_reserve_kbytes;
 extern unsigned long sysctl_admin_reserve_kbytes;
 
--- a/mm/internal.h~mm-abstract-reading-sysctl_max_map_count-and-read_once
+++ a/mm/internal.h
@@ -1864,4 +1864,10 @@ static inline int pmdp_test_and_clear_yo
 
 #endif /* CONFIG_MMU_NOTIFIER */
 
+extern int sysctl_max_map_count;
+static inline int get_sysctl_max_map_count(void)
+{
+	return READ_ONCE(sysctl_max_map_count);
+}
+
 #endif	/* __MM_INTERNAL_H */
--- a/mm/mmap.c~mm-abstract-reading-sysctl_max_map_count-and-read_once
+++ a/mm/mmap.c
@@ -375,7 +375,7 @@ unsigned long do_mmap(struct file *file,
 		return -EOVERFLOW;
 
 	/* Too many mappings? */
-	if (mm->map_count > sysctl_max_map_count)
+	if (mm->map_count > get_sysctl_max_map_count())
 		return -ENOMEM;
 
 	/*
--- a/mm/mremap.c~mm-abstract-reading-sysctl_max_map_count-and-read_once
+++ a/mm/mremap.c
@@ -1045,7 +1045,7 @@ static unsigned long prep_move_vma(struc
 	 * which may not merge, then (if MREMAP_DONTUNMAP is not set) unmap the
 	 * source, which may split, causing a net increase of 2 mappings.
 	 */
-	if (current->mm->map_count + 2 > sysctl_max_map_count)
+	if (current->mm->map_count + 2 > get_sysctl_max_map_count())
 		return -ENOMEM;
 
 	if (vma->vm_ops && vma->vm_ops->may_split) {
@@ -1813,7 +1813,7 @@ static unsigned long check_mremap_params
 	 * net increased map count of 2. In move_vma() we check for headroom of
 	 * 2 additional mappings, so check early to avoid bailing out then.
 	 */
-	if (current->mm->map_count + 4 > sysctl_max_map_count)
+	if (current->mm->map_count + 4 > get_sysctl_max_map_count())
 		return -ENOMEM;
 
 	return 0;
--- a/mm/nommu.c~mm-abstract-reading-sysctl_max_map_count-and-read_once
+++ a/mm/nommu.c
@@ -1317,7 +1317,7 @@ static int split_vma(struct vma_iterator
 		return -ENOMEM;
 
 	mm = vma->vm_mm;
-	if (mm->map_count >= sysctl_max_map_count)
+	if (mm->map_count >= get_sysctl_max_map_count())
 		return -ENOMEM;
 
 	region = kmem_cache_alloc(vm_region_jar, GFP_KERNEL);
--- a/mm/vma.c~mm-abstract-reading-sysctl_max_map_count-and-read_once
+++ a/mm/vma.c
@@ -590,7 +590,7 @@ out_free_vma:
 static int split_vma(struct vma_iterator *vmi, struct vm_area_struct *vma,
 		     unsigned long addr, int new_below)
 {
-	if (vma->vm_mm->map_count >= sysctl_max_map_count)
+	if (vma->vm_mm->map_count >= get_sysctl_max_map_count())
 		return -ENOMEM;
 
 	return __split_vma(vmi, vma, addr, new_below);
@@ -1394,7 +1394,7 @@ static int vms_gather_munmap_vmas(struct
 		 * its limit temporarily, to help free resources as expected.
 		 */
 		if (vms->end < vms->vma->vm_end &&
-		    vms->vma->vm_mm->map_count >= sysctl_max_map_count) {
+		    vms->vma->vm_mm->map_count >= get_sysctl_max_map_count()) {
 			error = -ENOMEM;
 			goto map_count_exceeded;
 		}
@@ -2868,7 +2868,7 @@ int do_brk_flags(struct vma_iterator *vm
 	if (!may_expand_vm(mm, vm_flags, len >> PAGE_SHIFT))
 		return -ENOMEM;
 
-	if (mm->map_count > sysctl_max_map_count)
+	if (mm->map_count > get_sysctl_max_map_count())
 		return -ENOMEM;
 
 	if (security_vm_enough_memory_mm(mm, len >> PAGE_SHIFT))
--- a/tools/testing/vma/include/custom.h~mm-abstract-reading-sysctl_max_map_count-and-read_once
+++ a/tools/testing/vma/include/custom.h
@@ -21,9 +21,6 @@ extern unsigned long dac_mmap_min_addr;
 #define VM_BUG_ON(_expr) (BUG_ON(_expr))
 #define VM_BUG_ON_VMA(_expr, _vma) (BUG_ON(_expr))
 
-/* We hardcode this for now. */
-#define sysctl_max_map_count 0x1000000UL
-
 #define TASK_SIZE ((1ul << 47)-PAGE_SIZE)
 
 /*
--- a/tools/testing/vma/include/dup.h~mm-abstract-reading-sysctl_max_map_count-and-read_once
+++ a/tools/testing/vma/include/dup.h
@@ -419,6 +419,9 @@ struct vma_iterator {
 
 #define EMPTY_VMA_FLAGS ((vma_flags_t){ })
 
+#define MAPCOUNT_ELF_CORE_MARGIN	(5)
+#define DEFAULT_MAX_MAP_COUNT	(USHRT_MAX - MAPCOUNT_ELF_CORE_MARGIN)
+
 /* What action should be taken after an .mmap_prepare call is complete? */
 enum mmap_action_type {
 	MMAP_NOTHING,		/* Mapping is complete, no further action. */
@@ -1342,3 +1345,9 @@ static inline void vma_set_file(struct v
 	swap(vma->vm_file, file);
 	fput(file);
 }
+
+extern int sysctl_max_map_count;
+static inline int get_sysctl_max_map_count(void)
+{
+	return READ_ONCE(sysctl_max_map_count);
+}
--- a/tools/testing/vma/main.c~mm-abstract-reading-sysctl_max_map_count-and-read_once
+++ a/tools/testing/vma/main.c
@@ -14,6 +14,8 @@
 #include "tests/mmap.c"
 #include "tests/vma.c"
 
+int sysctl_max_map_count __read_mostly = DEFAULT_MAX_MAP_COUNT;
+
 /* Helper functions which utilise static kernel functions. */
 
 struct vm_area_struct *merge_existing(struct vma_merge_struct *vmg)
_

Patches currently in -mm which might be from ljs@kernel.org are

mm-rename-vma-flag-helpers-to-be-more-readable.patch
mm-add-vma_desc_test_all-and-use-it.patch
mm-always-inline-__mk_vma_flags-and-invoked-functions.patch
mm-reintroduce-vma_flags_test-as-a-singular-flag-test.patch
mm-reintroduce-vma_desc_test-as-a-singular-flag-test.patch
tools-testing-vma-add-test-for-vma_flags_test-vma_desc_test.patch
tools-testing-vma-add-test-for-vma_flags_test-vma_desc_test-fix.patch
mm-mremap-correct-invalid-map-count-check.patch
mm-abstract-reading-sysctl_max_map_count-and-read_once.patch
mm-mremap-check-map-count-under-mmap-write-lock-and-abstract.patch

