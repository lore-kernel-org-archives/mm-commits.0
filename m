From: akpm@linux-foundation.org
Subject: +
 mm-memoryc-mark-wp_huge_pmd-inline-to-prevent-build-failure.patch added to
 -mm tree
Date: Wed, 06 Dec 2017 16:07:54 -0800
Message-ID: <5a28865a.Z4gwh2sz9i6kpz4e%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:45584 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751718AbdLGAHz (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 6 Dec 2017 19:07:55 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: geert@linux-m68k.org, mm-commits@vger.kernel.org


The patch titled
     Subject: mm/memory.c: mark wp_huge_pmd() inline to prevent build failure
has been added to the -mm tree.  Its filename is
     mm-memoryc-mark-wp_huge_pmd-inline-to-prevent-build-failure.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-memoryc-mark-wp_huge_pmd-inline-to-prevent-build-failure.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-memoryc-mark-wp_huge_pmd-inline-to-prevent-build-failure.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Geert Uytterhoeven <geert@linux-m68k.org>
Subject: mm/memory.c: mark wp_huge_pmd() inline to prevent build failure

With gcc 4.1.2:

    mm/memory.o: In function `wp_huge_pmd':
    memory.c:(.text+0x9b4): undefined reference to `do_huge_pmd_wp_page'

Interestingly, wp_huge_pmd() is emitted in the assembler output, but never
called.

Apparently replacing the call to pmd_write() in __handle_mm_fault() by a
call to the more complex pmd_access_permitted() reduced the ability of the
compiler to remove unused code.

Fix this by marking wp_huge_pmd() inline, like was done in
91a90140f9987101 ("mm/memory.c: mark create_huge_pmd() inline to prevent
build failure") for a similar problem.

Link: http://lkml.kernel.org/r/1512335500-10889-1-git-send-email-geert@linux-m68k.org
Fixes: c7da82b894e9eef6 ("mm: replace pmd_write with pmd_access_permitted in fault + gup paths")
Signed-off-by: Geert Uytterhoeven <geert@linux-m68k.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memory.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN mm/memory.c~mm-memoryc-mark-wp_huge_pmd-inline-to-prevent-build-failure mm/memory.c
--- a/mm/memory.c~mm-memoryc-mark-wp_huge_pmd-inline-to-prevent-build-failure
+++ a/mm/memory.c
@@ -3831,7 +3831,7 @@ static inline int create_huge_pmd(struct
 	return VM_FAULT_FALLBACK;
 }
 
-static int wp_huge_pmd(struct vm_fault *vmf, pmd_t orig_pmd)
+static inline int wp_huge_pmd(struct vm_fault *vmf, pmd_t orig_pmd)
 {
 	if (vma_is_anonymous(vmf->vma))
 		return do_huge_pmd_wp_page(vmf, orig_pmd);
_

Patches currently in -mm which might be from geert@linux-m68k.org are

mm-memoryc-mark-wp_huge_pmd-inline-to-prevent-build-failure.patch
m68k-bitops-always-include-asm-generic-bitops-findh.patch

