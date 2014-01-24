From: akpm@linux-foundation.org
Subject: [merged]
 drivers-mfd-tps65217c-fix-pointer-integer-size-mismatch-warning-in-tps65217_probe.patch removed from -mm tree
Date: Fri, 24 Jan 2014 11:00:33 -0800
Message-ID: <52e2b851.272BGTey/Se2165L%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:43493 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752340AbaAXTAd (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 24 Jan 2014 14:00:33 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, sameo@linux.intel.com, anilkumar@ti.com, dhowells@redhat.com

Subject: [merged] drivers-mfd-tps65217c-fix-pointer-integer-size-mismatch-warning-in-tps65217_probe.patch removed from -mm tree
To: dhowells@redhat.com,anilkumar@ti.com,sameo@linux.intel.com,mm-commits@vger.kernel.org
From: akpm@linux-foundation.org
Date: Fri, 24 Jan 2014 11:00:33 -0800


The patch titled
     Subject: drivers/mfd/tps65217.c: fix pointer-integer size mismatch warning in tps65217_probe()
has been removed from the -mm tree.  Its filename was
     drivers-mfd-tps65217c-fix-pointer-integer-size-mismatch-warning-in-tps65217_probe.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: David Howells <dhowells@redhat.com>
Subject: drivers/mfd/tps65217.c: fix pointer-integer size mismatch warning in tps65217_probe()

Fix up the following pointer-integer size mismatch warning in tps65217_probe():

	drivers/mfd/tps65217.c: In function 'tps65217_probe':
	drivers/mfd/tps65217.c:173:13: warning: cast from pointer to integer of different size [-Wpointer-to-int-cast]
	   chip_id = (unsigned int)match->data;
		     ^

Signed-off-by: David Howells <dhowells@redhat.com>
Cc: AnilKumar Ch <anilkumar@ti.com>
Cc: Samuel Ortiz <sameo@linux.intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/mfd/tps65217.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN drivers/mfd/tps65217.c~drivers-mfd-tps65217c-fix-pointer-integer-size-mismatch-warning-in-tps65217_probe drivers/mfd/tps65217.c
--- a/drivers/mfd/tps65217.c~drivers-mfd-tps65217c-fix-pointer-integer-size-mismatch-warning-in-tps65217_probe
+++ a/drivers/mfd/tps65217.c
@@ -170,7 +170,7 @@ static int tps65217_probe(struct i2c_cli
 				"Failed to find matching dt id\n");
 			return -EINVAL;
 		}
-		chip_id = (unsigned int)match->data;
+		chip_id = (unsigned int)(unsigned long)match->data;
 		status_off = of_property_read_bool(client->dev.of_node,
 					"ti,pmic-shutdown-controller");
 	}
_

Patches currently in -mm which might be from dhowells@redhat.com are

origin.patch
afs-proc-cells-and-rootcell-are-writeable.patch
linux-next.patch
mutex-subsystem-synchro-test-module.patch

