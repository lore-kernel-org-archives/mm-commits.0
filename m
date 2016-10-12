From: akpm@linux-foundation.org
Subject: +
 dont-touch-single-threaded-ptes-which-are-on-the-right-node-fix.patch added to -mm tree
Date: Wed, 12 Oct 2016 16:18:48 -0700
Message-ID: <57fec4d8.TmygRDo4FBomWVdG%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:40670 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932724AbcJLXZu (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 12 Oct 2016 19:25:50 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, ak@linux.intel.com, mm-commits@vger.kernel.org


The patch titled
     Subject: dont-touch-single-threaded-ptes-which-are-on-the-right-node-fix
has been added to the -mm tree.  Its filename is
     dont-touch-single-threaded-ptes-which-are-on-the-right-node-fix.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/dont-touch-single-threaded-ptes-which-are-on-the-right-node-fix.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/dont-touch-single-threaded-ptes-which-are-on-the-right-node-fix.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: dont-touch-single-threaded-ptes-which-are-on-the-right-node-fix

tweak code layout

Cc: Andi Kleen <ak@linux.intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/mprotect.c |    5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

diff -puN mm/mprotect.c~dont-touch-single-threaded-ptes-which-are-on-the-right-node-fix mm/mprotect.c
--- a/mm/mprotect.c~dont-touch-single-threaded-ptes-which-are-on-the-right-node-fix
+++ a/mm/mprotect.c
@@ -76,10 +76,9 @@ static unsigned long change_pte_range(st
 	if (!pte)
 		return 0;
 
-	if (prot_numa &&
-	    !(vma->vm_flags & VM_SHARED) &&
+	if (prot_numa && !(vma->vm_flags & VM_SHARED) &&
 	    atomic_read(&vma->vm_mm->mm_users) == 1)
-	    target_node = cpu_to_node(raw_smp_processor_id());
+		target_node = cpu_to_node(raw_smp_processor_id());
 
 	arch_enter_lazy_mmu_mode();
 	do {
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

i-need-old-gcc.patch
arm-arch-arm-include-asm-pageh-needs-personalityh.patch
mm.patch
dont-touch-single-threaded-ptes-which-are-on-the-right-node-fix.patch
linux-next-rejects.patch
drivers-net-wireless-intel-iwlwifi-dvm-calibc-fix-min-warning.patch
include-linux-mlx5-deviceh-kill-build_bug_ons.patch
kernel-forkc-export-kernel_thread-to-modules.patch
slab-leaks3-default-y.patch

