From: akpm@linux-foundation.org
Subject: +
 include-linux-compiler-gcch-improve-__visible-documentation.patch added to
 -mm tree
Date: Fri, 18 Sep 2015 12:19:34 -0700
Message-ID: <55fc63c6.BDmdXAEyHdHSii3N%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:43157 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753443AbbIRTTe (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 18 Sep 2015 15:19:34 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, andi@firstfloor.org, mm-commits@vger.kernel.org


The patch titled
     Subject: include/linux/compiler-gcc.h: improve __visible documentation
has been added to the -mm tree.  Its filename is
     include-linux-compiler-gcch-improve-__visible-documentation.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/include-linux-compiler-gcch-improve-__visible-documentation.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/include-linux-compiler-gcch-improve-__visible-documentation.patch

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
Subject: include/linux/compiler-gcc.h: improve __visible documentation

Cc: Andi Kleen <andi@firstfloor.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/compiler-gcc.h |    5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff -puN include/linux/compiler-gcc.h~include-linux-compiler-gcch-improve-__visible-documentation include/linux/compiler-gcc.h
--- a/include/linux/compiler-gcc.h~include-linux-compiler-gcch-improve-__visible-documentation
+++ a/include/linux/compiler-gcc.h
@@ -205,7 +205,10 @@
 
 #if GCC_VERSION >= 40600
 /*
- * Tell the optimizer that something else uses this function or variable.
+ * When used with Link Time Optimization, gcc can optimize away C functions or
+ * variables which are referenced only from assembly code.  __visible tells the
+ * optimizer that something else uses this function or variable, thus preventing
+ * this.
  */
 #define __visible	__attribute__((externally_visible))
 #endif
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

arch-alpha-kernel-systblss-remove-debug-check.patch
drivers-gpu-drm-i915-intel_spritec-fix-build.patch
drivers-gpu-drm-i915-intel_tvc-fix-build.patch
mm-dax-vma-with-vm_ops-pfn_mkwrite-wants-to-be-write-notified-fix.patch
x86-efi-kasan-undef-memset-memcpy-memmove-per-arch-fix.patch
mm.patch
uaccess-reimplement-probe_kernel_address-using-probe_kernel_read.patch
uaccess-reimplement-probe_kernel_address-using-probe_kernel_read-fix.patch
uaccess-reimplement-probe_kernel_address-using-probe_kernel_read-fix-fix.patch
kasan-various-fixes-in-documentation-checkpatch-fixes.patch
page-flags-introduce-page-flags-policies-wrt-compound-pages-fix.patch
include-linux-page-flagsh-rename-macros-to-avoid-collisions.patch
x86-add-pmd_-for-thp-fix.patch
sparc-add-pmd_-for-thp-fix.patch
mm-support-madvisemadv_free-fix-2.patch
mm-dont-split-thp-page-when-syscall-is-called-fix-3.patch
mm-move-lazy-free-pages-to-inactive-list-fix-fix.patch
remove-abs64.patch
include-linux-compiler-gcch-improve-__visible-documentation.patch
do_shared_fault-check-that-mmap_sem-is-held.patch
kernel-forkc-export-kernel_thread-to-modules.patch
slab-leaks3-default-y.patch

