From: akpm@linux-foundation.org
Subject: [patch 068/142] userfaultfd: hugetlbfs:
 userfaultfd_huge_must_wait for hugepmd ranges
Date: Wed, 22 Feb 2017 15:43:10 -0800
Message-ID: <58ae220e.mXtXZhJBYvbRpR2a%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:48642 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S934685AbdBVXnM (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 22 Feb 2017 18:43:12 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: torvalds@linux-foundation.org, mm-commits@vger.kernel.org, akpm@linux-foundation.org, mike.kravetz@oracle.com, RAPOPORT@il.ibm.com, aarcange@redhat.com, dgilbert@redhat.com, hillf.zj@alibaba-inc.com, rppt@linux.vnet.ibm.com, xemul@parallels.com

From: Mike Kravetz <mike.kravetz@oracle.com>
Subject: userfaultfd: hugetlbfs: userfaultfd_huge_must_wait for hugepmd ranges

Add routine userfaultfd_huge_must_wait which has the same functionality as
the existing userfaultfd_must_wait routine.  Only difference is that new
routine must handle page table structure for hugepmd vmas.

Link: http://lkml.kernel.org/r/20161216144821.5183-24-aarcange@redhat.com
Signed-off-by: Mike Kravetz <mike.kravetz@oracle.com>
Signed-off-by: Andrea Arcangeli <aarcange@redhat.com>
Cc: "Dr. David Alan Gilbert" <dgilbert@redhat.com>
Cc: Hillf Danton <hillf.zj@alibaba-inc.com>
Cc: Michael Rapoport <RAPOPORT@il.ibm.com>
Cc: Mike Rapoport <rppt@linux.vnet.ibm.com>
Cc: Pavel Emelyanov <xemul@parallels.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/userfaultfd.c |   51 +++++++++++++++++++++++++++++++++++++++++++--
 1 file changed, 49 insertions(+), 2 deletions(-)

diff -puN fs/userfaultfd.c~userfaultfd-hugetlbfs-userfaultfd_huge_must_wait-for-hugepmd-ranges fs/userfaultfd.c
--- a/fs/userfaultfd.c~userfaultfd-hugetlbfs-userfaultfd_huge_must_wait-for-hugepmd-ranges
+++ a/fs/userfaultfd.c
@@ -202,6 +202,49 @@ static inline struct uffd_msg userfault_
 	return msg;
 }
 
+#ifdef CONFIG_HUGETLB_PAGE
+/*
+ * Same functionality as userfaultfd_must_wait below with modifications for
+ * hugepmd ranges.
+ */
+static inline bool userfaultfd_huge_must_wait(struct userfaultfd_ctx *ctx,
+					 unsigned long address,
+					 unsigned long flags,
+					 unsigned long reason)
+{
+	struct mm_struct *mm = ctx->mm;
+	pte_t *pte;
+	bool ret = true;
+
+	VM_BUG_ON(!rwsem_is_locked(&mm->mmap_sem));
+
+	pte = huge_pte_offset(mm, address);
+	if (!pte)
+		goto out;
+
+	ret = false;
+
+	/*
+	 * Lockless access: we're in a wait_event so it's ok if it
+	 * changes under us.
+	 */
+	if (huge_pte_none(*pte))
+		ret = true;
+	if (!huge_pte_write(*pte) && (reason & VM_UFFD_WP))
+		ret = true;
+out:
+	return ret;
+}
+#else
+static inline bool userfaultfd_huge_must_wait(struct userfaultfd_ctx *ctx,
+					 unsigned long address,
+					 unsigned long flags,
+					 unsigned long reason)
+{
+	return false;	/* should never get here */
+}
+#endif /* CONFIG_HUGETLB_PAGE */
+
 /*
  * Verify the pagetables are still not ok after having reigstered into
  * the fault_pending_wqh to avoid userland having to UFFDIO_WAKE any
@@ -378,8 +421,12 @@ int handle_userfault(struct vm_fault *vm
 	set_current_state(blocking_state);
 	spin_unlock(&ctx->fault_pending_wqh.lock);
 
-	must_wait = userfaultfd_must_wait(ctx, vmf->address, vmf->flags,
-					  reason);
+	if (!is_vm_hugetlb_page(vmf->vma))
+		must_wait = userfaultfd_must_wait(ctx, vmf->address, vmf->flags,
+						  reason);
+	else
+		must_wait = userfaultfd_huge_must_wait(ctx, vmf->address,
+						       vmf->flags, reason);
 	up_read(&mm->mmap_sem);
 
 	if (likely(must_wait && !ACCESS_ONCE(ctx->released) &&
_
