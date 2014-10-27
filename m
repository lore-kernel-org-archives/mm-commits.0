From: akpm@linux-foundation.org
Subject: + sh-fix-sh770x-scif-memory-regions.patch added to -mm tree
Date: Mon, 27 Oct 2014 16:08:24 -0700
Message-ID: <544ed068.KFMMyOmthlbRwnBR%akpm__44018.2502069094$1414451316$gmane$org@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:41104 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751490AbaJ0XIY (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 27 Oct 2014 19:08:24 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: askulysh@gmail.com, laurent.pinchart+renesas@ideasonboard.com, laurent.pinchart@ideasonboard.com, stable@vger.kernel.org, mm-commits@vger.kernel.org


The patch titled
     Subject: sh: fix sh770x SCIF memory regions
has been added to the -mm tree.  Its filename is
     sh-fix-sh770x-scif-memory-regions.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/sh-fix-sh770x-scif-memory-regions.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/sh-fix-sh770x-scif-memory-regions.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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

sh-fix-sh770x-scif-memory-regions.patch

