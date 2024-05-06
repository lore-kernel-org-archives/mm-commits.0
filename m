Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EC90125757
	for <mm-commits@vger.kernel.org>; Mon,  6 May 2024 00:57:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714957080; cv=none; b=ZmXT6SiaSAFJ6YjAJpGMuqYU5i/+sMtFKb9LiUKuafxSSHF4Z8kybFzvqjLLDGLC40O5UsW+gLOrHNYm6wnxx54CQ/EKtU7KIOke7vcK5TaGNLaJ6lOcSxXJ/EpBBajAIrdXhxtnH/aCWBSQADHAwMWk0yUXOZGMrYUjj1T9ujE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714957080; c=relaxed/simple;
	bh=Kid4aeVgdW9IzV8WQkW+Bia5kVNQRX0U8eieIHbH11U=;
	h=Date:To:From:Subject:Message-Id; b=ospKvDPccQ/FWKrdgy/a7N4DlnogsegTseDspCwuN7BMOqY6uRNVfPluAk9DmNC5786wnUpZfHNydpyYOEVhg8Q2XKnDhp+PZ4lvLOwzcx0dd5oX8NrK2Shb6MiQhjYKREvUdL5Ryt+8L5xEf1fA3YtoGGoIrllDrokaNXVuRnI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=DhpkeXda; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="DhpkeXda"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C1470C113CC;
	Mon,  6 May 2024 00:57:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1714957079;
	bh=Kid4aeVgdW9IzV8WQkW+Bia5kVNQRX0U8eieIHbH11U=;
	h=Date:To:From:Subject:From;
	b=DhpkeXdaLzXpO2JLFZQorgtEdUXOpLaK+GY8zfdcRZwmz+IeJdEdLlnZbgZJCgUbp
	 mAMPom07iv5G3zcnXIDEMh+94Mln/SBZYx73VcMVAiqPCCPKWO/mGAsRtM5X9m1NvL
	 l/kdHVmJjrWYB5CGflt3KjStFfUwBon/vynh7tDE=
Date: Sun, 05 May 2024 17:57:59 -0700
To: mm-commits@vger.kernel.org,peterx@redhat.com,wangkefeng.wang@huawei.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-memory-check-userfaultfd_wp-in-vmf_orig_pte_uffd_wp.patch removed from -mm tree
Message-Id: <20240506005759.C1470C113CC@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm: memory: check userfaultfd_wp() in vmf_orig_pte_uffd_wp()
has been removed from the -mm tree.  Its filename was
     mm-memory-check-userfaultfd_wp-in-vmf_orig_pte_uffd_wp.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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


