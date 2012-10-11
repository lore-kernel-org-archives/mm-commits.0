From: akpm@linux-foundation.org
Subject: + memory-hotplug-suppress-device-nodex-does-not-have-a-release-function-warning.patch added to -mm tree
Date: Thu, 11 Oct 2012 14:12:22 -0700
Message-ID: <20121011211223.C59A65C0050@hpza9.eem.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-bk0-f74.google.com ([209.85.214.74]:42250 "EHLO
	mail-bk0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754856Ab2JKVM1 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 11 Oct 2012 17:12:27 -0400
Received: by mail-bk0-f74.google.com with SMTP id q16so141127bkw.1
        for <mm-commits@vger.kernel.org>; Thu, 11 Oct 2012 14:12:25 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: isimatu.yasuaki@jp.fujitsu.com, greg@kroah.com, kosaki.motohiro@jp.fujitsu.com, liuj97@gmail.com, minchan.kim@gmail.com, rientjes@google.com, wency@cn.fujitsu.com


The patch titled
     Subject: memory hotplug: suppress "Device nodeX does not have a release() function" warning
has been added to the -mm tree.  Its filename is
     memory-hotplug-suppress-device-nodex-does-not-have-a-release-function-warning.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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
Cc: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
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

origin.patch
acpi_memhotplugc-fix-memory-leak-when-memory-device-is-unbound-from-the-module-acpi_memhotplug.patch
acpi_memhotplugc-free-memory-device-if-acpi_memory_enable_device-failed.patch
acpi_memhotplugc-remove-memory-info-from-list-before-freeing-it.patch
acpi_memhotplugc-dont-allow-to-eject-the-memory-device-if-it-is-being-used.patch
acpi_memhotplugc-bind-the-memory-device-when-the-driver-is-being-loaded.patch
acpi_memhotplugc-auto-bind-the-memory-device-which-is-hotplugged-before-the-driver-is-loaded.patch
memory-hotplug-suppress-device-memoryx-does-not-have-a-release-function-warning.patch
memory-hotplug-suppress-device-nodex-does-not-have-a-release-function-warning.patch

