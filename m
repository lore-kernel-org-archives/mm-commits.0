Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8BF3615532F
	for <mm-commits@vger.kernel.org>; Mon, 22 Apr 2024 20:12:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713816720; cv=none; b=Xc0UIbLWTme0HcOmESz8aQU5EGu3g/xqE8FkI1AynjNGxnZXN/FqxSgWfzn6yqF64+htSi5wjEGQNwOSFg1IZ3fju08YeMCokwYjN66L2JVkpdC8SW1BtDuE1dUQ5UEdqDtaBRiLaGRhTawfMAvP5D5n4JlV37RMPzYcRzHdFQs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713816720; c=relaxed/simple;
	bh=tGqUTAaA1UPWEnPznxh4AusuE/35hVf9Nl2cdZIrl08=;
	h=Date:To:From:Subject:Message-Id; b=Y/g6n43ZBYS9wEdm8BuKRmlM0A5Wi54UuG1n5Gm6QYCasxowVbdatMH9cLUgzo/GnJc+nN0yk6C6wGg/p8fMUIxSqNv3O55GzprnlMm4QTtnufbor85T9w8S6A0JPVosrqwWSA+IIXnENQMo45XKfw5FvoLPzZdUMwIwf7LBaUw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=Lqk+C76T; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="Lqk+C76T"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 530BFC113CC;
	Mon, 22 Apr 2024 20:12:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1713816720;
	bh=tGqUTAaA1UPWEnPznxh4AusuE/35hVf9Nl2cdZIrl08=;
	h=Date:To:From:Subject:From;
	b=Lqk+C76TlM2F/T6caVqQfU8Uon2Kd2+5AeEOH+jL66IkK8BYANRzo+2x3JBYtYA9z
	 5TZ8hR1fJkSYADWrUMegXvbi2zqScrTLdCANUyTuhMEkfgubEQtvx6fY1ln9z6k+1U
	 qBhsVibaC7bKUZhBTKU3LMrzRKPEz8ZD+fUH5Zoo=
Date: Mon, 22 Apr 2024 13:11:59 -0700
To: mm-commits@vger.kernel.org,peterx@redhat.com,wangkefeng.wang@huawei.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-memory-check-userfaultfd_wp-in-vmf_orig_pte_uffd_wp.patch added to mm-unstable branch
Message-Id: <20240422201200.530BFC113CC@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm: memory: check userfaultfd_wp() in vmf_orig_pte_uffd_wp()
has been added to the -mm mm-unstable branch.  Its filename is
     mm-memory-check-userfaultfd_wp-in-vmf_orig_pte_uffd_wp.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-memory-check-userfaultfd_wp-in-vmf_orig_pte_uffd_wp.patch

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
From: Kefeng Wang <wangkefeng.wang@huawei.com>
Subject: mm: memory: check userfaultfd_wp() in vmf_orig_pte_uffd_wp()
Date: Mon, 22 Apr 2024 11:00:39 +0800

Add userfaultfd_wp() check in vmf_orig_pte_uffd_wp() to avoid the
unnecessary FAULT_FLAG_ORIG_PTE_VALID check/pte_marker_entry_uffd_wp() in
most pagefault, note, the function vmf_orig_pte_uffd_wp() is not inlined
in the two kernel versions, the difference is shown below,

perf date,

  perf report -i perf.data.before | grep vmf
     0.17%     0.13%  lat_pagefault  [kernel.kallsyms]      [k] vmf_orig_pte_uffd_wp.part.0.isra.0
  perf report -i perf.data.after  | grep vmf

lat_pagefault -W 5 -N 5 /tmp/XXX
  latency              before        after        diff
  average(8 tests)     0.262675      0.2600375   -0.0026375

Although it's a small, but the uffd_wp is a new feature than previous
kernel, when the vma is not registered with UFFD_WP, let's avoid to
execute the new logical, also adding __always_inline attribute to
vmf_orig_pte_uffd_wp(), which make set_pte_range() only check VM_UFFD_WP
flags without the function call.  In addition, directly call the
vmf_orig_pte_uffd_wp() in do_anonymous_page() and set_pte_range() to save
an uffd_wp variable.

