Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2C439269D09
	for <mm-commits@vger.kernel.org>; Mon, 28 Apr 2025 19:01:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745866914; cv=none; b=fI8OGQsUCPN9gBfXvk1wwyQ9w1/8MrFj0F8R1gl3J73QU+SVl9Q7Y5GgvW8Mcf25RqM4NNYFDg7VCCkBf70f4al52hxF4cfnFNjG9VyDaNk4un2G6F5wA+MTPbMHgRzmbCb16gx2gYw7O/qdmG35BYphYQdS2JSvCiUN0w1qGdk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745866914; c=relaxed/simple;
	bh=74qAYVvuhV9B5A1M9N5mAFsDqJapeXO9JeImlAvThhk=;
	h=Date:To:From:Subject:Message-Id; b=GdLqOTdEc0B0U9k/ZdrCgf3u/AM2UW4j3QEAkylgNibeB1LSj3Zjwwx2wzg00vvR6SqF+b7QEGbrmDKAD/7x+OUAiTaY/mzieddgcyZi+XyCL/MVbbH8OAKuoKv10sxjQ45JjOZ7WsMWnKhQz7Nv+if5SGYWE82NS4QY2JCgh3w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=UmeNE2uC; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="UmeNE2uC"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8D67EC4CEE4;
	Mon, 28 Apr 2025 19:01:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1745866913;
	bh=74qAYVvuhV9B5A1M9N5mAFsDqJapeXO9JeImlAvThhk=;
	h=Date:To:From:Subject:From;
	b=UmeNE2uCocm03cvSW4Rf9gEFIRwW+51oVvhklkCjKy1NbvZK+ZiRLcmu2ZoIrThFO
	 BnFjstboY29OpnuVhSHFevRVDnbk8Yd9McoR7gr1QoHILtz4m+bSSyOMPfNeGQpDOf
	 QT0Q39J7ORPZ35irzE+OZPJf8nMHHc9RRJPAHqLY=
Date: Mon, 28 Apr 2025 12:01:53 -0700
To: mm-commits@vger.kernel.org,zokeefe@google.com,ziy@nvidia.com,yang@os.amperecomputing.com,willy@infradead.org,will@kernel.org,wangkefeng.wang@huawei.com,vishal.moola@gmail.com,usamaarif642@gmail.com,tiwai@suse.de,thomas.hellstrom@linux.intel.com,surenb@google.com,sunnanyong@huawei.com,shuah@kernel.org,ryan.roberts@arm.com,rostedt@goodmis.org,rientjes@google.com,rdunlap@infradead.org,raquini@redhat.com,peterx@redhat.com,mhocko@suse.com,mhiramat@kernel.org,mathieu.desnoyers@efficios.com,lorenzo.stoakes@oracle.com,liam.howlett@oracle.com,kirill.shutemov@linux.intel.com,jack@suse.cz,hannes@cmpxchg.org,dev.jain@arm.com,david@redhat.com,corbet@lwn.net,cl@gentwo.org,catalin.marinas@arm.com,baolin.wang@linux.alibaba.com,baohua@kernel.org,bagasdotme@gmail.com,anshuman.khandual@arm.com,aarcange@redhat.com,npache@redhat.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + khugepaged-add-defer-option-to-mthp-options.patch added to mm-new branch
Message-Id: <20250428190153.8D67EC4CEE4@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: khugepaged: add defer option to mTHP options
has been added to the -mm mm-new branch.  Its filename is
     khugepaged-add-defer-option-to-mthp-options.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/khugepaged-add-defer-option-to-mthp-options.patch

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
From: Nico Pache <npache@redhat.com>
Subject: khugepaged: add defer option to mTHP options
Date: Mon, 28 Apr 2025 12:29:03 -0600

Now that we have defer to globally disable THPs at fault time, lets add a
defer setting to the mTHP options.  This will allow khugepaged to operate
at that order, while avoiding it at PF time.

