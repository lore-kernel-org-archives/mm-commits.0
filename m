From: akpm@linux-foundation.org
Subject: - ehea-simplify-resource-usage-check.patch removed from -mm tree
Date: Wed, 08 Aug 2007 12:07:56 -0700
Message-ID: <200708081907.l78J7ucg025827@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:37014 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1765986AbXHHTIf (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 8 Aug 2007 15:08:35 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: osstklei@de.ibm.com, tklein@de.ibm.com, mm-commits@vger.kernel.org


The patch titled
     ehea: simplify resource usage check
has been removed from the -mm tree.  Its filename was
     ehea-simplify-resource-usage-check.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: ehea: simplify resource usage check
From: Thomas Klein <osstklei@de.ibm.com>

Use shorter method to determine whether adapter has configured ports

Signed-off-by: Thomas Klein <tklein@de.ibm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/net/ehea/ehea_main.c |   18 ++++++------------
 1 files changed, 6 insertions(+), 12 deletions(-)

diff -puN drivers/net/ehea/ehea_main.c~ehea-simplify-resource-usage-check drivers/net/ehea/ehea_main.c
--- a/drivers/net/ehea/ehea_main.c~ehea-simplify-resource-usage-check
+++ a/drivers/net/ehea/ehea_main.c
@@ -2165,24 +2165,18 @@ static int ehea_clean_all_portres(struct
 	return ret;
 }
 
-static void ehea_remove_adapter_mr (struct ehea_adapter *adapter)
+static void ehea_remove_adapter_mr(struct ehea_adapter *adapter)
 {
-	int i;
-
-	for (i=0; i < EHEA_MAX_PORTS; i++)
-		if (adapter->port[i])
-			return;
+	if (adapter->active_ports)
+		return;
 
 	ehea_rem_mr(&adapter->mr);
 }
 
-static int ehea_add_adapter_mr (struct ehea_adapter *adapter)
+static int ehea_add_adapter_mr(struct ehea_adapter *adapter)
 {
-	int i;
-
-	for (i=0; i < EHEA_MAX_PORTS; i++)
-		if (adapter->port[i])
-			return 0;
+	if (adapter->active_ports)
+		return 0;
 
 	return ehea_reg_kernel_mr(adapter, &adapter->mr);
 }
_

Patches currently in -mm which might be from osstklei@de.ibm.com are

git-netdev-all.patch
