From: akpm@linux-foundation.org
Subject: +
 memory_hotplug-introduce-config_memory_hotplug_default_online.patch added
 to -mm tree
Date: Wed, 06 Apr 2016 11:54:42 -0700
Message-ID: <57055b72.VCNOXooDOGBWqYmU%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:41097 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751992AbcDFSyo (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 6 Apr 2016 14:54:44 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: vkuznets@redhat.com, corbet@lwn.net, dan.j.williams@intel.com, david.vrabel@citrix.com, imammedo@redhat.com, kirill.shutemov@linux.intel.com, lennart@poettering.net, mgorman@suse.de, rientjes@google.com, mm-commits@vger.kernel.org


The patch titled
     Subject: memory_hotplug: introduce CONFIG_MEMORY_HOTPLUG_DEFAULT_ONLINE
has been added to the -mm tree.  Its filename is
     memory_hotplug-introduce-config_memory_hotplug_default_online.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/memory_hotplug-introduce-config_memory_hotplug_default_online.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/memory_hotplug-introduce-config_memory_hotplug_default_online.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Vitaly Kuznetsov <vkuznets@redhat.com>
Subject: memory_hotplug: introduce CONFIG_MEMORY_HOTPLUG_DEFAULT_ONLINE

This patchset continues the work I started with 31bc3858ea3eb
("memory-hotplug: add automatic onlining policy for the newly added
memory").

Initially I was going to stop there and bring the policy setting logic to
userspace. I met two issues on this way:

1) It is possible to have memory hotplugged at boot (e.g. with QEMU). These
   blocks stay offlined if we turn the onlining policy on by userspace.

2) My attempt to bring this policy setting to systemd failed, systemd
   maintainers suggest to change the default in kernel or ... to use tmpfiles.d
   to alter the policy (which looks like a hack to me): 
   https://github.com/systemd/systemd/pull/2938

Here I suggest to add a config option to set the default value for the
policy and a kernel command line parameter to make the override.


This patch (of 2):

Introduce config option to set the default value for memory hotplug
onlining policy (/sys/devices/system/memory/auto_online_blocks). The
reason one would want to turn this option on are to have early onlining
for hotpluggable memory available at boot and to not require any userspace
actions to make memory hotplug work.

Signed-off-by: Vitaly Kuznetsov <vkuznets@redhat.com>
Cc: Jonathan Corbet <corbet@lwn.net>
Cc: Dan Williams <dan.j.williams@intel.com>
Cc: "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>
Cc: Mel Gorman <mgorman@suse.de>
Cc: David Vrabel <david.vrabel@citrix.com>
Cc: David Rientjes <rientjes@google.com>
Cc: Igor Mammedov <imammedo@redhat.com>
Cc: Lennart Poettering <lennart@poettering.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/memory-hotplug.txt |    9 +++++----
 mm/Kconfig                       |   16 ++++++++++++++++
 mm/memory_hotplug.c              |    4 ++++
 3 files changed, 25 insertions(+), 4 deletions(-)

diff -puN Documentation/memory-hotplug.txt~memory_hotplug-introduce-config_memory_hotplug_default_online Documentation/memory-hotplug.txt
--- a/Documentation/memory-hotplug.txt~memory_hotplug-introduce-config_memory_hotplug_default_online
+++ a/Documentation/memory-hotplug.txt
@@ -261,10 +261,11 @@ it according to the policy which can be
 
 % cat /sys/devices/system/memory/auto_online_blocks
 
-The default is "offline" which means the newly added memory is not in a
-ready-to-use state and you have to "online" the newly added memory blocks
-manually. Automatic onlining can be requested by writing "online" to
-"auto_online_blocks" file:
+The default depends on the CONFIG_MEMORY_HOTPLUG_DEFAULT_ONLINE kernel config
+option. If it is disabled the default is "offline" which means the newly added
+memory is not in a ready-to-use state and you have to "online" the newly added
+memory blocks manually. Automatic onlining can be requested by writing "online"
+to "auto_online_blocks" file:
 
 % echo online > /sys/devices/system/memory/auto_online_blocks
 
diff -puN mm/Kconfig~memory_hotplug-introduce-config_memory_hotplug_default_online mm/Kconfig
--- a/mm/Kconfig~memory_hotplug-introduce-config_memory_hotplug_default_online
+++ a/mm/Kconfig
@@ -192,6 +192,22 @@ config MEMORY_HOTPLUG_SPARSE
 	def_bool y
 	depends on SPARSEMEM && MEMORY_HOTPLUG
 
+config MEMORY_HOTPLUG_DEFAULT_ONLINE
+        bool "Online the newly added memory blocks by default"
+        default n
+        depends on MEMORY_HOTPLUG
+        help
+	  This option changes the default policy setting for memory hotplug
+	  onlining policy (/sys/devices/system/memory/auto_online_blocks) which
+	  determines what happens to the newly added memory regions. Policy
+	  setting can always be changed in runtime.
+	  See Documentation/memory-hotplug.txt for more information.
+
+	  Say Y here if you want all hot-plugged memory blocks to appear in
+	  'online' state by default.
+	  Say N here if you want the default policy to keep all hot-plugged
+	  memory blocks in 'offline' state.
+
 config MEMORY_HOTREMOVE
 	bool "Allow for memory hot remove"
 	select MEMORY_ISOLATION
diff -puN mm/memory_hotplug.c~memory_hotplug-introduce-config_memory_hotplug_default_online mm/memory_hotplug.c
--- a/mm/memory_hotplug.c~memory_hotplug-introduce-config_memory_hotplug_default_online
+++ a/mm/memory_hotplug.c
@@ -78,7 +78,11 @@ static struct {
 #define memhp_lock_acquire()      lock_map_acquire(&mem_hotplug.dep_map)
 #define memhp_lock_release()      lock_map_release(&mem_hotplug.dep_map)
 
+#ifndef CONFIG_MEMORY_HOTPLUG_DEFAULT_ONLINE
 bool memhp_auto_online;
+#else
+bool memhp_auto_online = true;
+#endif
 EXPORT_SYMBOL_GPL(memhp_auto_online);
 
 void get_online_mems(void)
_

Patches currently in -mm which might be from vkuznets@redhat.com are

memory_hotplug-introduce-config_memory_hotplug_default_online.patch
memory_hotplug-introduce-memhp_default_state=-command-line-parameter.patch

