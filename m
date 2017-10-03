From: akpm@linux-foundation.org
Subject: [patch 04/51] include/linux/mm.h: fix typo in VM_MPX definition
Date: Tue, 03 Oct 2017 16:14:24 -0700
Message-ID: <59d419d0.YuACnsBAusU9TjVz%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:58320 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750865AbdJCXOZ (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 3 Oct 2017 19:14:25 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: torvalds@linux-foundation.org, mm-commits@vger.kernel.org, akpm@linux-foundation.org, kirill.shutemov@linux.intel.com, dave.hansen@intel.com, me@kylehuey.com, riel@redhat.com, stable@vger.kernel.org

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
