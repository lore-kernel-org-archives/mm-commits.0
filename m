Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3A38A224222;
	Tue, 29 Apr 2025 20:30:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745958625; cv=none; b=Ptoy3q1zIhxibAiKcjv4S6+I5SeiksWHFOTvPR/JqHDVoj/ogDhCEVQ+2DmkrldA96cl+M97bArnjdkZmjnPydhryLnGgQ95v/qCc7mULDud0dY9ZnKrRghrp40XgSMMJ8wHtFqoIszlObzZvd0oCOGmBOlqfKZDIscVGPNcKVA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745958625; c=relaxed/simple;
	bh=L+xHPu2WFbG7EX+zFMLeWxjzB7da8Hhj5jBVRXZsXHk=;
	h=Date:To:From:Subject:Message-Id; b=liASfDWY6bTLHTnC8kxUeB3ix8QioZNTgrAaMHGXaV6QuX6bQCYUpQSrapb4+poKoIS/Tkuzqp2f5+NVZPZ9bG6XBAlnbi/udQg0tz4B4rOaJvFphkIr7n0Yv0UXEdPBukXHYiI5ytXJ5+PdzsD9o2ayUcpaPrI4CsSsolQVpU4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=TqfoIv7k; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="TqfoIv7k"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DEE72C4CEE3;
	Tue, 29 Apr 2025 20:30:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1745958625;
	bh=L+xHPu2WFbG7EX+zFMLeWxjzB7da8Hhj5jBVRXZsXHk=;
	h=Date:To:From:Subject:From;
	b=TqfoIv7kONLSmzauG7kbP7bH3bKeip3yPBJXGv5eco3AM2akp/bmJ6QiRAxMN2gh5
	 tz9D+n4j7hMDl9tIwdAmzVPaji1LMSXzyvFzm9fz3pt4DWUGoKQAZTVaJZPYPfNWqF
	 41FuTb+BbEyhxUGimYzd1EGgKYh1DYs1yuQ9a6oc=
Date: Tue, 29 Apr 2025 13:30:24 -0700
To: mm-commits@vger.kernel.org,vincenzo.frascino@arm.com,stable@vger.kernel.org,ryabinin.a.a@gmail.com,glider@google.com,dvyukov@google.com,dja@axtens.net,andreyknvl@gmail.com,agordeev@linux.ibm.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + kasan-avoid-sleepable-page-allocation-from-atomic-context.patch added to mm-hotfixes-unstable branch
Message-Id: <20250429203024.DEE72C4CEE3@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: kasan: avoid sleepable page allocation from atomic context
has been added to the -mm mm-hotfixes-unstable branch.  Its filename is
     kasan-avoid-sleepable-page-allocation-from-atomic-context.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/kasan-avoid-sleepable-page-allocation-from-atomic-context.patch

This patch will later appear in the mm-hotfixes-unstable branch at
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
From: Alexander Gordeev <agordeev@linux.ibm.com>
Subject: kasan: avoid sleepable page allocation from atomic context
Date: Tue, 29 Apr 2025 18:08:41 +0200

apply_to_pte_range() enters the lazy MMU mode and then invokes
kasan_populate_vmalloc_pte() callback on each page table walk iteration. 
However, the callback can go into sleep when trying to allocate a single
page, e.g.  if an architecutre disables preemption on lazy MMU mode enter.

On s390 with the call sequences arch_enter_lazy_mmu_mode() ->
preempt_enable() and arch_leave_lazy_mmu_mode() -> preempt_disable(), such
a crash occurs:

    [  553.332108] preempt_count: 1, expected: 0
    [  553.332117] no locks held by multipathd/2116.
    [  553.332128] CPU: 24 PID: 2116 Comm: multipathd Kdump: loaded Tainted:
    [  553.332139] Hardware name: IBM 3931 A01 701 (LPAR)
    [  553.332146] Call Trace:
    [  553.332152]  [<00000000158de23a>] dump_stack_lvl+0xfa/0x150
    [  553.332167]  [<0000000013e10d12>] __might_resched+0x57a/0x5e8
    [  553.332178]  [<00000000144eb6c2>] __alloc_pages+0x2ba/0x7c0
    [  553.332189]  [<00000000144d5cdc>] __get_free_pages+0x2c/0x88
    [  553.332198]  [<00000000145663f6>] kasan_populate_vmalloc_pte+0x4e/0x110
    [  553.332207]  [<000000001447625c>] apply_to_pte_range+0x164/0x3c8
    [  553.332218]  [<000000001448125a>] apply_to_pmd_range+0xda/0x318
    [  553.332226]  [<000000001448181c>] __apply_to_page_range+0x384/0x768
    [  553.332233]  [<0000000014481c28>] apply_to_page_range+0x28/0x38
    [  553.332241]  [<00000000145665da>] kasan_populate_vmalloc+0x82/0x98
    [  553.332249]  [<00000000144c88d0>] alloc_vmap_area+0x590/0x1c90
    [  553.332257]  [<00000000144ca108>] __get_vm_area_node.constprop.0+0x138/0x260
    [  553.332265]  [<00000000144d17fc>] __vmalloc_node_range+0x134/0x360
    [  553.332274]  [<0000000013d5dbf2>] alloc_thread_stack_node+0x112/0x378
    [  553.332284]  [<0000000013d62726>] dup_task_struct+0x66/0x430
    [  553.332293]  [<0000000013d63962>] copy_process+0x432/0x4b80
    [  553.332302]  [<0000000013d68300>] kernel_clone+0xf0/0x7d0
    [  553.332311]  [<0000000013d68bd6>] __do_sys_clone+0xae/0xc8
    [  553.332400]  [<0000000013d68dee>] __s390x_sys_clone+0xd6/0x118
    [  553.332410]  [<0000000013c9d34c>] do_syscall+0x22c/0x328
    [  553.332419]  [<00000000158e7366>] __do_syscall+0xce/0xf0
    [  553.332428]  [<0000000015913260>] system_call+0x70/0x98

