From: akpm@linux-foundation.org
Subject: [merged] documentation-abi-sys-devices-system-cpu-cpu-node.patch removed from -mm tree
Date: Tue, 15 Dec 2009 13:52:56 -0800
Message-ID: <200912152152.nBFLquBY015231@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:58027 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1761260AbZLOVyE (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 15 Dec 2009 16:54:04 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: achiang@hp.com, garyhade@us.ibm.com, greg@kroah.com, kosaki.motohiro@jp.fujitsu.com, mingo@elte.hu, pbadari@us.ibm.com, randy.dunlap@oracle.com, rientjes@google.com, mm-commits@vger.kernel.org


The patch titled
     Documentation: ABI: /sys/devices/system/cpu/cpu#/node
has been removed from the -mm tree.  Its filename was
     documentation-abi-sys-devices-system-cpu-cpu-node.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: Documentation: ABI: /sys/devices/system/cpu/cpu#/node
From: Alex Chiang <achiang@hp.com>

Describe NUMA node symlink created for CPUs when CONFIG_NUMA is set.

Signed-off-by: Alex Chiang <achiang@hp.com>
Cc: Greg KH <greg@kroah.com>
Cc: Randy Dunlap <randy.dunlap@oracle.com>
Cc: Gary Hade <garyhade@us.ibm.com>
Cc: Badari Pulavarty <pbadari@us.ibm.com>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: David Rientjes <rientjes@google.com>
Cc: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/ABI/testing/sysfs-devices-system-cpu |   14 +++++++++++
 1 file changed, 14 insertions(+)

diff -puN Documentation/ABI/testing/sysfs-devices-system-cpu~documentation-abi-sys-devices-system-cpu-cpu-node Documentation/ABI/testing/sysfs-devices-system-cpu
--- a/Documentation/ABI/testing/sysfs-devices-system-cpu~documentation-abi-sys-devices-system-cpu-cpu-node
+++ a/Documentation/ABI/testing/sysfs-devices-system-cpu
@@ -92,6 +92,20 @@ Description:	Discover NUMA node a CPU be
 		/sys/devices/system/cpu/cpu42/node2 -> ../../node/node2
 
 
+What:		/sys/devices/system/cpu/cpu#/node
+Date:		October 2009
+Contact:	Linux memory management mailing list <linux-mm@kvack.org>
+Description:	Discover NUMA node a CPU belongs to
+
+		When CONFIG_NUMA is enabled, a symbolic link that points
+		to the corresponding NUMA node directory.
+
+		For example, the following symlink is created for cpu42
+		in NUMA node 2:
+
+		/sys/devices/system/cpu/cpu42/node2 -> ../../node/node2
+
+
 What:		/sys/devices/system/cpu/cpu#/topology/core_id
 		/sys/devices/system/cpu/cpu#/topology/core_siblings
 		/sys/devices/system/cpu/cpu#/topology/core_siblings_list
_

Patches currently in -mm which might be from achiang@hp.com are

origin.patch
linux-next.patch