Link: https://lkml.kernel.org/r/20250428182904.93989-4-npache@redhat.com
Signed-off-by: Nico Pache <npache@redhat.com>
Cc: Andrea Arcangeli <aarcange@redhat.com>
Cc: Anshuman Khandual <anshuman.khandual@arm.com>
Cc: Bagas Sanjaya <bagasdotme@gmail.com>
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
Cc: Liam Howlett <liam.howlett@oracle.com>
Cc: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Cc: "Masami Hiramatsu (Google)" <mhiramat@kernel.org>
Cc: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Nanyong Sun <sunnanyong@huawei.com>
Cc: Peter Xu <peterx@redhat.com>
Cc: Rafael Aquini <raquini@redhat.com>
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

 include/linux/huge_mm.h |    5 +++++
 mm/huge_memory.c        |   38 +++++++++++++++++++++++++++++++++-----
 mm/khugepaged.c         |    8 ++++----
 3 files changed, 42 insertions(+), 9 deletions(-)

--- a/include/linux/huge_mm.h~khugepaged-add-defer-option-to-mthp-options
+++ a/include/linux/huge_mm.h
@@ -96,6 +96,7 @@ extern struct kobj_attribute thpsize_shm
 #define TVA_SMAPS		(1 << 0)	/* Will be used for procfs */
 #define TVA_IN_PF		(1 << 1)	/* Page fault handler */
 #define TVA_ENFORCE_SYSFS	(1 << 2)	/* Obey sysfs configuration */
+#define TVA_IN_KHUGEPAGE	((1 << 2) | (1 << 3)) /* Khugepaged defer support */
 
 #define thp_vma_allowable_order(vma, vm_flags, tva_flags, order) \
 	(!!thp_vma_allowable_orders(vma, vm_flags, tva_flags, BIT(order)))
@@ -182,6 +183,7 @@ extern unsigned long transparent_hugepag
 extern unsigned long huge_anon_orders_always;
 extern unsigned long huge_anon_orders_madvise;
 extern unsigned long huge_anon_orders_inherit;
