Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 612111FC10E;
	Thu, 10 Apr 2025 22:47:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744325245; cv=none; b=FxaCd5R1LtiYHelASqTff1gl4tuM8TNcTTWtRr2GbkcUpLPvoqbdcSxykIbNlHNjYRM3uweIa4FZEndsGMY7rXG2gS0Mc+K+nOPgHIDfyHS+Qsa7Dio+rmqWlBIxlirGjqcMwAy5G/vDvIm0OeX+3shfEFtR+kJfkS2jen42SnI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744325245; c=relaxed/simple;
	bh=45A55zbTta3+sm2yur+7uadHuUUZJBsmn0VOhAtw+Qk=;
	h=Date:To:From:Subject:Message-Id; b=DJRfLjyNNjLr7SVqs9ADy3XiORD9HU7NM6KjrUDNOT5MfBn98xT2jI+RHtIs/aQOXYg9wqGE9/1qFsX8WFbifC/LO7TUwIyYQp5OaAwEXbEi8kiTTaQoDJEF/A+Zo+sIz0sPlEbMTgtEIZPsgdm7zw8nti4OPIfCBPWFSnFlIXA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=KC4PV+7y; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="KC4PV+7y"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A6A38C4CEDD;
	Thu, 10 Apr 2025 22:47:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1744325244;
	bh=45A55zbTta3+sm2yur+7uadHuUUZJBsmn0VOhAtw+Qk=;
	h=Date:To:From:Subject:From;
	b=KC4PV+7yVqqnfY6u5KJvE0PIOKGBDPQ9t/Bcg+VxuV11SYrNenz5k6cgr4kF0um3R
	 6p2dc2niF94KxTlpfEMr1gQm43nGOO1mp5DjTSMWVSLw6R/D4MKvIPNv93qSlyGRpi
	 dOcEIiQUt4dG/GRjfbZNs1bOsCnjHU+iTdfcK4+0=
Date: Thu, 10 Apr 2025 15:47:23 -0700
To: mm-commits@vger.kernel.org,stable@vger.kernel.org,ryabinin.a.a@gmail.com,npiggin@gmail.com,linux@roeck-us.net,jgross@suse.com,jeremy@goop.org,hughd@google.com,agordeev@linux.ibm.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [to-be-updated] kasan-avoid-sleepable-page-allocation-from-atomic-context.patch removed from -mm tree
Message-Id: <20250410224724.A6A38C4CEDD@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: kasan: avoid sleepable page allocation from atomic context
has been removed from the -mm tree.  Its filename was
     kasan-avoid-sleepable-page-allocation-from-atomic-context.patch

This patch was dropped because an updated version will be issued

------------------------------------------------------
From: Alexander Gordeev <agordeev@linux.ibm.com>
Subject: kasan: avoid sleepable page allocation from atomic context
Date: Tue, 8 Apr 2025 18:07:30 +0200

Patch series "mm: Fix apply_to_pte_range() vs lazy MMU mode", v2.

This series is an attempt to fix the violation of lazy MMU mode context
requirement as described for arch_enter_lazy_mmu_mode():

    This mode can only be entered and left under the protection of
    the page table locks for all page tables which may be modified.

On s390 if I make arch_enter_lazy_mmu_mode() -> preempt_enable() and
arch_leave_lazy_mmu_mode() -> preempt_disable() I am getting this:

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

This exposes a KASAN issue fixed with patch 1 and apply_to_pte_range()
issue fixed with patch 3, while patch 2 is a prerequisite.

Commit b9ef323ea168 ("powerpc/64s: Disable preemption in hash lazy mmu
mode") looks like powerpc-only fix, yet not entirely conforming to the
above provided requirement (page tables itself are still not protected). 
If I am not mistaken, xen and sparc are alike.


This patch (of 3):

apply_to_page_range() enters lazy MMU mode and then invokes
kasan_populate_vmalloc_pte() callback on each page table walk iteration. 
The lazy MMU mode may only be entered only under protection of the page
table lock.  However, the callback can go into sleep when trying to
allocate a single page.

Change __get_free_page() allocation mode from GFP_KERNEL to GFP_ATOMIC to
avoid scheduling out while in atomic context.

Link: https://lkml.kernel.org/r/cover.1744128123.git.agordeev@linux.ibm.com
Link: https://lkml.kernel.org/r/2d9f4ac4528701b59d511a379a60107fa608ad30.1744128123.git.agordeev@linux.ibm.com
Fixes: 3c5c3cfb9ef4 ("kasan: support backing vmalloc space with real shadow memory")
Signed-off-by: Alexander Gordeev <agordeev@linux.ibm.com>
Cc: Andrey Ryabinin <ryabinin.a.a@gmail.com>
Cc: Guenetr Roeck <linux@roeck-us.net>
Cc: Hugh Dickins <hughd@google.com>
Cc: Jeremy Fitzhardinge <jeremy@goop.org>
Cc: Juegren Gross <jgross@suse.com>
Cc: Nicholas Piggin <npiggin@gmail.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/kasan/shadow.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/mm/kasan/shadow.c~kasan-avoid-sleepable-page-allocation-from-atomic-context
+++ a/mm/kasan/shadow.c
@@ -301,7 +301,7 @@ static int kasan_populate_vmalloc_pte(pt
 	if (likely(!pte_none(ptep_get(ptep))))
 		return 0;
 
-	page = __get_free_page(GFP_KERNEL);
+	page = __get_free_page(GFP_ATOMIC);
 	if (!page)
 		return -ENOMEM;
 
_

Patches currently in -mm which might be from agordeev@linux.ibm.com are

mm-cleanup-apply_to_pte_range-routine.patch
mm-protect-kernel-pgtables-in-apply_to_pte_range.patch

