From: akpm@linux-foundation.org
Subject: [merged] mm-memoryc-print_vma_addr-call-up_readmm-mmap_sem-directly.patch removed from -mm tree
Date: Wed, 01 Aug 2012 13:14:23 -0700
Message-ID: <20120801201423.F0E445C0060@hpza9.eem.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-wg0-f74.google.com ([74.125.82.74]:65135 "EHLO
	mail-wg0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755945Ab2HAUOZ (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 1 Aug 2012 16:14:25 -0400
Received: by wgbdt11 with SMTP id dt11so342543wgb.1
        for <mm-commits@vger.kernel.org>; Wed, 01 Aug 2012 13:14:24 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: jeff.liu@oracle.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm/memory.c:print_vma_addr(): call up_read(&mm->mmap_sem) directly
has been removed from the -mm tree.  Its filename was
     mm-memoryc-print_vma_addr-call-up_readmm-mmap_sem-directly.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Jeff Liu <jeff.liu@oracle.com>
Subject: mm/memory.c:print_vma_addr(): call up_read(&mm->mmap_sem) directly

Call up_read(&mm->mmap_sem) directly since we have already got mm via
current->mm at the beginning of print_vma_addr().

Signed-off-by: Jie Liu <jeff.liu@oracle.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memory.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN mm/memory.c~mm-memoryc-print_vma_addr-call-up_readmm-mmap_sem-directly mm/memory.c
--- a/mm/memory.c~mm-memoryc-print_vma_addr-call-up_readmm-mmap_sem-directly
+++ a/mm/memory.c
@@ -3941,7 +3941,7 @@ void print_vma_addr(char *prefix, unsign
 			free_page((unsigned long)buf);
 		}
 	}
-	up_read(&current->mm->mmap_sem);
+	up_read(&mm->mmap_sem);
 }
 
 #ifdef CONFIG_PROVE_LOCKING
_

Patches currently in -mm which might be from jeff.liu@oracle.com are

origin.patch

