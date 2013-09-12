From: akpm@linux-foundation.org
Subject: [merged] lto-watchdog-hpwdtc-make-assembler-label-global.patch
 removed from -mm tree
Date: Thu, 12 Sep 2013 12:46:09 -0700
Message-ID: <52321a01.pW7Clv7Tx8RGBAdF%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:58721 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756432Ab3ILTqJ (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 12 Sep 2013 15:46:09 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, wim@iguana.be, ak@linux.intel.com

Subject: [merged] lto-watchdog-hpwdtc-make-assembler-label-global.patch removed from -mm tree
To: ak@linux.intel.com,wim@iguana.be,mm-commits@vger.kernel.org
From: akpm@linux-foundation.org
Date: Thu, 12 Sep 2013 12:46:09 -0700


The patch titled
     Subject: lto, watchdog/hpwdt.c: make assembler label global
has been removed from the -mm tree.  Its filename was
     lto-watchdog-hpwdtc-make-assembler-label-global.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Andi Kleen <ak@linux.intel.com>
Subject: lto, watchdog/hpwdt.c: make assembler label global

We cannot assume that the inline assembler code always ends up in the same
file as the original C file.  So make any assembler labels that are called
with "extern" by C global

Signed-off-by: Andi Kleen <ak@linux.intel.com>
Cc: Wim Van Sebroeck <wim@iguana.be>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/watchdog/hpwdt.c |    6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff -puN drivers/watchdog/hpwdt.c~lto-watchdog-hpwdtc-make-assembler-label-global drivers/watchdog/hpwdt.c
--- a/drivers/watchdog/hpwdt.c~lto-watchdog-hpwdtc-make-assembler-label-global
+++ a/drivers/watchdog/hpwdt.c
@@ -162,7 +162,8 @@ extern asmlinkage void asminline_call(st
 #define HPWDT_ARCH	32
 
 asm(".text                          \n\t"
-    ".align 4                       \n"
+    ".align 4                       \n\t"
+    ".globl asminline_call	    \n"
     "asminline_call:                \n\t"
     "pushl       %ebp               \n\t"
     "movl        %esp, %ebp         \n\t"
@@ -352,7 +353,8 @@ static int detect_cru_service(void)
 #define HPWDT_ARCH	64
 
 asm(".text                      \n\t"
-    ".align 4                   \n"
+    ".align 4                   \n\t"
+    ".globl asminline_call	\n"
     "asminline_call:            \n\t"
     "pushq      %rbp            \n\t"
     "movq       %rsp, %rbp      \n\t"
_

Patches currently in -mm which might be from ak@linux.intel.com are

origin.patch
x86-add-1-2-4-8-byte-optimization-to-64bit-__copy_fromto_user_inatomic.patch
thp-account-anon-transparent-huge-pages-into-nr_anon_pages.patch
mm-cleanup-add_to_page_cache_locked.patch
thp-move-maybe_pmd_mkwrite-out-of-mk_huge_pmd.patch
thp-do_huge_pmd_anonymous_page-cleanup.patch
thp-consolidate-code-between-handle_mm_fault-and-do_huge_pmd_anonymous_page.patch

