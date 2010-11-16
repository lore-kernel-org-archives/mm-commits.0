From: akpm@linux-foundation.org
Subject: [merged] rapidio-use-resource_size.patch removed from -mm tree
Date: Tue, 16 Nov 2010 11:29:57 -0800
Message-ID: <201011161933.oAGJX9C7003078@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:46029 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756324Ab0KPTdV (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 16 Nov 2010 14:33:21 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: error27@gmail.com, alexandre.bounine@idt.com, leoli@freescale.com, mm-commits@vger.kernel.org


The patch titled
     rapidio: use resource_size()
has been removed from the -mm tree.  Its filename was
     rapidio-use-resource_size.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: rapidio: use resource_size()
From: Dan Carpenter <error27@gmail.com>

The size calculation is done incorrectly here because it should include
both the start and end (end - start + 1).  It's easiest to just use
resource_size() which does the right thing.

I was worried there was something non-standard going on because the
printk() subtracts "end - 1", but the rest of the file uses the normal
resource size calculations.  This function is only called from
fsl_rio_setup() in arch/powerpc/sysdev/fsl_rio.c and the calculation
there is also:

	port->iores.start = law_start;
	port->iores.end = law_start + law_size - 1;

So I think this is the correct fix.

Signed-off-by: Dan Carpenter <error27@gmail.com>
Cc: Alexandre Bounine <alexandre.bounine@idt.com>
Acked-by: Li Yang <leoli@freescale.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/rapidio/rio.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff -puN drivers/rapidio/rio.c~rapidio-use-resource_size drivers/rapidio/rio.c
--- a/drivers/rapidio/rio.c~rapidio-use-resource_size
+++ a/drivers/rapidio/rio.c
@@ -1159,11 +1159,11 @@ int __devinit rio_init_mports(void)
 
 	list_for_each_entry(port, &rio_mports, node) {
 		if (!request_mem_region(port->iores.start,
-					port->iores.end - port->iores.start,
+					resource_size(&port->iores),
 					port->name)) {
 			printk(KERN_ERR
 			       "RIO: Error requesting master port region 0x%016llx-0x%016llx\n",
-			       (u64)port->iores.start, (u64)port->iores.end - 1);
+			       (u64)port->iores.start, (u64)port->iores.end);
 			rc = -ENOMEM;
 			goto out;
 		}
_

Patches currently in -mm which might be from error27@gmail.com are

linux-next.patch

