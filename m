Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 42F521BD01F
	for <mm-commits@vger.kernel.org>; Tue, 14 Jan 2025 06:45:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736837137; cv=none; b=pmaSiJhWa7yboaSketGSxyqafuBHezdy59L+iBT6E5EYYUUa73LlDzbGVgXwPNMxK5960EAndHAAgRreZDVdYJ17ffLEP//rp6Vz2cAXyp8/mGEas4oeIugd5F5S4KlmLsHQyyj5mv91XWL0UQ0YUwRgHprfhuh1ehwXK9QNA4o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736837137; c=relaxed/simple;
	bh=8IleV2qIq1leeQFcJGWXBFLeGU99hJzrhZVTTOwIIuI=;
	h=Date:To:From:Subject:Message-Id; b=mOsVkJOEkIXlIigapnabsP10qEYbVdfEvesj0I9gM4WdkFZVYQ+M9EGaqMgPf2uHdTUzMqLOUVdIeiOyz+9kY38CZDmlok0Wk+mhbV4nEr6/hrPFaMY8XY8LSrRScZoaU78vKid7WbB9UcP+S2iCyjl20Ho/Za1r2HPAa6+OcN4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=riYtn0nl; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="riYtn0nl"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AD070C4CEDD;
	Tue, 14 Jan 2025 06:45:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1736837136;
	bh=8IleV2qIq1leeQFcJGWXBFLeGU99hJzrhZVTTOwIIuI=;
	h=Date:To:From:Subject:From;
	b=riYtn0nlEbti+m8r1QmNXjsSoXOjXsyOIrqCL5vV7rv8mKsVF5MCbBlArYivkiGrE
	 ehNO4K8okLXEq2+lMWTy2XygqH5Jw838ZULLDkjM0onelMuNw6Cl8QhzvJqVuJxEme
	 Vlx9Nl9aJUEmXrIDIOC4B1lJWYsivyPcj2hcYW1Q=
Date: Mon, 13 Jan 2025 22:45:36 -0800
To: mm-commits@vger.kernel.org,willy@infradead.org,vbabka@suse.cz,Liam.Howlett@Oracle.com,jannh@google.com,david@redhat.com,lorenzo.stoakes@oracle.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-debug-introduce-vm_warn_on_vmg-to-dump-vma-merge-state.patch removed from -mm tree
Message-Id: <20250114064536.AD070C4CEDD@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/debug: introduce VM_WARN_ON_VMG() to dump VMA merge state
has been removed from the -mm tree.  Its filename was
     mm-debug-introduce-vm_warn_on_vmg-to-dump-vma-merge-state.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Subject: mm/debug: introduce VM_WARN_ON_VMG() to dump VMA merge state
Date: Fri, 3 Jan 2025 19:35:35 +0000

Patch series "mm/debug: introduce and use VM_WARN_ON_VMG()".

We use a number of asserts, enabled only when CONFIG_DEBUG_VM is set,
during VMA merge operations to ensure state is as expected.

However, when syzkaller or the like encounters these asserts, often the
information provided by the report is insufficient to narrow down what the
problem is.

We noticed this recently in [0], where a non-repro issue resisted
debugging due to simply not having sufficient information to go on.

This series improves the situation by providing VM_WARN_ON_VMG() which
acts like VM_WARN_ON() (i.e.  only actually being invoked if
CONFIG_DEBUG_VM is set), while dumping significant information about the
VMA merge state, the mm_struct describing the virtual address space, all
associated VMAs and, if CONFIG_DEBUG_VM_MAPLE_TREE is set, the associated
maple tree.

[0]:https://lore.kernel.org/all/6774c98f.050a0220.25abdd.0991.GAE@google.com/


This patch (of 2):

We use a number of asserts, enabled only when CONFIG_DEBUG_VM is set,
during VMA merge operations to ensure state is as expected.

However, when syzkaller or the like encounters these asserts, often the
information provided by the report is insufficient to narrow down what the
problem is.

This might not be so much of an issue if the reported problem is
reproducible, but if it is a rarely encountered race or some other case
which precludes a repro, it is a very big problem (see [0] for the
motivating case).

It is therefore sensible to provide a means by which we can easily and
conveniently dump a lot more information in these circumstances.

The aggregation of merge state into a single struct threaded through the
operation makes this trivial - we can simply introduce a variant on
VM_WARN_ON() which takes the VMA merge state object (vmg) and use that to
dump information.

This patch therefore introduces VM_WARN_ON_VMG() which provides this
functionality.

It additionally dumps full mm state, VMA state for each of the three VMAs
the vmg contains (prev, next, vma) and if CONFIG_DEBUG_VM_MAPLE_TREE is
enabled, dumps the maple tree from the provided VMA iterator if non-NULL.

This patch has no functional impact if CONFIG_DEBUG_VM is not set.

[0]:https://lore.kernel.org/all/6774c98f.050a0220.25abdd.0991.GAE@google.com/

Link: https://lkml.kernel.org/r/cover.1735932169.git.lorenzo.stoakes@oracle.com
Link: https://lkml.kernel.org/r/13b09b52d4d103ee86acaf0ae612539648ae29e0.1735932169.git.lorenzo.stoakes@oracle.com
Signed-off-by: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Cc: David Hildenbrand <david@redhat.com>
Cc: Jann Horn <jannh@google.com>
Cc: Liam R. Howlett <Liam.Howlett@Oracle.com>
Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: Vlastimil Babka <vbabka@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/mmdebug.h |   14 ++++++-
 mm/debug.c              |   71 ++++++++++++++++++++++++++++++++++++++
 2 files changed, 84 insertions(+), 1 deletion(-)

