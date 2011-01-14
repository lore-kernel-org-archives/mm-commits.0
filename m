From: akpm@linux-foundation.org
Subject: [merged] thp-khugepaged-vma-merge.patch removed from -mm tree
Date: Fri, 14 Jan 2011 14:47:43 -0800
Message-ID: <201101142250.p0EMoXF1005420@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:57208 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752608Ab1ANWuo (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 14 Jan 2011 17:50:44 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: aarcange@redhat.com, mm-commits@vger.kernel.org


The patch titled
     thp: khugepaged vma merge
has been removed from the -mm tree.  Its filename was
     thp-khugepaged-vma-merge.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: thp: khugepaged vma merge
From: Andrea Arcangeli <aarcange@redhat.com>

register in khugepaged if the vma grows.

Signed-off-by: Andrea Arcangeli <aarcange@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/mmap.c |    5 +++++
 1 file changed, 5 insertions(+)

diff -puN mm/mmap.c~thp-khugepaged-vma-merge mm/mmap.c
--- a/mm/mmap.c~thp-khugepaged-vma-merge
+++ a/mm/mmap.c
@@ -29,6 +29,7 @@
 #include <linux/mmu_notifier.h>
 #include <linux/perf_event.h>
 #include <linux/audit.h>
+#include <linux/khugepaged.h>
 
 #include <asm/uaccess.h>
 #include <asm/cacheflush.h>
@@ -815,6 +816,7 @@ struct vm_area_struct *vma_merge(struct 
 				end, prev->vm_pgoff, NULL);
 		if (err)
 			return NULL;
+		khugepaged_enter_vma_merge(prev);
 		return prev;
 	}
 
@@ -833,6 +835,7 @@ struct vm_area_struct *vma_merge(struct 
 				next->vm_pgoff - pglen, NULL);
 		if (err)
 			return NULL;
+		khugepaged_enter_vma_merge(area);
 		return area;
 	}
 
@@ -1761,6 +1764,7 @@ int expand_upwards(struct vm_area_struct
 		}
 	}
 	vma_unlock_anon_vma(vma);
+	khugepaged_enter_vma_merge(vma);
 	return error;
 }
 #endif /* CONFIG_STACK_GROWSUP || CONFIG_IA64 */
@@ -1808,6 +1812,7 @@ static int expand_downwards(struct vm_ar
 		}
 	}
 	vma_unlock_anon_vma(vma);
+	khugepaged_enter_vma_merge(vma);
 	return error;
 }
 
_

Patches currently in -mm which might be from aarcange@redhat.com are

origin.patch
thp-add-pagetranscompound.patch

