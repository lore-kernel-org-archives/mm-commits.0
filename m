From: akpm@linux-foundation.org
Subject: [patch 048/123] mm: enable CONFIG_MOVABLE_NODE on non-x86 arches
Date: Mon, 12 Dec 2016 16:42:59 -0800
Message-ID: <584f4413.pW8FbLqcvhq18d0k%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:41088 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752425AbcLMAnA (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 12 Dec 2016 19:43:00 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: torvalds@linux-foundation.org, mm-commits@vger.kernel.org, akpm@linux-foundation.org, arbab@linux.vnet.ibm.com, aneesh.kumar@linux.vnet.ibm.com, apopple@au1.ibm.com, benh@kernel.crashing.org, bharata@linux.vnet.ibm.com, bsingharora@gmail.com, frowand.list@gmail.com, hpa@zytor.com, mingo@redhat.com, mpe@ellerman.id.au, nfont@linux.vnet.ibm.com, paulus@samba.org, robh+dt@kernel.org, stewart@linux.vnet.ibm.com, tglx@linutronix.de

From: Reza Arbab <arbab@linux.vnet.ibm.com>
Subject: mm: enable CONFIG_MOVABLE_NODE on non-x86 arches

To support movable memory nodes (CONFIG_MOVABLE_NODE), at least one of
the following must be true:

1. This config has the capability to identify movable nodes at boot.
   Right now, only x86 can do this.

2. Our config supports memory hotplug, which means that a movable node
   can be created by hotplugging all of its memory into ZONE_MOVABLE.

Fix the Kconfig definition of CONFIG_MOVABLE_NODE, which currently
recognizes (1), but not (2).

Link: http://lkml.kernel.org/r/1479160961-25840-4-git-send-email-arbab@linux.vnet.ibm.com
Signed-off-by: Reza Arbab <arbab@linux.vnet.ibm.com>
Reviewed-by: Aneesh Kumar K.V <aneesh.kumar@linux.vnet.ibm.com>
Acked-by: Balbir Singh <bsingharora@gmail.com>
Cc: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
Cc: "H. Peter Anvin" <hpa@zytor.com>
Cc: Alistair Popple <apopple@au1.ibm.com>
Cc: Aneesh Kumar K.V <aneesh.kumar@linux.vnet.ibm.com>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: Bharata B Rao <bharata@linux.vnet.ibm.com>
Cc: Frank Rowand <frowand.list@gmail.com>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: Michael Ellerman <mpe@ellerman.id.au>
Cc: Nathan Fontenot <nfont@linux.vnet.ibm.com>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Rob Herring <robh+dt@kernel.org>
Cc: Stewart Smith <stewart@linux.vnet.ibm.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/Kconfig |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN mm/Kconfig~mm-enable-config_movable_node-on-non-x86-arches mm/Kconfig
--- a/mm/Kconfig~mm-enable-config_movable_node-on-non-x86-arches
+++ a/mm/Kconfig
@@ -153,7 +153,7 @@ config MOVABLE_NODE
 	bool "Enable to assign a node which has only movable memory"
 	depends on HAVE_MEMBLOCK
 	depends on NO_BOOTMEM
-	depends on X86_64
+	depends on X86_64 || MEMORY_HOTPLUG
 	depends on NUMA
 	default n
 	help
_
