From: akpm@linux-foundation.org
Subject: [to-be-updated] memory-hotplug-suppress-device-nodex-does-not-have-a-release-function-warning.patch removed from -mm tree
Date: Wed, 31 Oct 2012 15:21:32 -0700
Message-ID: <20121031222133.6907D5C0050@hpza9.eem.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-wg0-f74.google.com ([74.125.82.74]:46271 "EHLO
	mail-wg0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755502Ab2JaWVg (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 31 Oct 2012 18:21:36 -0400
Received: by mail-wg0-f74.google.com with SMTP id dt11so123192wgb.1
        for <mm-commits@vger.kernel.org>; Wed, 31 Oct 2012 15:21:35 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: isimatu.yasuaki@jp.fujitsu.com, greg@kroah.com, kosaki.motohiro@jp.fujitsu.com, liuj97@gmail.com, minchan.kim@gmail.com, rientjes@google.com, wency@cn.fujitsu.com, mm-commits@vger.kernel.org


The patch titled
     Subject: memory hotplug: suppress "Device nodeX does not have a release() function" warning
has been removed from the -mm tree.  Its filename was
     memory-hotplug-suppress-device-nodex-does-not-have-a-release-function-warning.patch

This patch was dropped because an updated version will be merged

------------------------------------------------------
From: Yasuaki Ishimatsu <isimatu.yasuaki@jp.fujitsu.com>
Subject: memory hotplug: suppress "Device nodeX does not have a release() function" warning

When calling unregister_node(), the function shows following message at
device_release().

"Device 'node2' does not have a release() function, it is broken and must
be fixed."

The reason is node's device struct does not have a release() function.

So the patch registers node_device_release() to the device's release()
function for suppressing the warning message.  Additionally, the patch
adds memset() to initialize a node struct into register_node().  Because
the node struct is part of node_devices[] array and it cannot be freed by
node_device_release().  So if system reuses the node struct, it has a
garbage.

Signed-off-by: Yasuaki Ishimatsu <isimatu.yasuaki@jp.fujitsu.com>
Signed-off-by: Wen Congyang <wency@cn.fujitsu.com>
Acked-by: David Rientjes <rientjes@google.com>
Cc: Jiang Liu <liuj97@gmail.com>
Cc: Minchan Kim <minchan.kim@gmail.com>
Acked-by: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Cc: Greg KH <greg@kroah.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/base/node.c |   11 +++++++++++
 1 file changed, 11 insertions(+)

diff -puN drivers/base/node.c~memory-hotplug-suppress-device-nodex-does-not-have-a-release-function-warning drivers/base/node.c
--- a/drivers/base/node.c~memory-hotplug-suppress-device-nodex-does-not-have-a-release-function-warning
+++ a/drivers/base/node.c
@@ -252,6 +252,14 @@ static inline void hugetlb_register_node
 static inline void hugetlb_unregister_node(struct node *node) {}
 #endif
 
+static void node_device_release(struct device *dev)
+{
+#if defined(CONFIG_MEMORY_HOTPLUG_SPARSE) && defined(CONFIG_HUGETLBFS)
+	struct node *node_dev = to_node(dev);
+
+	flush_work(&node_dev->node_work);
+#endif
+}
 
 /*
  * register_node - Setup a sysfs device for a node.
@@ -263,8 +271,11 @@ int register_node(struct node *node, int
 {
 	int error;
 
+	memset(node, 0, sizeof(*node));
+
 	node->dev.id = num;
 	node->dev.bus = &node_subsys;
+	node->dev.release = node_device_release;
 	error = device_register(&node->dev);
 
 	if (!error){
_

Patches currently in -mm which might be from isimatu.yasuaki@jp.fujitsu.com are

linux-next.patch
acpi_memhotplugc-fix-memory-leak-when-memory-device-is-unbound-from-the-module-acpi_memhotplug.patch
acpi_memhotplugc-free-memory-device-if-acpi_memory_enable_device-failed.patch
acpi_memhotplugc-remove-memory-info-from-list-before-freeing-it.patch
acpi_memhotplugc-dont-allow-to-eject-the-memory-device-if-it-is-being-used.patch
acpi_memhotplugc-bind-the-memory-device-when-the-driver-is-being-loaded.patch
acpi_memhotplugc-auto-bind-the-memory-device-which-is-hotplugged-before-the-driver-is-loaded.patch
memory-hotplug-suppress-device-memoryx-does-not-have-a-release-function-warning.patch
memory-hotplug-skip-hwpoisoned-page-when-offlining-pages.patch
memory-hotplug-update-mce_bad_pages-when-removing-the-memory.patch
memory-hotplug-update-mce_bad_pages-when-removing-the-memory-fix.patch
memory-hotplug-auto-offline-page_cgroup-when-onlining-memory-block-failed.patch
memory-hotplug-fix-nr_free_pages-mismatch.patch
memory-hotplug-allocate-zones-pcp-before-onlining-pages.patch
memory-hotplug-allocate-zones-pcp-before-onlining-pages-fix-2.patch
memory_hotplug-fix-possible-incorrect-node_states.patch
slub-hotplug-ignore-unrelated-nodes-hot-adding-and-hot-removing.patch