Link: https://lkml.kernel.org/r/20240422030039.3293568-1-wangkefeng.wang@huawei.com
Signed-off-by: Kefeng Wang <wangkefeng.wang@huawei.com>
Reviewed-by: Peter Xu <peterx@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memory.c |   10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

--- a/mm/memory.c~mm-memory-check-userfaultfd_wp-in-vmf_orig_pte_uffd_wp
+++ a/mm/memory.c
@@ -112,8 +112,10 @@ static bool vmf_pte_changed(struct vm_fa
  * Return true if the original pte was a uffd-wp pte marker (so the pte was
  * wr-protected).
  */
-static bool vmf_orig_pte_uffd_wp(struct vm_fault *vmf)
+static __always_inline bool vmf_orig_pte_uffd_wp(struct vm_fault *vmf)
 {
+	if (!userfaultfd_wp(vmf->vma))
+		return false;
 	if (!(vmf->flags & FAULT_FLAG_ORIG_PTE_VALID))
 		return false;
 
@@ -4393,7 +4395,6 @@ fallback:
  */
 static vm_fault_t do_anonymous_page(struct vm_fault *vmf)
 {
-	bool uffd_wp = vmf_orig_pte_uffd_wp(vmf);
 	struct vm_area_struct *vma = vmf->vma;
 	unsigned long addr = vmf->address;
 	struct folio *folio;
@@ -4493,7 +4494,7 @@ static vm_fault_t do_anonymous_page(stru
 	folio_add_new_anon_rmap(folio, vma, addr);
 	folio_add_lru_vma(folio, vma);
 setpte:
-	if (uffd_wp)
+	if (vmf_orig_pte_uffd_wp(vmf))
 		entry = pte_mkuffd_wp(entry);
 	set_ptes(vma->vm_mm, addr, vmf->pte, entry, nr_pages);
 
@@ -4668,7 +4669,6 @@ void set_pte_range(struct vm_fault *vmf,
 		struct page *page, unsigned int nr, unsigned long addr)
 {
 	struct vm_area_struct *vma = vmf->vma;
-	bool uffd_wp = vmf_orig_pte_uffd_wp(vmf);
 	bool write = vmf->flags & FAULT_FLAG_WRITE;
 	bool prefault = in_range(vmf->address, addr, nr * PAGE_SIZE);
 	pte_t entry;
@@ -4683,7 +4683,7 @@ void set_pte_range(struct vm_fault *vmf,
 
 	if (write)
 		entry = maybe_mkwrite(pte_mkdirty(entry), vma);
-	if (unlikely(uffd_wp))
+	if (unlikely(vmf_orig_pte_uffd_wp(vmf)))
 		entry = pte_mkuffd_wp(entry);
 	/* copy-on-write page */
 	if (write && !(vma->vm_flags & VM_SHARED)) {
_

Patches currently in -mm which might be from wangkefeng.wang@huawei.com are

mm-backing-dev-use-group-allocation-free-of-per-cpu-counters-api.patch
mm-remove-__set_page_dirty_nobuffers.patch
arm64-mm-cleanup-__do_page_fault.patch
arm64-mm-accelerate-pagefault-when-vm_fault_badaccess.patch
arm-mm-accelerate-pagefault-when-vm_fault_badaccess.patch
powerpc-mm-accelerate-pagefault-when-badaccess.patch
riscv-mm-accelerate-pagefault-when-badaccess.patch
riscv-mm-accelerate-pagefault-when-badaccess-fix.patch
s390-mm-accelerate-pagefault-when-badaccess.patch
x86-mm-accelerate-pagefault-when-badaccess.patch
arm64-mm-drop-vm_fault_badmap-vm_fault_badaccess.patch
arm-mm-drop-vm_fault_badmap-vm_fault_badaccess.patch
mm-move-mm-counter-updating-out-of-set_pte_range.patch
mm-filemap-batch-mm-counter-updating-in-filemap_map_pages.patch
mm-swapfile-check-usable-swap-device-in-__folio_throttle_swaprate.patch
mm-memory-check-userfaultfd_wp-in-vmf_orig_pte_uffd_wp.patch

