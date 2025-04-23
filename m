Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1F7C913C81B
	for <mm-commits@vger.kernel.org>; Wed, 23 Apr 2025 21:49:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745444974; cv=none; b=NPXZlFRXxrBg4BGYlqeUVYr6mBCm22L3ExFknr7Xg1qwEzfXV1olfQDJrP8etYxTX+dfi6V6QYgB0u8dF233IK/XfFda9AnBi2W3SXvy7iHW6zjygjsdWieooTM5BZgb6F3rXfxZs32HLzAP1EF6/KRgXUVmWii2sFPLc5cJzM0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745444974; c=relaxed/simple;
	bh=ZguIgNv34luIyDQkeoxR3k9jQv9kmDgr9ZACo1WtHJY=;
	h=Date:To:From:Subject:Message-Id; b=aP+f7AEfmJqI/vmMBrJImgmjtEhsjZmdBvQNl3mYNIFYSrvvtYB0Mnt2Uh4nyI8NKHlcsvVei0niOPtmPbzhYO/+fA/nx5FCS/Kek6XtXVPyvRqcc4CNzrOwa+4rnCKboTrbc/EnVuHi7XPhyLrWKX36Vi2JgEYmgBIbZi74RWk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=EPLgdNXu; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="EPLgdNXu"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D67B5C4CEEA;
	Wed, 23 Apr 2025 21:49:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1745444974;
	bh=ZguIgNv34luIyDQkeoxR3k9jQv9kmDgr9ZACo1WtHJY=;
	h=Date:To:From:Subject:From;
	b=EPLgdNXuFqSsfQu35DDf1UgwntVgOl1AXzqIRZduQVu1Q48cZeoWBrZ8F7s8t8lwf
	 ZnxpDQfyTHqVwEoXi8zOmhxsoWu1sklCfrijh91U6QKqkA30J+ttJnfTElJuHpgzHr
	 ZjLB+DZxntY7s5o3dSIy7kt6XSQqYKZNlGFZ7rqU=
Date: Wed, 23 Apr 2025 14:49:33 -0700
To: mm-commits@vger.kernel.org,will@kernel.org,rppt@kernel.org,maz@kernel.org,mark.rutland@arm.com,lrh2000@pku.edu.cn,david@redhat.com,catalin.marinas@arm.com,ardb@kernel.org,anshuman.khandual@arm.com,dwmw@amazon.co.uk,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-implement-for_each_valid_pfn-for-config_sparsemem.patch added to mm-new branch
Message-Id: <20250423214933.D67B5C4CEEA@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm: implement for_each_valid_pfn() for CONFIG_SPARSEMEM
has been added to the -mm mm-new branch.  Its filename is
     mm-implement-for_each_valid_pfn-for-config_sparsemem.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-implement-for_each_valid_pfn-for-config_sparsemem.patch

This patch will later appear in the mm-new branch at
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
From: David Woodhouse <dwmw@amazon.co.uk>
Subject: mm: implement for_each_valid_pfn() for CONFIG_SPARSEMEM
Date: Wed, 23 Apr 2025 14:33:39 +0100

Implement for_each_valid_pfn() based on two helper functions.

The first_valid_pfn() function largely mirrors pfn_valid(), calling into a
pfn_section_first_valid() helper which is trivial for the !VMEMMAP case,
and in the VMEMMAP case will skip to the next subsection as needed.

Since next_valid_pfn() knows that its argument *is* a valid PFN, it
doesn't need to do any checking at all while iterating over the low bits
within a (sub)section mask; the whole (sub)section is either present or
not.

Note that the VMEMMAP version of pfn_section_first_valid() may return a
value *higher* than end_pfn when skipping to the next subsection, and
first_valid_pfn() happily returns that higher value.  This is fine.

Link: https://lkml.kernel.org/r/20250423133821.789413-4-dwmw2@infradead.org
Signed-off-by: David Woodhouse <dwmw@amazon.co.uk>
Reviewed-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
Cc: Anshuman Khandual <anshuman.khandual@arm.com>
Cc: Ard Biesheuvel <ardb@kernel.org>
Cc: Catalin Marinas <catalin.marinas@arm.com>
Cc: David Hildenbrand <david@redhat.com>
Cc: Marc Rutland <mark.rutland@arm.com>
Cc: Marc Zyngier <maz@kernel.org>
Cc: Ruihan Li <lrh2000@pku.edu.cn>
Cc: Will Deacon <will@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/mmzone.h |   78 +++++++++++++++++++++++++++++++++++++++
 1 file changed, 78 insertions(+)

