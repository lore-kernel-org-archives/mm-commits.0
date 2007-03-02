From: akpm@linux-foundation.org
Subject: + x86_64-export-physnode-mapping-to-userspace.patch added to -mm tree
Date: Thu, 01 Mar 2007 17:03:41 -0800
Message-ID: <200703020103.l2213fHa028227@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:33160 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932711AbXCBBDw (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Thu, 1 Mar 2007 20:03:52 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: rientjes@google.com, ak@suse.de, clameter@engr.sgi.com, pj@sgi.com, rohitseth@google.com


The patch titled
     x86_64: export physnode mapping to userspace
has been added to the -mm tree.  Its filename is
     x86_64-export-physnode-mapping-to-userspace.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

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
 1 files changed, 13 insertions(+)

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

x86_64-configurable-fake-numa-node-sizes.patch
x86_64-split-remaining-fake-nodes-equally.patch
x86_64-fixed-size-remaining-fake-nodes.patch
x86_64-map-fake-nodes-to-real-nodes.patch
x86_64-disable-alien-cache-for-fake-numa.patch
x86_64-export-physnode-mapping-to-userspace.patch
x86_64-fake-numa-for-cpusets-document.patch
smaps-extract-pmd-walker-from-smaps-code.patch
smaps-add-pages-referenced-count-to-smaps.patch
smaps-add-clear_refs-file-to-clear-reference.patch
smaps-add-clear_refs-file-to-clear-reference-fix.patch
smaps-add-clear_refs-file-to-clear-reference-fix-fix.patch
smaps-add-clear_refs-file-to-clear-reference-docs.patch