--- a/include/linux/mmdebug.h~mm-debug-introduce-vm_warn_on_vmg-to-dump-vma-merge-state
+++ a/include/linux/mmdebug.h
@@ -9,10 +9,12 @@ struct page;
 struct vm_area_struct;
 struct mm_struct;
 struct vma_iterator;
+struct vma_merge_struct;
 
 void dump_page(const struct page *page, const char *reason);
 void dump_vma(const struct vm_area_struct *vma);
 void dump_mm(const struct mm_struct *mm);
+void dump_vmg(const struct vma_merge_struct *vmg, const char *reason);
 void vma_iter_dump_tree(const struct vma_iterator *vmi);
 
 #ifdef CONFIG_DEBUG_VM
@@ -87,6 +89,15 @@ void vma_iter_dump_tree(const struct vma
 	}								\
 	unlikely(__ret_warn_once);					\
 })
+#define VM_WARN_ON_VMG(cond, vmg)		({			\
+	int __ret_warn = !!(cond);					\
+									\
+	if (unlikely(__ret_warn)) {					\
+		dump_vmg(vmg, "VM_WARN_ON_VMG(" __stringify(cond)")");	\
+		WARN_ON(1);						\
+	}								\
+	unlikely(__ret_warn);						\
+})
 
 #define VM_WARN_ON(cond) (void)WARN_ON(cond)
 #define VM_WARN_ON_ONCE(cond) (void)WARN_ON_ONCE(cond)
@@ -104,9 +115,10 @@ void vma_iter_dump_tree(const struct vma
 #define VM_WARN_ON_FOLIO(cond, folio)  BUILD_BUG_ON_INVALID(cond)
 #define VM_WARN_ON_ONCE_FOLIO(cond, folio)  BUILD_BUG_ON_INVALID(cond)
 #define VM_WARN_ON_ONCE_MM(cond, mm)  BUILD_BUG_ON_INVALID(cond)
+#define VM_WARN_ON_VMG(cond, vmg)  BUILD_BUG_ON_INVALID(cond)
 #define VM_WARN_ONCE(cond, format...) BUILD_BUG_ON_INVALID(cond)
 #define VM_WARN(cond, format...) BUILD_BUG_ON_INVALID(cond)
-#endif
+#endif /* CONFIG_DEBUG_VM */
 
 #ifdef CONFIG_DEBUG_VM_IRQSOFF
 #define VM_WARN_ON_IRQS_ENABLED() WARN_ON_ONCE(!irqs_disabled())
--- a/mm/debug.c~mm-debug-introduce-vm_warn_on_vmg-to-dump-vma-merge-state
+++ a/mm/debug.c
@@ -249,6 +249,77 @@ void dump_mm(const struct mm_struct *mm)
 }
 EXPORT_SYMBOL(dump_mm);
 
+void dump_vmg(const struct vma_merge_struct *vmg, const char *reason)
+{
+	if (reason)
+		pr_warn("vmg %px dumped because: %s\n", vmg, reason);
+
+	if (!vmg) {
+		pr_warn("vmg %px state: (NULL)\n", vmg);
+		return;
+	}
+
+	pr_warn("vmg %px state: mm %px pgoff %lx\n"
+		"vmi %px [%lx,%lx)\n"
+		"prev %px next %px vma %px\n"
+		"start %lx end %lx flags %lx\n"
+		"file %px anon_vma %px policy %px\n"
+		"uffd_ctx %px\n"
+		"anon_name %px\n"
+		"merge_flags %x state %x\n",
+		vmg, vmg->mm, vmg->pgoff,
+		vmg->vmi, vmg->vmi ? vma_iter_addr(vmg->vmi) : 0,
+		vmg->vmi ? vma_iter_end(vmg->vmi) : 0,
+		vmg->prev, vmg->next, vmg->vma,
+		vmg->start, vmg->end, vmg->flags,
+		vmg->file, vmg->anon_vma, vmg->policy,
+#ifdef CONFIG_USERFAULTFD
+		vmg->uffd_ctx.ctx,
+#else
+		(void *)0,
+#endif
+		vmg->anon_name,
+		(int)vmg->merge_flags, (int)vmg->state);
+
+	if (vmg->mm) {
+		pr_warn("vmg %px mm:\n", vmg);
+		dump_mm(vmg->mm);
+	} else {
+		pr_warn("vmg %px mm: (NULL)\n", vmg);
+	}
+
+	if (vmg->vma) {
+		pr_warn("vmg %px vma:\n", vmg);
+		dump_vma(vmg->vma);
+	} else {
+		pr_warn("vmg %px vma: (NULL)\n", vmg);
+	}
+
+	if (vmg->prev) {
+		pr_warn("vmg %px prev:\n", vmg);
+		dump_vma(vmg->prev);
+	} else {
+		pr_warn("vmg %px prev: (NULL)\n", vmg);
+	}
+
+	if (vmg->next) {
+		pr_warn("vmg %px next:\n", vmg);
+		dump_vma(vmg->next);
+	} else {
+		pr_warn("vmg %px next: (NULL)\n", vmg);
+	}
+
+#ifdef CONFIG_DEBUG_VM_MAPLE_TREE
+	if (vmg->vmi) {
+		pr_warn("vmg %px vmi:\n", vmg);
+		vma_iter_dump_tree(vmg->vmi);
+	} else {
+		pr_warn("vmg %px vmi: (NULL)\n", vmg);
+	}
+#endif
+}
+EXPORT_SYMBOL(dump_vmg);
+
 static bool page_init_poisoning __read_mostly = true;
 
 static int __init setup_vm_debug(char *str)
_

Patches currently in -mm which might be from lorenzo.stoakes@oracle.com are

mips-vdso-prefer-do_mmap-to-mmap_region.patch
mm-make-mmap_region-internal.patch

