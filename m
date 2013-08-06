From: akpm@linux-foundation.org
Subject: + lto-watchdog-hpwdtc-make-assembler-label-global.patch added to
 -mm tree
Date: Tue, 06 Aug 2013 13:46:50 -0700
Message-ID: <520160ba.xWn5xXa/qTpQ0C4V%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:55947 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754880Ab3HFUqv (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 6 Aug 2013 16:46:51 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, wim@iguana.be, ak@linux.intel.com

Subject: + lto-watchdog-hpwdtc-make-assembler-label-global.patch added to -mm tree
To: ak@linux.intel.com,wim@iguana.be
From: akpm@linux-foundation.org
Date: Tue, 06 Aug 2013 13:46:50 -0700


The patch titled
     Subject: lto, watchdog/hpwdt.c: make assembler label global
has been added to the -mm tree.  Its filename is
     lto-watchdog-hpwdtc-make-assembler-label-global.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/lto-watchdog-hpwdtc-make-assembler-label-global.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/lto-watchdog-hpwdtc-make-assembler-label-global.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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

thp-account-anon-transparent-huge-pages-into-nr_anon_pages.patch
mm-cleanup-add_to_page_cache_locked.patch
thp-move-maybe_pmd_mkwrite-out-of-mk_huge_pmd.patch
thp-do_huge_pmd_anonymous_page-cleanup.patch
thp-consolidate-code-between-handle_mm_fault-and-do_huge_pmd_anonymous_page.patch
syscallsh-use-gcc-alias-instead-of-assembler-aliases-for-syscalls.patch
kernel-modsign_pubkeyc-fix-init-const-for-module-signing-code.patch
lto-watchdog-hpwdtc-make-assembler-label-global.patch
linux-next.patch

