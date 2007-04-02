From: akpm@linux-foundation.org
Subject: - correctly-report-pnp-64bit-resources.patch removed from -mm tree
Date: Mon, 02 Apr 2007 16:03:53 -0700
Message-ID: <200704022303.l32N3rrG011940@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:52019 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S966079AbXDBXEW (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Mon, 2 Apr 2007 19:04:22 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: petr@vandrovec.name, ambx1@neo.rr.com, bjorn.helgaas@hp.com, mm-commits@vger.kernel.org


The patch titled
     Correctly report PnP 64bit resources
has been removed from the -mm tree.  Its filename was
     correctly-report-pnp-64bit-resources.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: Correctly report PnP 64bit resources
From: Petr Vandrovec <petr@vandrovec.name>

Change PnP resource handling code to use proper type for resource start and
length.  Fixes bogus regions reported in /proc/iomem.

I've also made some pointer constant, as they are constant...

Signed-off-by: Petr Vandrovec <petr@vandrovec.name>
Cc: Bjorn Helgaas <bjorn.helgaas@hp.com>
Cc: Adam Belay <ambx1@neo.rr.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/pnp/system.c |   13 +++++++------
 1 file changed, 7 insertions(+), 6 deletions(-)

diff -puN drivers/pnp/system.c~correctly-report-pnp-64bit-resources drivers/pnp/system.c
--- a/drivers/pnp/system.c~correctly-report-pnp-64bit-resources
+++ a/drivers/pnp/system.c
@@ -22,7 +22,7 @@ static const struct pnp_device_id pnp_de
 	{	"",			0	}
 };
 
-static void reserve_range(char *pnpid, int start, int end, int port)
+static void reserve_range(const char *pnpid, resource_size_t start, resource_size_t end, int port)
 {
 	struct resource *res;
 	char *regionid;
@@ -32,9 +32,9 @@ static void reserve_range(char *pnpid, i
 		return;
 	snprintf(regionid, 16, "pnp %s", pnpid);
 	if (port)
-		res = request_region(start,end-start+1,regionid);
+		res = request_region(start, end-start+1, regionid);
 	else
-		res = request_mem_region(start,end-start+1,regionid);
+		res = request_mem_region(start, end-start+1, regionid);
 	if (res == NULL)
 		kfree(regionid);
 	else
@@ -45,12 +45,13 @@ static void reserve_range(char *pnpid, i
 	 * have double reservations.
 	 */
 	printk(KERN_INFO
-		"pnp: %s: %s range 0x%x-0x%x %s reserved\n",
-		pnpid, port ? "ioport" : "iomem", start, end,
+		"pnp: %s: %s range 0x%llx-0x%llx %s reserved\n",
+		pnpid, port ? "ioport" : "iomem",
+                (unsigned long long)start, (unsigned long long)end,
 		NULL != res ? "has been" : "could not be");
 }
 
-static void reserve_resources_of_dev(struct pnp_dev *dev)
+static void reserve_resources_of_dev(const struct pnp_dev *dev)
 {
 	int i;
 
_

Patches currently in -mm which might be from petr@vandrovec.name are

origin.patch
