From: akpm@linux-foundation.org
Subject: - x86_64-export-physnode-mapping-to-userspace.patch removed from -mm tree
Date: Thu, 29 Mar 2007 16:13:10 -0700
Message-ID: <200703292313.l2TNDA5A014655@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:42293 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1422686AbXC2XNS (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Thu, 29 Mar 2007 19:13:18 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: rientjes@google.com, ak@suse.de, clameter@engr.sgi.com, pj@sgi.com, rohitseth@google.com, mm-commits@vger.kernel.org


The patch titled
     x86_64: export physnode mapping to userspace
has been removed from the -mm tree.  Its filename was
     x86_64-export-physnode-mapping-to-userspace.patch

This patch was dropped because it was nacked by the maintainer

------------------------------------------------------
Subject: x86_64: export physnode mapping to userspace
From: David Rientjes <rientjes@google.com>

Exports the physical NUMA node to fake NUMA node mapping to user-space via
sysfs.  The information is now accessible via the 'physnode' file.

Cc: Andi Kleen <ak@suse.de>
Signed-off-by: Rohit Seth <rohitseth@google.com>
Signed-off-by: David Rientjes <rientjes@google.com>
Cc: Paul Jackson <pj@sgi.com>
Cc: Christoph Lameter <clameter@engr.sgi.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/base/node.c |   13 +++++++++++++
 1 file changed, 13 insertions(+)

diff -puN drivers/base/node.c~x86_64-export-physnode-mapping-to-userspace drivers/base/node.c
--- a/drivers/base/node.c~x86_64-export-physnode-mapping-to-userspace
+++ a/drivers/base/node.c
@@ -131,6 +131,13 @@ static ssize_t node_read_distance(struct
 }
 static SYSDEV_ATTR(distance, S_IRUGO, node_read_distance, NULL);
 
+#ifdef CONFIG_NUMA_EMU
+static ssize_t node_read_physnode(struct sys_device *dev, char *buf)
+{
+	return sprintf(buf, "%d\n", get_phys_node(dev->id));
+}
+static SYSDEV_ATTR(physnode, S_IRUGO, node_read_physnode, NULL);
+#endif
 
 /*
  * register_node - Setup a sysfs device for a node.
@@ -151,6 +158,9 @@ int register_node(struct node *node, int
 		sysdev_create_file(&node->sysdev, &attr_meminfo);
 		sysdev_create_file(&node->sysdev, &attr_numastat);
 		sysdev_create_file(&node->sysdev, &attr_distance);
+#ifdef CONFIG_NUMA_EMU
+		sysdev_create_file(&node->sysdev, &attr_physnode);
+#endif
 	}
 	return error;
 }
@@ -168,6 +178,9 @@ void unregister_node(struct node *node)
 	sysdev_remove_file(&node->sysdev, &attr_meminfo);
 	sysdev_remove_file(&node->sysdev, &attr_numastat);
 	sysdev_remove_file(&node->sysdev, &attr_distance);
+#ifdef CONFIG_NUMA_EMU
+	sysdev_remove_file(&node->sysdev, &attr_physnode);
+#endif
 
 	sysdev_unregister(&node->sysdev);
 }
_

Patches currently in -mm which might be from rientjes@google.com are

x86_64-disable-alien-cache-for-fake-numa.patch
x86_64-export-physnode-mapping-to-userspace.patch
i386-add-ptep_test_and_clear_dirtyyoung.patch
i386-use-pte_update_defer-in-ptep_test_and_clear_dirtyyoung.patch
i386-use-pte_update_defer-in-ptep_test_and_clear_dirtyyoung-fix.patch
smaps-extract-pmd-walker-from-smaps-code.patch
smaps-add-pages-referenced-count-to-smaps.patch
smaps-add-clear_refs-file-to-clear-reference.patch
smaps-add-clear_refs-file-to-clear-reference-fix.patch
smaps-add-clear_refs-file-to-clear-reference-fix-fix.patch
smaps-add-clear_refs-file-to-clear-reference-fix-fix-2.patch
smaps-add-clear_refs-file-to-clear-reference-cleanup.patch
smaps-use-ptep_test_and_clear_young.patch
smaps-add-clear_refs-file-to-clear-reference-docs.patch
