From: akpm@linux-foundation.org
Subject: +
 rapidio-add-modular-rapidio-core-build-into-powerpc-and-mips-branches.patch added to -mm tree
Date: Thu, 19 Dec 2013 15:54:32 -0800
Message-ID: <52b38738.OiKPW4NVdnnR4PqQ%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:46841 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756258Ab3LSXyd (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 19 Dec 2013 18:54:33 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, ralf@linux-mips.org, mporter@kernel.crashing.org, leoli@freescale.com, jdelvare@suse.de, benh@kernel.crashing.org, alexandre.bounine@idt.com

Subject: + rapidio-add-modular-rapidio-core-build-into-powerpc-and-mips-branches.patch added to -mm tree
To: alexandre.bounine@idt.com,benh@kernel.crashing.org,jdelvare@suse.de,leoli@freescale.com,mporter@kernel.crashing.org,ralf@linux-mips.org
From: akpm@linux-foundation.org
Date: Thu, 19 Dec 2013 15:54:32 -0800


The patch titled
     Subject: rapidio: add modular rapidio core build into powerpc and mips branches
has been added to the -mm tree.  Its filename is
     rapidio-add-modular-rapidio-core-build-into-powerpc-and-mips-branches.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/rapidio-add-modular-rapidio-core-build-into-powerpc-and-mips-branches.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/rapidio-add-modular-rapidio-core-build-into-powerpc-and-mips-branches.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Alexandre Bounine <alexandre.bounine@idt.com>
Subject: rapidio: add modular rapidio core build into powerpc and mips branches

Allow modular build option for RapidIO subsystem core in MIPS and PowerPC
architectural branches.

At this moment modular RapidIO subsystem build is enabled only for
platforms that use PCI/PCIe based RapidIO controllers (e.g.  Tsi721).

Signed-off-by: Alexandre Bounine <alexandre.bounine@idt.com>
Cc: Matt Porter <mporter@kernel.crashing.org>
Cc: Jean Delvare <jdelvare@suse.de>
Cc: Ralf Baechle <ralf@linux-mips.org>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: Li Yang <leoli@freescale.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/mips/Kconfig    |    2 +-
 arch/powerpc/Kconfig |    4 ++--
 2 files changed, 3 insertions(+), 3 deletions(-)

diff -puN arch/mips/Kconfig~rapidio-add-modular-rapidio-core-build-into-powerpc-and-mips-branches arch/mips/Kconfig
--- a/arch/mips/Kconfig~rapidio-add-modular-rapidio-core-build-into-powerpc-and-mips-branches
+++ a/arch/mips/Kconfig
@@ -2430,7 +2430,7 @@ source "drivers/pcmcia/Kconfig"
 source "drivers/pci/hotplug/Kconfig"
 
 config RAPIDIO
-	bool "RapidIO support"
+	tristate "RapidIO support"
 	depends on PCI
 	default n
 	help
diff -puN arch/powerpc/Kconfig~rapidio-add-modular-rapidio-core-build-into-powerpc-and-mips-branches arch/powerpc/Kconfig
--- a/arch/powerpc/Kconfig~rapidio-add-modular-rapidio-core-build-into-powerpc-and-mips-branches
+++ a/arch/powerpc/Kconfig
@@ -790,7 +790,7 @@ config HAS_RAPIDIO
 	default n
 
 config RAPIDIO
-	bool "RapidIO support"
+	tristate "RapidIO support"
 	depends on HAS_RAPIDIO || PCI
 	help
 	  If you say Y here, the kernel will include drivers and
@@ -798,7 +798,7 @@ config RAPIDIO
 
 config FSL_RIO
 	bool "Freescale Embedded SRIO Controller support"
-	depends on RAPIDIO && HAS_RAPIDIO
+	depends on RAPIDIO = y && HAS_RAPIDIO
 	default "n"
 	---help---
 	  Include support for RapidIO controller on Freescale embedded
_

Patches currently in -mm which might be from alexandre.bounine@idt.com are

rapidio-add-modular-rapidio-core-build-into-powerpc-and-mips-branches.patch

