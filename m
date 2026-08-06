Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BCC7B425873
	for <mm-commits@vger.kernel.org>; Thu,  6 Aug 2026 23:28:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786058895; cv=none; b=fXSBBTLghyT93KFWrGnQhYKscYGPmeKcxu0ERiphV8LFg2YrW5z+Jje/M0fCGDjPIWjCA5ty90Bd3gQdJS7atUFJjCce+ckDTAH4xGNuqflxnOOQovs+L7LwW9Am+tSYriFQJr0G/p6qhKfiyT3t+Y1Ak/VouBUAgjCb0TM9Jag=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786058895; c=relaxed/simple;
	bh=MrPyHu/iDbgPBgFy/D97ArAnxzzcGLcxoLn565wRlNQ=;
	h=Date:To:From:Subject:Message-Id; b=DXJEgYxbYJPxZVihy6vDQrtfX1QovfsP2ZwxQj23BXSajpehdgMH9JHpuDUrcGSdRzrL0XNTtusfvl+guiQ4gEBkVbCy8HAvYNqCsR3CB+fYSUdtiTOjENZ6bi7ZTQ1WkdxijX/qrpuFNLnIY8pWHfqAsXRqkKHHOQRLhDfb5R4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=et3nXqDY; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="et3nXqDY"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 564401F000E9;
	Thu,  6 Aug 2026 23:28:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1786058893;
	bh=xjXpn89I3Sl3ZnllKH9Qg1qkJVc8iTcCxUH7h0y21kA=;
	h=Date:To:From:Subject;
	b=et3nXqDYQveFdfr5vN7Yuk4LwwbV3aEp8xKr0mZyJ4goh1he5TXGn2UqQPbyp3Dw2
	 Jjv1U6Ggf2oaSmGVEfRRhDVPy7OznuQvR0Mxtnbpx38Ltjyx17s/5f3m8gNe8zDOEI
	 LMb2ronult7lpNEOCN8vdaF/D82vtb7bSuXh8UAs=
Date: Thu, 06 Aug 2026 16:28:12 -0700
To: mm-commits@vger.kernel.org,ljs@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-introduce-linear_anon_page_index.patch added to mm-unstable branch
Message-Id: <20260806232813.564401F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm: introduce linear_anon_page_index()
has been added to the -mm mm-unstable branch.  Its filename is
     mm-introduce-linear_anon_page_index.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-introduce-linear_anon_page_index.patch

This patch will later appear in the mm-unstable branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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
From: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
Subject: mm: introduce linear_anon_page_index()
Date: Thu, 06 Aug 2026 21:21:28 +0100

This function provides the anonymous equivalent of linear_page_index(),
instead offsetting based on the anonymous page offset of the VMA.

It is valid only for anonymous or MAP_PRIVATE file-backed mappings, in
other words CoW mappings.

For pure anon VMAs, this will be equal to linear_page_index().

Assert that both of these invariants are true In linear_anon_page_index()
and implement the algorithm in __linear_anon_page_index().

Note that MAP_PRIVATE-/dev/zero mappings will satisfy vma_is_anonymous()
but not fulfill this invariant, so when asserting this we check
vma->vm_file to account for this.

We do not update callsites yet, so no functional change intended.

Also const-ify vma_is_anonymous() to make it compatible with the
const-ified linear_anon_page_index().

While we're here, update linear_page_index() to be more succinct.

VMA userland tests are also updated accordingly.

