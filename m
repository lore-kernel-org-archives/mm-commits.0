From: akpm@linux-foundation.org
Subject: [merged]
 drivers-base-nodec-fix-null-pointer-access-and-memory-leak-in-unregister_one_node.patch removed from -mm tree
Date: Wed, 12 Mar 2014 12:06:50 -0700
Message-ID: <5320b04a.9I31iaVYOwWjQ0AH%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:57159 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752445AbaCLTGv (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 12 Mar 2014 15:06:51 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, qiuxishi@huawei.com

Subject: [merged] drivers-base-nodec-fix-null-pointer-access-and-memory-leak-in-unregister_one_node.patch removed from -mm tree
To: qiuxishi@huawei.com,mm-commits@vger.kernel.org
From: akpm@linux-foundation.org
Date: Wed, 12 Mar 2014 12:06:50 -0700


The patch titled
     Subject: drivers/base/node.c: fix NULL pointer access and memory leak in unregister_one_node()
has been removed from the -mm tree.  Its filename was
     drivers-base-nodec-fix-null-pointer-access-and-memory-leak-in-unregister_one_node.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Xishi Qiu <qiuxishi@huawei.com>
Subject: drivers/base/node.c: fix NULL pointer access and memory leak in unregister_one_node()

When doing socket hot remove, "node_devices[nid]" is set to NULL;
acpi_processor_remove()
	try_offline_node()
		unregister_one_node()

Then hot add a socket, but do not echo 1 >
/sys/devices/system/cpu/cpuXX/online, so register_one_node() will not be
called, and "node_devices[nid]" is still NULL.

If doing socket hot remove again, NULL pointer access will be happen.
unregister_one_node()
	unregister_node()

Also, we should free the memory used by "node_devices[nid]" in
unregister_one_node().

Signed-off-by: Xishi Qiu <qiuxishi@huawei.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/base/node.c |    4 ++++
 1 file changed, 4 insertions(+)

diff -puN drivers/base/node.c~drivers-base-nodec-fix-null-pointer-access-and-memory-leak-in-unregister_one_node drivers/base/node.c
--- a/drivers/base/node.c~drivers-base-nodec-fix-null-pointer-access-and-memory-leak-in-unregister_one_node
+++ a/drivers/base/node.c
@@ -599,7 +599,11 @@ int register_one_node(int nid)
 
 void unregister_one_node(int nid)
 {
+	if (!node_devices[nid])
+		return;
+
 	unregister_node(node_devices[nid]);
+	kfree(node_devices[nid]);
 	node_devices[nid] = NULL;
 }
 
_

Patches currently in -mm which might be from qiuxishi@huawei.com are

linux-next.patch

