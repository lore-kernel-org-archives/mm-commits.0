From: akpm@linux-foundation.org
Subject: [merged] memory-hotplug-suppress-device-memoryx-does-not-have-a-release-function-warning.patch removed from -mm tree
Date: Wed, 12 Dec 2012 11:57:20 -0800
Message-ID: <20121212195720.E3C7B100047@wpzn3.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-gg0-f202.google.com ([209.85.161.202]:59153 "EHLO
	mail-gg0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754645Ab2LLT5W (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 12 Dec 2012 14:57:22 -0500
Received: by mail-gg0-f202.google.com with SMTP id k1so117716ggn.1
        for <mm-commits@vger.kernel.org>; Wed, 12 Dec 2012 11:57:21 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: isimatu.yasuaki@jp.fujitsu.com, greg@kroah.com, kosaki.motohiro@jp.fujitsu.com, liuj97@gmail.com, minchan.kim@gmail.com, rientjes@google.com, wency@cn.fujitsu.com, mm-commits@vger.kernel.org


The patch titled
     Subject: memory hotplug: suppress "Device memoryX does not have a release() function" warning
has been removed from the -mm tree.  Its filename was
     memory-hotplug-suppress-device-memoryx-does-not-have-a-release-function-warning.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Yasuaki Ishimatsu <isimatu.yasuaki@jp.fujitsu.com>
Subject: memory hotplug: suppress "Device memoryX does not have a release() function" warning

When calling remove_memory_block(), the function shows following message
at device_release().

"Device 'memory528' does not have a release() function, it is broken and
must be fixed."

The reason is memory_block's device struct does not have a release()
function.

So the patch registers memory_block_release() to the device's release()
function for suppressing the warning message.  Additionally, the patch
moves kfree(mem) into the release function since the release function is
prepared as a means to free a memory_block struct.

Signed-off-by: Yasuaki Ishimatsu <isimatu.yasuaki@jp.fujitsu.com>
Acked-by: David Rientjes <rientjes@google.com>
Cc: Jiang Liu <liuj97@gmail.com>
Cc: Minchan Kim <minchan.kim@gmail.com>
Acked-by: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Cc: Wen Congyang <wency@cn.fujitsu.com>
Cc: Greg KH <greg@kroah.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/base/memory.c |    9 ++++++++-
 1 file changed, 8 insertions(+), 1 deletion(-)

diff -puN drivers/base/memory.c~memory-hotplug-suppress-device-memoryx-does-not-have-a-release-function-warning drivers/base/memory.c
--- a/drivers/base/memory.c~memory-hotplug-suppress-device-memoryx-does-not-have-a-release-function-warning
+++ a/drivers/base/memory.c
@@ -70,6 +70,13 @@ void unregister_memory_isolate_notifier(
 }
 EXPORT_SYMBOL(unregister_memory_isolate_notifier);
 
+static void memory_block_release(struct device *dev)
+{
+	struct memory_block *mem = container_of(dev, struct memory_block, dev);
+
+	kfree(mem);
+}
+
 /*
  * register_memory - Setup a sysfs device for a memory block
  */
@@ -80,6 +87,7 @@ int register_memory(struct memory_block 
 
 	memory->dev.bus = &memory_subsys;
 	memory->dev.id = memory->start_section_nr / sections_per_block;
+	memory->dev.release = memory_block_release;
 
 	error = device_register(&memory->dev);
 	return error;
@@ -635,7 +643,6 @@ int remove_memory_block(unsigned long no
 		mem_remove_simple_file(mem, phys_device);
 		mem_remove_simple_file(mem, removable);
 		unregister_memory(mem);
-		kfree(mem);
 	} else
 		kobject_put(&mem->dev.kobj);
 
_

Patches currently in -mm which might be from isimatu.yasuaki@jp.fujitsu.com are

origin.patch
numa-add-config_movable_node-for-movable-dedicated-node.patch
numa-add-config_movable_node-for-movable-dedicated-node-fix.patch
memory_hotplug-allow-online-offline-memory-to-result-movable-node.patch
linux-next.patch
x86-fix-the-argument-passed-to-sync_global_pgds.patch
x86-make-mem=-option-to-work-for-efi-platform.patch

