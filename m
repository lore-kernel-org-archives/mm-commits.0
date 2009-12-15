From: akpm@linux-foundation.org
Subject: [merged] mm-refactor-register_cpu_under_node.patch removed from -mm tree
Date: Tue, 15 Dec 2009 13:52:44 -0800
Message-ID: <200912152152.nBFLqikC015213@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:38510 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1761236AbZLOVxo (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 15 Dec 2009 16:53:44 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: achiang@hp.com, garyhade@us.ibm.com, greg@kroah.com, kosaki.motohiro@jp.fujitsu.com, mingo@elte.hu, pbadari@us.ibm.com, randy.dunlap@oracle.com, rientjes@google.com, mm-commits@vger.kernel.org


The patch titled
     mm: refactor register_cpu_under_node()
has been removed from the -mm tree.  Its filename was
     mm-refactor-register_cpu_under_node.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: mm: refactor register_cpu_under_node()
From: Alex Chiang <achiang@hp.com>

By returning early if the node is not online, we can unindent the
interesting code by one level.

No functional change.

Signed-off-by: Alex Chiang <achiang@hp.com>
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

 drivers/base/node.c |   20 +++++++++++---------
 1 file changed, 11 insertions(+), 9 deletions(-)

diff -puN drivers/base/node.c~mm-refactor-register_cpu_under_node drivers/base/node.c
--- a/drivers/base/node.c~mm-refactor-register_cpu_under_node
+++ a/drivers/base/node.c
@@ -271,16 +271,18 @@ struct node node_devices[MAX_NUMNODES];
  */
 int register_cpu_under_node(unsigned int cpu, unsigned int nid)
 {
-	if (node_online(nid)) {
-		struct sys_device *obj = get_cpu_sysdev(cpu);
-		if (!obj)
-			return 0;
-		return sysfs_create_link(&node_devices[nid].sysdev.kobj,
-					 &obj->kobj,
-					 kobject_name(&obj->kobj));
-	 }
+	struct sys_device *obj;
 
-	return 0;
+	if (!node_online(nid))
+		return 0;
+
+	obj = get_cpu_sysdev(cpu);
+	if (!obj)
+		return 0;
+
+	return sysfs_create_link(&node_devices[nid].sysdev.kobj,
+				&obj->kobj,
+				kobject_name(&obj->kobj));
 }
 
 int unregister_cpu_under_node(unsigned int cpu, unsigned int nid)
_

Patches currently in -mm which might be from achiang@hp.com are

origin.patch
linux-next.patch

