From: akpm@linux-foundation.org
Subject: + mm-refactor-register_cpu_under_node.patch added to -mm tree
Date: Thu, 12 Nov 2009 13:18:11 -0800
Message-ID: <200911122118.nACLIBDE008137@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:58601 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754527AbZKLVSl (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 12 Nov 2009 16:18:41 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: achiang@hp.com, garyhade@us.ibm.com, greg@kroah.com, kosaki.motohiro@jp.fujitsu.com, mingo@elte.hu, pbadari@us.ibm.com, randy.dunlap@oracle.com, rientjes@google.com


The patch titled
     mm: refactor register_cpu_under_node()
has been added to the -mm tree.  Its filename is
     mm-refactor-register_cpu_under_node.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://userweb.kernel.org/~akpm/stuff/added-to-mm.txt to find
out what to do about this

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
page-types-learn-to-describe-flags-directly-from-command-line.patch
page-types-whitespace-alignment.patch
page-types-exit-early-when-invoked-with-d-describe.patch
mm-add-numa-node-symlink-for-memory-section-in-sysfs.patch
mm-refactor-register_cpu_under_node.patch
mm-refactor-unregister_cpu_under_node.patch
mm-add-numa-node-symlink-for-cpu-devices-in-sysfs.patch
documentation-abi-sys-devices-system-cpu-cpu-node.patch

