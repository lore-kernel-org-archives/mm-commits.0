Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BD4E6273D8A
	for <mm-commits@vger.kernel.org>; Fri, 27 Jun 2025 21:23:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751059406; cv=none; b=oHWhPDf6DVzQ874sgmRjmNmYp9E50lcbeIN9b2JmanmDu1Nc01WK32xASJS8cs+4XtQnARYx/6Or0LJsm7UqhcmYa5xgwX8MRom1shmuQOwIOGLCshcCSds4sBkJSCrdU1Mw6/NAJooqTtSv0XvtdReld6CpJ3/46VJ6jeKfhl8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751059406; c=relaxed/simple;
	bh=B5M7wKYcPVevq/vMWMc/3lpEI2jWKcAYNYdF4kGmwgo=;
	h=Date:To:From:Subject:Message-Id; b=qFun5gm2moDkgjhOy25lHqcPQG5ZZLEctRyosB/xZGvTcsOkFSZSw27+JRNH5SHRCi9XO6koGLcMoX+ZuOHXoQtd3vDxGU+Ce7cWsPu5HDPUP06AoRXYEd82sy2gkm1h1w4ZgFDsDEPmNypj1urH7o9c/eZgZz/+UrvqoXzpF1A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=A9NNAxLT; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="A9NNAxLT"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 432E1C4AF09;
	Fri, 27 Jun 2025 21:23:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1751059406;
	bh=B5M7wKYcPVevq/vMWMc/3lpEI2jWKcAYNYdF4kGmwgo=;
	h=Date:To:From:Subject:From;
	b=A9NNAxLTYdfORi5J877zt3fsmImVmreQ9RjuF5zXmihercIiyd9ZGoHYF7hu9ZGid
	 4JXVDls1DkSMENPlNd7WuuOFPGo4mURHXFvuc9tVJYvDeHMAQQmt2I44kOV/DJuZdv
	 yCNXGzQRERxRQ8IeMrEcr4Nq8t935MSP6G6ZclIA=
Date: Fri, 27 Jun 2025 14:23:24 -0700
To: mm-commits@vger.kernel.org,vbabka@suse.cz,surenb@google.com,rppt@kernel.org,osalvador@suse.de,muchun.song@linux.dev,mhocko@suse.com,lorenzo.stoakes@oracle.com,liam.howlett@oracle.com,jthoughton@google.com,hughd@google.com,david@redhat.com,axelrasmussen@google.com,aarcange@redhat.com,peterx@redhat.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-shmem-support-vm_uffd_ops-api.patch added to mm-new branch
Message-Id: <20250627212326.432E1C4AF09@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/shmem: support vm_uffd_ops API
has been added to the -mm mm-new branch.  Its filename is
     mm-shmem-support-vm_uffd_ops-api.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-shmem-support-vm_uffd_ops-api.patch

This patch will later appear in the mm-new branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Note, mm-new is a provisional staging ground for work-in-progress
patches, and acceptance into mm-new is a notification for others take
notice and to finish up reviews.  Please do not hesitate to respond to
review feedback and post updated versions to replace or incrementally
fixup patches in mm-new.

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
From: Peter Xu <peterx@redhat.com>
Subject: mm/shmem: support vm_uffd_ops API
Date: Fri, 27 Jun 2025 11:46:53 -0400

Add support for the new vm_uffd_ops API for shmem.  Note that this only
introduces the support, the API is not yet used by core mm.

Due to the tailored uffd_copy() API, shmem is extremely easy to support it
by reusing the existing mfill function.

It only needs a separate uffd_get_folio() definition but that's oneliner.

Link: https://lkml.kernel.org/r/20250627154655.2085903-3-peterx@redhat.com
Signed-off-by: Peter Xu <peterx@redhat.com>
Cc: Hugh Dickins <hughd@google.com>
Cc: Andrea Arcangeli <aarcange@redhat.com>
Cc: Axel Rasmussen <axelrasmussen@google.com>
Cc: David Hildenbrand <david@redhat.com>
Cc: James Houghton <jthoughton@google.com>
Cc: Liam Howlett <liam.howlett@oracle.com>
Cc: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Mike Rapoport <rppt@kernel.org>
Cc: Muchun Song <muchun.song@linux.dev>
Cc: Oscar Salvador <osalvador@suse.de>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: Vlastimil Babka <vbabka@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/shmem.c |   26 ++++++++++++++++++++++++++
 1 file changed, 26 insertions(+)

--- a/mm/shmem.c~mm-shmem-support-vm_uffd_ops-api
+++ a/mm/shmem.c
@@ -3161,6 +3161,13 @@ static inline struct inode *shmem_get_in
 #endif /* CONFIG_TMPFS_QUOTA */
 
 #ifdef CONFIG_USERFAULTFD
+
+static int shmem_uffd_get_folio(struct inode *inode, pgoff_t pgoff,
+				struct folio **folio)
+{
+	return shmem_get_folio(inode, pgoff, 0, folio, SGP_NOALLOC);
+}
+
 int shmem_mfill_atomic_pte(pmd_t *dst_pmd,
 			   struct vm_area_struct *dst_vma,
 			   unsigned long dst_addr,
@@ -5204,6 +5211,19 @@ static int shmem_error_remove_folio(stru
 	return 0;
 }
 
+#ifdef CONFIG_USERFAULTFD
+static const vm_uffd_ops shmem_uffd_ops = {
+	.uffd_features	= 	__VM_UFFD_FLAGS,
+	.uffd_ioctls	= 	BIT(_UFFDIO_COPY) |
+				BIT(_UFFDIO_ZEROPAGE) |
+				BIT(_UFFDIO_WRITEPROTECT) |
+				BIT(_UFFDIO_CONTINUE) |
+				BIT(_UFFDIO_POISON),
+	.uffd_get_folio	=	shmem_uffd_get_folio,
+	.uffd_copy	=	shmem_mfill_atomic_pte,
+};
+#endif
+
 static const struct address_space_operations shmem_aops = {
 	.dirty_folio	= noop_dirty_folio,
 #ifdef CONFIG_TMPFS
@@ -5306,6 +5326,9 @@ static const struct vm_operations_struct
 	.set_policy     = shmem_set_policy,
 	.get_policy     = shmem_get_policy,
 #endif
+#ifdef CONFIG_USERFAULTFD
+	.userfaultfd_ops = &shmem_uffd_ops,
+#endif
 };
 
 static const struct vm_operations_struct shmem_anon_vm_ops = {
@@ -5315,6 +5338,9 @@ static const struct vm_operations_struct
 	.set_policy     = shmem_set_policy,
 	.get_policy     = shmem_get_policy,
 #endif
+#ifdef CONFIG_USERFAULTFD
+	.userfaultfd_ops = &shmem_uffd_ops,
+#endif
 };
 
 int shmem_init_fs_context(struct fs_context *fc)
_

Patches currently in -mm which might be from peterx@redhat.com are

selftests-mm-reduce-uffd-unit-test-poison-test-to-minimum.patch
selftests-mm-reduce-uffd-unit-test-poison-test-to-minimum-fix.patch
mm-hugetlb-remove-prepare_hugepage_range.patch
mm-deduplicate-mm_get_unmapped_area.patch
mm-introduce-vm_uffd_ops-api.patch
mm-shmem-support-vm_uffd_ops-api.patch
mm-hugetlb-support-vm_uffd_ops-api.patch
mm-apply-vm_uffd_ops-api-to-core-mm.patch