+extern unsigned long huge_anon_orders_defer;
 
 static inline bool hugepage_global_enabled(void)
 {
@@ -306,6 +308,9 @@ unsigned long thp_vma_allowable_orders(s
 	/* Optimization to check if required orders are enabled early. */
 	if ((tva_flags & TVA_ENFORCE_SYSFS) && vma_is_anonymous(vma)) {
 		unsigned long mask = READ_ONCE(huge_anon_orders_always);
+
+		if ((tva_flags & TVA_IN_KHUGEPAGE) == TVA_IN_KHUGEPAGE)
+			mask |= READ_ONCE(huge_anon_orders_defer);
 		if (vm_flags & VM_HUGEPAGE)
 			mask |= READ_ONCE(huge_anon_orders_madvise);
 		if (hugepage_global_always() || hugepage_global_defer() ||
--- a/mm/huge_memory.c~khugepaged-add-defer-option-to-mthp-options
+++ a/mm/huge_memory.c
@@ -81,6 +81,7 @@ unsigned long huge_zero_pfn __read_mostl
 unsigned long huge_anon_orders_always __read_mostly;
 unsigned long huge_anon_orders_madvise __read_mostly;
 unsigned long huge_anon_orders_inherit __read_mostly;
+unsigned long huge_anon_orders_defer __read_mostly;
 static bool anon_orders_configured __initdata;
 
 static inline bool file_thp_enabled(struct vm_area_struct *vma)
@@ -505,13 +506,15 @@ static ssize_t anon_enabled_show(struct
 	const char *output;
 
 	if (test_bit(order, &huge_anon_orders_always))
-		output = "[always] inherit madvise never";
+		output = "[always] inherit madvise defer never";
 	else if (test_bit(order, &huge_anon_orders_inherit))
-		output = "always [inherit] madvise never";
+		output = "always [inherit] madvise defer never";
 	else if (test_bit(order, &huge_anon_orders_madvise))
-		output = "always inherit [madvise] never";
+		output = "always inherit [madvise] defer never";
+	else if (test_bit(order, &huge_anon_orders_defer))
+		output = "always inherit madvise [defer] never";
 	else
-		output = "always inherit madvise [never]";
+		output = "always inherit madvise defer [never]";
 
 	return sysfs_emit(buf, "%s\n", output);
 }
@@ -527,25 +530,36 @@ static ssize_t anon_enabled_store(struct
 		spin_lock(&huge_anon_orders_lock);
 		clear_bit(order, &huge_anon_orders_inherit);
 		clear_bit(order, &huge_anon_orders_madvise);
+		clear_bit(order, &huge_anon_orders_defer);
 		set_bit(order, &huge_anon_orders_always);
 		spin_unlock(&huge_anon_orders_lock);
 	} else if (sysfs_streq(buf, "inherit")) {
 		spin_lock(&huge_anon_orders_lock);
 		clear_bit(order, &huge_anon_orders_always);
 		clear_bit(order, &huge_anon_orders_madvise);
+		clear_bit(order, &huge_anon_orders_defer);
 		set_bit(order, &huge_anon_orders_inherit);
 		spin_unlock(&huge_anon_orders_lock);
 	} else if (sysfs_streq(buf, "madvise")) {
 		spin_lock(&huge_anon_orders_lock);
 		clear_bit(order, &huge_anon_orders_always);
 		clear_bit(order, &huge_anon_orders_inherit);
+		clear_bit(order, &huge_anon_orders_defer);
 		set_bit(order, &huge_anon_orders_madvise);
 		spin_unlock(&huge_anon_orders_lock);
+	} else if (sysfs_streq(buf, "defer")) {
+		spin_lock(&huge_anon_orders_lock);
+		clear_bit(order, &huge_anon_orders_always);
+		clear_bit(order, &huge_anon_orders_inherit);
+		clear_bit(order, &huge_anon_orders_madvise);
+		set_bit(order, &huge_anon_orders_defer);
+		spin_unlock(&huge_anon_orders_lock);
 	} else if (sysfs_streq(buf, "never")) {
 		spin_lock(&huge_anon_orders_lock);
 		clear_bit(order, &huge_anon_orders_always);
 		clear_bit(order, &huge_anon_orders_inherit);
 		clear_bit(order, &huge_anon_orders_madvise);
+		clear_bit(order, &huge_anon_orders_defer);
 		spin_unlock(&huge_anon_orders_lock);
 	} else
 		ret = -EINVAL;
@@ -1002,7 +1016,7 @@ static char str_dup[PAGE_SIZE] __initdat
 static int __init setup_thp_anon(char *str)
 {
 	char *token, *range, *policy, *subtoken;
-	unsigned long always, inherit, madvise;
+	unsigned long always, inherit, madvise, defer;
 	char *start_size, *end_size;
 	int start, end, nr;
 	char *p;
@@ -1014,6 +1028,8 @@ static int __init setup_thp_anon(char *s
 	always = huge_anon_orders_always;
 	madvise = huge_anon_orders_madvise;
 	inherit = huge_anon_orders_inherit;
+	defer = huge_anon_orders_defer;
+
 	p = str_dup;
 	while ((token = strsep(&p, ";")) != NULL) {
 		range = strsep(&token, ":");
@@ -1053,18 +1069,28 @@ static int __init setup_thp_anon(char *s
 				bitmap_set(&always, start, nr);
 				bitmap_clear(&inherit, start, nr);
 				bitmap_clear(&madvise, start, nr);
+				bitmap_clear(&defer, start, nr);
 			} else if (!strcmp(policy, "madvise")) {
 				bitmap_set(&madvise, start, nr);
 				bitmap_clear(&inherit, start, nr);
 				bitmap_clear(&always, start, nr);
+				bitmap_clear(&defer, start, nr);
 			} else if (!strcmp(policy, "inherit")) {
 				bitmap_set(&inherit, start, nr);
 				bitmap_clear(&madvise, start, nr);
 				bitmap_clear(&always, start, nr);
+				bitmap_clear(&defer, start, nr);
+			} else if (!strcmp(policy, "defer")) {
+				bitmap_set(&defer, start, nr);
+				bitmap_clear(&madvise, start, nr);
+				bitmap_clear(&always, start, nr);
+				bitmap_clear(&inherit, start, nr);
 			} else if (!strcmp(policy, "never")) {
 				bitmap_clear(&inherit, start, nr);
 				bitmap_clear(&madvise, start, nr);
 				bitmap_clear(&always, start, nr);
+				bitmap_clear(&defer, start, nr);
+
 			} else {
 				pr_err("invalid policy %s in thp_anon boot parameter\n", policy);
 				goto err;
@@ -1075,6 +1101,8 @@ static int __init setup_thp_anon(char *s
 	huge_anon_orders_always = always;
 	huge_anon_orders_madvise = madvise;
 	huge_anon_orders_inherit = inherit;
+	huge_anon_orders_defer = defer;
+
 	anon_orders_configured = true;
 	return 1;
 
--- a/mm/khugepaged.c~khugepaged-add-defer-option-to-mthp-options
+++ a/mm/khugepaged.c
@@ -491,7 +491,7 @@ void khugepaged_enter_vma(struct vm_area
 {
 	if (!test_bit(MMF_VM_HUGEPAGE, &vma->vm_mm->flags) &&
 	    hugepage_pmd_enabled()) {
-		if (thp_vma_allowable_order(vma, vm_flags, TVA_ENFORCE_SYSFS,
+		if (thp_vma_allowable_order(vma, vm_flags, TVA_IN_KHUGEPAGE,
 					    PMD_ORDER))
 			__khugepaged_enter(vma->vm_mm);
 	}
@@ -954,7 +954,7 @@ static int hugepage_vma_revalidate(struc
 				   struct collapse_control *cc, int order)
 {
 	struct vm_area_struct *vma;
-	unsigned long tva_flags = cc->is_khugepaged ? TVA_ENFORCE_SYSFS : 0;
+	unsigned long tva_flags = cc->is_khugepaged ? TVA_IN_KHUGEPAGE  : 0;
 
 	if (unlikely(khugepaged_test_exit_or_disable(mm)))
 		return SCAN_ANY_PROCESS;
@@ -1428,7 +1428,7 @@ static int khugepaged_scan_pmd(struct mm
 	bool writable = false;
 	int chunk_none_count = 0;
 	int scaled_none = khugepaged_max_ptes_none >> (HPAGE_PMD_ORDER - KHUGEPAGED_MIN_MTHP_ORDER);
-	unsigned long tva_flags = cc->is_khugepaged ? TVA_ENFORCE_SYSFS : 0;
+	unsigned long tva_flags = cc->is_khugepaged ? TVA_IN_KHUGEPAGE : 0;
 	VM_BUG_ON(address & ~HPAGE_PMD_MASK);
 
 	result = find_pmd_or_thp_or_none(mm, address, &pmd);
@@ -2631,7 +2631,7 @@ static unsigned int khugepaged_scan_mm_s
 			break;
 		}
 		if (!thp_vma_allowable_order(vma, vma->vm_flags,
-					TVA_ENFORCE_SYSFS, PMD_ORDER)) {
+					TVA_IN_KHUGEPAGE, PMD_ORDER)) {
 skip:
 			progress++;
 			continue;
_

Patches currently in -mm which might be from npache@redhat.com are

khugepaged-rename-hpage_collapse_-to-khugepaged_.patch
introduce-khugepaged_collapse_single_pmd-to-unify-khugepaged-and-madvise_collapse.patch
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

