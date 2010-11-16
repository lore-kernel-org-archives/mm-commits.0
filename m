From: akpm@linux-foundation.org
Subject: + nommu-yield-cpu-while-disposing-vm.patch added to -mm tree
Date: Tue, 16 Nov 2010 12:26:00 -0800
Message-ID: <201011162026.oAGKQ1ke005706@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:48954 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754990Ab0KPU1o (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 16 Nov 2010 15:27:44 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: steve@digidescorp.com, gerg@snapgear.com, stable@kernel.org


The patch titled
     nommu: yield CPU while disposing VM
has been added to the -mm tree.  Its filename is
     nommu-yield-cpu-while-disposing-vm.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://userweb.kernel.org/~akpm/stuff/added-to-mm.txt to find
out what to do about this

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

nommu-yield-cpu-while-disposing-vm.patch

