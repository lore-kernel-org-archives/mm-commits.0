From: akpm@linux-foundation.org
Subject: [folded-merged] thp-implement-refcounting-for-huge-zero-page-fix.patch removed from -mm tree
Date: Wed, 12 Dec 2012 13:37:32 -0800
Message-ID: <20121212213733.8B0DB20004E@hpza10.eem.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-ee0-f73.google.com ([74.125.83.73]:37725 "EHLO
	mail-ee0-f73.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754515Ab2LLVhf (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 12 Dec 2012 16:37:35 -0500
Received: by mail-ee0-f73.google.com with SMTP id c50so69453eek.4
        for <mm-commits@vger.kernel.org>; Wed, 12 Dec 2012 13:37:34 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: lliubbo@gmail.com, kirill.shutemov@linux.intel.com, mm-commits@vger.kernel.org


The patch titled
     Subject: huge_memory: fix huge zero page refcount
has been removed from the -mm tree.  Its filename was
     thp-implement-refcounting-for-huge-zero-page-fix.patch

This patch was dropped because it was folded into thp-implement-refcounting-for-huge-zero-page.patch

------------------------------------------------------
From: Bob Liu <lliubbo@gmail.com>
Subject: huge_memory: fix huge zero page refcount

It seems patch "[PATCH v5 10/11] thp: implement refcounting for huge zero
page" was merged wrong into your tree.

In Kirill's patch, put_huge_zero_page() is called in
do_huge_pmd_wp_zero_page_fallback().
But in linux-next and linux-mmotm.git, it's called in
do_huge_pmd_wp_page_fallback().

That's wrong and make below BUG triggered again:

[ 1384.485993] ------------[ cut here ]------------
[ 1384.486031] kernel BUG at mm/huge_memory.c:213!
[ 1384.486055] invalid opcode: 0000 [#1] PREEMPT SMP
.....
3.7.0-rc8+ #53 Dell Inc. OptiPlex 760                 /0M860N
[ 1384.486473] EIP: 0060:[<c114d9d8>] EFLAGS: 00010202 CPU: 1
[ 1384.486504] EIP is at put_huge_zero_page+0x18/0x20
[ 1384.486528] EAX: 00000001 EBX: 00000008 ECX: 00000000 EDX: ed5c4000
[ 1384.486556] ESI: b5a00000 EDI: ed7af000 EBP: ed5c5e8c ESP: ed5c5e8c
[ 1384.486585]  DS: 007b ES: 007b FS: 00d8 GS: 00e0 SS: 0068
[ 1384.486611] CR0: 8005003b CR2: b59ffba8 CR3: 2e79a000 CR4: 000427f0
[ 1384.486639] DR0: 00000000 DR1: 00000000 DR2: 00000000 DR3: 00000000
[ 1384.486668] DR6: ffff0ff0 DR7: 00000400
[ 1384.486687] Process gnome-terminal (pid: 12714, ti=ed5c4000 task=ebd59a60
task.ti=ed5c4000)
[ 1384.486724] Stack:
[ 1384.486735]  ed5c5eec c1151329 092fb067 80000000 eaf9eca8 ed7ae800 ed7ae800
2c6f9000
[ 1384.486786]  00000000 f5ff16e8 f251d378 00000163 b5a00000 f4622000 b5800000
f251d340
[ 1384.486836]  ec7b6c60 80000000 092fb067 2c6f9067 00000000 c74000c5 80000000
eaf9ed60
[ 1384.486887] Call Trace:
[ 1384.486902]  [<c1151329>] do_huge_pmd_wp_page+0x949/0xb60
[ 1384.486929]  [<c1128aff>] handle_mm_fault+0x14f/0x330
[ 1384.486956]  [<c1804810>] ? __do_page_fault+0x550/0x550
[ 1384.486981]  [<c180440d>] __do_page_fault+0x14d/0x550
[ 1384.487005]  [<c180481d>] ? do_page_fault+0xd/0x10
[ 1384.487030]  [<c1801cdf>] ? error_code+0x67/0x6c
[ 1384.487054]  [<c180007b>] ? __schedule+0x66b/0x7c0
[ 1384.487080]  [<c12ea155>] ? __put_user_4+0x11/0x18
[ 1384.487104]  [<c1804810>] ? __do_page_fault+0x550/0x550
[ 1384.487130]  [<c180481d>] do_page_fault+0xd/0x10
[ 1384.487153]  [<c1801cdf>] error_code+0x67/0x6c
[ 1384.487176]  [<c1800000>] ? __schedule+0x5f0/0x7c0

Signed-off-by: Bob Liu <lliubbo@gmail.com>
Acked-by: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/huge_memory.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN mm/huge_memory.c~thp-implement-refcounting-for-huge-zero-page-fix mm/huge_memory.c
--- a/mm/huge_memory.c~thp-implement-refcounting-for-huge-zero-page-fix
+++ a/mm/huge_memory.c
@@ -982,6 +982,7 @@ static int do_huge_pmd_wp_zero_page_fall
 	smp_wmb(); /* make pte visible before pmd */
 	pmd_populate(mm, pmd, pgtable);
 	spin_unlock(&mm->page_table_lock);
+	put_huge_zero_page();
 	inc_mm_counter(mm, MM_ANONPAGES);
 
 	mmu_notifier_invalidate_range_end(mm, mmun_start, mmun_end);
@@ -1071,7 +1072,6 @@ static int do_huge_pmd_wp_page_fallback(
 	pmd_populate(mm, pmd, pgtable);
 	page_remove_rmap(page);
 	spin_unlock(&mm->page_table_lock);
-	put_huge_zero_page();
 
 	mmu_notifier_invalidate_range_end(mm, mmun_start, mmun_end);
 
_

Patches currently in -mm which might be from lliubbo@gmail.com are

origin.patch
thp-implement-refcounting-for-huge-zero-page.patch
thp-avoid-race-on-multiple-parallel-page-faults-to-the-same-page.patch
hotplug-update-nodemasks-management-fix.patch

