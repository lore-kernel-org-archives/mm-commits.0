Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 04218189903
	for <mm-commits@vger.kernel.org>; Wed,  6 Nov 2024 01:01:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730854882; cv=none; b=Yz4aPJ64dVBzD5ndpwfIFKHpi3Mq76b3hRqq1QzV9dHi/64nTzMZIGvIehjNOsqrMBN1Mrh213Led5V8Ky4KHCgUfQ5buiipza3KLHn+qa8mG452KRv9UT3aaXmjZcebMigP9Drpx5SOJsbO2OizVYOTn47RErDieXomAa8j3WQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730854882; c=relaxed/simple;
	bh=vTw0lPVdNEYH/kmS4QUby502eNgtjI1HRBpDLK7hLAs=;
	h=Date:To:From:Subject:Message-Id; b=rbaicaGybO7wej1VrSrA+1pC8wdnQCCBceJnRyNYCnZDCTotEis4EOIhAmwFt7rrc/Xp/IHFtYXNwlYfl3K5gU+msHEs/Gcm4FEnO9LI2birqSCKtcO5/OpKto2TL2OMxDlz4k9mQ4BBaMK/d0r7EuhlieC48cGRwAQS2DT/lik=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=FMRLhBOz; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="FMRLhBOz"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CFFBAC4CECF;
	Wed,  6 Nov 2024 01:01:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1730854881;
	bh=vTw0lPVdNEYH/kmS4QUby502eNgtjI1HRBpDLK7hLAs=;
	h=Date:To:From:Subject:From;
	b=FMRLhBOzR7Rxsn+ncFAYMAMwa8gdD8wqPB6Aoeh9X6LOhvhDvrwd9MkQZP2+S4E3f
	 30ub1Dex3ZcjlEupFQaozA5QWIhUIQLGXvuOIO2PR5FhrniBzv4DSd9SS4kjhrsSVW
	 Qsno8T2hnmuYcjuj9ciZ+qzY+EaJjmcnTbR/NDIc=
Date: Tue, 05 Nov 2024 17:01:21 -0800
To: mm-commits@vger.kernel.org,vbabka@suse.cz,torvalds@linux-foundation.org,peterx@redhat.com,Liam.Howlett@Oracle.com,jannh@google.com,lorenzo.stoakes@oracle.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] tools-testing-add-additional-vma_internalh-stubs.patch removed from -mm tree
Message-Id: <20241106010121.CFFBAC4CECF@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: tools: testing: add additional vma_internal.h stubs
has been removed from the -mm tree.  Its filename was
     tools-testing-add-additional-vma_internalh-stubs.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Subject: tools: testing: add additional vma_internal.h stubs
Date: Fri, 25 Oct 2024 13:26:23 +0100

Patch series "fix error handling in mmap_region() and refactor", v3.

The mmap_region() function is somewhat terrifying, with spaghetti-like
control flow and numerous means by which issues can arise and incomplete
state, memory leaks and other unpleasantness can occur.

This series goes to great lengths to simplify how mmap_region() works and
to avoid unwinding errors late on in the process of setting up the VMA for
the new mapping, and equally avoids such operations occurring while the
VMA is in an inconsistent state.

This series builds on the previously submitted hotfix patches (see link to
v2 below) which addresses the most critical issues around mmap_region(),
and further works to improve mmap_region() complexity, stability, and
testability.

This series moves the code to mm/vma.c to render it userland testable,
refactors and simplifies it into smaller functions that are significantly
more readable.

It additionally avoids performing an attempt at a second merge mid-way
through allocating a new VMA, a dubious proposition at best and one that
is highly subject to subtle bugs.

Rather than do this, we simply note that we ought to retry the merge and
do this as a final step.


This patch (of 3):

Add some additional vma_internal.h stubs in preparation for
__mmap_region() being moved to mm/vma.c.  Without these the move would
result in the tests no longer compiling.

Link: https://lkml.kernel.org/r/cover.1729858176.git.lorenzo.stoakes@oracle.com
Link: https://lkml.kernel.org/r/74b27e159e261d2ac1fe66a130edad1d61fdc176.1729858176.git.lorenzo.stoakes@oracle.com
Signed-off-by: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Cc: Jann Horn <jannh@google.com>
Cc: Liam R. Howlett <Liam.Howlett@Oracle.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Peter Xu <peterx@redhat.com>
Cc: Vlastimil Babka <vbabka@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 tools/testing/vma/vma_internal.h |  115 ++++++++++++++++++++++++++++-
 1 file changed, 114 insertions(+), 1 deletion(-)

--- a/tools/testing/vma/vma_internal.h~tools-testing-add-additional-vma_internalh-stubs
+++ a/tools/testing/vma/vma_internal.h
@@ -44,7 +44,9 @@
 #define VM_LOCKED	0x00002000
 #define VM_IO           0x00004000
 #define VM_DONTEXPAND	0x00040000
+#define VM_LOCKONFAULT	0x00080000
 #define VM_ACCOUNT	0x00100000