Instead of allocating single pages per-PTE, bulk-allocate the shadow
memory prior to applying kasan_populate_vmalloc_pte() callback on a page
range.

Link: https://lkml.kernel.org/r/573a823565734e1eac3aa128fb9d3506ec918a72.1745940843.git.agordeev@linux.ibm.com
Fixes: 3c5c3cfb9ef4 ("kasan: support backing vmalloc space with real shadow memory")
Signed-off-by: Alexander Gordeev <agordeev@linux.ibm.com>
Suggested-by: Andrey Ryabinin <ryabinin.a.a@gmail.com>
Cc: Alexander Gordeev <agordeev@linux.ibm.com>
Cc: Daniel Axtens <dja@axtens.net>
Cc: Alexander Potapenko <glider@google.com>
Cc: Andrey Konovalov <andreyknvl@gmail.com>
Cc: Dmitry Vyukov <dvyukov@google.com>
Cc: Vincenzo Frascino <vincenzo.frascino@arm.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/kasan/shadow.c |   65 +++++++++++++++++++++++++++++++++-----------
 1 file changed, 49 insertions(+), 16 deletions(-)

--- a/mm/kasan/shadow.c~kasan-avoid-sleepable-page-allocation-from-atomic-context
+++ a/mm/kasan/shadow.c
@@ -292,30 +292,65 @@ void __init __weak kasan_populate_early_
 {
 }
 
+struct vmalloc_populate_data {
+	unsigned long start;
+	struct page **pages;
+};
+
 static int kasan_populate_vmalloc_pte(pte_t *ptep, unsigned long addr,
-				      void *unused)
+				      void *_data)
 {
-	unsigned long page;
+	struct vmalloc_populate_data *data = _data;
+	struct page *page;
+	unsigned long pfn;
 	pte_t pte;
 
 	if (likely(!pte_none(ptep_get(ptep))))
 		return 0;
 
-	page = __get_free_page(GFP_KERNEL);
-	if (!page)
-		return -ENOMEM;
-
-	__memset((void *)page, KASAN_VMALLOC_INVALID, PAGE_SIZE);
-	pte = pfn_pte(PFN_DOWN(__pa(page)), PAGE_KERNEL);
+	page = data->pages[PFN_DOWN(addr - data->start)];
+	pfn = page_to_pfn(page);
+	__memset(pfn_to_virt(pfn), KASAN_VMALLOC_INVALID, PAGE_SIZE);
+	pte = pfn_pte(pfn, PAGE_KERNEL);
 
 	spin_lock(&init_mm.page_table_lock);
-	if (likely(pte_none(ptep_get(ptep)))) {
+	if (likely(pte_none(ptep_get(ptep))))
 		set_pte_at(&init_mm, addr, ptep, pte);
-		page = 0;
-	}
 	spin_unlock(&init_mm.page_table_lock);
-	if (page)
-		free_page(page);
+
+	return 0;
+}
+
+static int __kasan_populate_vmalloc(unsigned long start, unsigned long end)
+{
+	unsigned long nr_pages, nr_total = PFN_UP(end - start);
+	struct vmalloc_populate_data data;
+	int ret;
+
+	data.pages = (struct page **)__get_free_page(GFP_KERNEL);
+	if (!data.pages)
+		return -ENOMEM;
+
+	while (nr_total) {
+		nr_pages = min(nr_total, PAGE_SIZE / sizeof(data.pages[0]));
+		__memset(data.pages, 0, nr_pages * sizeof(data.pages[0]));
+		if (nr_pages != alloc_pages_bulk(GFP_KERNEL, nr_pages, data.pages)) {
+			free_page((unsigned long)data.pages);
+			return -ENOMEM;
+		}
+
+		data.start = start;
+		ret = apply_to_page_range(&init_mm, start, nr_pages * PAGE_SIZE,
+					  kasan_populate_vmalloc_pte, &data);
+		if (ret)
+			return ret;
+
+		start += nr_pages * PAGE_SIZE;
+		nr_total -= nr_pages;
+	}
+
+	free_page((unsigned long)data.pages);
+
 	return 0;
 }
 
@@ -348,9 +383,7 @@ int kasan_populate_vmalloc(unsigned long
 	shadow_start = PAGE_ALIGN_DOWN(shadow_start);
 	shadow_end = PAGE_ALIGN(shadow_end);
 
-	ret = apply_to_page_range(&init_mm, shadow_start,
-				  shadow_end - shadow_start,
-				  kasan_populate_vmalloc_pte, NULL);
+	ret = __kasan_populate_vmalloc(shadow_start, shadow_end);
 	if (ret)
 		return ret;
 
_

Patches currently in -mm which might be from agordeev@linux.ibm.com are

kasan-avoid-sleepable-page-allocation-from-atomic-context.patch

