From: akpm@linux-foundation.org
Subject: - uml-free-ldt-state-on-process-exit.patch removed from -mm tree
Date: Tue, 16 Oct 2007 13:37:50 -0700
Message-ID: <200710162037.l9GKboWx015320@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:37206 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1763242AbXJPVHd (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 16 Oct 2007 17:07:33 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: jdike@addtoit.com, jdike@linux.intel.com, mm-commits@vger.kernel.org


The patch titled
     uml: free LDT state on process exit
has been removed from the -mm tree.  Its filename was
     uml-free-ldt-state-on-process-exit.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: uml: free LDT state on process exit
From: Jeff Dike <jdike@addtoit.com>

The space allocated for a process LDT wasn't being freed when the process
exited.

Signed-off-by: Jeff Dike <jdike@linux.intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/um/kernel/skas/mmu.c |    2 ++
 1 file changed, 2 insertions(+)

diff -puN arch/um/kernel/skas/mmu.c~uml-free-ldt-state-on-process-exit arch/um/kernel/skas/mmu.c
--- a/arch/um/kernel/skas/mmu.c~uml-free-ldt-state-on-process-exit
+++ a/arch/um/kernel/skas/mmu.c
@@ -149,4 +149,6 @@ void destroy_context(struct mm_struct *m
 		pmd_free((pmd_t *) mmu->last_pmd);
 #endif
 	}
+
+	free_ldt(mmu);
 }
_

Patches currently in -mm which might be from jdike@addtoit.com are

origin.patch
git-kvm.patch
uml-header_ops-conversion-needed-for-non-ethernet-drivers.patch
bitops-introduce-lock-ops.patch