+#define VM_NORESERVE	0x00200000
 #define VM_MIXEDMAP	0x10000000
 #define VM_STACK	VM_GROWSDOWN
 #define VM_SHADOW_STACK	VM_NONE
@@ -53,6 +55,14 @@
 #define VM_ACCESS_FLAGS (VM_READ | VM_WRITE | VM_EXEC)
 #define VM_SPECIAL (VM_IO | VM_DONTEXPAND | VM_PFNMAP | VM_MIXEDMAP)
 
+/* This mask represents all the VMA flag bits used by mlock */
+#define VM_LOCKED_MASK	(VM_LOCKED | VM_LOCKONFAULT)
+
+#ifdef CONFIG_64BIT
+/* VM is sealed, in vm_flags */
+#define VM_SEALED	_BITUL(63)
+#endif
+
 #define FIRST_USER_ADDRESS	0UL
 #define USER_PGTABLES_CEILING	0UL
 
@@ -698,8 +708,9 @@ static inline void tlb_finish_mmu(struct
 {
 }
 
-static inline void get_file(struct file *)
+static inline struct file *get_file(struct file *f)
 {
+	return f;
 }
 
 static inline int vma_dup_policy(struct vm_area_struct *, struct vm_area_struct *)
@@ -920,4 +931,106 @@ static inline bool signal_pending(void *
 	return false;
 }
 
+static inline bool is_file_hugepages(struct file *)
+{
+	return false;
+}
+
+static inline int security_vm_enough_memory_mm(struct mm_struct *, long)
+{
+	return true;
+}
+
+static inline bool may_expand_vm(struct mm_struct *, vm_flags_t, unsigned long)
+{
+	return true;
+}
+
+static inline void vm_flags_init(struct vm_area_struct *vma,
+				 vm_flags_t flags)
+{
+	vma->__vm_flags = flags;
+}
+
+static inline void vm_flags_set(struct vm_area_struct *vma,
+				vm_flags_t flags)
+{
+	vma_start_write(vma);
+	vma->__vm_flags |= flags;
+}
+
+static inline void vm_flags_clear(struct vm_area_struct *vma,
+				  vm_flags_t flags)
+{
+	vma_start_write(vma);
+	vma->__vm_flags &= ~flags;
+}
+
+static inline int call_mmap(struct file *, struct vm_area_struct *)
+{
+	return 0;
+}
+
+static inline int shmem_zero_setup(struct vm_area_struct *)
+{
+	return 0;
+}
+
+static inline void vma_set_anonymous(struct vm_area_struct *vma)
+{
+	vma->vm_ops = NULL;
+}
+
+static inline void ksm_add_vma(struct vm_area_struct *)
+{
+}
+
+static inline void perf_event_mmap(struct vm_area_struct *)
+{
+}
+
+static inline bool vma_is_dax(struct vm_area_struct *)
+{
+	return false;
+}
+
+static inline struct vm_area_struct *get_gate_vma(struct mm_struct *)
+{
+	return NULL;
+}
+
+bool vma_wants_writenotify(struct vm_area_struct *vma, pgprot_t vm_page_prot);
+
+/* Update vma->vm_page_prot to reflect vma->vm_flags. */
+static inline void vma_set_page_prot(struct vm_area_struct *vma)
+{
+	unsigned long vm_flags = vma->vm_flags;
+	pgprot_t vm_page_prot;
+
+	/* testing: we inline vm_pgprot_modify() to avoid clash with vma.h. */
+	vm_page_prot = pgprot_modify(vma->vm_page_prot, vm_get_page_prot(vm_flags));
+
+	if (vma_wants_writenotify(vma, vm_page_prot)) {
+		vm_flags &= ~VM_SHARED;
+		/* testing: we inline vm_pgprot_modify() to avoid clash with vma.h. */
+		vm_page_prot = pgprot_modify(vm_page_prot, vm_get_page_prot(vm_flags));
+	}
+	/* remove_protection_ptes reads vma->vm_page_prot without mmap_lock */
+	WRITE_ONCE(vma->vm_page_prot, vm_page_prot);
+}
+
+static inline bool arch_validate_flags(unsigned long)
+{
+	return true;
+}
+
+static inline void vma_close(struct vm_area_struct *)
+{
+}
+
+static inline int mmap_file(struct file *, struct vm_area_struct *)
+{
+	return 0;
+}
+
 #endif	/* __MM_VMA_INTERNAL_H */
_

Patches currently in -mm which might be from lorenzo.stoakes@oracle.com are

mm-pagewalk-add-the-ability-to-install-ptes.patch
mm-add-pte_marker_guard-pte-marker.patch
mm-madvise-implement-lightweight-guard-page-mechanism.patch
tools-testing-update-tools-uapi-header-for-mman-commonh.patch
selftests-mm-add-self-tests-for-guard-page-feature.patch
mm-remove-unnecessary-page_table_lock-on-stack-expansion.patch

