From: akpm@linux-foundation.org
Subject: - paravirt_ops-dont-steal-memory-resources-in-paravirt_disable_iospace.patch removed from -mm tree
Date: Mon, 31 Mar 2008 18:23:09 -0700
Message-ID: <200804010123.m311N9jq002987@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:49192 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751530AbYDABXp (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 31 Mar 2008 21:23:45 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: jeremy@goop.org, jeremy.fitzhardinge@citrix.com, mingo@elte.hu, rusty@rustcorp.com.au, tglx@linutronix.de, mm-commits@vger.kernel.org


The patch titled
     paravirt_ops: don't steal memory resources in paravirt_disable_iospace
has been removed from the -mm tree.  Its filename was
     paravirt_ops-dont-steal-memory-resources-in-paravirt_disable_iospace.patch

This patch was dropped because an updated version will be merged

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: paravirt_ops: don't steal memory resources in paravirt_disable_iospace
From: Jeremy Fitzhardinge <jeremy@goop.org>

The memory resource is also used for main memory, and we need it to allocate
physical addresses for memory hotplug.  Knobbling io space is enough to get
the job done anyway.

Signed-off-by: Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>
Cc: Rusty Russell <rusty@rustcorp.com.au>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Thomas Gleixner <tglx@linutronix.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/x86/kernel/paravirt.c |   18 +-----------------
 1 file changed, 1 insertion(+), 17 deletions(-)

diff -puN arch/x86/kernel/paravirt.c~paravirt_ops-dont-steal-memory-resources-in-paravirt_disable_iospace arch/x86/kernel/paravirt.c
--- a/arch/x86/kernel/paravirt.c~paravirt_ops-dont-steal-memory-resources-in-paravirt_disable_iospace
+++ a/arch/x86/kernel/paravirt.c
@@ -206,13 +206,6 @@ static struct resource reserve_ioports =
 	.flags = IORESOURCE_IO | IORESOURCE_BUSY,
 };
 
-static struct resource reserve_iomem = {
-	.start = 0,
-	.end = -1,
-	.name = "paravirt-iomem",
-	.flags = IORESOURCE_MEM | IORESOURCE_BUSY,
-};
-
 /*
  * Reserve the whole legacy IO space to prevent any legacy drivers
  * from wasting time probing for their hardware.  This is a fairly
@@ -222,16 +215,7 @@ static struct resource reserve_iomem = {
  */
 int paravirt_disable_iospace(void)
 {
-	int ret;
-
-	ret = request_resource(&ioport_resource, &reserve_ioports);
-	if (ret == 0) {
-		ret = request_resource(&iomem_resource, &reserve_iomem);
-		if (ret)
-			release_resource(&reserve_ioports);
-	}
