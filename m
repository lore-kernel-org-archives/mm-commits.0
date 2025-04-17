Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F00E541C63
	for <mm-commits@vger.kernel.org>; Thu, 17 Apr 2025 23:22:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744932154; cv=none; b=hwbjJ0uraUnITJ85Y7pVWFe7x9aBk6sveTCQFZPYQs6pdHaclaIxjUvGTg/7XAh1G2KJhZk9om1uuLoGWKY8XVYSeZnN8MXxEOUZilPPgGkQNdMvzygH2c0oKU2UmCuQF1FNuv2xBYnb2HBVHSJdYmiGIW/HyMm17m6DDpcC/fA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744932154; c=relaxed/simple;
	bh=3cEovQ6mZvNgSwPgzbygChkdNLsvRgxm1FEp924VjQk=;
	h=Date:To:From:Subject:Message-Id; b=hg+oCi8TQKUZDjHPIVi9tblxwesBptrsg+kbhACaxyp+LzC1jn9IH1j/uNl0zeIq0i5F3ID+oHQJS2uNP/4s8Zps/6caUGCC1lcobgdabUNfzhByxK8/49gtbcDoxEAkYV3rNVbZU5LUcPWx384aa4fwN7iwljMWMXr3XhQrRsk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=siIJzAHA; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="siIJzAHA"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2773DC4CEE4;
	Thu, 17 Apr 2025 23:22:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1744932153;
	bh=3cEovQ6mZvNgSwPgzbygChkdNLsvRgxm1FEp924VjQk=;
	h=Date:To:From:Subject:From;
	b=siIJzAHAEToizMdDaDMOrJeh6+6Gvrx7nlHFNWcWUDidvyjRYi4jbOml7tmB4oS+7
	 iG+iP+gddEzlRXkYQdb9uFRtFTMvHKA1GTu09X8lDhgtnLvWiNAkRRINaJd1lnB03V
	 h39dTHzxUyKWQHUzqR70hNW8JplJOMl2CIYEdAGQ=
Date: Thu, 17 Apr 2025 16:22:32 -0700
To: mm-commits@vger.kernel.org,zokeefe@google.com,ziy@nvidia.com,yang@os.amperecomputing.com,willy@infradead.org,will@kernel.org,wangkefeng.wang@huawei.com,vishal.moola@gmail.com,usamaarif642@gmail.com,tiwai@suse.de,thomas.hellstrom@linux.intel.com,surenb@google.com,sunnanyong@huawei.com,shuah@kernel.org,ryan.roberts@arm.com,rostedt@goodmis.org,rientjes@google.com,rdunlap@infradead.org,raquini@redhat.com,peterx@redhat.com,mhocko@suse.com,mhiramat@kernel.org,mathieu.desnoyers@efficios.com,kirill.shutemov@linux.intel.com,jack@suse.cz,hannes@cmpxchg.org,dev.jain@arm.com,david@redhat.com,corbet@lwn.net,cl@gentwo.org,catalin.marinas@arm.com,baolin.wang@linux.alibaba.com,baohua@kernel.org,anshuman.khandual@arm.com,aarcange@redhat.com,npache@redhat.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-defer-thp-insertion-to-khugepaged.patch added to mm-new branch
Message-Id: <20250417232233.2773DC4CEE4@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm: defer THP insertion to khugepaged
has been added to the -mm mm-new branch.  Its filename is
     mm-defer-thp-insertion-to-khugepaged.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-defer-thp-insertion-to-khugepaged.patch

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
From: Nico Pache <npache@redhat.com>
Subject: mm: defer THP insertion to khugepaged
Date: Wed, 16 Apr 2025 18:18:43 -0600

Patch series "mm: introduce THP deferred setting", v4.

This series is a follow-up to [1], which adds mTHP support to khugepaged. 
mTHP khugepaged support is a "loose" dependency for the sysfs/sysctl
configs to make sense.  Without it global="defer" and mTHP="inherit" case
is "undefined" behavior.

We've seen cases where customers switching from RHEL7 to RHEL8 see a
significant increase in the memory footprint for the same workloads.

Through our investigations we found that a large contributing factor to
the increase in RSS was an increase in THP usage.

For workloads like MySQL, or when using allocators like jemalloc, it is
often recommended to set /transparent_hugepages/enabled=never.  This is in
part due to performance degradations and increased memory waste.

