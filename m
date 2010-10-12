From: akpm@linux-foundation.org
Subject: + mips-remove-dma64_addr_t-usage.patch added to -mm tree
Date: Tue, 12 Oct 2010 14:42:34 -0700
Message-ID: <201010122142.o9CLgYKa020685@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:39466 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750993Ab0JLVnM (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 12 Oct 2010 17:43:12 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: fujita.tomonori@lab.ntt.co.jp, ralf@linux-mips.org


The patch titled
     mips: remove dma64_addr_t usage
has been added to the -mm tree.  Its filename is
     mips-remove-dma64_addr_t-usage.patch

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
Subject: mips: remove dma64_addr_t usage
From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>

dma64_addr_t looks pointless (at least there is no point that an
architecture has the own dma64_addr_t typedef).

dma_addr_t is set to 32 or 64 bits appropriately.  You can use u64 at
places where you know that 64 bit address is always necessary.

Let's use u64 instead for mips.

Signed-off-by: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Cc: Ralf Baechle <ralf@linux-mips.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/mips/include/asm/pci/bridge.h |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN arch/mips/include/asm/pci/bridge.h~mips-remove-dma64_addr_t-usage arch/mips/include/asm/pci/bridge.h
--- a/arch/mips/include/asm/pci/bridge.h~mips-remove-dma64_addr_t-usage
+++ a/arch/mips/include/asm/pci/bridge.h
@@ -839,7 +839,7 @@ struct bridge_controller {
 	nasid_t			nasid;
 	unsigned int		widget_id;
 	unsigned int 		irq_cpu;
-	dma64_addr_t		baddr;
+	u64			baddr;
 	unsigned int		pci_int[8];
 };
 
_

Patches currently in -mm which might be from fujita.tomonori@lab.ntt.co.jp are

linux-next.patch
x86-enable-arch_dma_addr_t_64bit-with-x86_64-highmem64g.patch
powerpc-enable-arch_dma_addr_t_64bit-with-arch_phys_addr_t_64bit.patch
tile-enable-arch_dma_addr_t_64bit.patch
mips-enable-arch_dma_addr_t_64bit-with-highmem-64bit_phys_addr-64bit.patch
s390-enable-arch_dma_addr_t_64bit-with-64bit.patch
alpha-enable-arch_dma_addr_t_64bit.patch
uml-define-config_no_dma.patch
add-the-common-dma_addr_t-typedef-to-include-linux-typesh.patch
sparc-remove-dma64_addr_t-usage.patch
mips-remove-dma64_addr_t-usage.patch
alpha-remove-dma64_addr_t-usage.patch
remove-dma64_addr_t.patch

