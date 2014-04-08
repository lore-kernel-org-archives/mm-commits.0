From: akpm@linux-foundation.org
Subject: [merged] mm-thp-add-vm_init_def_mask-and-prctl_thp_disable.patch
 removed from -mm tree
Date: Tue, 08 Apr 2014 13:38:35 -0700
Message-ID: <53445e4b.FV1kx2QYC2XKrZuU%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:56351 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756207AbaDHUig (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 8 Apr 2014 16:38:36 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, viro@zeniv.linux.org.uk, schwidefsky@de.ibm.com, rientjes@google.com, riel@redhat.com, peterz@infradead.org, pbonzini@redhat.com, oleg@redhat.com, mingo@kernel.org, mgorman@suse.de, kirill.shutemov@linux.intel.com, heiko.carstens@de.ibm.com, hannes@cmpxchg.org, gerald.schaefer@de.ibm.com, ebiederm@xmission.com, borntraeger@de.ibm.com, aarcange@redhat.com, athorlton@sgi.com

Subject: [merged] mm-thp-add-vm_init_def_mask-and-prctl_thp_disable.patch removed from -mm tree
To: athorlton@sgi.com,aarcange@redhat.com,borntraeger@de.ibm.com,ebiederm@xmission.com,gerald.schaefer@de.ibm.com,hannes@cmpxchg.org,heiko.carstens@de.ibm.com,kirill.shutemov@linux.intel.com,mgorman@suse.de,mingo@kernel.org,oleg@redhat.com,pbonzini@redhat.com,peterz@infradead.org,riel@redhat.com,rientjes@google.com,schwidefsky@de.ibm.com,viro@zeniv.linux.org.uk,mm-commits@vger.kernel.org
From: akpm@linux-foundation.org
Date: Tue, 08 Apr 2014 13:38:35 -0700


The patch titled
     Subject: mm, thp: add VM_INIT_DEF_MASK and PRCTL_THP_DISABLE
has been removed from the -mm tree.  Its filename was
     mm-thp-add-vm_init_def_mask-and-prctl_thp_disable.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Alex Thorlton <athorlton@sgi.com>
Subject: mm, thp: add VM_INIT_DEF_MASK and PRCTL_THP_DISABLE

Add VM_INIT_DEF_MASK, to allow us to set the default flags for VMs.  It
also adds a prctl control which allows us to set the THP disable bit in
mm->def_flags so that VMs will pick up the setting as they are created.

Signed-off-by: Alex Thorlton <athorlton@sgi.com>
Suggested-by: Oleg Nesterov <oleg@redhat.com>
Cc: Gerald Schaefer <gerald.schaefer@de.ibm.com>
Cc: Martin Schwidefsky <schwidefsky@de.ibm.com>
Cc: Heiko Carstens <heiko.carstens@de.ibm.com>
Cc: Christian Borntraeger <borntraeger@de.ibm.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>
Cc: "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>
Cc: Mel Gorman <mgorman@suse.de>
Acked-by: Rik van Riel <riel@redhat.com>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Andrea Arcangeli <aarcange@redhat.com>
Cc: Oleg Nesterov <oleg@redhat.com>
Cc: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: Alexander Viro <viro@zeniv.linux.org.uk>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: David Rientjes <rientjes@google.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/mm.h         |    3 +++
 include/uapi/linux/prctl.h |    3 +++
 kernel/fork.c              |   11 ++++++++---
 kernel/sys.c               |   15 +++++++++++++++
 4 files changed, 29 insertions(+), 3 deletions(-)

diff -puN include/linux/mm.h~mm-thp-add-vm_init_def_mask-and-prctl_thp_disable include/linux/mm.h
--- a/include/linux/mm.h~mm-thp-add-vm_init_def_mask-and-prctl_thp_disable
+++ a/include/linux/mm.h
@@ -177,6 +177,9 @@ extern unsigned int kobjsize(const void
  */
 #define VM_SPECIAL (VM_IO | VM_DONTEXPAND | VM_PFNMAP | VM_MIXEDMAP)
 
+/* This mask defines which mm->def_flags a process can inherit its parent */
+#define VM_INIT_DEF_MASK	VM_NOHUGEPAGE
+
 /*
  * mapping from the currently active vm_flags protection bits (the
  * low four bits) to a page protection mask..
diff -puN include/uapi/linux/prctl.h~mm-thp-add-vm_init_def_mask-and-prctl_thp_disable include/uapi/linux/prctl.h
--- a/include/uapi/linux/prctl.h~mm-thp-add-vm_init_def_mask-and-prctl_thp_disable
+++ a/include/uapi/linux/prctl.h
@@ -149,4 +149,7 @@
 
 #define PR_GET_TID_ADDRESS	40
 
+#define PR_SET_THP_DISABLE	41
+#define PR_GET_THP_DISABLE	42
+
 #endif /* _LINUX_PRCTL_H */
diff -puN kernel/fork.c~mm-thp-add-vm_init_def_mask-and-prctl_thp_disable kernel/fork.c
--- a/kernel/fork.c~mm-thp-add-vm_init_def_mask-and-prctl_thp_disable
+++ a/kernel/fork.c
@@ -530,8 +530,6 @@ static struct mm_struct *mm_init(struct
 	atomic_set(&mm->mm_count, 1);
 	init_rwsem(&mm->mmap_sem);
 	INIT_LIST_HEAD(&mm->mmlist);
-	mm->flags = (current->mm) ?
-		(current->mm->flags & MMF_INIT_MASK) : default_dump_filter;
 	mm->core_state = NULL;
 	atomic_long_set(&mm->nr_ptes, 0);
 	memset(&mm->rss_stat, 0, sizeof(mm->rss_stat));
@@ -540,8 +538,15 @@ static struct mm_struct *mm_init(struct
 	mm_init_owner(mm, p);
 	clear_tlb_flush_pending(mm);
 
-	if (likely(!mm_alloc_pgd(mm))) {
+	if (current->mm) {
+		mm->flags = current->mm->flags & MMF_INIT_MASK;
+		mm->def_flags = current->mm->def_flags & VM_INIT_DEF_MASK;
+	} else {
+		mm->flags = default_dump_filter;
 		mm->def_flags = 0;
+	}
+
+	if (likely(!mm_alloc_pgd(mm))) {
 		mmu_notifier_mm_init(mm);
 		return mm;
 	}
diff -puN kernel/sys.c~mm-thp-add-vm_init_def_mask-and-prctl_thp_disable kernel/sys.c
--- a/kernel/sys.c~mm-thp-add-vm_init_def_mask-and-prctl_thp_disable
+++ a/kernel/sys.c
@@ -1996,6 +1996,21 @@ SYSCALL_DEFINE5(prctl, int, option, unsi
 		if (arg2 || arg3 || arg4 || arg5)
 			return -EINVAL;
 		return current->no_new_privs ? 1 : 0;
+	case PR_GET_THP_DISABLE:
+		if (arg2 || arg3 || arg4 || arg5)
+			return -EINVAL;
+		error = !!(me->mm->def_flags & VM_NOHUGEPAGE);
+		break;
+	case PR_SET_THP_DISABLE:
+		if (arg3 || arg4 || arg5)
+			return -EINVAL;
+		down_write(&me->mm->mmap_sem);
+		if (arg2)
+			me->mm->def_flags |= VM_NOHUGEPAGE;
+		else
+			me->mm->def_flags &= ~VM_NOHUGEPAGE;
+		up_write(&me->mm->mmap_sem);
+		break;
 	default:
 		error = -EINVAL;
 		break;
_

Patches currently in -mm which might be from athorlton@sgi.com are

origin.patch

