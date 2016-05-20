From: akpm@linux-foundation.org
Subject: [merged]
 memory_hotplug-introduce-memhp_default_state=-command-line-parameter.patch
 removed from -mm tree
Date: Fri, 20 May 2016 14:05:56 -0700
Message-ID: <573f7c34.KHXve63kmQ2wW/NZ%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:47261 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751172AbcETVF5 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 20 May 2016 17:05:57 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: vkuznets@redhat.com, corbet@lwn.net, dan.j.williams@intel.com, david.vrabel@citrix.com, imammedo@redhat.com, kirill.shutemov@linux.intel.com, lennart@poettering.net, mgorman@techsingularity.net, rientjes@google.com, mm-commits@vger.kernel.org


The patch titled
     Subject: memory_hotplug: introduce memhp_default_state= command line parameter
has been removed from the -mm tree.  Its filename was
     memory_hotplug-introduce-memhp_default_state=-command-line-parameter.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Vitaly Kuznetsov <vkuznets@redhat.com>
Subject: memory_hotplug: introduce memhp_default_state= command line parameter

CONFIG_MEMORY_HOTPLUG_DEFAULT_ONLINE specifies the default value for the
memory hotplug onlining policy.  Add a command line parameter to make it
possible to override the default.  It may come handy for debug and testing
purposes.

Signed-off-by: Vitaly Kuznetsov <vkuznets@redhat.com>
Cc: Jonathan Corbet <corbet@lwn.net>
Cc: Dan Williams <dan.j.williams@intel.com>
Cc: "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>
Cc: Mel Gorman <mgorman@techsingularity.net>
Cc: David Vrabel <david.vrabel@citrix.com>
Cc: David Rientjes <rientjes@google.com>
Cc: Igor Mammedov <imammedo@redhat.com>
Cc: Lennart Poettering <lennart@poettering.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/kernel-parameters.txt |    8 ++++++++
 mm/memory_hotplug.c                 |   11 +++++++++++
 2 files changed, 19 insertions(+)

diff -puN Documentation/kernel-parameters.txt~memory_hotplug-introduce-memhp_default_state=-command-line-parameter Documentation/kernel-parameters.txt
--- a/Documentation/kernel-parameters.txt~memory_hotplug-introduce-memhp_default_state=-command-line-parameter
+++ a/Documentation/kernel-parameters.txt
@@ -2161,6 +2161,14 @@ bytes respectively. Such letter suffixes
 			[KNL,SH] Allow user to override the default size for
 			per-device physically contiguous DMA buffers.
 
+        memhp_default_state=online/offline
+			[KNL] Set the initial state for the memory hotplug
+			onlining policy. If not specified, the default value is
+			set according to the
+			CONFIG_MEMORY_HOTPLUG_DEFAULT_ONLINE kernel config
+			option.
+			See Documentation/memory-hotplug.txt.
+
 	memmap=exactmap	[KNL,X86] Enable setting of an exact
 			E820 memory map, as specified by the user.
 			Such memmap=exactmap lines can be constructed based on
diff -puN mm/memory_hotplug.c~memory_hotplug-introduce-memhp_default_state=-command-line-parameter mm/memory_hotplug.c
--- a/mm/memory_hotplug.c~memory_hotplug-introduce-memhp_default_state=-command-line-parameter
+++ a/mm/memory_hotplug.c
@@ -85,6 +85,17 @@ bool memhp_auto_online = true;
 #endif
 EXPORT_SYMBOL_GPL(memhp_auto_online);
 
+static int __init setup_memhp_default_state(char *str)
+{
+	if (!strcmp(str, "online"))
+		memhp_auto_online = true;
+	else if (!strcmp(str, "offline"))
+		memhp_auto_online = false;
+
+	return 1;
+}
+__setup("memhp_default_state=", setup_memhp_default_state);
+
 void get_online_mems(void)
 {
 	might_sleep();
_

Patches currently in -mm which might be from vkuznets@redhat.com are


