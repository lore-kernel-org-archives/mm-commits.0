From: akpm@linux-foundation.org
Subject: [merged] ppc-make-ppc_book3s_64-select-irq_work.patch removed
 from -mm tree
Date: Tue, 08 Apr 2014 14:33:21 -0700
Message-ID: <53446b21.xzmPOLey4fCUm/VN%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:57042 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757687AbaDHVdW (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 8 Apr 2014 17:33:22 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, sfr@canb.auug.org.au, benh@kernel.crashing.org, josh@joshtriplett.org

Subject: [merged] ppc-make-ppc_book3s_64-select-irq_work.patch removed from -mm tree
To: josh@joshtriplett.org,benh@kernel.crashing.org,sfr@canb.auug.org.au,mm-commits@vger.kernel.org
From: akpm@linux-foundation.org
Date: Tue, 08 Apr 2014 14:33:21 -0700


The patch titled
     Subject: ppc: make PPC_BOOK3S_64 select IRQ_WORK
has been removed from the -mm tree.  Its filename was
     ppc-make-ppc_book3s_64-select-irq_work.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Josh Triplett <josh@joshtriplett.org>
Subject: ppc: make PPC_BOOK3S_64 select IRQ_WORK

Fix breakage which will be exposed by the patch "kconfig: make allnoconfig
disable options behind EMBEDDED and EXPERT".

arch/powerpc/kernel/mce.c, compiled in for PPC_BOOK3S_64, calls
functions only built when IRQ_WORK, so select it.  Fixes the following
build error:

arch/powerpc/kernel/built-in.o: In function `.machine_check_queue_event':
(.text+0x11260): undefined reference to `.irq_work_queue'

Signed-off-by: Josh Triplett <josh@joshtriplett.org>
Reported-by: Stephen Rothwell <sfr@canb.auug.org.au>
Acked-by: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/powerpc/platforms/Kconfig.cputype |    1 +
 1 file changed, 1 insertion(+)

diff -puN arch/powerpc/platforms/Kconfig.cputype~ppc-make-ppc_book3s_64-select-irq_work arch/powerpc/platforms/Kconfig.cputype
--- a/arch/powerpc/platforms/Kconfig.cputype~ppc-make-ppc_book3s_64-select-irq_work
+++ a/arch/powerpc/platforms/Kconfig.cputype
@@ -73,6 +73,7 @@ config PPC_BOOK3S_64
 	select SYS_SUPPORTS_HUGETLBFS
 	select HAVE_ARCH_TRANSPARENT_HUGEPAGE if PPC_64K_PAGES
 	select ARCH_SUPPORTS_NUMA_BALANCING
+	select IRQ_WORK
 
 config PPC_BOOK3E_64
 	bool "Embedded processors"
_

Patches currently in -mm which might be from josh@joshtriplett.org are

origin.patch

