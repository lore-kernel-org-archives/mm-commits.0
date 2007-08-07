From: akpm@linux-foundation.org
Subject: + ehea-simplify-resource-usage-check.patch added to -mm tree
Date: Tue, 07 Aug 2007 16:20:09 -0700
Message-ID: <200708072320.l77NK9nA010116@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:46410 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754269AbXHGXUu (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 7 Aug 2007 19:20:50 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: osstklei@de.ibm.com, tklein@de.ibm.com


The patch titled
     ehea: simplify resource usage check
has been added to the -mm tree.  Its filename is
     ehea-simplify-resource-usage-check.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

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

ehea-fix-workqueue-handling.patch
ehea-simplify-resource-usage-check.patch
ehea-eliminated-some-compiler-warnings.patch
