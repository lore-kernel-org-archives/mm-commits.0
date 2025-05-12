Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A665C253F2D
	for <mm-commits@vger.kernel.org>; Mon, 12 May 2025 23:34:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747092861; cv=none; b=QibMhrstuxsULmZwEaGkJBQymCEFf2bpV5X8RktR5fEoo/zA592xvaeQp/NiBHhSLsKrTqRqiT0MDgVPDBzNAs53+HjxcEDejRAI0UPq5nNXqfWudLGH+h2ldVK+4268GagjsqJeqJA0shpVgPzX+9pustiEgPba9gtv/L+Zd8Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747092861; c=relaxed/simple;
	bh=VltN+uP319umxFwvkht1dh7dUc4P3flW3zgR+OktAII=;
	h=Date:To:From:Subject:Message-Id; b=MzckOcW39ZOH4QqpaJM1Z9E2Ulmf9XCFabTIKSArpgMYYp0CkzQXoe9BRMvD1L7+WozSs3pyOxNO8kz25r4NhTKB1UuMwywaWpZo2hD92n8R0KsOCPLcii5a3b/Jd76K0EfcHwhXJjhi7Egh6kxpBt0af+cZsMpsXlkM0H64C88=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=CFHSxjmd; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="CFHSxjmd"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 109B1C4CEE7;
	Mon, 12 May 2025 23:34:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1747092861;
	bh=VltN+uP319umxFwvkht1dh7dUc4P3flW3zgR+OktAII=;
	h=Date:To:From:Subject:From;
	b=CFHSxjmdpCMwqv0+xm0S7umhdzML0cKr8O9RyeAvqjWCRZBFA3m7+3w/j2+cx5Aqw
	 Id97HgJNIk/bDsZxoxzpcIU7AvYU+zbm/p6D6HQijCkHtyaN9MQemFJpoQrDs3odm/
	 uSvYTbMpvwlqTbIY6/AkwUMgorEOmlo0/KIxbay8=
Date: Mon, 12 May 2025 16:34:20 -0700
To: mm-commits@vger.kernel.org,vbabka@suse.cz,tursulin@ursulin.net,tglx@linutronix.de,rostedt@goodmis.org,rodrigo.vivi@intel.com,peterz@infradead.org,peterx@redhat.com,mingo@kernel.org,mhiramat@kernel.org,mathieu.desnoyers@efficios.com,luto@kernel.org,lorenzo.stoakes@oracle.com,liam.howlett@oracle.com,joonas.lahtinen@linux.intel.com,jannh@google.com,jani.nikula@linux.intel.com,hpa@zytor.com,bp@alien8.de,airlied@gmail.com,david@redhat.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-introduce-pfnmap_track-and-pfnmap_untrack-and-use-them-for-memremap.patch added to mm-new branch
Message-Id: <20250512233421.109B1C4CEE7@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm: introduce pfnmap_track() and pfnmap_untrack() and use them for memremap
has been added to the -mm mm-new branch.  Its filename is
     mm-introduce-pfnmap_track-and-pfnmap_untrack-and-use-them-for-memremap.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-introduce-pfnmap_track-and-pfnmap_untrack-and-use-them-for-memremap.patch

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
From: David Hildenbrand <david@redhat.com>
Subject: mm: introduce pfnmap_track() and pfnmap_untrack() and use them for memremap
Date: Mon, 12 May 2025 14:34:16 +0200

Let's provide variants of track_pfn_remap() and untrack_pfn() that won't
mess with VMAs, and replace the usage in mm/memremap.c.

Add some documentation.

Link: https://lkml.kernel.org/r/20250512123424.637989-4-david@redhat.com
Signed-off-by: David Hildenbrand <david@redhat.com>
Reviewed-by: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Acked-by: Ingo Molnar <mingo@kernel.org> # x86 bits
Cc: Andy Lutomirski <luto@kernel.org>
Cc: Borislav Betkov <bp@alien8.de>
Cc: Dave Airlie <airlied@gmail.com>
Cc: "H. Peter Anvin" <hpa@zytor.com>
Cc: Jani Nikula <jani.nikula@linux.intel.com>
Cc: Jann Horn <jannh@google.com>
Cc: Jonas Lahtinen <joonas.lahtinen@linux.intel.com>
Cc: Liam Howlett <liam.howlett@oracle.com>
Cc: "Masami Hiramatsu (Google)" <mhiramat@kernel.org>
Cc: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Cc: Peter Xu <peterx@redhat.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Rodrigo Vivi <rodrigo.vivi@intel.com>
Cc: Steven Rostedt <rostedt@goodmis.org>
Cc: Thomas Gleinxer <tglx@linutronix.de>
Cc: Tvrtko Ursulin <tursulin@ursulin.net>
Cc: Vlastimil Babka <vbabka@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/x86/mm/pat/memtype.c |   14 ++++++++++++
 include/linux/pgtable.h   |   39 ++++++++++++++++++++++++++++++++++++
 mm/memremap.c             |    8 +++----
 3 files changed, 57 insertions(+), 4 deletions(-)

--- a/arch/x86/mm/pat/memtype.c~mm-introduce-pfnmap_track-and-pfnmap_untrack-and-use-them-for-memremap
+++ a/arch/x86/mm/pat/memtype.c
@@ -1068,6 +1068,20 @@ int pfnmap_setup_cachemode(unsigned long
 	return 0;
 }
 
