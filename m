From: Andrew Morton <akpm@linux-foundation.org>
Subject: +
 mm-debug-add-tests-validating-architecture-page-table-helpers-fix-2.patch
 added to -mm tree
Date: Wed, 26 Feb 2020 20:42:20 -0800
Message-ID: <20200227044220.-_hGvVByM%akpm@linux-foundation.org>
References: <20200203173311.6269a8be06a05e5a4aa08a93@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:41438 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728284AbgB0EmV (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Wed, 26 Feb 2020 23:42:21 -0500
In-Reply-To: <20200203173311.6269a8be06a05e5a4aa08a93@linux-foundation.org>
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: anshuman.khandual@arm.com, cai@lca.pw, christophe.leroy@c-s.fr, james.morse@arm.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm/debug: replace __pa() with __pa_symbol() in debug_vm_pgtable()
has been added to the -mm tree.  Its filename is
     mm-debug-add-tests-validating-architecture-page-table-helpers-fix-2.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-debug-add-tests-validating-architecture-page-table-helpers-fix-2.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-debug-add-tests-validating-architecture-page-table-helpers-fix-2.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Anshuman Khandual <anshuman.khandual@arm.com>
Subject: mm/debug: replace __pa() with __pa_symbol() in debug_vm_pgtable()

Replace __pa() with __pa_symbol() in debug_vm_pgtable() while accessing
the physical address for 'start_kernel' which is a kernel text symbol,
else it might trigger the following warning on some platforms when
DEBUG_VIRTUAL is enabled.

[   23.123852] ------------[ cut here ]------------
[   23.124486] virt_to_phys used for non-linear address: (____ptrval____) (start_kernel+0x0/0x424)
[   23.125663] WARNING: CPU: 11 PID: 1 at arch/arm64/mm/physaddr.c:15 __virt_to_phys+0x60/0x98
[   23.126877] Modules linked in:
[   23.127390] CPU: 11 PID: 1 Comm: swapper/0 Tainted: G        W 5.6.0-rc3-next-20200226-00001-g306225cc6ffd #163
[   23.129139] Hardware name: linux,dummy-virt (DT)
[   23.129898] pstate: 60400005 (nZCv daif +PAN -UAO)
[   23.130693] pc : __virt_to_phys+0x60/0x98
[   23.131359] lr : __virt_to_phys+0x60/0x98
[   23.132022] sp : ffff800011e6be10
[   23.132575] x29: ffff800011e6be10 x28: 0000000000000000
[   23.133447] x27: 0000000000000000 x26: 0000000000000000
[   23.134319] x25: 0000000000000000 x24: 0020000000000fd3
[   23.135197] x23: fffffe000bd27700 x22: ffff0002fcae8000
[   23.136069] x21: ffff800011a47000 x20: 0000000000000001
[   23.136941] x19: ffff800011350a14 x18: 0000000000000010
[   23.137815] x17: 000000006bb8910e x16: 00000000a1fdc699
[   23.138693] x15: ffffffffffffffff x14: 6c656e72656b5f74
[   23.139567] x13: 726174732820295f x12: 5f5f5f6c61767274
[   23.140441] x11: 705f5f5f5f28203a x10: 7373657264646120
[   23.141314] x9 : 7261656e696c2d6e x8 : ffff8000106b4e70
[   23.142189] x7 : 00000000000002a1 x6 : ffff800011a58bba
[   23.143067] x5 : 001fffffffffffff x4 : 0000000000000000
[   23.143939] x3 : 00000000ffffffff x2 : ffff800011881bf8
[   23.144810] x1 : 16ee3f9cb03efc00 x0 : 0000000000000000
[   23.145682] Call trace:
[   23.146097]  __virt_to_phys+0x60/0x98
[   23.146710]  debug_vm_pgtable+0xd0/0x440
[   23.147362]  kernel_init+0x18/0x100
[   23.147944]  ret_from_fork+0x10/0x18
[   23.148539] ---[ end trace fc4ccb3cb35ff225 ]---

Link: http://lkml.kernel.org/r/1582776031-30344-1-git-send-email-anshuman.khandual@arm.com
Signed-off-by: Anshuman Khandual <anshuman.khandual@arm.com>
Reported-by: Qian Cai <cai@lca.pw>
Cc: James Morse <james.morse@arm.com>
Cc: Christophe Leroy <christophe.leroy@c-s.fr>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/debug_vm_pgtable.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/mm/debug_vm_pgtable.c~mm-debug-add-tests-validating-architecture-page-table-helpers-fix-2
+++ a/mm/debug_vm_pgtable.c
@@ -331,7 +331,7 @@ void __init debug_vm_pgtable(void)
 	 * helps avoid large memory block allocations to be used for mapping
 	 * at higher page table levels.
 	 */
-	paddr = __pa(&start_kernel);
+	paddr = __pa_symbol(&start_kernel);
 
 	pte_aligned = (paddr & PAGE_MASK) >> PAGE_SHIFT;
 	pmd_aligned = (paddr & PMD_MASK) >> PAGE_SHIFT;
_

Patches currently in -mm which might be from anshuman.khandual@arm.com are

mm-debug-add-tests-validating-architecture-page-table-helpers.patch
mm-debug-add-tests-validating-architecture-page-table-helpers-fix-2.patch
mm-vma-add-missing-vma-flag-readable-name-for-vm_sync.patch
mm-vma-make-vma_is_accessible-available-for-general-use.patch
mm-vma-replace-all-remaining-open-encodings-with-is_vm_hugetlb_page.patch
mm-vma-replace-all-remaining-open-encodings-with-vma_is_anonymous.patch
mm-vma-append-unlikely-while-testing-vma-access-permissions.patch
