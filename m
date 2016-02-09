From: akpm@linux-foundation.org
Subject: [alternative-merged]
 arm-mm-do-not-use-virt_to_idmap-for-nommu-systems.patch removed from -mm
 tree
Date: Tue, 09 Feb 2016 10:46:35 -0800
Message-ID: <56ba340b.qBiqbjr4WzLcNHuu%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:35558 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932228AbcBISqg (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 9 Feb 2016 13:46:36 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: vitalya@ti.com, mm-commits@vger.kernel.org


The patch titled
     Subject: ARM: mm: do not use virt_to_idmap() for NOMMU systems
has been removed from the -mm tree.  Its filename was
     arm-mm-do-not-use-virt_to_idmap-for-nommu-systems.patch

This patch was dropped because an alternative patch was merged

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
@@ -275,6 +275,7 @@ static inline void *phys_to_virt(phys_ad
 
 extern phys_addr_t (*arch_virt_to_idmap)(unsigned long x);
 
+#ifdef CONFIG_MMU
 /*
  * These are for systems that have a hardware interconnect supported alias of
  * physical memory for idmap purposes.  Most cases should leave these
@@ -289,6 +290,9 @@ static inline phys_addr_t __virt_to_idma
 }
 
 #define virt_to_idmap(x)	__virt_to_idmap((unsigned long)(x))
+#else
+#define virt_to_idmap(x)	__virt_to_phys((unsigned long)(x))
+#endif
 
 /*
  * Virtual <-> DMA view memory address translations
_

Patches currently in -mm which might be from vitalya@ti.com are


