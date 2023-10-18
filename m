Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D20CCCDB47E
	for <mm-commits@archiver.kernel.org>; Wed, 18 Oct 2023 15:40:57 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232311AbjJRPk5 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 18 Oct 2023 11:40:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52114 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232413AbjJRPkz (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 18 Oct 2023 11:40:55 -0400
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0671B111
        for <mm-commits@vger.kernel.org>; Wed, 18 Oct 2023 08:40:53 -0700 (PDT)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 950AEC433C7;
        Wed, 18 Oct 2023 15:40:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1697643652;
        bh=ObQ9caDfjTVS+ecIUfHxw4q+ZrHrGU2hMOWsADmEl3k=;
        h=Date:To:From:Subject:From;
        b=ymH/ifnJ+Lbc7YLh7VOrpFS6xJD9VAH1H0mxCYpTaG5I8grE55Kh3S/kI+TUWwIs3
         LHGv2R4Jqg1Mbnfe71Yk4NDctCdo6cPrMRD4rnzmUfnGWNzt47CdRnMxZR48P1xclm
         TEK5PWJFzh4Kvy7VkJ8mktD7y/sfMKSom0g8MU5g=
Date:   Wed, 18 Oct 2023 08:40:52 -0700
To:     mm-commits@vger.kernel.org, wangkefeng.wang@huawei.com,
        patrick.wang.shcn@gmail.com, catalin.marinas@arm.com,
        liushixin2@huawei.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-kmemleak-fix-partially-freeing-unknown-object-warning.patch added to mm-unstable branch
Message-Id: <20231018154052.950AEC433C7@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/kmemleak: fix partially freeing unknown object warning
has been added to the -mm mm-unstable branch.  Its filename is
     mm-kmemleak-fix-partially-freeing-unknown-object-warning.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-kmemleak-fix-partially-freeing-unknown-object-warning.patch

This patch will later appear in the mm-unstable branch at
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
From: Liu Shixin <liushixin2@huawei.com>
Subject: mm/kmemleak: fix partially freeing unknown object warning
Date: Wed, 18 Oct 2023 18:29:52 +0800

delete_object_part() can be called by multiple callers in the same time. 
If an object is found and removed by a caller, and then another caller try
to find it too, it failed and return directly.  It still be recorded by
kmemleak even if it has already been freed to buddy.  With DEBUG on,
kmemleak will report the following warning,

 kmemleak: Partially freeing unknown object at 0xa1af86000 (size 4096)
 CPU: 0 PID: 742 Comm: test_huge Not tainted 6.6.0-rc3kmemleak+ #54
 Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS 1.13.0-1ubuntu1.1 04/01/2014
 Call Trace:
  <TASK>
  dump_stack_lvl+0x37/0x50
  kmemleak_free_part_phys+0x50/0x60
  hugetlb_vmemmap_optimize+0x172/0x290
  ? __pfx_vmemmap_remap_pte+0x10/0x10
  __prep_new_hugetlb_folio+0xe/0x30
  prep_new_hugetlb_folio.isra.0+0xe/0x40
  alloc_fresh_hugetlb_folio+0xc3/0xd0
  alloc_surplus_hugetlb_folio.constprop.0+0x6e/0xd0
  hugetlb_acct_memory.part.0+0xe6/0x2a0
  hugetlb_reserve_pages+0x110/0x2c0
  hugetlbfs_file_mmap+0x11d/0x1b0
  mmap_region+0x248/0x9a0
  ? hugetlb_get_unmapped_area+0x15c/0x2d0
  do_mmap+0x38b/0x580
  vm_mmap_pgoff+0xe6/0x190
  ksys_mmap_pgoff+0x18a/0x1f0
  do_syscall_64+0x3f/0x90
  entry_SYSCALL_64_after_hwframe+0x6e/0xd8

Expand __create_object() and move __alloc_object() to the beginning.  Then
use kmemleak_lock to protect __find_and_remove_object() and
__link_object() as a whole, which can guarantee all objects are processed
sequentialally.

Link: https://lkml.kernel.org/r/20231018102952.3339837-8-liushixin2@huawei.com
Fixes: 53238a60dd4a ("kmemleak: Allow partial freeing of memory blocks")
Signed-off-by: Liu Shixin <liushixin2@huawei.com>
Cc: Catalin Marinas <catalin.marinas@arm.com>
Cc: Kefeng Wang <wangkefeng.wang@huawei.com>
Cc: Patrick Wang <patrick.wang.shcn@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/kmemleak.c |   42 +++++++++++++++++++++++++++++++-----------
 1 file changed, 31 insertions(+), 11 deletions(-)

--- a/mm/kmemleak.c~mm-kmemleak-fix-partially-freeing-unknown-object-warning
+++ a/mm/kmemleak.c
@@ -816,16 +816,25 @@ static void delete_object_full(unsigned
  */
 static void delete_object_part(unsigned long ptr, size_t size, bool is_phys)
 {
-	struct kmemleak_object *object;
-	unsigned long start, end;
+	struct kmemleak_object *object, *object_l, *object_r;
+	unsigned long start, end, flags;
 
-	object = find_and_remove_object(ptr, 1, is_phys);
+	object_l = __alloc_object(GFP_KERNEL);
+	if (!object_l)
+		return;
+
+	object_r = __alloc_object(GFP_KERNEL);
+	if (!object_r)
+		goto out;
+
+	raw_spin_lock_irqsave(&kmemleak_lock, flags);
+	object = __find_and_remove_object(ptr, 1, is_phys);
 	if (!object) {
 #ifdef DEBUG
 		kmemleak_warn("Partially freeing unknown object at 0x%08lx (size %zu)\n",
 			      ptr, size);
 #endif
-		return;
+		goto unlock;
 	}
 
 	/*
@@ -835,14 +844,25 @@ static void delete_object_part(unsigned
 	 */
 	start = object->pointer;
 	end = object->pointer + object->size;
-	if (ptr > start)
-		__create_object(start, ptr - start, object->min_count,
-			      GFP_KERNEL, is_phys);
-	if (ptr + size < end)
-		__create_object(ptr + size, end - ptr - size, object->min_count,
-			      GFP_KERNEL, is_phys);
+	if ((ptr > start) &&
+	    !__link_object(object_l, start, ptr - start,
+			   object->min_count, is_phys))
+		object_l = NULL;
+	if ((ptr + size < end) &&
+	    !__link_object(object_r, ptr + size, end - ptr - size,
+			   object->min_count, is_phys))
+		object_r = NULL;
+
+unlock:
+	raw_spin_unlock_irqrestore(&kmemleak_lock, flags);
+	if (object)
+		__delete_object(object);
 
-	__delete_object(object);
+out:
+	if (object_l)
+		mem_pool_free(object_l);
+	if (object_r)
+		mem_pool_free(object_r);
 }
 
 static void __paint_it(struct kmemleak_object *object, int color)
_

Patches currently in -mm which might be from liushixin2@huawei.com are

mm-vmscan-try-to-reclaim-swapcache-pages-if-no-swap-space.patch
mm-vmscan-try-to-reclaim-swapcache-pages-if-no-swap-space-v6.patch
bootmem-use-kmemleak_free_part_phys-in-put_page_bootmem.patch
bootmem-use-kmemleak_free_part_phys-in-free_bootmem_page.patch
mm-kmemleak-fix-print-format-of-pointer-in-pr_debug.patch
mm-kmemleak-split-__create_object-into-two-functions.patch
mm-kmemleak-use-mem_pool_free-to-free-object.patch
mm-kmemleak-add-__find_and_remove_object.patch
mm-kmemleak-fix-partially-freeing-unknown-object-warning.patch

