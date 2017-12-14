From: akpm@linux-foundation.org
Subject: [patch 09/17] mm/memory.c: mark wp_huge_pmd() inline to prevent
 build failure
Date: Thu, 14 Dec 2017 15:32:52 -0800
Message-ID: <5a330a24.b1c+qPYGMEWUVP7X%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:54350 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754331AbdLNXcx (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 14 Dec 2017 18:32:53 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: torvalds@linux-foundation.org, mm-commits@vger.kernel.org, akpm@linux-foundation.org, geert@linux-m68k.org

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

[akpm@linux-foundation.org: add comment]
Link: http://lkml.kernel.org/r/1512335500-10889-1-git-send-email-geert@linux-m68k.org
Fixes: c7da82b894e9eef6 ("mm: replace pmd_write with pmd_access_permitted in fault + gup paths")
Signed-off-by: Geert Uytterhoeven <geert@linux-m68k.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memory.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff -puN mm/memory.c~mm-memoryc-mark-wp_huge_pmd-inline-to-prevent-build-failure mm/memory.c
--- a/mm/memory.c~mm-memoryc-mark-wp_huge_pmd-inline-to-prevent-build-failure
+++ a/mm/memory.c
@@ -3831,7 +3831,8 @@ static inline int create_huge_pmd(struct
 	return VM_FAULT_FALLBACK;
 }
 
-static int wp_huge_pmd(struct vm_fault *vmf, pmd_t orig_pmd)
+/* `inline' is required to avoid gcc 4.1.2 build error */
+static inline int wp_huge_pmd(struct vm_fault *vmf, pmd_t orig_pmd)
 {
 	if (vma_is_anonymous(vmf->vma))
 		return do_huge_pmd_wp_page(vmf, orig_pmd);
_