This series introduces enabled=defer, this setting acts as a middle ground
between always and madvise.  If the mapping is MADV_HUGEPAGE, the page
fault handler will act normally, making a hugepage if possible.  If the
allocation is not MADV_HUGEPAGE, then the page fault handler will default
to the base size allocation.  The caveat is that khugepaged can still
operate on pages thats not MADV_HUGEPAGE.

This allows for three things...  one, applications specifically designed
to use hugepages will get them, and two, applications that don't use
hugepages can still benefit from them without aggressively inserting THPs
at every possible chance.  This curbs the memory waste, and defers the use
of hugepages to khugepaged.  Khugepaged can then scan the memory for
eligible collapsing.  Lastly there is the added benefit for those who want
THPs but experience higher latency PFs.  Now you can get base page
performance at the PF handler and Hugepage performance for those mappings
after they collapse.

Admins may want to lower max_ptes_none, if not, khugepaged may
aggressively collapse single allocations into hugepages.


This patch (of 4):

Setting /transparent_hugepages/enabled=always allows applications to
benefit from THPs without having to madvise.  However, the pf handler
takes very few considerations to decide weather or not to actually use a
THP.  This can lead to a lot of wasted memory.  khugepaged only operates
on memory that was either allocated with enabled=always or MADV_HUGEPAGE.

Introduce the ability to set enabled=defer, which will prevent THPs from
being allocated by the page fault handler unless madvise is set, leaving
it up to khugepaged to decide which allocations will collapse to a THP. 
This should allow applications to benefits from THPs, while curbing some
of the memory waste.

Link: https://lkml.kernel.org/r/20250417001846.81480-1-npache@redhat.com
Link: https://lore.kernel.org/lkml/20250417000238.74567-1-npache@redhat.com/ [1]
Link: https://lkml.kernel.org/r/20250417001846.81480-2-npache@redhat.com
Co-developed-by: Rafael Aquini <raquini@redhat.com>
Signed-off-by: Rafael Aquini <raquini@redhat.com>
Signed-off-by: Nico Pache <npache@redhat.com>
Cc: Andrea Arcangeli <aarcange@redhat.com>
Cc: Anshuman Khandual <anshuman.khandual@arm.com>
Cc: Baolin Wang <baolin.wang@linux.alibaba.com>
Cc: Barry Song <baohua@kernel.org>
Cc: Catalin Marinas <catalin.marinas@arm.com>
Cc: Christoph Lameter (Ampere) <cl@gentwo.org>
Cc: David Hildenbrand <david@redhat.com>
Cc: David Rientjes <rientjes@google.com>
Cc: Dev Jain <dev.jain@arm.com>
Cc: Jan Kara <jack@suse.cz>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Jonathan Corbet <corbet@lwn.net>
Cc: Kefeng Wang <wangkefeng.wang@huawei.com>
Cc: Kirill A. Shuemov <kirill.shutemov@linux.intel.com>
Cc: "Masami Hiramatsu (Google)" <mhiramat@kernel.org>
Cc: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Nanyong Sun <sunnanyong@huawei.com>
Cc: Peter Xu <peterx@redhat.com>
Cc: Randy Dunlap <rdunlap@infradead.org>
Cc: Reported-by:Takashi Iwai <tiwai@suse.de>
Cc: Ryan Roberts <ryan.roberts@arm.com>
Cc: Shuah Khan <shuah@kernel.org>
Cc: Steven Rostedt <rostedt@goodmis.org>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: Thomas Hellstrom <thomas.hellstrom@linux.intel.com>
Cc: Usama Arif <usamaarif642@gmail.com>
Cc: Vishal Moola (Oracle) <vishal.moola@gmail.com>
Cc: Will Deacon <will@kernel.org>
Cc: Yang Shi <yang@os.amperecomputing.com>
Cc: Zach O'Keefe <zokeefe@google.com>
Cc: Zi Yan <ziy@nvidia.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/huge_mm.h |   15 +++++++++++++--
 mm/huge_memory.c        |   31 +++++++++++++++++++++++++++----
 2 files changed, 40 insertions(+), 6 deletions(-)

