From: akpm@linux-foundation.org
Subject: +
 drivers-net-ethernet-ibm-ehea-ehea_mainc-add-alias-entry-for-portn-properties.patch added to -mm tree
Date: Tue, 28 May 2013 16:09:58 -0700
Message-ID: <51a53946.hQQ+dw3VlEaWbBzC%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:33854 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758127Ab3E1XJ7 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 28 May 2013 19:09:59 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, jslaby@suse.cz, jeffm@suse.com, davem@davemloft.net, cascardo@linux.vnet.ibm.com, ohering@suse.com

Subject: + drivers-net-ethernet-ibm-ehea-ehea_mainc-add-alias-entry-for-portn-properties.patch added to -mm tree
To: ohering@suse.com,cascardo@linux.vnet.ibm.com,davem@davemloft.net,jeffm@suse.com,jslaby@suse.cz
From: akpm@linux-foundation.org
Date: Tue, 28 May 2013 16:09:58 -0700


The patch titled
     Subject: drivers/net/ethernet/ibm/ehea/ehea_main.c: add alias entry for portN properties
has been added to the -mm tree.  Its filename is
     drivers-net-ethernet-ibm-ehea-ehea_mainc-add-alias-entry-for-portn-properties.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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
@@ -103,6 +103,19 @@ static int ehea_probe_adapter(struct pla
 
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
@@ -110,7 +123,6 @@ static struct of_device_id ehea_device_t
 	},
 	{},
 };
-MODULE_DEVICE_TABLE(of, ehea_device_table);
 
 static struct of_platform_driver ehea_driver = {
 	.driver = {
_

Patches currently in -mm which might be from ohering@suse.com are

drivers-net-ethernet-ibm-ehea-ehea_mainc-add-alias-entry-for-portn-properties.patch

