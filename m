From: akpm@linux-foundation.org
Subject: [merged]
 mm-mlock-avoid-increase-mm-locked_vm-on-mlock-when-already-mlock2mlock_onfault.patch removed from -mm tree
Date: Mon, 10 Oct 2016 15:44:39 -0700
Message-ID: <57fc19d7.xDmf7wOizeGdx0QS%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:36786 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752421AbcJJWok (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 10 Oct 2016 18:44:40 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: wei.guo.simon@gmail.com, emunson@akamai.com, geert@linux-m68k.org, kirill.shutemov@linux.intel.com, klimov.linux@gmail.com, mgorman@techsingularity.net, mhocko@suse.com, rientjes@google.com, shuah@kernel.org, treding@nvidia.com, vbabka@suse.cz, mm-commits@vger.kernel.org


The patch titled
     Subject: mm: mlock: avoid increase mm->locked_vm on mlock() when already mlock2(,MLOCK_ONFAULT)
has been removed from the -mm tree.  Its filename was
     mm-mlock-avoid-increase-mm-locked_vm-on-mlock-when-already-mlock2mlock_onfault.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Simon Guo <wei.guo.simon@gmail.com>
Subject: mm: mlock: avoid increase mm->locked_vm on mlock() when already mlock2(,MLOCK_ONFAULT)

When one vma was with flag VM_LOCKED|VM_LOCKONFAULT (by invoking
mlock2(,MLOCK_ONFAULT)), it can again be populated with mlock() with
VM_LOCKED flag only.

There is a hole in mlock_fixup() which increase mm->locked_vm twice even
the two operations are on the same vma and both with VM_LOCKED flags.

The issue can be reproduced by following code:
mlock2(p, 1024 * 64, MLOCK_ONFAULT); //VM_LOCKED|VM_LOCKONFAULT
mlock(p, 1024 * 64);  //VM_LOCKED
Then check the increase VmLck field in /proc/pid/status(to 128k).

When vma is set with different vm_flags, and the new vm_flags is with
VM_LOCKED, it is not necessarily be a "new locked" vma.  This patch
corrects this bug by prevent mm->locked_vm from increment when old
vm_flags is already VM_LOCKED.

Link: http://lkml.kernel.org/r/1472554781-9835-3-git-send-email-wei.guo.simon@gmail.com
Signed-off-by: Simon Guo <wei.guo.simon@gmail.com>
Acked-by: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
Cc: Alexey Klimov <klimov.linux@gmail.com>
Cc: Eric B Munson <emunson@akamai.com>
Cc: Geert Uytterhoeven <geert@linux-m68k.org>
Cc: Mel Gorman <mgorman@techsingularity.net>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Shuah Khan <shuah@kernel.org>
Cc: Simon Guo <wei.guo.simon@gmail.com>
Cc: Thierry Reding <treding@nvidia.com>
Cc: Vlastimil Babka <vbabka@suse.cz>
Cc: David Rientjes <rientjes@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/mlock.c |    3 +++
 1 file changed, 3 insertions(+)

diff -puN mm/mlock.c~mm-mlock-avoid-increase-mm-locked_vm-on-mlock-when-already-mlock2mlock_onfault mm/mlock.c
--- a/mm/mlock.c~mm-mlock-avoid-increase-mm-locked_vm-on-mlock-when-already-mlock2mlock_onfault
+++ a/mm/mlock.c
@@ -516,6 +516,7 @@ static int mlock_fixup(struct vm_area_st
 	int nr_pages;
 	int ret = 0;
 	int lock = !!(newflags & VM_LOCKED);
+	vm_flags_t old_flags = vma->vm_flags;
 
 	if (newflags == vma->vm_flags || (vma->vm_flags & VM_SPECIAL) ||
 	    is_vm_hugetlb_page(vma) || vma == get_gate_vma(current->mm))
@@ -550,6 +551,8 @@ success:
 	nr_pages = (end - start) >> PAGE_SHIFT;
 	if (!lock)
 		nr_pages = -nr_pages;
+	else if (old_flags & VM_LOCKED)
+		nr_pages = 0;
 	mm->locked_vm += nr_pages;
 
 	/*
_

Patches currently in -mm which might be from wei.guo.simon@gmail.com are


