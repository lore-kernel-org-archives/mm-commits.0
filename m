From: akpm@linux-foundation.org
Subject: [merged] rapidio-idt_gen2-fix-locking-warning.patch removed from
 -mm tree
Date: Wed, 03 Aug 2016 11:14:34 -0700
Message-ID: <57a2348a.CtGQyoYxDJkprLL/%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:33632 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756874AbcHCSOf (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 3 Aug 2016 14:14:35 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: alexandre.bounine@idt.com, andre.van.herk@prodrive-technologies.com, barry.wood@idt.com, mporter@kernel.crashing.org, mm-commits@vger.kernel.org


The patch titled
     Subject: rapidio/idt_gen2: fix locking warning
has been removed from the -mm tree.  Its filename was
     rapidio-idt_gen2-fix-locking-warning.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Alexandre Bounine <alexandre.bounine@idt.com>
Subject: rapidio/idt_gen2: fix locking warning

Fix lockdep warning during device probing: move sysfs initialization out
of code protected by a spin lock.

Link: http://lkml.kernel.org/r/1469125134-16523-10-git-send-email-alexandre.bounine@idt.com
Signed-off-by: Alexandre Bounine <alexandre.bounine@idt.com>
Cc: Matt Porter <mporter@kernel.crashing.org>
Cc: Andre van Herk <andre.van.herk@prodrive-technologies.com>
Cc: Barry Wood <barry.wood@idt.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/rapidio/switches/idt_gen2.c |    7 +++----
 1 file changed, 3 insertions(+), 4 deletions(-)

diff -puN drivers/rapidio/switches/idt_gen2.c~rapidio-idt_gen2-fix-locking-warning drivers/rapidio/switches/idt_gen2.c
--- a/drivers/rapidio/switches/idt_gen2.c~rapidio-idt_gen2-fix-locking-warning
+++ a/drivers/rapidio/switches/idt_gen2.c
@@ -436,10 +436,11 @@ static int idtg2_probe(struct rio_dev *r
 				    RIO_STD_RTE_DEFAULT_PORT, IDT_NO_ROUTE);
 	}
 
+	spin_unlock(&rdev->rswitch->lock);
+
 	/* Create device-specific sysfs attributes */
 	idtg2_sysfs(rdev, true);
 
-	spin_unlock(&rdev->rswitch->lock);
 	return 0;
 }
 
@@ -452,11 +453,9 @@ static void idtg2_remove(struct rio_dev
 		return;
 	}
 	rdev->rswitch->ops = NULL;
-
+	spin_unlock(&rdev->rswitch->lock);
 	/* Remove device-specific sysfs attributes */
 	idtg2_sysfs(rdev, false);
