From: akpm@linux-foundation.org
Subject: [merged] mm-dont-overwrite-mm-def_flags-in-do_mlockall.patch removed from -mm tree
Date: Wed, 13 Feb 2013 12:35:57 -0800
Message-ID: <20130213203558.15AD55A41B5__30600.545978132$1360787794$gmane$org@corp2gmr1-2.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-qc0-f202.google.com ([209.85.216.202]:61860 "EHLO
	mail-qc0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934065Ab3BMUf7 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 13 Feb 2013 15:35:59 -0500
Received: by mail-qc0-f202.google.com with SMTP id k26so165886qcs.5
        for <mm-commits@vger.kernel.org>; Wed, 13 Feb 2013 12:35:58 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: gerald.schaefer@de.ibm.com, aarcange@redhat.com, heiko.carstens@de.ibm.com, hughd@google.com, schwidefsky@de.ibm.com, stable@vger.kernel.org, vgoyal@redhat.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm: don't overwrite mm->def_flags in do_mlockall()
has been removed from the -mm tree.  Its filename was
     mm-dont-overwrite-mm-def_flags-in-do_mlockall.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Gerald Schaefer <gerald.schaefer@de.ibm.com>
Subject: mm: don't overwrite mm->def_flags in do_mlockall()

With commit 8e72033 "thp: make MADV_HUGEPAGE check for mm->def_flags"
the VM_NOHUGEPAGE flag may be set on s390 in mm->def_flags for certain
processes, to prevent future thp mappings. This would be overwritten
by do_mlockall(), which sets it back to 0 with an optional VM_LOCKED
flag set.

To fix this, instead of overwriting mm->def_flags in do_mlockall(),
only the VM_LOCKED flag should be set or cleared.

Signed-off-by: Gerald Schaefer <gerald.schaefer@de.ibm.com>
Reported-by: Vivek Goyal <vgoyal@redhat.com>
Cc: Andrea Arcangeli <aarcange@redhat.com>
Cc: Hugh Dickins <hughd@google.com>
Cc: Martin Schwidefsky <schwidefsky@de.ibm.com>
Cc: Heiko Carstens <heiko.carstens@de.ibm.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/mlock.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff -puN mm/mlock.c~mm-dont-overwrite-mm-def_flags-in-do_mlockall mm/mlock.c
--- a/mm/mlock.c~mm-dont-overwrite-mm-def_flags-in-do_mlockall
+++ a/mm/mlock.c
@@ -517,11 +517,11 @@ SYSCALL_DEFINE2(munlock, unsigned long, 
 static int do_mlockall(int flags)
 {
 	struct vm_area_struct * vma, * prev = NULL;
-	unsigned int def_flags = 0;
 
 	if (flags & MCL_FUTURE)
-		def_flags = VM_LOCKED;
-	current->mm->def_flags = def_flags;
+		current->mm->def_flags |= VM_LOCKED;
+	else
+		current->mm->def_flags &= ~VM_LOCKED;
 	if (flags == MCL_FUTURE)
 		goto out;
 
_

Patches currently in -mm which might be from gerald.schaefer@de.ibm.com are

origin.patch
linux-next.patch
ksm-allow-trees-per-numa-node.patch
ksm-add-sysfs-abi-documentation.patch
ksm-trivial-tidyups.patch
ksm-reorganize-ksm_check_stable_tree.patch
ksm-get_ksm_page-locked.patch
ksm-remove-old-stable-nodes-more-thoroughly.patch
ksm-make-ksm-page-migration-possible.patch
ksm-make-merge_across_nodes-migration-safe.patch
ksm-enable-ksm-page-migration.patch
mm-remove-offlining-arg-to-migrate_pages.patch
ksm-stop-hotremove-lockdep-warning.patch

