From: akpm@linux-foundation.org
Subject: + documentation-abi-sys-devices-system-node.patch added to -mm tree
Date: Wed, 12 Dec 2012 12:56:55 -0800
Message-ID: <20121212205655.95CB582004A@wpzn4.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-gh0-f202.google.com ([209.85.160.202]:36042 "EHLO
	mail-gh0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755982Ab2LLU44 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 12 Dec 2012 15:56:56 -0500
Received: by mail-gh0-f202.google.com with SMTP id z10so126289ghb.1
        for <mm-commits@vger.kernel.org>; Wed, 12 Dec 2012 12:56:56 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: davidlohr.bueso@hp.com, gregkh@linuxfoundation.org


The patch titled
     Subject: Documentation: ABI: /sys/devices/system/node/
has been added to the -mm tree.  Its filename is
     documentation-abi-sys-devices-system-node.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Davidlohr Bueso <davidlohr.bueso@hp.com>
Subject: Documentation: ABI: /sys/devices/system/node/

Describe NUMA node sysfs files/attributes.

Note that for the specific dates and contacts I couldn't find,
I left it as default for Oct 2002 and linux-mm.

Signed-off-by: Davidlohr Bueso <davidlohr.bueso@hp.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/ABI/stable/sysfs-devices-node |   96 +++++++++++++++++-
 1 file changed, 95 insertions(+), 1 deletion(-)

diff -puN Documentation/ABI/stable/sysfs-devices-node~documentation-abi-sys-devices-system-node Documentation/ABI/stable/sysfs-devices-node
--- a/Documentation/ABI/stable/sysfs-devices-node~documentation-abi-sys-devices-system-node
+++ a/Documentation/ABI/stable/sysfs-devices-node
@@ -1,7 +1,101 @@
+What:		/sys/devices/system/node/possible
+Date:		October 2002
+Contact:	Linux Memory Management list <linux-mm@kvack.org>
+Description:
+		Nodes that could be possibly become online at some point.
+
+What:		/sys/devices/system/node/online
+Date:		October 2002
+Contact:	Linux Memory Management list <linux-mm@kvack.org>
+Description:
+		Nodes that are online.
+
+What:		/sys/devices/system/node/has_normal_memory
+Date:		October 2002
+Contact:	Linux Memory Management list <linux-mm@kvack.org>
+Description:
+		Nodes that have regular memory.
+
+What:		/sys/devices/system/node/has_cpu
+Date:		October 2002
+Contact:	Linux Memory Management list <linux-mm@kvack.org>
+Description:
+		Nodes that have one or more CPUs.
+
+What:		/sys/devices/system/node/has_high_memory
+Date:		October 2002
+Contact:	Linux Memory Management list <linux-mm@kvack.org>
+Description:
+		Nodes that have regular or high memory.
+		Depends on CONFIG_HIGHMEM.
+
 What:		/sys/devices/system/node/nodeX
 Date:		October 2002
 Contact:	Linux Memory Management list <linux-mm@kvack.org>
 Description:
 		When CONFIG_NUMA is enabled, this is a directory containing
 		information on node X such as what CPUs are local to the
-		node.
+		node. Each file is detailed next.
+
+What:		/sys/devices/system/node/nodeX/cpumap
+Date:		October 2002
+Contact:	Linux Memory Management list <linux-mm@kvack.org>
+Description:
+		The node's cpumap.
+
+What:		/sys/devices/system/node/nodeX/cpulist
+Date:		October 2002
+Contact:	Linux Memory Management list <linux-mm@kvack.org>
+Description:
+		The CPUs associated to the node.
+
+What:		/sys/devices/system/node/nodeX/meminfo
+Date:		October 2002
+Contact:	Linux Memory Management list <linux-mm@kvack.org>
+Description:
+		Provides information about the node's distribution and memory
+		utilization. Similar to /proc/meminfo, see Documentation/filesystems/proc.txt
+
+What:		/sys/devices/system/node/nodeX/numastat
+Date:		October 2002
+Contact:	Linux Memory Management list <linux-mm@kvack.org>
+Description:
+		The node's hit/miss statistics, in units of pages.
+		See Documentation/numastat.txt
+
+What:		/sys/devices/system/node/nodeX/distance
+Date:		October 2002
+Contact:	Linux Memory Management list <linux-mm@kvack.org>
+Description:
+		Distance between the node and all the other nodes
+		in the system.
+
+What:		/sys/devices/system/node/nodeX/vmstat
+Date:		October 2002
+Contact:	Linux Memory Management list <linux-mm@kvack.org>
+Description:
+		The node's zoned virtual memory statistics.
+		This is a superset of numastat.
+
+What:		/sys/devices/system/node/nodeX/compact
+Date:		February 2010
+Contact:	Mel Gorman <mel@csn.ul.ie>
+Description:
+		When this file is written to, all memory within that node
+		will be compacted. When it completes, memory will be freed
+		into blocks which have as many contiguous pages as possible
+
+What:		/sys/devices/system/node/nodeX/scan_unevictable_pages
+Date:		October 2008
+Contact:	Lee Schermerhorn <lee.schermerhorn@hp.com>
+Description:
+		When set, it triggers scanning the node's unevictable lists
+		and move any pages that have become evictable onto the respective
+		zone's inactive list. See mm/vmscan.c
+
+What:		/sys/devices/system/node/nodeX/hugepages/hugepages-<size>/
+Date:		December 2009
+Contact:	Lee Schermerhorn <lee.schermerhorn@hp.com>
+Description:
+		The node's huge page size control/query attributes.
+		See Documentation/vm/hugetlbpage.txt
\ No newline at end of file
_

Patches currently in -mm which might be from davidlohr.bueso@hp.com are

documentation-abi-sys-devices-system-node.patch

