From: akpm@linux-foundation.org
Subject: [folded-merged]
 mm-revert-thp-make-madv_hugepage-check-for-mm-def_flags-ignore-madv_hugepage-on-s390-to-prevent-sigsegv-in-qemu.patch removed from -mm tree
Date: Mon, 07 Apr 2014 14:58:08 -0700
Message-ID: <53431f70.NG3HPVtyzQJD9IUQ%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:39861 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755194AbaDGV6J (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 7 Apr 2014 17:58:09 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, viro@zeniv.linux.org.uk, schwidefsky@de.ibm.com, rientjes@google.com, riel@redhat.com, peterz@infradead.org, pbonzini@redhat.com, oleg@redhat.com, mingo@kernel.org, mgorman@suse.de, kirill.shutemov@linux.intel.com, heiko.carstens@de.ibm.com, gerald.schaefer@de.ibm.com, ebiederm@xmission.com, borntraeger@de.ibm.com, aarcange@redhat.com, athorlton@sgi.com

Subject: [folded-merged] mm-revert-thp-make-madv_hugepage-check-for-mm-def_flags-ignore-madv_hugepage-on-s390-to-prevent-sigsegv-in-qemu.patch removed from -mm tree
To: athorlton@sgi.com,aarcange@redhat.com,borntraeger@de.ibm.com,ebiederm@xmission.com,gerald.schaefer@de.ibm.com,heiko.carstens@de.ibm.com,kirill.shutemov@linux.intel.com,mgorman@suse.de,mingo@kernel.org,oleg@redhat.com,pbonzini@redhat.com,peterz@infradead.org,riel@redhat.com,rientjes@google.com,schwidefsky@de.ibm.com,viro@zeniv.linux.org.uk,mm-commits@vger.kernel.org
From: akpm@linux-foundation.org
Date: Mon, 07 Apr 2014 14:58:08 -0700


The patch titled
     Subject: mm, s390: ignore MADV_HUGEPAGE on s390 to prevent SIGSEGV in qemu
has been removed from the -mm tree.  Its filename was
     mm-revert-thp-make-madv_hugepage-check-for-mm-def_flags-ignore-madv_hugepage-on-s390-to-prevent-sigsegv-in-qemu.patch

This patch was dropped because it was folded into mm-revert-thp-make-madv_hugepage-check-for-mm-def_flags.patch

------------------------------------------------------
From: Alex Thorlton <athorlton@sgi.com>
Subject: mm, s390: ignore MADV_HUGEPAGE on s390 to prevent SIGSEGV in qemu

As Christian pointed out, the recent 'Revert "thp: make MADV_HUGEPAGE
check for mm->def_flags"' breaks qemu, it does QEMU_MADV_HUGEPAGE for all
kvm pages but this doesn't work after s390_enable_sie/thp_split_mm.

Paolo suggested that instead of failing on the call to madvise, we simply
ignore the call (return 0).

Reported-by: Christian Borntraeger <borntraeger@de.ibm.com>
Suggested-by: Paolo Bonzini <pbonzini@redhat.com>
Suggested-by: Oleg Nesterov <oleg@redhat.com>
Signed-off-by: Alex Thorlton <athorlton@sgi.com>
Cc: Gerald Schaefer <gerald.schaefer@de.ibm.com>
Cc: Martin Schwidefsky <schwidefsky@de.ibm.com>
Cc: Heiko Carstens <heiko.carstens@de.ibm.com>
Tested-by: Christian Borntraeger <borntraeger@de.ibm.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>
Cc: "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>
Cc: Mel Gorman <mgorman@suse.de>
Cc: Rik van Riel <riel@redhat.com>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Andrea Arcangeli <aarcange@redhat.com>
Cc: Oleg Nesterov <oleg@redhat.com>
Cc: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: Alexander Viro <viro@zeniv.linux.org.uk>
Cc: David Rientjes <rientjes@google.com>
Acked-by: Paolo Bonzini <pbonzini@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/huge_memory.c |    9 +++++++++
 1 file changed, 9 insertions(+)

diff -puN mm/huge_memory.c~mm-revert-thp-make-madv_hugepage-check-for-mm-def_flags-ignore-madv_hugepage-on-s390-to-prevent-sigsegv-in-qemu mm/huge_memory.c
--- a/mm/huge_memory.c~mm-revert-thp-make-madv_hugepage-check-for-mm-def_flags-ignore-madv_hugepage-on-s390-to-prevent-sigsegv-in-qemu
+++ a/mm/huge_memory.c
@@ -1893,6 +1893,15 @@ int hugepage_madvise(struct vm_area_stru
 {
 	switch (advice) {
 	case MADV_HUGEPAGE:
+#ifdef CONFIG_S390
+		/*
+		 * qemu blindly sets MADV_HUGEPAGE on all allocations, but s390
+		 * can't handle this properly after s390_enable_sie, so we simply
+		 * ignore the madvise to prevent qemu from causing a SIGSEGV.
+		 */
+		if (mm_has_pgste(vma->vm_mm))
+			return 0;
+#endif
 		/*
 		 * Be somewhat over-protective like KSM for now!
 		 */
_

Patches currently in -mm which might be from athorlton@sgi.com are

mm-revert-thp-make-madv_hugepage-check-for-mm-def_flags.patch
mm-thp-add-vm_init_def_mask-and-prctl_thp_disable.patch
exec-kill-the-unnecessary-mm-def_flags-setting-in-load_elf_binary.patch

