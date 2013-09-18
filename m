From: akpm@linux-foundation.org
Subject: [merged]
 drivers-net-ethernet-ibm-ehea-ehea_mainc-add-alias-entry-for-portn-properties.patch removed from -mm tree
Date: Wed, 18 Sep 2013 13:02:25 -0700
Message-ID: <523a06d1.1XyMa8OHCVJL5w+z%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:46115 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752031Ab3IRUC0 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 18 Sep 2013 16:02:26 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, jslaby@suse.cz, jeffm@suse.com, davem@davemloft.net, cascardo@linux.vnet.ibm.com, ohering@suse.com

Subject: [merged] drivers-net-ethernet-ibm-ehea-ehea_mainc-add-alias-entry-for-portn-properties.patch removed from -mm tree
To: ohering@suse.com,cascardo@linux.vnet.ibm.com,davem@davemloft.net,jeffm@suse.com,jslaby@suse.cz,mm-commits@vger.kernel.org
From: akpm@linux-foundation.org
Date: Wed, 18 Sep 2013 13:02:25 -0700


The patch titled
     Subject: drivers/net/ethernet/ibm/ehea/ehea_main.c: add alias entry for portN properties
has been removed from the -mm tree.  Its filename was
     drivers-net-ethernet-ibm-ehea-ehea_mainc-add-alias-entry-for-portn-properties.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Olaf Hering <ohering@suse.com>
Subject: drivers/net/ethernet/ibm/ehea/ehea_main.c: add alias entry for portN properties

Use separate table for alias entries in the ehea module, otherwise the
probe() function will operate on the separate ports instead of the
lhea-"root" entry of the device-tree

Addresses https://bugzilla.novell.com/show_bug.cgi?id=435215

Signed-off-by: Jeff Mahoney <jeffm@suse.com>
Signed-off-by: Olaf Hering <ohering@suse.com>
Signed-off-by: Jiri Slaby <jslaby@suse.cz>
Cc: Thadeu Lima de Souza Cascardo <cascardo@linux.vnet.ibm.com>
Cc: "David S. Miller" <davem@davemloft.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/net/ethernet/ibm/ehea/ehea_main.c |   14 +++++++++++++-
 1 file changed, 13 insertions(+), 1 deletion(-)

diff -puN drivers/net/ethernet/ibm/ehea/ehea_main.c~drivers-net-ethernet-ibm-ehea-ehea_mainc-add-alias-entry-for-portn-properties drivers/net/ethernet/ibm/ehea/ehea_main.c
--- a/drivers/net/ethernet/ibm/ehea/ehea_main.c~drivers-net-ethernet-ibm-ehea-ehea_mainc-add-alias-entry-for-portn-properties
+++ a/drivers/net/ethernet/ibm/ehea/ehea_main.c
@@ -102,6 +102,19 @@ static int ehea_probe_adapter(struct pla
 
 static int ehea_remove(struct platform_device *dev);
 
+static struct of_device_id ehea_module_device_table[] = {
+	{
+		.name = "lhea",
+		.compatible = "IBM,lhea",
+	},
+	{
+		.type = "network",
+		.compatible = "IBM,lhea-ethernet",
+	},
+	{},
+};
+MODULE_DEVICE_TABLE(of, ehea_module_device_table);
+
 static struct of_device_id ehea_device_table[] = {
 	{
 		.name = "lhea",
@@ -109,7 +122,6 @@ static struct of_device_id ehea_device_t
 	},
 	{},
 };
-MODULE_DEVICE_TABLE(of, ehea_device_table);
 
 static struct platform_driver ehea_driver = {
 	.driver = {
_

Patches currently in -mm which might be from ohering@suse.com are

linux-next.patch

