From: akpm@linux-foundation.org
Subject: [merged] mm-add-numa-node-symlink-for-cpu-devices-in-sysfs.patch removed from -mm tree
Date: Tue, 15 Dec 2009 13:52:50 -0800
Message-ID: <200912152152.nBFLqouv015222@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:40498 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1761231AbZLOVxn (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 15 Dec 2009 16:53:43 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: achiang@hp.com, garyhade@us.ibm.com, greg@kroah.com, kosaki.motohiro@jp.fujitsu.com, mingo@elte.hu, pbadari@us.ibm.com, randy.dunlap@oracle.com, rientjes@google.com, mm-commits@vger.kernel.org


The patch titled
     mm: add numa node symlink for cpu devices in sysfs
has been removed from the -mm tree.  Its filename was
     mm-add-numa-node-symlink-for-cpu-devices-in-sysfs.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: mm: add numa node symlink for cpu devices in sysfs
From: Alex Chiang <achiang@hp.com>

You can discover which CPUs belong to a NUMA node by examining
/sys/devices/system/node/node#/

However, it's not convenient to go in the other direction, when looking at
/sys/devices/system/cpu/cpu#/

Yes, you can muck about in sysfs, but adding these symlinks makes life a
lot more convenient.

Signed-off-by: Alex Chiang <achiang@hp.com>
Acked-by: David Rientjes <rientjes@google.com>
Cc: Gary Hade <garyhade@us.ibm.com>
Cc: Badari Pulavarty <pbadari@us.ibm.com>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: David Rientjes <rientjes@google.com>
Cc: Greg KH <greg@kroah.com>
Cc: Randy Dunlap <randy.dunlap@oracle.com>
Cc: David Rientjes <rientjes@google.com>
Cc: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/base/node.c |   11 ++++++++++-
 1 file changed, 10 insertions(+), 1 deletion(-)

diff -puN drivers/base/node.c~mm-add-numa-node-symlink-for-cpu-devices-in-sysfs drivers/base/node.c
--- a/drivers/base/node.c~mm-add-numa-node-symlink-for-cpu-devices-in-sysfs
+++ a/drivers/base/node.c
@@ -271,6 +271,7 @@ struct node node_devices[MAX_NUMNODES];
  */
 int register_cpu_under_node(unsigned int cpu, unsigned int nid)
 {
+	int ret;
 	struct sys_device *obj;
 
 	if (!node_online(nid))
@@ -280,9 +281,15 @@ int register_cpu_under_node(unsigned int
 	if (!obj)
 		return 0;
 
-	return sysfs_create_link(&node_devices[nid].sysdev.kobj,
+	ret = sysfs_create_link(&node_devices[nid].sysdev.kobj,
 				&obj->kobj,
 				kobject_name(&obj->kobj));
+	if (ret)
+		return ret;
+
+	return sysfs_create_link(&obj->kobj,
+				 &node_devices[nid].sysdev.kobj,
+				 kobject_name(&node_devices[nid].sysdev.kobj));
 }
 
 int unregister_cpu_under_node(unsigned int cpu, unsigned int nid)
@@ -298,6 +305,8 @@ int unregister_cpu_under_node(unsigned i
 
 	sysfs_remove_link(&node_devices[nid].sysdev.kobj,
 			  kobject_name(&obj->kobj));
+	sysfs_remove_link(&obj->kobj,
+			  kobject_name(&node_devices[nid].sysdev.kobj));
 
 	return 0;
 }
_

Patches currently in -mm which might be from achiang@hp.com are

origin.patch
linux-next.patch

