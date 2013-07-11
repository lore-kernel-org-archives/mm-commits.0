From: akpm@linux-foundation.org
Subject: [merged] zswap-add-documentation.patch removed from -mm tree
Date: Thu, 11 Jul 2013 13:16:35 -0700
Message-ID: <51df12a3.oqHSEpTzwE8m6vnv%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: application/octet-stream
Content-Transfer-Encoding: 8bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:41389 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755975Ab3GKUQg (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 11 Jul 2013 16:16:36 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, riel@redhat.com, rcj@linux.vnet.ibm.com, paulus@samba.org, ngupta@vflare.org, minchan@kernel.org, mgorman@suse.de, lwoodman@redhat.com, konrad.wilk@oracle.com, jweiner@redhat.com, joe@perches.com, jhopper@us.ibm.com, iamjoonsoo.kim@lge.com, hughd@google.com, gregkh@linuxfoundation.org, dave@sr71.net, dan.magenheimer@oracle.com, cody@linux.vnet.ibm.com, benh@kernel.crashing.org, sjenning@linux.vnet.ibm.com

Subject: [merged] zswap-add-documentation.patch removed from -mm tree
To: sjenning@linux.vnet.ibm.com,benh@kernel.crashing.org,cody@linux.vnet.ibm.com,dan.magenheimer@oracle.com,dave@sr71.net,gregkh@linuxfoundation.org,hughd@google.com,iamjoonsoo.kim@lge.com,jhopper@us.ibm.com,joe@perches.com,jweiner@redhat.com,konrad.wilk@oracle.com,lwoodman@redhat.com,mgorman@suse.de,minchan@kernel.org,ngupta@vflare.org,paulus@samba.org,rcj@linux.vnet.ibm.com,riel@redhat.com,mm-commits@vger.kernel.org
From: akpm@linux-foundation.org
Date: Thu, 11 Jul 2013 13:16:35 -0700


The patch titled
     Subject: zswap: add documentation
has been removed from the -mm tree.  Its filename was
     zswap-add-documentation.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Seth Jennings <sjenning@linux.vnet.ibm.com>
Subject: zswap: add documentation

Add the documentation file for the zswap functionality

Signed-off-by: Seth Jennings <sjenning@linux.vnet.ibm.com>
Acked-by: Rik van Riel <riel@redhat.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Nitin Gupta <ngupta@vflare.org>
Cc: Minchan Kim <minchan@kernel.org>
Cc: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Cc: Dan Magenheimer <dan.magenheimer@oracle.com>
Cc: Robert Jennings <rcj@linux.vnet.ibm.com>
Cc: Jenifer Hopper <jhopper@us.ibm.com>
Cc: Mel Gorman <mgorman@suse.de>
Cc: Johannes Weiner <jweiner@redhat.com>
Cc: Larry Woodman <lwoodman@redhat.com>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: Dave Hansen <dave@sr71.net>
Cc: Joe Perches <joe@perches.com>
Cc: Joonsoo Kim <iamjoonsoo.kim@lge.com>
Cc: Cody P Schafer <cody@linux.vnet.ibm.com>
Cc: Hugh Dickens <hughd@google.com>
Cc: Paul Mackerras <paulus@samba.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/vm/zswap.txt |   68 +++++++++++++++++++++++++++++++++++
 1 file changed, 68 insertions(+)

diff -puN /dev/null Documentation/vm/zswap.txt
--- /dev/null
+++ a/Documentation/vm/zswap.txt
@@ -0,0 +1,68 @@
+Overview:
+
+Zswap is a lightweight compressed cache for swap pages. It takes pages that are
+in the process of being swapped out and attempts to compress them into a
+dynamically allocated RAM-based memory pool.  zswap basically trades CPU cycles
+for potentially reduced swap I/O.  This trade-off can also result in a
+significant performance improvement if reads from the compressed cache are
+faster than reads from a swap device.
+
+NOTE: Zswap is a new feature as of v3.11 and interacts heavily with memory
+reclaim.  This interaction has not be fully explored on the large set of
+potential configurations and workloads that exist.  For this reason, zswap
+is a work in progress and should be considered experimental.
+
+Some potential benefits:
+* Desktop/laptop users with limited RAM capacities can mitigate the
+    performance impact of swapping.
+* Overcommitted guests that share a common I/O resource can
+    dramatically reduce their swap I/O pressure, avoiding heavy handed I/O
+    throttling by the hypervisor. This allows more work to get done with less
+    impact to the guest workload and guests sharing the I/O subsystem
+* Users with SSDs as swap devices can extend the life of the device by
+    drastically reducing life-shortening writes.
+
+Zswap evicts pages from compressed cache on an LRU basis to the backing swap
+device when the compressed pool reaches it size limit.  This requirement had
+been identified in prior community discussions.
+
+To enabled zswap, the "enabled" attribute must be set to 1 at boot time.  e.g.
+zswap.enabled=1
+
+Design:
+
+Zswap receives pages for compression through the Frontswap API and is able to
+evict pages from its own compressed pool on an LRU basis and write them back to
+the backing swap device in the case that the compressed pool is full.
+
+Zswap makes use of zbud for the managing the compressed memory pool.  Each
+allocation in zbud is not directly accessible by address.  Rather, a handle is
+return by the allocation routine and that handle must be mapped before being
+accessed.  The compressed memory pool grows on demand and shrinks as compressed
+pages are freed.  The pool is not preallocated.
+
+When a swap page is passed from frontswap to zswap, zswap maintains a mapping
+of the swap entry, a combination of the swap type and swap offset, to the zbud
+handle that references that compressed swap page.  This mapping is achieved
+with a red-black tree per swap type.  The swap offset is the search key for the
+tree nodes.
+
+During a page fault on a PTE that is a swap entry, frontswap calls the zswap
+load function to decompress the page into the page allocated by the page fault
+handler.
+
+Once there are no PTEs referencing a swap page stored in zswap (i.e. the count
+in the swap_map goes to 0) the swap code calls the zswap invalidate function,
+via frontswap, to free the compressed entry.
+
+Zswap seeks to be simple in its policies.  Sysfs attributes allow for one user
+controlled policies:
+* max_pool_percent - The maximum percentage of memory that the compressed
+    pool can occupy.
+
+Zswap allows the compressor to be selected at kernel boot time by setting the
+“compressor” attribute.  The default compressor is lzo.  e.g.
+zswap.compressor=deflate
+
+A debugfs interface is provided for various statistic about pool size, number
+of pages stored, and various counters for the reasons pages are rejected.
_

Patches currently in -mm which might be from sjenning@linux.vnet.ibm.com are

origin.patch

