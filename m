From: akpm@linux-foundation.org
Subject: [merged] nommu-yield-cpu-while-disposing-vm.patch removed from -mm tree
Date: Mon, 29 Nov 2010 11:50:47 -0800
Message-ID: <201011291951.oATJpGXg007277@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:59392 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752918Ab0K2Tvu (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 29 Nov 2010 14:51:50 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: steve@digidescorp.com, gerg@snapgear.com, kosaki.motohiro@jp.fujitsu.com, stable@kernel.org, mm-commits@vger.kernel.org


The patch titled
     nommu: yield CPU while disposing VM
has been removed from the -mm tree.  Its filename was
     nommu-yield-cpu-while-disposing-vm.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: nommu: yield CPU while disposing VM
From: "Steven J. Magnani" <steve@digidescorp.com>

Depending on processor speed, page size, and the amount of memory a
process is allowed to amass, cleanup of a large VM may freeze the system
for many seconds.  This can result in a watchdog timeout.

Make sure other tasks receive some service when cleaning up large VMs.

Signed-off-by: Steven J. Magnani <steve@digidescorp.com>
Cc: Greg Ungerer <gerg@snapgear.com>
Reviewed-by: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Cc: <stable@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/nommu.c |    1 +
 1 file changed, 1 insertion(+)

diff -puN mm/nommu.c~nommu-yield-cpu-while-disposing-vm mm/nommu.c
--- a/mm/nommu.c~nommu-yield-cpu-while-disposing-vm
+++ a/mm/nommu.c
@@ -1717,6 +1717,7 @@ void exit_mmap(struct mm_struct *mm)
 		mm->mmap = vma->vm_next;
 		delete_vma_from_mm(vma);
 		delete_vma(mm, vma);
+		cond_resched();
 	}
 
 	kleave("");
_

Patches currently in -mm which might be from steve@digidescorp.com are

origin.patch

