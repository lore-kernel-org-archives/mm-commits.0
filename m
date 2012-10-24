From: akpm@linux-foundation.org
Subject: + slub-hotplug-ignore-unrelated-nodes-hot-adding-and-hot-removing.patch added to -mm tree
Date: Wed, 24 Oct 2012 13:17:40 -0700
Message-ID: <20121024201741.31A505C0050@hpza9.eem.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-wg0-f74.google.com ([74.125.82.74]:59959 "EHLO
	mail-wg0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933789Ab2JXURp (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 24 Oct 2012 16:17:45 -0400
Received: by mail-wg0-f74.google.com with SMTP id dt11so60295wgb.1
        for <mm-commits@vger.kernel.org>; Wed, 24 Oct 2012 13:17:44 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: laijs@cn.fujitsu.com, akpm@linux-foundation.org, cl@linux.com, gregkh@suse.de, isimatu.yasuaki@jp.fujitsu.com, jiang.liu@huawei.com, kay.sievers@vrfy.org, kosaki.motohiro@jp.fujitsu.com, mgorman@suse.de, minchan.kim@gmail.com, penberg@kernel.org, rientjes@google.com, rob@landley.net, wency@cn.fujitsu.com


The patch titled
     Subject: slub, hotplug: ignore unrelated node's hot-adding and hot-removing
has been added to the -mm tree.  Its filename is
     slub-hotplug-ignore-unrelated-nodes-hot-adding-and-hot-removing.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Lai Jiangshan <laijs@cn.fujitsu.com>
Subject: slub, hotplug: ignore unrelated node's hot-adding and hot-removing

SLUB only focuses on the nodes which have normal memory and it ignores the
other node's hot-adding and hot-removing.

Aka: if some memory of a node which has no onlined memory is online, but
this new memory onlined is not normal memory (for example, highmem), we
should not allocate kmem_cache_node for SLUB.

And if the last normal memory is offlined, but the node still has memory,
we should remove kmem_cache_node for that node.  (The current code delays
it when all of the memory is offlined)

So we only do something when marg->status_change_nid_normal > 0. 
marg->status_change_nid is not suitable here.

The same problem doesn't exist in SLAB, because SLAB allocates kmem_list3
for every node even the node don't have normal memory, SLAB tolerates
kmem_list3 on alien nodes.  SLUB only focuses on the nodes which have
normal memory, it don't tolerate alien kmem_cache_node.  The patch makes
SLUB become self-compatible and avoids WARNs and BUGs in rare conditions.

Signed-off-by: Lai Jiangshan <laijs@cn.fujitsu.com>
Cc: David Rientjes <rientjes@google.com>
Cc: Minchan Kim <minchan.kim@gmail.com>
Cc: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Cc: Yasuaki Ishimatsu <isimatu.yasuaki@jp.fujitsu.com>
Cc: Rob Landley <rob@landley.net>
Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: Jiang Liu <jiang.liu@huawei.com>
Cc: Kay Sievers <kay.sievers@vrfy.org>
Cc: Greg Kroah-Hartman <gregkh@suse.de>
Cc: Mel Gorman <mgorman@suse.de>
Cc: Wen Congyang <wency@cn.fujitsu.com>
Acked-by: Christoph Lameter <cl@linux.com>
Cc: Pekka Enberg <penberg@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/slub.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff -puN mm/slub.c~slub-hotplug-ignore-unrelated-nodes-hot-adding-and-hot-removing mm/slub.c
--- a/mm/slub.c~slub-hotplug-ignore-unrelated-nodes-hot-adding-and-hot-removing
+++ a/mm/slub.c
@@ -3567,7 +3567,7 @@ static void slab_mem_offline_callback(vo
 	struct memory_notify *marg = arg;
 	int offline_node;
 
-	offline_node = marg->status_change_nid;
+	offline_node = marg->status_change_nid_normal;
 
 	/*
 	 * If the node still has available memory. we need kmem_cache_node
@@ -3600,7 +3600,7 @@ static int slab_mem_going_online_callbac
 	struct kmem_cache_node *n;
 	struct kmem_cache *s;
 	struct memory_notify *marg = arg;
-	int nid = marg->status_change_nid;
+	int nid = marg->status_change_nid_normal;
 	int ret = 0;
 
 	/*
_

Patches currently in -mm which might be from laijs@cn.fujitsu.com are

linux-next.patch
memory_hotplug-fix-possible-incorrect-node_states.patch
slub-hotplug-ignore-unrelated-nodes-hot-adding-and-hot-removing.patch