Link: https://lore.kernel.org/20260806-b4-scalable-cow-virt-pgoff-v4-3-ab318a350404@kernel.org
Signed-off-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>
Reviewed-by: Gregory Price (Meta) <gourry@gourry.net>
Cc: Adrian Hunter <adrian.hunter@intel.com>
Cc: Alexander Deucher <alexander.deucher@amd.com>
Cc: Alexander Gordeev <agordeev@linux.ibm.com>
Cc: Alexander Shishkin <alexander.shishkin@linux.intel.com>
Cc: Alistair Popple <apopple@nvidia.com>
Cc: Arnaldo Carvalho de Melo <acme@kernel.org>
Cc: Arnd Bergmann <arnd@arndb.de>
Cc: Baolin Wang <baolin.wang@linux.alibaba.com>
Cc: Baoquan He <baoquan.he@linux.dev>
Cc: Barry Song <baohua@kernel.org>
Cc: Boris Brezillon <boris.brezillon@collabora.com>
Cc: Byungchul Park <byungchul@sk.com>
Cc: Chengming Zhou <chengming.zhou@linux.dev>
Cc: Chris Li <chrisl@kernel.org>
Cc: Christan König <christian.koenig@amd.com>
Cc: Christian Borntraeger <borntraeger@linux.ibm.com>
Cc: Claudio Imbrenda <imbrenda@linux.ibm.com>
Cc: Dave Airlie <airlied@gmail.com>
Cc: David Hildenbrand (Arm) <david@kernel.org>
Cc: Dev Jain <dev.jain@arm.com>
Cc: Gerald Schaefer <gerald.schaefer@linux.ibm.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Harry Yoo <harry@kernel.org>
Cc: Heiko Carstens <hca@linux.ibm.com>
Cc: Huang Ray <Ray.Huang@amd.com>
Cc: "Huang, Ying" <ying.huang@linux.alibaba.com>
Cc: Ian Rogers <irogers@google.com>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: James Clark <james.clark@linaro.org>
Cc: Jan Kara <jack@suse.cz>
Cc: Jann Horn <jannh@google.com>
Cc: Janosch Frank <frankja@linux.ibm.com>
Cc: Jason Gunthorpe <jgg@ziepe.ca>
Cc: Jiri Olsa <jolsa@kernel.org>
Cc: John Hubbard <jhubbard@nvidia.com>
Cc: Joshua Hahn <joshua.hahnjy@gmail.com>
Cc: Kairui Song <kasong@tencent.com>
Cc: Kees Cook <kees@kernel.org>
Cc: Kemeng Shi <shikemeng@huaweicloud.com>
Cc: Lance Yang <lance.yang@linux.dev>
Cc: Liam R. Howlett <liam@infradead.org>
Cc: Liviu Dudau <liviu.dudau@arm.com>
Cc: Maarten Lankhorst <maarten.lankhorst@linux.intel.com>
Cc: Marc Rutland <mark.rutland@arm.com>
Cc: "Masami Hiramatsu (Google)" <mhiramat@kernel.org>
Cc: Matthew Auld <matthew.auld@intel.com>
Cc: Matthew Brost <matthew.brost@intel.com>
Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: Maxime Ripard <mripard@kernel.org>
Cc: Miaohe Lin <linmiaohe@huawei.com>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Mike Rapoport <rppt@kernel.org>
Cc: Muchun Song <muchun.song@linux.dev>
Cc: Namhyung kim <namhyung@kernel.org>
Cc: Naoya Horiguchi <nao.horiguchi@gmail.com>
Cc: Nhat Pham <nphamcs@gmail.com>
Cc: Nico Pache <npache@redhat.com>
Cc: Oleg Nesterov <oleg@redhat.com>
Cc: Oscar Salvador <osalvador@suse.de>
Cc: Pedro Falcato <pfalcato@suse.de>
Cc: Peter Xu <peterx@redhat.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Rakie Kim <rakie.kim@sk.com>
Cc: Rik van Riel <riel@surriel.com>
Cc: Rodrigo Vivi <rodrigo.vivi@intel.com>
Cc: Ryan Roberts <ryan.roberts@arm.com>
Cc: Steven Price <steven.price@arm.com>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: Sven Schnelle <svens@linux.ibm.com>
Cc: <syzbot@syzkaller.appspotmail.com>
Cc: Thomas Hellström <thomas.hellstrom@linux.intel.com>
Cc: Thomas Zimemrmann <tzimmermann@suse.de>
Cc: Vasily Gorbik <gor@linux.ibm.com>
Cc: Vlastimil Babka <vbabka@kernel.org>
Cc: Xu Xin <xu.xin16@zte.com.cn>
Cc: Zi Yan <ziy@nvidia.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/mm.h              |    2 -
 include/linux/pagemap.h         |   40 +++++++++++++++++++++++++++---
 tools/testing/vma/include/dup.h |   25 ++++++++++++++++++
 3 files changed, 62 insertions(+), 5 deletions(-)

