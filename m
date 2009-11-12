From: akpm@linux-foundation.org
Subject: + mm-add-numa-node-symlink-for-memory-section-in-sysfs.patch added to -mm tree
Date: Thu, 12 Nov 2009 13:18:09 -0800
Message-ID: <200911122118.nACLI9k4008036@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:43812 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754207AbZKLVSi (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 12 Nov 2009 16:18:38 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: achiang@hp.com, garyhade@us.ibm.com, greg@kroah.com, kosaki.motohiro@jp.fujitsu.com, mingo@elte.hu, pbadari@us.ibm.com, randy.dunlap@oracle.com, rientjes@google.com


The patch titled
     mm: add numa node symlink for memory section in sysfs
has been added to the -mm tree.  Its filename is
     mm-add-numa-node-symlink-for-memory-section-in-sysfs.patch

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
Subject: mm: add numa node symlink for memory section in sysfs
From: Alex Chiang <achiang@hp.com>

Commit c04fc586c (mm: show node to memory section relationship with
symlinks in sysfs) created symlinks from nodes to memory sections, e.g.

/sys/devices/system/node/node1/memory135 -> ../../memory/memory135

If you're examining the memory section though and are wondering what node
it might belong to, you can find it by grovelling around in sysfs, but
it's a little cumbersome.

Add a reverse symlink for each memory section that points back to the
node to which it belongs.

Signed-off-by: Alex Chiang <achiang@hp.com>
Cc: Gary Hade <garyhade@us.ibm.com>
Cc: Badari Pulavarty <pbadari@us.ibm.com>
Cc: Ingo Molnar <mingo@elte.hu>
Acked-by: David Rientjes <rientjes@google.com>
Cc: Greg KH <greg@kroah.com>
Cc: Randy Dunlap <randy.dunlap@oracle.com>
Cc: David Rientjes <rientjes@google.com>
Cc: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/ABI/testing/sysfs-devices-memory |   14 +++++++++++++-
 Documentation/memory-hotplug.txt               |   11 +++++++----
 drivers/base/node.c                            |   11 ++++++++++-
 3 files changed, 30 insertions(+), 6 deletions(-)

diff -puN Documentation/ABI/testing/sysfs-devices-memory~mm-add-numa-node-symlink-for-memory-section-in-sysfs Documentation/ABI/testing/sysfs-devices-memory
--- a/Documentation/ABI/testing/sysfs-devices-memory~mm-add-numa-node-symlink-for-memory-section-in-sysfs
+++ a/Documentation/ABI/testing/sysfs-devices-memory
@@ -60,6 +60,19 @@ Description:
 Users:		hotplug memory remove tools
 		https://w3.opensource.ibm.com/projects/powerpc-utils/
 
+
+What:		/sys/devices/system/memoryX/nodeY
+Date:		October 2009
+Contact:	Linux Memory Management list <linux-mm@kvack.org>
+Description:
+		When CONFIG_NUMA is enabled, a symbolic link that
+		points to the corresponding NUMA node directory.
+
+		For example, the following symbolic link is created for
+		memory section 9 on node0:
+		/sys/devices/system/memory/memory9/node0 -> ../../node/node0
+
+
 What:		/sys/devices/system/node/nodeX/memoryY
 Date:		September 2008
 Contact:	Gary Hade <garyhade@us.ibm.com>
@@ -70,4 +83,3 @@ Description:
 		memory section directory.  For example, the following symbolic
 		link is created for memory section 9 on node0.
 		/sys/devices/system/node/node0/memory9 -> ../../memory/memory9
-
diff -puN Documentation/memory-hotplug.txt~mm-add-numa-node-symlink-for-memory-section-in-sysfs Documentation/memory-hotplug.txt
--- a/Documentation/memory-hotplug.txt~mm-add-numa-node-symlink-for-memory-section-in-sysfs
+++ a/Documentation/memory-hotplug.txt
@@ -160,12 +160,15 @@ Under each section, you can see 4 files.
 NOTE:
   These directories/files appear after physical memory hotplug phase.
 
-If CONFIG_NUMA is enabled the
-/sys/devices/system/memory/memoryXXX memory section
-directories can also be accessed via symbolic links located in
-the /sys/devices/system/node/node* directories.  For example:
+If CONFIG_NUMA is enabled the memoryXXX/ directories can also be accessed
+via symbolic links located in the /sys/devices/system/node/node* directories.
+
+For example:
 /sys/devices/system/node/node0/memory9 -> ../../memory/memory9
 
+A backlink will also be created:
+/sys/devices/system/memory/memory9/node0 -> ../../node/node0
+
 --------------------------------
 4. Physical memory hot-add phase
 --------------------------------
diff -puN drivers/base/node.c~mm-add-numa-node-symlink-for-memory-section-in-sysfs drivers/base/node.c
--- a/drivers/base/node.c~mm-add-numa-node-symlink-for-memory-section-in-sysfs
+++ a/drivers/base/node.c
@@ -312,6 +312,7 @@ static int get_nid_for_pfn(unsigned long
 /* register memory section under specified node if it spans that node */
 int register_mem_sect_under_node(struct memory_block *mem_blk, int nid)
 {
+	int ret;
 	unsigned long pfn, sect_start_pfn, sect_end_pfn;
 
 	if (!mem_blk)
@@ -328,9 +329,15 @@ int register_mem_sect_under_node(struct 
 			continue;
 		if (page_nid != nid)
 			continue;
-		return sysfs_create_link_nowarn(&node_devices[nid].sysdev.kobj,
+		ret = sysfs_create_link_nowarn(&node_devices[nid].sysdev.kobj,
 					&mem_blk->sysdev.kobj,
 					kobject_name(&mem_blk->sysdev.kobj));
+		if (ret)
+			return ret;
+
+		return sysfs_create_link_nowarn(&mem_blk->sysdev.kobj,
+				&node_devices[nid].sysdev.kobj,
+				kobject_name(&node_devices[nid].sysdev.kobj));
 	}
 	/* mem section does not span the specified node */
 	return 0;
@@ -359,6 +366,8 @@ int unregister_mem_sect_under_nodes(stru
 			continue;
 		sysfs_remove_link(&node_devices[nid].sysdev.kobj,
 			 kobject_name(&mem_blk->sysdev.kobj));
+		sysfs_remove_link(&mem_blk->sysdev.kobj,
+			 kobject_name(&node_devices[nid].sysdev.kobj));
 	}
 	return 0;
 }
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

