From: akpm@linux-foundation.org
Subject: + memory-hotplug-document-and-enable-config_movable_node.patch added to -mm tree
Date: Fri, 14 Dec 2012 16:34:11 -0800
Message-ID: <20121215003413.1AFC0200057@hpza10.eem.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-wi0-f202.google.com ([209.85.212.202]:45271 "EHLO
	mail-wi0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756820Ab2LOAeP (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 14 Dec 2012 19:34:15 -0500
Received: by mail-wi0-f202.google.com with SMTP id hn17so71824wib.1
        for <mm-commits@vger.kernel.org>; Fri, 14 Dec 2012 16:34:14 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: tangchen@cn.fujitsu.com, isimatu.yasuaki@jp.fujitsu.com, laijs@cn.fujitsu.com, mingo@elte.hu, wency@cn.fujitsu.com


The patch titled
     Subject: memory-hotplug: document and enable CONFIG_MOVABLE_NODE
has been added to the -mm tree.  Its filename is
     memory-hotplug-document-and-enable-config_movable_node.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/Kconfig |   12 +++++++++++-
 1 file changed, 11 insertions(+), 1 deletion(-)

diff -puN mm/Kconfig~memory-hotplug-document-and-enable-config_movable_node mm/Kconfig
--- a/mm/Kconfig~memory-hotplug-document-and-enable-config_movable_node
+++ a/mm/Kconfig
@@ -149,7 +149,17 @@ config MOVABLE_NODE
 	depends on NO_BOOTMEM
 	depends on X86_64
 	depends on NUMA
-	depends on BROKEN
+	default n
+	help
+	  Allow a node to have only movable memory. Pages used by kernel, such
+	  as direct mapping pages can not be migrated. So the corresponding
+	  memory device can not be hotpluged. This option allows users to
+	  online all the memory of a node as movable memory so that the whole
+	  node can be hotpluged. Users who don't use hotplug feature are fine
+	  with this option on since they don't online memory as movable.
+
+	  Say Y here if you want to hotplug a whole node.
+	  Say N here if you want kernel to use memory on all nodes evenly.
 
 # eventually, we can have this option just 'select SPARSEMEM'
 config MEMORY_HOTPLUG
_

Patches currently in -mm which might be from tangchen@cn.fujitsu.com are

origin.patch
memory-hotplug-document-and-enable-config_movable_node.patch
memory-hotplug-document-and-enable-config_movable_node-fix.patch

