Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A1822C4321E
	for <mm-commits@archiver.kernel.org>; Thu,  1 Dec 2022 00:00:25 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229966AbiLAAAY (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 30 Nov 2022 19:00:24 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46428 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229812AbiLAAAR (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 30 Nov 2022 19:00:17 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C52E95ADD3
        for <mm-commits@vger.kernel.org>; Wed, 30 Nov 2022 16:00:15 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 64D70B81D12
        for <mm-commits@vger.kernel.org>; Thu,  1 Dec 2022 00:00:14 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 20B5FC433C1;
        Thu,  1 Dec 2022 00:00:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1669852813;
        bh=WSH8wJAakWitLJNCT34COTv4vJTxJegunItzjQri0lY=;
        h=Date:To:From:Subject:From;
        b=iJr1FA453NTEpewefc9qXy38W8i4saP1zU1chvFcIQ6JNkswG0CEdtPhIUugVdZN9
         NOtK5JRGcQMdkRr+388bZVLU3WNVLzuN1WnOZx5m/C7JsKriNKHl0g+DBK7IQlgLkk
         K7/fVuH9PUWHoL7HsYpuKOWkJkV69fPQnTDcvS1Y=
Date:   Wed, 30 Nov 2022 16:00:12 -0800
To:     mm-commits@vger.kernel.org, xueshuai@linux.alibaba.com,
        willy@infradead.org, npiggin@gmail.com, naoya.horiguchi@nec.com,
        mpe@ellerman.id.au, linmiaohe@huawei.com, glider@google.com,
        dan.j.williams@intel.com, christophe.leroy@csgroup.eu,
        tony.luck@intel.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-hwpoison-try-to-recover-from-copy-on-write-faults.patch removed from -mm tree
Message-Id: <20221201000013.20B5FC433C1@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: mm, hwpoison: try to recover from copy-on write faults
has been removed from the -mm tree.  Its filename was
     mm-hwpoison-try-to-recover-from-copy-on-write-faults.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Tony Luck <tony.luck@intel.com>
Subject: mm, hwpoison: try to recover from copy-on write faults
Date: Fri, 21 Oct 2022 13:01:19 -0700

Patch series "Copy-on-write poison recovery", v3.

Part 1 deals with the process that triggered the copy on write fault with
a store to a shared read-only page.  That process is send a SIGBUS with
the usual machine check decoration to specify the virtual address of the
lost page, together with the scope.

Part 2 sets up to asynchronously take the page with the uncorrected error
offline to prevent additional machine check faults.  H/t to Miaohe Lin
<linmiaohe@huawei.com> and Shuai Xue <xueshuai@linux.alibaba.com> for
pointing me to the existing function to queue a call to memory_failure().

On x86 there is some duplicate reporting (because the error is also
signalled by the memory controller as well as by the core that triggered
the machine check).  Console logs look like this:


This patch (of 2):

If the kernel is copying a page as the result of a copy-on-write
fault and runs into an uncorrectable error, Linux will crash because
it does not have recovery code for this case where poison is consumed
by the kernel.

It is easy to set up a test case. Just inject an error into a private
page, fork(2), and have the child process write to the page.

I wrapped that neatly into a test at:

  git://git.kernel.org/pub/scm/linux/kernel/git/aegl/ras-tools.git

just enable ACPI error injection and run:

  # ./einj_mem-uc -f copy-on-write

Add a new copy_user_highpage_mc() function that uses copy_mc_to_kernel()
on architectures where that is available (currently x86 and powerpc).
When an error is detected during the page copy, return VM_FAULT_HWPOISON
to caller of wp_page_copy(). This propagates up the call stack. Both x86
and powerpc have code in their fault handler to deal with this code by
sending a SIGBUS to the application.

Note that this patch avoids a system crash and signals the process that
triggered the copy-on-write action. It does not take any action for the
memory error that is still in the shared page. To handle that a call to
memory_failure() is needed. But this cannot be done from wp_page_copy()
because it holds mmap_lock(). Perhaps the architecture fault handlers
can deal with this loose end in a subsequent patch?

On Intel/x86 this loose end will often be handled automatically because
the memory controller provides an additional notification of the h/w
poison in memory, the handler for this will call memory_failure(). This
isn't a 100% solution. If there are multiple errors, not all may be
logged in this way.

[tony.luck@intel.com: add call to kmsan_unpoison_memory(), per Miaohe Lin]
  Link: https://lkml.kernel.org/r/20221031201029.102123-2-tony.luck@intel.com
Link: https://lkml.kernel.org/r/20221021200120.175753-1-tony.luck@intel.com
Link: https://lkml.kernel.org/r/20221021200120.175753-2-tony.luck@intel.com
Signed-off-by: Tony Luck <tony.luck@intel.com>
Reviewed-by: Dan Williams <dan.j.williams@intel.com>
Reviewed-by: Naoya Horiguchi <naoya.horiguchi@nec.com>
Reviewed-by: Miaohe Lin <linmiaohe@huawei.com>
Reviewed-by: Alexander Potapenko <glider@google.com>
Tested-by: Shuai Xue <xueshuai@linux.alibaba.com>
Cc: Christophe Leroy <christophe.leroy@csgroup.eu>
Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: Michael Ellerman <mpe@ellerman.id.au>
Cc: Nicholas Piggin <npiggin@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/highmem.h |   26 ++++++++++++++++++++++++++
 mm/memory.c             |   30 ++++++++++++++++++++----------
 2 files changed, 46 insertions(+), 10 deletions(-)

--- a/include/linux/highmem.h~mm-hwpoison-try-to-recover-from-copy-on-write-faults
+++ a/include/linux/highmem.h
@@ -319,6 +319,32 @@ static inline void copy_user_highpage(st
 
 #endif
 
+#ifdef copy_mc_to_kernel
+static inline int copy_mc_user_highpage(struct page *to, struct page *from,
+					unsigned long vaddr, struct vm_area_struct *vma)
+{
+	unsigned long ret;
+	char *vfrom, *vto;
+
+	vfrom = kmap_local_page(from);
+	vto = kmap_local_page(to);
+	ret = copy_mc_to_kernel(vto, vfrom, PAGE_SIZE);
+	if (!ret)
+		kmsan_unpoison_memory(page_address(to), PAGE_SIZE);
+	kunmap_local(vto);
+	kunmap_local(vfrom);
+
+	return ret;
+}
+#else
+static inline int copy_mc_user_highpage(struct page *to, struct page *from,
+					unsigned long vaddr, struct vm_area_struct *vma)
+{
+	copy_user_highpage(to, from, vaddr, vma);
+	return 0;
+}
+#endif
+
 #ifndef __HAVE_ARCH_COPY_HIGHPAGE
 
 static inline void copy_highpage(struct page *to, struct page *from)
--- a/mm/memory.c~mm-hwpoison-try-to-recover-from-copy-on-write-faults
+++ a/mm/memory.c
@@ -2798,10 +2798,16 @@ static inline int pte_unmap_same(struct
 	return same;
 }
 
-static inline bool __wp_page_copy_user(struct page *dst, struct page *src,
-				       struct vm_fault *vmf)
+/*
+ * Return:
+ *	0:		copied succeeded
+ *	-EHWPOISON:	copy failed due to hwpoison in source page
+ *	-EAGAIN:	copied failed (some other reason)
+ */
+static inline int __wp_page_copy_user(struct page *dst, struct page *src,
+				      struct vm_fault *vmf)
 {
-	bool ret;
+	int ret;
 	void *kaddr;
 	void __user *uaddr;
 	bool locked = false;
@@ -2810,8 +2816,9 @@ static inline bool __wp_page_copy_user(s
 	unsigned long addr = vmf->address;
 
 	if (likely(src)) {
-		copy_user_highpage(dst, src, addr, vma);
-		return true;
+		if (copy_mc_user_highpage(dst, src, addr, vma))
+			return -EHWPOISON;
+		return 0;
 	}
 
 	/*
@@ -2838,7 +2845,7 @@ static inline bool __wp_page_copy_user(s
 			 * and update local tlb only
 			 */
 			update_mmu_tlb(vma, addr, vmf->pte);
-			ret = false;
+			ret = -EAGAIN;
 			goto pte_unlock;
 		}
 
@@ -2863,7 +2870,7 @@ static inline bool __wp_page_copy_user(s
 		if (!likely(pte_same(*vmf->pte, vmf->orig_pte))) {
 			/* The PTE changed under us, update local tlb */
 			update_mmu_tlb(vma, addr, vmf->pte);
-			ret = false;
+			ret = -EAGAIN;
 			goto pte_unlock;
 		}
 
@@ -2882,7 +2889,7 @@ warn:
 		}
 	}
 
-	ret = true;
+	ret = 0;
 
 pte_unlock:
 	if (locked)
@@ -3054,6 +3061,7 @@ static vm_fault_t wp_page_copy(struct vm
 	pte_t entry;
 	int page_copied = 0;
 	struct mmu_notifier_range range;
+	int ret;
 
 	delayacct_wpcopy_start();
 
@@ -3071,19 +3079,21 @@ static vm_fault_t wp_page_copy(struct vm
 		if (!new_page)
 			goto oom;
 
-		if (!__wp_page_copy_user(new_page, old_page, vmf)) {
+		ret = __wp_page_copy_user(new_page, old_page, vmf);
+		if (ret) {
 			/*
 			 * COW failed, if the fault was solved by other,
 			 * it's fine. If not, userspace would re-fault on
 			 * the same address and we will handle the fault
 			 * from the second attempt.
+			 * The -EHWPOISON case will not be retried.
 			 */
 			put_page(new_page);
 			if (old_page)
 				put_page(old_page);
 
 			delayacct_wpcopy_end();
-			return 0;
+			return ret == -EHWPOISON ? VM_FAULT_HWPOISON : 0;
 		}
 		kmsan_copy_page_meta(new_page, old_page);
 	}
_

Patches currently in -mm which might be from tony.luck@intel.com are


