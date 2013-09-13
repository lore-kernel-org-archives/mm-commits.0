From: akpm@linux-foundation.org
Subject: + mm-acpi-use-numa_no_node.patch added to -mm tree
Date: Fri, 13 Sep 2013 15:33:57 -0700
Message-ID: <523392d5.OwIWtf8HdO98GLcN%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:39359 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753932Ab3IMWd6 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 13 Sep 2013 18:33:58 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, rjw@sisk.pl, rientjes@google.com, wujianguo@huawei.com

Subject: + mm-acpi-use-numa_no_node.patch added to -mm tree
To: wujianguo@huawei.com,rientjes@google.com,rjw@sisk.pl
From: akpm@linux-foundation.org
Date: Fri, 13 Sep 2013 15:33:57 -0700


The patch titled
     Subject: mm/acpi: use NUMA_NO_NODE
has been added to the -mm tree.  Its filename is
     mm-acpi-use-numa_no_node.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-acpi-use-numa_no_node.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-acpi-use-numa_no_node.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Jianguo Wu <wujianguo@huawei.com>
Subject: mm/acpi: use NUMA_NO_NODE

Use more appropriate NUMA_NO_NODE instead of -1

Signed-off-by: Jianguo Wu <wujianguo@huawei.com>
Acked-by: David Rientjes <rientjes@google.com>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/acpi/acpi_memhotplug.c |    2 +-
 drivers/acpi/numa.c            |    4 ++--
 2 files changed, 3 insertions(+), 3 deletions(-)

diff -puN drivers/acpi/acpi_memhotplug.c~mm-acpi-use-numa_no_node drivers/acpi/acpi_memhotplug.c
--- a/drivers/acpi/acpi_memhotplug.c~mm-acpi-use-numa_no_node
+++ a/drivers/acpi/acpi_memhotplug.c
@@ -281,7 +281,7 @@ static void acpi_memory_remove_memory(st
 		if (!info->enabled)
 			continue;
 
-		if (nid < 0)
+		if (nid == NUMA_NO_NODE)
 			nid = memory_add_physaddr_to_nid(info->start_addr);
 
 		acpi_unbind_memory_blocks(info, handle);
diff -puN drivers/acpi/numa.c~mm-acpi-use-numa_no_node drivers/acpi/numa.c
--- a/drivers/acpi/numa.c~mm-acpi-use-numa_no_node
+++ a/drivers/acpi/numa.c
@@ -73,7 +73,7 @@ int acpi_map_pxm_to_node(int pxm)
 {
 	int node = pxm_to_node_map[pxm];
 
-	if (node < 0) {
+	if (node == NUMA_NO_NODE) {
 		if (nodes_weight(nodes_found_map) >= MAX_NUMNODES)
 			return NUMA_NO_NODE;
 		node = first_unset_node(nodes_found_map);
@@ -334,7 +334,7 @@ int acpi_get_pxm(acpi_handle h)
 
 int acpi_get_node(acpi_handle *handle)
 {
-	int pxm, node = -1;
+	int pxm, node = NUMA_NO_NODE;
 
 	pxm = acpi_get_pxm(handle);
 	if (pxm >= 0 && pxm < MAX_PXM_DOMAINS)
_

Patches currently in -mm which might be from wujianguo@huawei.com are

origin.patch
mm-vmalloc-use-numa_no_node.patch
mm-acpi-use-numa_no_node.patch
x86-srat-use-numa_no_node.patch