--- a/include/linux/huge_mm.h~mm-defer-thp-insertion-to-khugepaged
+++ a/include/linux/huge_mm.h
@@ -48,6 +48,7 @@ enum transparent_hugepage_flag {
 	TRANSPARENT_HUGEPAGE_UNSUPPORTED,
 	TRANSPARENT_HUGEPAGE_FLAG,
 	TRANSPARENT_HUGEPAGE_REQ_MADV_FLAG,
+	TRANSPARENT_HUGEPAGE_DEFER_PF_INST_FLAG,
 	TRANSPARENT_HUGEPAGE_DEFRAG_DIRECT_FLAG,
 	TRANSPARENT_HUGEPAGE_DEFRAG_KSWAPD_FLAG,
 	TRANSPARENT_HUGEPAGE_DEFRAG_KSWAPD_OR_MADV_FLAG,
@@ -186,6 +187,7 @@ static inline bool hugepage_global_enabl
 {
 	return transparent_hugepage_flags &
 			((1<<TRANSPARENT_HUGEPAGE_FLAG) |
+			(1<<TRANSPARENT_HUGEPAGE_DEFER_PF_INST_FLAG) |
 			(1<<TRANSPARENT_HUGEPAGE_REQ_MADV_FLAG));
 }
 
@@ -195,6 +197,12 @@ static inline bool hugepage_global_alway
 			(1<<TRANSPARENT_HUGEPAGE_FLAG);
 }
 
