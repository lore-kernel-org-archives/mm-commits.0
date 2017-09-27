From: akpm@linux-foundation.org
Subject: + mm-fix-typo-in-vm_mpx-definition.patch added to -mm tree
Date: Wed, 27 Sep 2017 15:29:26 -0700
Message-ID: <59cc2646./WIpnitehz2TDShV%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:53814 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752222AbdI0W31 (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 27 Sep 2017 18:29:27 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: kirill.shutemov@linux.intel.com, dave.hansen@intel.com, me@kylehuey.com, riel@redhat.com, mm-commits@vger.kernel.org


The patch titled
     Subject: include/linux/mm.h: fix typo in VM_MPX definition
has been added to the -mm tree.  Its filename is
     mm-fix-typo-in-vm_mpx-definition.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-fix-typo-in-vm_mpx-definition.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-fix-typo-in-vm_mpx-definition.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>
Subject: include/linux/mm.h: fix typo in VM_MPX definition

There's a typo in recent change of VM_MPX definition.  We want it to be
VM_HIGH_ARCH_4, not VM_HIGH_ARCH_BIT_4.

Fixes: df3735c5b40f ("x86,mpx: make mpx depend on x86-64 to free up VMA flag")
Link: http://lkml.kernel.org/r/20170918140253.36856-1-kirill.shutemov@linux.intel.com
Signed-off-by: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
Reviewed-by: Rik van Riel <riel@redhat.com>
Cc: Dave Hansen <dave.hansen@intel.com>
Cc: Kyle Huey <me@kylehuey.com>
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

mm-fix-typo-in-vm_mpx-definition.patch

