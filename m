From: akpm@linux-foundation.org
Subject: + mm-debug-add-vm_warn-which-maps-to-warn.patch added to -mm tree
Date: Tue, 31 May 2016 12:13:02 -0700
Message-ID: <574de23e.B2MLSSvj1kJDx/CR%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:48705 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755647AbcEaTND (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 31 May 2016 15:13:03 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: aneesh.kumar@linux.vnet.ibm.com, benh@kernel.crashing.org, mpe@ellerman.id.au, mm-commits@vger.kernel.org


The patch titled
     Subject: include/linux/mmdebug.h: add VM_WARN which maps to WARN()
has been added to the -mm tree.  Its filename is
     mm-debug-add-vm_warn-which-maps-to-warn.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-debug-add-vm_warn-which-maps-to-warn.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-debug-add-vm_warn-which-maps-to-warn.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
Subject: include/linux/mmdebug.h: add VM_WARN which maps to WARN()

This enables us to do VM_WARN(condition, "warn message");

Link: http://lkml.kernel.org/r/1464692688-6612-1-git-send-email-aneesh.kumar@linux.vnet.ibm.com
Signed-off-by: Aneesh Kumar K.V <aneesh.kumar@linux.vnet.ibm.com>
Cc: Michael Ellerman <mpe@ellerman.id.au>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/mmdebug.h |    2 ++
 1 file changed, 2 insertions(+)

diff -puN include/linux/mmdebug.h~mm-debug-add-vm_warn-which-maps-to-warn include/linux/mmdebug.h
--- a/include/linux/mmdebug.h~mm-debug-add-vm_warn-which-maps-to-warn
+++ a/include/linux/mmdebug.h
@@ -39,6 +39,7 @@ void dump_mm(const struct mm_struct *mm)
 #define VM_WARN_ON(cond) WARN_ON(cond)
 #define VM_WARN_ON_ONCE(cond) WARN_ON_ONCE(cond)
 #define VM_WARN_ONCE(cond, format...) WARN_ONCE(cond, format)
+#define VM_WARN(cond, format...) WARN(cond, format)
 #else
 #define VM_BUG_ON(cond) BUILD_BUG_ON_INVALID(cond)
 #define VM_BUG_ON_PAGE(cond, page) VM_BUG_ON(cond)
@@ -47,6 +48,7 @@ void dump_mm(const struct mm_struct *mm)
 #define VM_WARN_ON(cond) BUILD_BUG_ON_INVALID(cond)
 #define VM_WARN_ON_ONCE(cond) BUILD_BUG_ON_INVALID(cond)
 #define VM_WARN_ONCE(cond, format...) BUILD_BUG_ON_INVALID(cond)
+#define VM_WARN(cond, format...) BUILD_BUG_ON_INVALID(cond)
 #endif
 
 #ifdef CONFIG_DEBUG_VIRTUAL
_

Patches currently in -mm which might be from aneesh.kumar@linux.vnet.ibm.com are

mm-debug-add-vm_warn-which-maps-to-warn.patch
powerpc-mm-check-for-irq-disabled-only-if-debug_vm-is-enabled.patch