+static inline bool hugepage_global_defer(void)
+{
+	return transparent_hugepage_flags &
+			(1<<TRANSPARENT_HUGEPAGE_DEFER_PF_INST_FLAG);
+}
+
 static inline int highest_order(unsigned long orders)
 {
 	return fls_long(orders) - 1;
@@ -291,13 +299,16 @@ unsigned long thp_vma_allowable_orders(s
 				       unsigned long tva_flags,
 				       unsigned long orders)
 {
+	if ((tva_flags & TVA_IN_PF) && hugepage_global_defer() &&
+			!(vm_flags & VM_HUGEPAGE))
+		return 0;
+
 	/* Optimization to check if required orders are enabled early. */
 	if ((tva_flags & TVA_ENFORCE_SYSFS) && vma_is_anonymous(vma)) {
 		unsigned long mask = READ_ONCE(huge_anon_orders_always);
-
 		if (vm_flags & VM_HUGEPAGE)
 			mask |= READ_ONCE(huge_anon_orders_madvise);
-		if (hugepage_global_always() ||
+		if (hugepage_global_always() || hugepage_global_defer() ||
 		    ((vm_flags & VM_HUGEPAGE) && hugepage_global_enabled()))
 			mask |= READ_ONCE(huge_anon_orders_inherit);
 
--- a/mm/huge_memory.c~mm-defer-thp-insertion-to-khugepaged
+++ a/mm/huge_memory.c
@@ -297,12 +297,15 @@ static ssize_t enabled_show(struct kobje
 	const char *output;
 
 	if (test_bit(TRANSPARENT_HUGEPAGE_FLAG, &transparent_hugepage_flags))
-		output = "[always] madvise never";
+		output = "[always] madvise defer never";
 	else if (test_bit(TRANSPARENT_HUGEPAGE_REQ_MADV_FLAG,
 			  &transparent_hugepage_flags))
-		output = "always [madvise] never";
+		output = "always [madvise] defer never";
+	else if (test_bit(TRANSPARENT_HUGEPAGE_DEFER_PF_INST_FLAG,
+			  &transparent_hugepage_flags))
+		output = "always madvise [defer] never";
 	else
-		output = "always madvise [never]";
+		output = "always madvise defer [never]";
 
 	return sysfs_emit(buf, "%s\n", output);
 }
@@ -315,13 +318,20 @@ static ssize_t enabled_store(struct kobj
 
 	if (sysfs_streq(buf, "always")) {
 		clear_bit(TRANSPARENT_HUGEPAGE_REQ_MADV_FLAG, &transparent_hugepage_flags);
+		clear_bit(TRANSPARENT_HUGEPAGE_DEFER_PF_INST_FLAG, &transparent_hugepage_flags);
 		set_bit(TRANSPARENT_HUGEPAGE_FLAG, &transparent_hugepage_flags);
+	} else if (sysfs_streq(buf, "defer")) {
+		clear_bit(TRANSPARENT_HUGEPAGE_FLAG, &transparent_hugepage_flags);
+		clear_bit(TRANSPARENT_HUGEPAGE_REQ_MADV_FLAG, &transparent_hugepage_flags);
+		set_bit(TRANSPARENT_HUGEPAGE_DEFER_PF_INST_FLAG, &transparent_hugepage_flags);
 	} else if (sysfs_streq(buf, "madvise")) {
 		clear_bit(TRANSPARENT_HUGEPAGE_FLAG, &transparent_hugepage_flags);
+		clear_bit(TRANSPARENT_HUGEPAGE_DEFER_PF_INST_FLAG, &transparent_hugepage_flags);
 		set_bit(TRANSPARENT_HUGEPAGE_REQ_MADV_FLAG, &transparent_hugepage_flags);
 	} else if (sysfs_streq(buf, "never")) {
 		clear_bit(TRANSPARENT_HUGEPAGE_FLAG, &transparent_hugepage_flags);
 		clear_bit(TRANSPARENT_HUGEPAGE_REQ_MADV_FLAG, &transparent_hugepage_flags);
+		clear_bit(TRANSPARENT_HUGEPAGE_DEFER_PF_INST_FLAG, &transparent_hugepage_flags);
 	} else
 		ret = -EINVAL;
 
@@ -954,18 +964,31 @@ static int __init setup_transparent_huge
 			&transparent_hugepage_flags);
 		clear_bit(TRANSPARENT_HUGEPAGE_REQ_MADV_FLAG,
 			  &transparent_hugepage_flags);
+		clear_bit(TRANSPARENT_HUGEPAGE_DEFER_PF_INST_FLAG,
+			  &transparent_hugepage_flags);
 		ret = 1;
+	} else if (!strcmp(str, "defer")) {
+		clear_bit(TRANSPARENT_HUGEPAGE_FLAG,
+			  &transparent_hugepage_flags);
+		clear_bit(TRANSPARENT_HUGEPAGE_REQ_MADV_FLAG,
+			  &transparent_hugepage_flags);
+		set_bit(TRANSPARENT_HUGEPAGE_DEFER_PF_INST_FLAG,
+			  &transparent_hugepage_flags);
 	} else if (!strcmp(str, "madvise")) {
 		clear_bit(TRANSPARENT_HUGEPAGE_FLAG,
 			  &transparent_hugepage_flags);
+		clear_bit(TRANSPARENT_HUGEPAGE_DEFER_PF_INST_FLAG,
+			  &transparent_hugepage_flags);
 		set_bit(TRANSPARENT_HUGEPAGE_REQ_MADV_FLAG,
-			&transparent_hugepage_flags);
+			  &transparent_hugepage_flags);
 		ret = 1;
 	} else if (!strcmp(str, "never")) {
 		clear_bit(TRANSPARENT_HUGEPAGE_FLAG,
 			  &transparent_hugepage_flags);
 		clear_bit(TRANSPARENT_HUGEPAGE_REQ_MADV_FLAG,
 			  &transparent_hugepage_flags);
+		clear_bit(TRANSPARENT_HUGEPAGE_DEFER_PF_INST_FLAG,
+			  &transparent_hugepage_flags);
 		ret = 1;
 	}
 out:
_

Patches currently in -mm which might be from npache@redhat.com are

introduce-khugepaged_collapse_single_pmd-to-unify-khugepaged-and-madvise_collapse.patch
khugepaged-rename-hpage_collapse_-to-khugepaged_.patch
khugepaged-generalize-hugepage_vma_revalidate-for-mthp-support.patch
khugepaged-generalize-__collapse_huge_page_-for-mthp-support.patch
khugepaged-introduce-khugepaged_scan_bitmap-for-mthp-support.patch
khugepaged-add-mthp-support.patch
khugepaged-skip-collapsing-mthp-to-smaller-orders.patch
khugepaged-avoid-unnecessary-mthp-collapse-attempts.patch
khugepaged-improve-tracepoints-for-mthp-orders.patch
khugepaged-add-per-order-mthp-khugepaged-stats.patch
documentation-mm-update-the-admin-guide-for-mthp-collapse.patch
mm-defer-thp-insertion-to-khugepaged.patch
mm-document-mthp-defer-usage.patch
khugepaged-add-defer-option-to-mthp-options.patch
selftests-mm-add-defer-to-thp-setting-parser.patch

