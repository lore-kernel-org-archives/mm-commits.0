From: akpm@linux-foundation.org
Subject: + arm-mm-do-not-use-virt_to_idmap-for-nommu-systems.patch added
 to -mm tree
Date: Mon, 20 Jul 2015 13:44:49 -0700
Message-ID: <55ad5dc1.36Vxb8P4NVdifNJx%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:37800 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756538AbbGTUou (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 20 Jul 2015 16:44:50 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: vitalya@ti.com, mm-commits@vger.kernel.org


The patch titled
     Subject: ARM: mm: do not use virt_to_idmap() for NOMMU systems
has been added to the -mm tree.  Its filename is
     arm-mm-do-not-use-virt_to_idmap-for-nommu-systems.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/arm-mm-do-not-use-virt_to_idmap-for-nommu-systems.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/arm-mm-do-not-use-virt_to_idmap-for-nommu-systems.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Vitaly Andrianov <vitalya@ti.com>
Subject: ARM: mm: do not use virt_to_idmap() for NOMMU systems

The "ARM: mm: Introduce virt_to_idmap() with an arch hook" defines
arch_virt_to_idmap hook in arch/arm/mm/idmap.c. That breaks systems w/o
MMU because that file is not built for them.

This patch fixes this bug.

Signed-off-by: Vitaly Andrianov <vitalya@ti.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/arm/include/asm/memory.h |    4 ++++
 1 file changed, 4 insertions(+)

diff -puN arch/arm/include/asm/memory.h~arm-mm-do-not-use-virt_to_idmap-for-nommu-systems arch/arm/include/asm/memory.h
--- a/arch/arm/include/asm/memory.h~arm-mm-do-not-use-virt_to_idmap-for-nommu-systems
+++ a/arch/arm/include/asm/memory.h
@@ -279,6 +279,7 @@ static inline void *phys_to_virt(phys_ad
 
 extern phys_addr_t (*arch_virt_to_idmap)(unsigned long x);
 
+#ifdef CONFIG_MMU
 /*
  * These are for systems that have a hardware interconnect supported alias of
  * physical memory for idmap purposes.  Most cases should leave these
@@ -293,6 +294,9 @@ static inline phys_addr_t __virt_to_idma
 }
 
 #define virt_to_idmap(x)	__virt_to_idmap((unsigned long)(x))
+#else
+#define virt_to_idmap(x)	__virt_to_phys((unsigned long)(x))
+#endif
 
 /*
  * Virtual <-> DMA view memory address translations
_

Patches currently in -mm which might be from vitalya@ti.com are

arm-mm-do-not-use-virt_to_idmap-for-nommu-systems.patch

