From: akpm@linux-foundation.org
Subject: + ehae-get_property-returns-const.patch added to -mm tree
Date: Wed, 02 May 2007 21:31:08 -0700
Message-ID: <200705030431.l434V8So004777@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([65.172.181.25]:47552 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1767381AbXECEbR (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 3 May 2007 00:31:17 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: sfr@canb.auug.org.au


The patch titled
     ehae: get_property returns const
has been added to the -mm tree.  Its filename is
     ehae-get_property-returns-const.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: ehae: get_property returns const
From: Stephen Rothwell <sfr@canb.auug.org.au>

This is the last place that needs changing since get_property was changed
to return "const void *".

Signed-off-by: Stephen Rothwell <sfr@canb.auug.org.au>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/net/ehea/ehea_main.c |   13 ++++++-------
 1 file changed, 6 insertions(+), 7 deletions(-)

diff -puN drivers/net/ehea/ehea_main.c~ehae-get_property-returns-const drivers/net/ehea/ehea_main.c
--- a/drivers/net/ehea/ehea_main.c~ehae-get_property-returns-const
+++ a/drivers/net/ehea/ehea_main.c
@@ -2603,14 +2603,13 @@ static int ehea_setup_ports(struct ehea_
 {
 	struct device_node *lhea_dn;
 	struct device_node *eth_dn = NULL;
-
-	u32 *dn_log_port_id;
+	const u32 *dn_log_port_id;
 	int i = 0;
 
 	lhea_dn = adapter->ebus_dev->ofdev.node;
 	while ((eth_dn = of_get_next_child(lhea_dn, eth_dn))) {
 
-		dn_log_port_id = (u32*)get_property(eth_dn, "ibm,hea-port-no",
+		dn_log_port_id = get_property(eth_dn, "ibm,hea-port-no",
 						    NULL);
 		if (!dn_log_port_id) {
 			ehea_error("bad device node: eth_dn name=%s",
@@ -2645,12 +2644,12 @@ static struct device_node *ehea_get_eth_
 {
 	struct device_node *lhea_dn;
 	struct device_node *eth_dn = NULL;
-	u32 *dn_log_port_id;
+	const u32 *dn_log_port_id;
 
 	lhea_dn = adapter->ebus_dev->ofdev.node;
 	while ((eth_dn = of_get_next_child(lhea_dn, eth_dn))) {
 
-		dn_log_port_id = (u32*)get_property(eth_dn, "ibm,hea-port-no",
+		dn_log_port_id = get_property(eth_dn, "ibm,hea-port-no",
 						    NULL);
 		if (dn_log_port_id)
 			if (*dn_log_port_id == logical_port_id)
@@ -2774,7 +2773,7 @@ static int __devinit ehea_probe_adapter(
 					const struct of_device_id *id)
 {
 	struct ehea_adapter *adapter;
-	u64 *adapter_handle;
+	const u64 *adapter_handle;
 	int ret;
 
 	if (!dev || !dev->ofdev.node) {
@@ -2791,7 +2790,7 @@ static int __devinit ehea_probe_adapter(
 
 	adapter->ebus_dev = dev;
 
-	adapter_handle = (u64*)get_property(dev->ofdev.node, "ibm,hea-handle",
+	adapter_handle = get_property(dev->ofdev.node, "ibm,hea-handle",
 					    NULL);
 	if (adapter_handle)
 		adapter->handle = *adapter_handle;
_

Patches currently in -mm which might be from sfr@canb.auug.org.au are

origin.patch
ehae-get_property-returns-const.patch
drivers-char-hvc_consolec-cleanups.patch
rename-get_property-to-of_get_property-drivers.patch