--- a/include/linux/mm.h~mm-introduce-linear_anon_page_index
+++ a/include/linux/mm.h
@@ -1556,7 +1556,7 @@ static inline void vma_desc_set_anonymou
 	desc->vm_ops = NULL;
 }
 
-static inline bool vma_is_anonymous(struct vm_area_struct *vma)
+static inline bool vma_is_anonymous(const struct vm_area_struct *vma)
 {
 	return !vma->vm_ops;
 }
--- a/include/linux/pagemap.h~mm-introduce-linear_anon_page_index
+++ a/include/linux/pagemap.h
@@ -1094,10 +1094,44 @@ static inline pgoff_t linear_page_delta(
 static inline pgoff_t linear_page_index(const struct vm_area_struct *vma,
 					const unsigned long address)
 {
-	pgoff_t pgoff;
+	return linear_page_delta(vma, address) + vma_start_pgoff(vma);
+}
+
+static inline pgoff_t __linear_anon_page_index(const struct vm_area_struct *vma,
+		const unsigned long address)
+{
+	return linear_page_delta(vma, address) + vma_start_anon_pgoff(vma);
+}
+
+/**
+ * linear_anon_page_index() - Determine the absolute anonymous page offset of
+ * @address within @vma.
+ * @vma: An anonymous or MAP_PRIVATE file-backed VMA in which @address resides.
+ * @address: The address whose absolute page offset is required.
+ *
+ * This returns the anonymous page offset of @address, which is the page offset
+ * the address possessed at the time the VMA was first faulted.
+ *
+ * For anonymous mappings, this returns the same value as linear_page_index().
+ *
+ * For MAP_PRIVATE file-backed mappings, this returns the anonymous page offset
+ * of @address, which is the page offset the address possessed at the time the
+ * VMA was first faulted.
+ *
+ * It is not valid to call this function for shared file-backed mappings.
+ *
+ * Returns: The absolute anonymous page offset of @address within @vma.
+ */
+static inline pgoff_t linear_anon_page_index(const struct vm_area_struct *vma,
+		const unsigned long address)
+{
+	const pgoff_t pgoff = __linear_anon_page_index(vma, address);
+
+	VM_WARN_ON_ONCE(!vma_is_cow_mapping(vma));
+	/* Account for MAP_PRIVATE-/dev/zero which is only semi-anonymous. */
+	if (vma_is_anonymous(vma) && !vma->vm_file)
+		VM_WARN_ON_ONCE(pgoff != linear_page_index(vma, address));
 
-	pgoff = linear_page_delta(vma, address);
-	pgoff += vma_start_pgoff(vma);
 	return pgoff;
 }
 
--- a/tools/testing/vma/include/dup.h~mm-introduce-linear_anon_page_index
+++ a/tools/testing/vma/include/dup.h
@@ -1428,7 +1428,7 @@ static inline void vma_iter_set(struct v
 	mas_set(&vmi->mas, addr);
 }
 
-static inline bool vma_is_anonymous(struct vm_area_struct *vma)
+static inline bool vma_is_anonymous(const struct vm_area_struct *vma)
 {
 	return !vma->vm_ops;
 }
@@ -1621,3 +1621,26 @@ static inline pgprot_t vma_get_page_prot
 {
 	return vma_flags_to_page_prot(vma->flags);
 }
+
+static inline pgoff_t __linear_anon_page_index(const struct vm_area_struct *vma,
+					       const unsigned long address)
+{
+	pgoff_t pgoff;
+
+	pgoff = linear_page_delta(vma, address);
+	pgoff += vma_start_anon_pgoff(vma);
+	return pgoff;
+}
+
+static inline pgoff_t linear_anon_page_index(const struct vm_area_struct *vma,
+		const unsigned long address)
+{
+	const pgoff_t pgoff = __linear_anon_page_index(vma, address);
+
+	VM_WARN_ON_ONCE(!vma_is_cow_mapping(vma));
+	/* Account for MAP_PRIVATE-/dev/zero which is only semi-anonymous. */
+	if (vma_is_anonymous(vma) && !vma->vm_file)
+		VM_WARN_ON_ONCE(pgoff != linear_page_index(vma, address));
+
+	return pgoff;
+}
_

Patches currently in -mm which might be from ljs@kernel.org are

x86-mm-pat-acquire-init_mm-write-lock-on-collapse-to-avoid-uaf.patch
x86-mm-pat-acquire-init_mm-read-lock-on-attribute-change-to-avoid-uaf.patch
x86-mm-pat-allocate-split-page-tables-as-kernel-page-tables.patch
mm-introduce-vma_flags_can_grow-and-vma_can_grow.patch
mm-vma-update-do_mmap-to-use-vma_flags_t.patch
mm-convert-__get_unmapped_area-to-use-vma_flags_t.patch
mm-update-generic_get_unmapped_area-to-use-vma_flags_t.patch
mm-prefer-mm-def_vma_flags-in-mm-logic.patch
mm-vma-convert-vm_pgprot_modify-to-use-vma_flags_t-and-rename.patch
mm-vma-rename-vma_get_page_prot-to-vma_flags_to_page_prot.patch
mm-introduce-vma_get_page_prot-and-use-it.patch
mm-vma-update-create_init_stack_vma-to-use-vma_flags_t.patch
mm-vma-convert-miscellaneous-uses-of-vma-flags-in-core-mm.patch
mm-mlock-convert-mlock-code-to-use-vma_flags_t.patch
mm-mprotect-convert-mprotect-code-to-use-vma_flags_t.patch
mm-mremap-convert-mremap-code-to-use-vma_flags_t.patch
mm-mseal-remove-superfluous-comments-fix-confusion-around-mm.patch
mm-mseal-limit-scope-of-mseal-address-zero-to-address-zero.patch
mm-mseal-remove-further-superfluous-comments-do_mseal.patch
mm-vma-introduce-vma-anon-page-offset-field-and-add-helpers.patch
mm-provide-vma_is_cow_mapping-and-remove-is_cow_mapping.patch
mm-introduce-linear_anon_page_index.patch
mm-abstract-vma_address-and-introduce-vma_anon_address.patch
mm-update-print_bad_page_map-to-show-anon-index-if-appropriate.patch
mm-introduce-and-use-vma_filebacked_address.patch
mm-vma-fix-self-merge-check-in-copy_vma.patch
tools-testing-vma-add-tests-for-copy_vma-self-merge.patch
mm-propagate-vma-anonymous-page-offset-on-map-remap-split-merge.patch
mm-rmap-track-whether-the-page-vma-mapped-pgoff-is-anonymous.patch
mm-clean-up-vma_address_end.patch
mm-huge_memory-update-remove_migration_pmd-to-accept-a-folio.patch
mm-migrate-calculate-large-folio-page-index-using-pfn.patch
mm-rmap-use-anon-pgoff-to-track-map_private-file-backed-anon-folios.patch
tools-testing-vma-expand-vma-merge-tests-to-assert-anon-pgoff.patch
tools-testing-selftests-mm-test-anonymous-page-offset-merge-behaviour.patch
mm-vma-only-permit-map_private-dev-zero-to-be-mapped-anonymous.patch
mm-vma-make-map_private-mapped-dev-zero-mappings-truly-anonymous.patch
tools-testing-vma-add-test-to-assert-map_private-dev-zero-is-anon.patch
tools-testing-selftests-mm-add-map_private-dev-zero-merge-tests.patch
mm-add-some-missing-includes-to-mm-local-headers.patch

