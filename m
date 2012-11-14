From: akpm@linux-foundation.org
Subject: + drivers-base-nodec-cleanup-node_state_attr.patch added to -mm tree
Date: Wed, 14 Nov 2012 11:31:39 -0800
Message-ID: <20121114193141.B0EA45C0060@hpza9.eem.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-ea0-f202.google.com ([209.85.215.202]:33643 "EHLO
	mail-ea0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1423372Ab2KNTbo (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 14 Nov 2012 14:31:44 -0500
Received: by mail-ea0-f202.google.com with SMTP id f11so60777eaa.1
        for <mm-commits@vger.kernel.org>; Wed, 14 Nov 2012 11:31:42 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: laijs@cn.fujitsu.com, rientjes@google.com, wency@cn.fujitsu.com


The patch titled
     Subject: drivers/base/node.c: cleanup node_state_attr[]
has been added to the -mm tree.  Its filename is
     drivers-base-nodec-cleanup-node_state_attr.patch

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
Subject: drivers/base/node.c: cleanup node_state_attr[]

use [index] = init_value
use N_xxxxx instead of hardcode.

Make it more readability and easier to add new state.

Signed-off-by: Lai Jiangshan <laijs@cn.fujitsu.com>
Signed-off-by: Wen Congyang <wency@cn.fujitsu.com>
Acked-by: David Rientjes <rientjes@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/base/node.c |   20 ++++++++++----------
 1 file changed, 10 insertions(+), 10 deletions(-)

diff -puN drivers/base/node.c~drivers-base-nodec-cleanup-node_state_attr drivers/base/node.c
--- a/drivers/base/node.c~drivers-base-nodec-cleanup-node_state_attr
+++ a/drivers/base/node.c
@@ -638,23 +638,23 @@ static ssize_t show_node_state(struct de
 	{ __ATTR(name, 0444, show_node_state, NULL), state }
 
 static struct node_attr node_state_attr[] = {
-	_NODE_ATTR(possible, N_POSSIBLE),
-	_NODE_ATTR(online, N_ONLINE),
-	_NODE_ATTR(has_normal_memory, N_NORMAL_MEMORY),
-	_NODE_ATTR(has_cpu, N_CPU),
+	[N_POSSIBLE] = _NODE_ATTR(possible, N_POSSIBLE),
+	[N_ONLINE] = _NODE_ATTR(online, N_ONLINE),
+	[N_NORMAL_MEMORY] = _NODE_ATTR(has_normal_memory, N_NORMAL_MEMORY),
 #ifdef CONFIG_HIGHMEM
-	_NODE_ATTR(has_high_memory, N_HIGH_MEMORY),
+	[N_HIGH_MEMORY] = _NODE_ATTR(has_high_memory, N_HIGH_MEMORY),
 #endif
+	[N_CPU] = _NODE_ATTR(has_cpu, N_CPU),
 };
 
 static struct attribute *node_state_attrs[] = {
-	&node_state_attr[0].attr.attr,
-	&node_state_attr[1].attr.attr,
-	&node_state_attr[2].attr.attr,
-	&node_state_attr[3].attr.attr,
+	&node_state_attr[N_POSSIBLE].attr.attr,
+	&node_state_attr[N_ONLINE].attr.attr,
+	&node_state_attr[N_NORMAL_MEMORY].attr.attr,
 #ifdef CONFIG_HIGHMEM
-	&node_state_attr[4].attr.attr,
+	&node_state_attr[N_HIGH_MEMORY].attr.attr,
 #endif
+	&node_state_attr[N_CPU].attr.attr,
 	NULL
 };
 
_

Patches currently in -mm which might be from laijs@cn.fujitsu.com are

linux-next.patch
memory_hotplug-fix-possible-incorrect-node_states.patch
slub-hotplug-ignore-unrelated-nodes-hot-adding-and-hot-removing.patch
drivers-base-nodec-cleanup-node_state_attr.patch

