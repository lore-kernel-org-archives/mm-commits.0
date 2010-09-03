From: akpm@linux-foundation.org
Subject: + x86-enable-arch_dma_addr_t_64bit-with-x86_64-highmem64g.patch added to -mm tree
Date: Fri, 03 Sep 2010 15:10:03 -0700
Message-ID: <201009032210.o83MA32K015266@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:51476 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757684Ab0ICWKq (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 3 Sep 2010 18:10:46 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: fujita.tomonori@lab.ntt.co.jp, hpa@zytor.com, mingo@elte.hu, tglx@linutronix.de


The patch titled
     x86: enable ARCH_DMA_ADDR_T_64BIT with X86_64 || HIGHMEM64G
has been added to the -mm tree.  Its filename is
     x86-enable-arch_dma_addr_t_64bit-with-x86_64-highmem64g.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://userweb.kernel.org/~akpm/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: x86: enable ARCH_DMA_ADDR_T_64BIT with X86_64 || HIGHMEM64G
From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>

Signed-off-by: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: "H. Peter Anvin" <hpa@zytor.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/x86/Kconfig |    3 +++
 1 file changed, 3 insertions(+)

diff -puN arch/x86/Kconfig~x86-enable-arch_dma_addr_t_64bit-with-x86_64-highmem64g arch/x86/Kconfig
--- a/arch/x86/Kconfig~x86-enable-arch_dma_addr_t_64bit-with-x86_64-highmem64g
+++ a/arch/x86/Kconfig
@@ -1129,6 +1129,9 @@ config X86_PAE
 config ARCH_PHYS_ADDR_T_64BIT
 	def_bool X86_64 || X86_PAE
 
+config ARCH_DMA_ADDR_T_64BIT
+	def_bool X86_64 || HIGHMEM64G
+
 config DIRECT_GBPAGES
 	bool "Enable 1GB pages for kernel pagetables" if EMBEDDED
 	default y
_

Patches currently in -mm which might be from fujita.tomonori@lab.ntt.co.jp are

linux-next.patch
x86-enable-arch_dma_addr_t_64bit-with-x86_64-highmem64g.patch
alpha-enable-arch_dma_addr_t_64bit.patch
ia64-enable-arch_dma_addr_t_64bit.patch
mips-enable-arch_dma_addr_t_64bit-with-highmem-64bit_phys_addr-64bit.patch
powerpc-enable-arch_dma_addr_t_64bit-with-arch_phys_addr_t_64bit.patch
s390-enable-arch_dma_addr_t_64bit-with-64bit.patch
tile-enable-arch_dma_addr_t_64bit.patch
add-the-common-dma_addr_t-typedef-to-include-linux-typesh.patch

