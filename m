From: akpm@linux-foundation.org
Subject: [merged] mm-fix-typo-in-vm_mpx-definition.patch removed
 from -mm tree
Date: Wed, 04 Oct 2017 12:40:01 -0700
Message-ID: <20171004194001.fTm16B80x%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:33250 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751132AbdJDTkC (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 4 Oct 2017 15:40:02 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: dave.hansen@intel.com, kirill.shutemov@linux.intel.com, me@kylehuey.com, mm-commits@vger.kernel.org, riel@redhat.com, stable@vger.kernel.org


The patch titled
     Subject: include/linux/mm.h: fix typo in VM_MPX definition
has been removed from the -mm tree.  Its filename was
     mm-fix-typo-in-vm_mpx-definition.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>
Subject: include/linux/mm.h: fix typo in VM_MPX definition

There's a typo in recent change of VM_MPX definition.  We want it to be
VM_HIGH_ARCH_4, not VM_HIGH_ARCH_BIT_4.

This bug does cause visible regressions.  In arch_vma_name the vmflags
are tested against VM_MPX.  With the incorrect value of VM_MPX, a
number of vmas (such as the stack) test positive and end up being
marked as [mpx] in /proc/N/maps instead of their correct names.  This
confuses tools like rr which expect to be able to find familiar vmas.

Fixes: df3735c5b40f ("x86,mpx: make mpx depend on x86-64 to free up VMA flag")
Link: http://lkml.kernel.org/r/20170918140253.36856-1-kirill.shutemov@linux.intel.com
Signed-off-by: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
Reviewed-by: Rik van Riel <riel@redhat.com>
Cc: Dave Hansen <dave.hansen@intel.com>
Cc: Kyle Huey <me@kylehuey.com>
Cc: <stable@vger.kernel.org>	[4.14+]
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/mm.h |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN include/linux/mm.h~mm-fix-typo-in-vm_mpx-definition include/linux/mm.h
--- a/include/linux/mm.h~mm-fix-typo-in-vm_mpx-definition
+++ a/include/linux/mm.h
@@ -240,7 +240,7 @@ extern unsigned int kobjsize(const void
 
 #if defined(CONFIG_X86_INTEL_MPX)
 /* MPX specific bounds table or bounds directory */
-# define VM_MPX		VM_HIGH_ARCH_BIT_4
+# define VM_MPX		VM_HIGH_ARCH_4
 #else
 # define VM_MPX		VM_NONE
 #endif
_

Patches currently in -mm which might be from kirill.shutemov@linux.intel.com are

mm-account-pud-page-tables.patch
mm-add-infrastructure-for-get_user_pages_fast-benchmarking.patch

