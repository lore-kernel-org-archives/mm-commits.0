From: akpm@linux-foundation.org
Subject: + mm-update-the-document-of-numa_zonelist_order.patch added to
 -mm tree
Date: Mon, 25 Apr 2016 17:00:31 -0700
Message-ID: <571eaf9f.1r7ofOZKHp7CXB9/%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:58470 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751095AbcDZAAc (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 25 Apr 2016 20:00:32 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: qiuxishi@huawei.com, hannes@cmpxchg.org, kamezawa.hiroyu@jp.fujitsu.com, mgorman@suse.de, riel@redhat.com, rientjes@google.com, mm-commits@vger.kernel.org


The patch titled
     Subject: Documentation/sysctl/vm.txt: update numa_zonelist_order description
has been added to the -mm tree.  Its filename is
     mm-update-the-document-of-numa_zonelist_order.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-update-the-document-of-numa_zonelist_order.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-update-the-document-of-numa_zonelist_order.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Xishi Qiu <qiuxishi@huawei.com>
Subject: Documentation/sysctl/vm.txt: update numa_zonelist_order description

3193913ce62c ("mm: page_alloc: default node-ordering on 64-bit NUMA,
zone-ordering on 32-bit") changes the default value of
numa_zonelist_order.  Update the document.

Signed-off-by: Xishi Qiu <qiuxishi@huawei.com>
Cc: Mel Gorman <mgorman@suse.de>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: "Rik van Riel" <riel@redhat.com>
Cc: David Rientjes <rientjes@google.com>
Cc: "Kamezawa Hiroyuki" <kamezawa.hiroyu@jp.fujitsu.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/sysctl/vm.txt |   17 +++++++++--------
 1 file changed, 9 insertions(+), 8 deletions(-)

diff -puN Documentation/sysctl/vm.txt~mm-update-the-document-of-numa_zonelist_order Documentation/sysctl/vm.txt
--- a/Documentation/sysctl/vm.txt~mm-update-the-document-of-numa_zonelist_order
+++ a/Documentation/sysctl/vm.txt
@@ -581,15 +581,16 @@ Specify "[Nn]ode" for node order
 "Zone Order" orders the zonelists by zone type, then by node within each
 zone.  Specify "[Zz]one" for zone order.
 
-Specify "[Dd]efault" to request automatic configuration.  Autoconfiguration
-will select "node" order in following case.
-(1) if the DMA zone does not exist or
-(2) if the DMA zone comprises greater than 50% of the available memory or
-(3) if any node's DMA zone comprises greater than 70% of its local memory and
-    the amount of local memory is big enough.
+Specify "[Dd]efault" to request automatic configuration.
 
-Otherwise, "zone" order will be selected. Default order is recommended unless
-this is causing problems for your system/application.
+On 32-bit, the Normal zone needs to be preserved for allocations accessible
+by the kernel, so "zone" order will be selected.
+
+On 64-bit, devices that require DMA32/DMA are relatively rare, so "node"
+order will be selected.
+
+Default order is recommended unless this is causing problems for your
+system/application.
 
 ==============================================================
 
_

Patches currently in -mm which might be from qiuxishi@huawei.com are

mm-update-the-document-of-numa_zonelist_order.patch

