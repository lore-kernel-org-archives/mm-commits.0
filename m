From: akpm@linux-foundation.org
Subject: [merged] memory-hotplug-document-and-enable-config_movable_node.patch removed from -mm tree
Date: Wed, 19 Dec 2012 12:39:50 -0800
Message-ID: <20121219203951.177E920004E@hpza10.eem.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-la0-f73.google.com ([209.85.215.73]:33277 "EHLO
	mail-la0-f73.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753435Ab2LSUjy (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 19 Dec 2012 15:39:54 -0500
Received: by mail-la0-f73.google.com with SMTP id d3so121267lah.2
        for <mm-commits@vger.kernel.org>; Wed, 19 Dec 2012 12:39:52 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: tangchen@cn.fujitsu.com, isimatu.yasuaki@jp.fujitsu.com, laijs@cn.fujitsu.com, mingo@elte.hu, wency@cn.fujitsu.com, mm-commits@vger.kernel.org


The patch titled
     Subject: memory-hotplug: document and enable CONFIG_MOVABLE_NODE
has been removed from the -mm tree.  Its filename was
     memory-hotplug-document-and-enable-config_movable_node.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Tang Chen <tangchen@cn.fujitsu.com>
Subject: memory-hotplug: document and enable CONFIG_MOVABLE_NODE

Add help info for CONFIG_MOVABLE_NODE and permit its selection.

This option allows the user to online all memory of a node as movable
memory.  So that the whole node can be hotplugged.  Users who don't use
the hotplug feature are also fine with this option on since they won't
online memory as movable.

Signed-off-by: Tang Chen <tangchen@cn.fujitsu.com>
Reviewed-by: Yasuaki Ishimatsu <isimatu.yasuaki@jp.fujitsu.com>
Cc: Lai Jiangshan <laijs@cn.fujitsu.com>
Cc: Wen Congyang <wency@cn.fujitsu.com>
Cc: Ingo Molnar <mingo@elte.hu>
[akpm@linux-foundation.org: tweak help text]
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/Kconfig |   13 ++++++++++++-
 1 file changed, 12 insertions(+), 1 deletion(-)

diff -puN mm/Kconfig~memory-hotplug-document-and-enable-config_movable_node mm/Kconfig
--- a/mm/Kconfig~memory-hotplug-document-and-enable-config_movable_node
+++ a/mm/Kconfig
@@ -149,7 +149,18 @@ config MOVABLE_NODE
 	depends on NO_BOOTMEM
 	depends on X86_64
 	depends on NUMA
-	depends on BROKEN
+	default n
+	help
+	  Allow a node to have only movable memory.  Pages used by the kernel,
+	  such as direct mapping pages cannot be migrated.  So the corresponding
+	  memory device cannot be hotplugged.  This option allows users to
+	  online all the memory of a node as movable memory so that the whole
+	  node can be hotplugged.  Users who don't use the memory hotplug
+	  feature are fine with this option on since they don't online memory
+	  as movable.
+
+	  Say Y here if you want to hotplug a whole node.
+	  Say N here if you want kernel to use memory on all nodes evenly.
 
 # eventually, we can have this option just 'select SPARSEMEM'
 config MEMORY_HOTPLUG
_

Patches currently in -mm which might be from tangchen@cn.fujitsu.com are

origin.patch

