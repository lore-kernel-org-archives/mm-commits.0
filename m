From: akpm@linux-foundation.org
Subject: [patch 090/124] memory-hotplug: use dev_online for
 memhp_auto_online
Date: Fri, 24 Feb 2017 15:00:02 -0800
Message-ID: <58b0baf2.+ogJtGKMQKgWlvxR%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:38884 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751558AbdBXXAE (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 24 Feb 2017 18:00:04 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: torvalds@linux-foundation.org, mm-commits@vger.kernel.org, akpm@linux-foundation.org, nfont@linux.vnet.ibm.com, mdroth@linux.vnet.ibm.com, mpe@ellerman.id.au

From: Nathan Fontenot <nfont@linux.vnet.ibm.com>
Subject: memory-hotplug: use dev_online for memhp_auto_online

Commit 31bc3858e "add automatic onlining policy for the newly added
memory" provides the capability to have added memory automatically onlined
during add, but this appears to be slightly broken.

The current implementation uses walk_memory_range() to call
online_memory_block, which uses memory_block_change_state() to online the
memory.  Instead, we should be calling device_online() for the memory
block in online_memory_block().  This would online the memory (the memory
bus online routine memory_subsys_online() called from device_online calls
memory_block_change_state()) and properly update the device struct offline
flag.

As a result of the current implementation, attempting to remove a memory
block after adding it using auto online fails.  This is because doing a
remove, for instance 'echo offline >
/sys/devices/system/memory/memoryXXX/state', uses device_offline() which
checks the dev->offline flag.

Link: http://lkml.kernel.org/r/20170222220744.8119.19687.stgit@ltcalpine2-lp14.aus.stglabs.ibm.com
Signed-off-by: Nathan Fontenot <nfont@linux.vnet.ibm.com>
Cc: Michael Ellerman <mpe@ellerman.id.au>
Cc: Michael Roth <mdroth@linux.vnet.ibm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/base/memory.c  |    2 +-
 include/linux/memory.h |    3 ---
 mm/memory_hotplug.c    |    2 +-
 3 files changed, 2 insertions(+), 5 deletions(-)

diff -puN drivers/base/memory.c~memory-hotplug-use-dev_online-for-memhp_auto_online drivers/base/memory.c
--- a/drivers/base/memory.c~memory-hotplug-use-dev_online-for-memhp_auto_online
+++ a/drivers/base/memory.c
@@ -249,7 +249,7 @@ memory_block_action(unsigned long phys_i
 	return ret;
 }
 
-int memory_block_change_state(struct memory_block *mem,
+static int memory_block_change_state(struct memory_block *mem,
 		unsigned long to_state, unsigned long from_state_req)
 {
 	int ret = 0;
diff -puN include/linux/memory.h~memory-hotplug-use-dev_online-for-memhp_auto_online include/linux/memory.h
--- a/include/linux/memory.h~memory-hotplug-use-dev_online-for-memhp_auto_online
+++ a/include/linux/memory.h
@@ -109,9 +109,6 @@ extern void unregister_memory_notifier(s
 extern int register_memory_isolate_notifier(struct notifier_block *nb);
 extern void unregister_memory_isolate_notifier(struct notifier_block *nb);
 extern int register_new_memory(int, struct mem_section *);
-extern int memory_block_change_state(struct memory_block *mem,
-				     unsigned long to_state,
-				     unsigned long from_state_req);
 #ifdef CONFIG_MEMORY_HOTREMOVE
 extern int unregister_memory_section(struct mem_section *);
 #endif
diff -puN mm/memory_hotplug.c~memory-hotplug-use-dev_online-for-memhp_auto_online mm/memory_hotplug.c
--- a/mm/memory_hotplug.c~memory-hotplug-use-dev_online-for-memhp_auto_online
+++ a/mm/memory_hotplug.c
@@ -1337,7 +1337,7 @@ int zone_for_memory(int nid, u64 start,
 
 static int online_memory_block(struct memory_block *mem, void *arg)
 {
-	return memory_block_change_state(mem, MEM_ONLINE, MEM_OFFLINE);
+	return device_online(&mem->dev);
 }
 
 /* we are OK calling __meminit stuff here - we have CONFIG_MEMORY_HOTPLUG */
_
