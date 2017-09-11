From: akpm@linux-foundation.org
Subject: [merged] mm-fix-mem_cgroup_oom_disable-call-missing.patch
 removed from -mm tree
Date: Mon, 11 Sep 2017 12:40:16 -0700
Message-ID: <20170911194016.ymGaxC9II%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:49354 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751015AbdIKTkR (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 11 Sep 2017 15:40:17 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: kirill@shutemov.name, ldufour@linux.vnet.ibm.com, mhocko@suse.com, mm-commits@vger.kernel.org, stable@vger.kernel.org


The patch titled
     Subject: mm/memory.c: fix mem_cgroup_oom_disable() call missing
has been removed from the -mm tree.  Its filename was
     mm-fix-mem_cgroup_oom_disable-call-missing.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Laurent Dufour <ldufour@linux.vnet.ibm.com>
Subject: mm/memory.c: fix mem_cgroup_oom_disable() call missing

Seen while reading the code, in handle_mm_fault(), in the case
arch_vma_access_permitted() is failing the call to
mem_cgroup_oom_disable() is not made.

To fix that, move the call to mem_cgroup_oom_enable() after calling
arch_vma_access_permitted() as it should not have entered the memcg OOM.

Link: http://lkml.kernel.org/r/1504625439-31313-1-git-send-email-ldufour@linux.vnet.ibm.com
Fixes: bae473a423f6 ("mm: introduce fault_env")
Signed-off-by: Laurent Dufour <ldufour@linux.vnet.ibm.com>
Acked-by: Kirill A. Shutemov <kirill@shutemov.name>
Acked-by: Michal Hocko <mhocko@suse.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memory.c |   10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

diff -puN mm/memory.c~mm-fix-mem_cgroup_oom_disable-call-missing mm/memory.c
--- a/mm/memory.c~mm-fix-mem_cgroup_oom_disable-call-missing
+++ a/mm/memory.c
@@ -4053,6 +4053,11 @@ int handle_mm_fault(struct vm_area_struc
 	/* do counter updates before entering really critical section. */
 	check_sync_rss_stat(current);
 
+	if (!arch_vma_access_permitted(vma, flags & FAULT_FLAG_WRITE,
+					    flags & FAULT_FLAG_INSTRUCTION,
+					    flags & FAULT_FLAG_REMOTE))
+		return VM_FAULT_SIGSEGV;
+
 	/*
 	 * Enable the memcg OOM handling for faults triggered in user
 	 * space.  Kernel faults are handled more gracefully.
@@ -4060,11 +4065,6 @@ int handle_mm_fault(struct vm_area_struc
 	if (flags & FAULT_FLAG_USER)
 		mem_cgroup_oom_enable();
 
-	if (!arch_vma_access_permitted(vma, flags & FAULT_FLAG_WRITE,
-					    flags & FAULT_FLAG_INSTRUCTION,
-					    flags & FAULT_FLAG_REMOTE))
-		return VM_FAULT_SIGSEGV;