+int pfnmap_track(unsigned long pfn, unsigned long size, pgprot_t *prot)
+{
+	const resource_size_t paddr = (resource_size_t)pfn << PAGE_SHIFT;
+
+	return reserve_pfn_range(paddr, size, prot, 0);
+}
+
+void pfnmap_untrack(unsigned long pfn, unsigned long size)
+{
+	const resource_size_t paddr = (resource_size_t)pfn << PAGE_SHIFT;
+
+	free_pfn_range(paddr, size);
+}
+
 /*
  * untrack_pfn is called while unmapping a pfnmap for a region.
  * untrack can be called for a specific region indicated by pfn and size or
--- a/include/linux/pgtable.h~mm-introduce-pfnmap_track-and-pfnmap_untrack-and-use-them-for-memremap
+++ a/include/linux/pgtable.h
@@ -1502,6 +1502,16 @@ static inline int pfnmap_setup_cachemode
 	return 0;
 }
 
+static inline int pfnmap_track(unsigned long pfn, unsigned long size,
+		pgprot_t *prot)
+{
+	return 0;
+}
+
+static inline void pfnmap_untrack(unsigned long pfn, unsigned long size)
+{
+}
+
 /*
  * track_pfn_copy is called when a VM_PFNMAP VMA is about to get the page
  * tables copied during copy_page_range(). Will store the pfn to be
@@ -1575,6 +1585,35 @@ extern int track_pfn_remap(struct vm_are
  */
 int pfnmap_setup_cachemode(unsigned long pfn, unsigned long size,
 		pgprot_t *prot);
+
+/**
+ * pfnmap_track - track a pfn range
+ * @pfn: the start of the pfn range
+ * @size: the size of the pfn range in bytes
+ * @prot: the pgprot to track
+ *
+ * Requested the pfn range to be 'tracked' by a hardware implementation and
+ * setup the cachemode in @prot similar to pfnmap_setup_cachemode().
+ *
+ * This allows for fine-grained control of memory cache behaviour at page
+ * level granularity. Tracking memory this way is persisted across VMA splits
+ * (VMA merging does not apply for VM_PFNMAP).
+ *
+ * Currently, there is only one implementation for this - x86 Page Attribute
+ * Table (PAT). See Documentation/arch/x86/pat.rst for more details.
+ *
+ * Returns 0 on success and -EINVAL on error.
+ */
+int pfnmap_track(unsigned long pfn, unsigned long size, pgprot_t *prot);
+
+/**
+ * pfnmap_untrack - untrack a pfn range
+ * @pfn: the start of the pfn range
+ * @size: the size of the pfn range in bytes
+ *
+ * Untrack a pfn range previously tracked through pfnmap_track().
+ */
+void pfnmap_untrack(unsigned long pfn, unsigned long size);
 extern int track_pfn_copy(struct vm_area_struct *dst_vma,
 		struct vm_area_struct *src_vma, unsigned long *pfn);
 extern void untrack_pfn_copy(struct vm_area_struct *dst_vma,
--- a/mm/memremap.c~mm-introduce-pfnmap_track-and-pfnmap_untrack-and-use-them-for-memremap
+++ a/mm/memremap.c
@@ -130,7 +130,7 @@ static void pageunmap_range(struct dev_p
 	}
 	mem_hotplug_done();
 
-	untrack_pfn(NULL, PHYS_PFN(range->start), range_len(range), true);
+	pfnmap_untrack(PHYS_PFN(range->start), range_len(range));
 	pgmap_array_delete(range);
 }
 
@@ -211,8 +211,8 @@ static int pagemap_range(struct dev_page
 	if (nid < 0)
 		nid = numa_mem_id();
 
-	error = track_pfn_remap(NULL, &params->pgprot, PHYS_PFN(range->start), 0,
-			range_len(range));
+	error = pfnmap_track(PHYS_PFN(range->start), range_len(range),
+			     &params->pgprot);
 	if (error)
 		goto err_pfn_remap;
 
@@ -277,7 +277,7 @@ err_add_memory:
 	if (!is_private)
 		kasan_remove_zero_shadow(__va(range->start), range_len(range));
 err_kasan:
-	untrack_pfn(NULL, PHYS_PFN(range->start), range_len(range), true);
+	pfnmap_untrack(PHYS_PFN(range->start), range_len(range));
 err_pfn_remap:
 	pgmap_array_delete(range);
 	return error;
_

Patches currently in -mm which might be from david@redhat.com are

selftests-mm-add-simple-vm_pfnmap-tests-based-on-mmaping-dev-mem.patch
x86-mm-pat-factor-out-setting-cachemode-into-pgprot_set_cachemode.patch
mm-convert-track_pfn_insert-to-pfnmap_setup_cachemode.patch
mm-introduce-pfnmap_track-and-pfnmap_untrack-and-use-them-for-memremap.patch
mm-convert-vm_pfnmap-tracking-to-pfnmap_track-pfnmap_untrack.patch
x86-mm-pat-remove-old-pfnmap-tracking-interface.patch
mm-remove-vm_pat.patch
x86-mm-pat-remove-strict_prot-parameter-from-reserve_pfn_range.patch
x86-mm-pat-remove-memtype__match.patch
x86-mm-pat-inline-memtype_match-into-memtype_erase.patch
drm-i915-track_pfn-pfnmap-tracking.patch
mm-io-mapping-track_pfn-pfnmap-tracking.patch

