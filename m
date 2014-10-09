From: akpm@linux-foundation.org
Subject: [merged]
 driver-base-node-remove-unnecessary-kfree-of-node-struct-from-unregister_one_node.patch removed from -mm tree
Date: Thu, 09 Oct 2014 11:22:00 -0700
Message-ID: <5436d248.NUEp8mlBCpgKuGj3%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:34046 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751462AbaJISWA (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 9 Oct 2014 14:22:00 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: isimatu.yasuaki@jp.fujitsu.com, akpm@linux-foundation.org, gregkh@linuxfoundation.org, qiuxishi@huawei.com, stable@vger.kernel.org, mm-commits@vger.kernel.org


The patch titled
     Subject: driver/base/node,c: remove unnecessary kfree of node struct from unregister_one_node
has been removed from the -mm tree.  Its filename was
     driver-base-node-remove-unnecessary-kfree-of-node-struct-from-unregister_one_node.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Yasuaki Ishimatsu <isimatu.yasuaki@jp.fujitsu.com>
Subject: driver/base/node,c: remove unnecessary kfree of node struct from unregister_one_node

Commit 92d585ef067d ("numa: fix NULL pointer access and memory leak in
unregister_one_node()") added kfree() of node struct in
unregister_one_node().  But node struct is freed by node_device_release()
which is called in unregister_node().  So by adding the kfree(), node
struct is freed two times.

While hot removing memory, the commit leads the following BUG_ON():

  kernel BUG at mm/slub.c:3346!
  invalid opcode: 0000 [#1] SMP
  [...]
  Call Trace:
   [...] unregister_one_node
   [...] try_offline_node
   [...] remove_memory
   [...] acpi_memory_device_remove
   [...] acpi_bus_trim
   [...] acpi_bus_trim
   [...] acpi_device_hotplug
   [...] acpi_hotplug_work_fn
   [...] process_one_work
   [...] worker_thread
   [...] ? rescuer_thread
   [...] kthread
   [...] ? kthread_create_on_node
   [...] ret_from_fork
   [...] ? kthread_create_on_node

This patch removes unnecessary kfree() from unregister_one_node().

Fixes: 92d585ef067d "numa: fix NULL pointer access and memory leak in unregister_one_node()"
Signed-off-by: Yasuaki Ishimatsu <isimatu.yasuaki@jp.fujitsu.com>
Cc: Xishi Qiu <qiuxishi@huawei.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: <stable@vger.kernel.org>	[3.16+]
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/base/node.c |    1 -
 1 file changed, 1 deletion(-)

diff -puN drivers/base/node.c~driver-base-node-remove-unnecessary-kfree-of-node-struct-from-unregister_one_node drivers/base/node.c
--- a/drivers/base/node.c~driver-base-node-remove-unnecessary-kfree-of-node-struct-from-unregister_one_node
+++ a/drivers/base/node.c
@@ -600,7 +600,6 @@ void unregister_one_node(int nid)
 		return;
 
 	unregister_node(node_devices[nid]);
-	kfree(node_devices[nid]);
 	node_devices[nid] = NULL;
 }
 
_

Patches currently in -mm which might be from isimatu.yasuaki@jp.fujitsu.com are

origin.patch
memory-hotplug-add-sysfs-zones_online_to-attribute.patch
memory-hotplug-add-sysfs-zones_online_to-attribute-fix-3.patch
memory-hotplug-add-sysfs-zones_online_to-attribute-fix-4.patch
driver-firmware-memmap-dont-create-memmap-sysfs-of-same-firmware_map_entry.patch
linux-next.patch