--- a/include/linux/mmzone.h~mm-implement-for_each_valid_pfn-for-config_sparsemem
+++ a/include/linux/mmzone.h
@@ -2075,11 +2075,37 @@ static inline int pfn_section_valid(stru
 
 	return usage ? test_bit(idx, usage->subsection_map) : 0;
 }
+
+static inline bool pfn_section_first_valid(struct mem_section *ms, unsigned long *pfn)
+{
+	struct mem_section_usage *usage = READ_ONCE(ms->usage);
+	int idx = subsection_map_index(*pfn);
+	unsigned long bit;
+
+	if (!usage)
+		return false;
+
+	if (test_bit(idx, usage->subsection_map))
+		return true;
+
+	/* Find the next subsection that exists */
+	bit = find_next_bit(usage->subsection_map, SUBSECTIONS_PER_SECTION, idx);
+	if (bit == SUBSECTIONS_PER_SECTION)
+		return false;
+
+	*pfn = (*pfn & PAGE_SECTION_MASK) + (bit * PAGES_PER_SUBSECTION);
+	return true;
+}
 #else
 static inline int pfn_section_valid(struct mem_section *ms, unsigned long pfn)
 {
 	return 1;
 }
+
+static inline bool pfn_section_first_valid(struct mem_section *ms, unsigned long *pfn)
+{
+	return true;
+}
 #endif
 
 void sparse_init_early_section(int nid, struct page *map, unsigned long pnum,
@@ -2128,6 +2154,58 @@ static inline int pfn_valid(unsigned lon
 
 	return ret;
 }
+
+/* Returns end_pfn or higher if no valid PFN remaining in range */
+static inline unsigned long first_valid_pfn(unsigned long pfn, unsigned long end_pfn)
+{
+	unsigned long nr = pfn_to_section_nr(pfn);
+
+	rcu_read_lock_sched();
+
+	while (nr <= __highest_present_section_nr && pfn < end_pfn) {
+		struct mem_section *ms = __pfn_to_section(pfn);
+
+		if (valid_section(ms) &&
+		    (early_section(ms) || pfn_section_first_valid(ms, &pfn))) {
+			rcu_read_unlock_sched();
+			return pfn;
+		}
+
+		/* Nothing left in this section? Skip to next section */
+		nr++;
+		pfn = section_nr_to_pfn(nr);
+	}
+
+	rcu_read_unlock_sched();
+	return end_pfn;
+}
+
+static inline unsigned long next_valid_pfn(unsigned long pfn, unsigned long end_pfn)
+{
+	pfn++;
+
+	if (pfn >= end_pfn)
+		return end_pfn;
+
+	/*
+	 * Either every PFN within the section (or subsection for VMEMMAP) is
+	 * valid, or none of them are. So there's no point repeating the check
+	 * for every PFN; only call first_valid_pfn() the first time, and when
+	 * crossing a (sub)section boundary (i.e. !(pfn & ~PFN_VALID_MASK)).
+	 */
+	if (pfn & (IS_ENABLED(CONFIG_SPARSEMEM_VMEMMAP) ?
+		   PAGE_SUBSECTION_MASK : PAGE_SECTION_MASK))
+		return pfn;
+
+	return first_valid_pfn(pfn, end_pfn);
+}
+
+
+#define for_each_valid_pfn(_pfn, _start_pfn, _end_pfn)			\
+	for ((_pfn) = first_valid_pfn((_start_pfn), (_end_pfn));	\
+	     (_pfn) < (_end_pfn);					\
+	     (_pfn) = next_valid_pfn((_pfn), (_end_pfn)))
+
 #endif
 
 static inline int pfn_in_present_section(unsigned long pfn)
_

Patches currently in -mm which might be from dwmw@amazon.co.uk are

mm-introduce-for_each_valid_pfn-and-use-it-from-reserve_bootmem_region.patch
mm-implement-for_each_valid_pfn-for-config_flatmem.patch
mm-implement-for_each_valid_pfn-for-config_sparsemem.patch
mm-pm-use-for_each_valid_pfn-in-kernel-power-snapshotc.patch
mm-x86-use-for_each_valid_pfn-from-__ioremap_check_ram.patch
mm-use-for_each_valid_pfn-in-memory_hotplug.patch
mm-mm_init-use-for_each_valid_pfn-in-init_unavailable_range.patch

