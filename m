From: akpm@linux-foundation.org
Subject: [merged] sh-fix-sh770x-scif-memory-regions.patch removed from -mm tree
Date: Thu, 30 Oct 2014 13:28:04 -0700
Message-ID: <54529f54.3z5TXbHBxSF2k/Gh%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:40545 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1161185AbaJ3U2D (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 30 Oct 2014 16:28:03 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: askulysh@gmail.com, geert@linux-m68k.org, laurent.pinchart+renesas@ideasonboard.com, laurent.pinchart@ideasonboard.com, stable@vger.kernel.org, mm-commits@vger.kernel.org


The patch titled
     Subject: sh: fix sh770x SCIF memory regions
has been removed from the -mm tree.  Its filename was
     sh-fix-sh770x-scif-memory-regions.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Andriy Skulysh <askulysh@gmail.com>
Subject: sh: fix sh770x SCIF memory regions

Resources scif1_resources & scif2_resources overlap.  Actual SCIF region
size is 0x10.

This is regression from:

Author: Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>
Date:   Fri Dec 6 10:59:48 2013 +0100
sh: Declare SCIF register base and IRQ as resources

Signed-off-by: Andriy Skulysh <askulysh@gmail.com>
Acked-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Cc: Geert Uytterhoeven <geert@linux-m68k.org>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/sh/kernel/cpu/sh3/setup-sh770x.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff -puN arch/sh/kernel/cpu/sh3/setup-sh770x.c~sh-fix-sh770x-scif-memory-regions arch/sh/kernel/cpu/sh3/setup-sh770x.c
--- a/arch/sh/kernel/cpu/sh3/setup-sh770x.c~sh-fix-sh770x-scif-memory-regions
+++ a/arch/sh/kernel/cpu/sh3/setup-sh770x.c
@@ -118,7 +118,7 @@ static struct plat_sci_port scif0_platfo
 };
 
 static struct resource scif0_resources[] = {
-	DEFINE_RES_MEM(0xfffffe80, 0x100),
+	DEFINE_RES_MEM(0xfffffe80, 0x10),
 	DEFINE_RES_IRQ(evt2irq(0x4e0)),
 };
 
@@ -143,7 +143,7 @@ static struct plat_sci_port scif1_platfo
 };
 
 static struct resource scif1_resources[] = {
-	DEFINE_RES_MEM(0xa4000150, 0x100),
+	DEFINE_RES_MEM(0xa4000150, 0x10),
 	DEFINE_RES_IRQ(evt2irq(0x900)),
 };
 
@@ -169,7 +169,7 @@ static struct plat_sci_port scif2_platfo
 };
 
 static struct resource scif2_resources[] = {
-	DEFINE_RES_MEM(0xa4000140, 0x100),
+	DEFINE_RES_MEM(0xa4000140, 0x10),
 	DEFINE_RES_IRQ(evt2irq(0x880)),
 };
 
_

Patches currently in -mm which might be from askulysh@gmail.com are

origin.patch

