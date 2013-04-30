From: akpm@linux-foundation.org
Subject: [merged] mm-reinititalise-user-and-admin-reserves-if-memory-is-added-or-removed.patch removed from -mm tree
Date: Tue, 30 Apr 2013 11:48:59 -0700
Message-ID: <20130430184859.825B15A4082@corp2gmr1-2.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-yh0-f74.google.com ([209.85.213.74]:64497 "EHLO
	mail-yh0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932871Ab3D3StA (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 30 Apr 2013 14:49:00 -0400
Received: by mail-yh0-f74.google.com with SMTP id z12so84801yhz.1
        for <mm-commits@vger.kernel.org>; Tue, 30 Apr 2013 11:48:59 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: agshew@gmail.com, fengguang.wu@intel.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm: reinititalise user and admin reserves if memory is added or removed
has been removed from the -mm tree.  Its filename was
     mm-reinititalise-user-and-admin-reserves-if-memory-is-added-or-removed.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Andrew Shewmaker <agshew@gmail.com>
Subject: mm: reinititalise user and admin reserves if memory is added or removed

Alter the admin and user reserves of the previous patches in this series
when memory is added or removed.

If memory is added and the reserves have been eliminated or increased
above the default max, then we'll trust the admin.

If memory is removed and there isn't enough free memory, then we need to
reset the reserves.

Otherwise keep the reserve set by the admin.

The reserve reset code is the same as the reserve initialization code.

I tested hot addition and removal by triggering it via sysfs.  The
reserves shrunk when they were set high and memory was removed.  They were
reset higher when memory was added again.

[akpm@linux-foundation.org: use register_hotmemory_notifier()]
[akpm@linux-foundation.org: init_user_reserve() and init_admin_reserve can no longer be __meminit]
[fengguang.wu@intel.com: make init_reserve_notifier() static]
[akpm@linux-foundation.org: coding-style fixes]
Signed-off-by: Andrew Shewmaker <agshew@gmail.com>
Signed-off-by: Fengguang Wu <fengguang.wu@intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/mmap.c |   76 ++++++++++++++++++++++++++++++++++++++++++++++++++--
 1 file changed, 74 insertions(+), 2 deletions(-)

diff -puN mm/mmap.c~mm-reinititalise-user-and-admin-reserves-if-memory-is-added-or-removed mm/mmap.c
--- a/mm/mmap.c~mm-reinititalise-user-and-admin-reserves-if-memory-is-added-or-removed
+++ a/mm/mmap.c
@@ -33,6 +33,8 @@
 #include <linux/uprobes.h>
 #include <linux/rbtree_augmented.h>
 #include <linux/sched/sysctl.h>
+#include <linux/notifier.h>
+#include <linux/memory.h>
 
 #include <asm/uaccess.h>
 #include <asm/cacheflush.h>
@@ -3110,7 +3112,7 @@ void __init mmap_init(void)
  * The default value is min(3% of free memory, 128MB)
  * 128MB is enough to recover with sshd/login, bash, and top/kill.
  */
-static int __meminit init_user_reserve(void)
+static int init_user_reserve(void)
 {
 	unsigned long free_kbytes;
 
@@ -3131,7 +3133,7 @@ module_init(init_user_reserve)
  * with sshd, bash, and top in OVERCOMMIT_GUESS. Smaller systems will
  * only reserve 3% of free pages by default.
  */
-static int __meminit init_admin_reserve(void)
+static int init_admin_reserve(void)
 {
 	unsigned long free_kbytes;
 
@@ -3141,3 +3143,73 @@ static int __meminit init_admin_reserve(
 	return 0;
 }
 module_init(init_admin_reserve)
+
+/*
+ * Reinititalise user and admin reserves if memory is added or removed.
+ *
+ * The default user reserve max is 128MB, and the default max for the
+ * admin reserve is 8MB. These are usually, but not always, enough to
+ * enable recovery from a memory hogging process using login/sshd, a shell,
+ * and tools like top. It may make sense to increase or even disable the
+ * reserve depending on the existence of swap or variations in the recovery
+ * tools. So, the admin may have changed them.
+ *
+ * If memory is added and the reserves have been eliminated or increased above
+ * the default max, then we'll trust the admin.
+ *
+ * If memory is removed and there isn't enough free memory, then we
+ * need to reset the reserves.
+ *
+ * Otherwise keep the reserve set by the admin.
+ */
+static int reserve_mem_notifier(struct notifier_block *nb,
+			     unsigned long action, void *data)
+{
+	unsigned long tmp, free_kbytes;
+
+	switch (action) {
+	case MEM_ONLINE:
+		/* Default max is 128MB. Leave alone if modified by operator. */
+		tmp = sysctl_user_reserve_kbytes;
+		if (0 < tmp && tmp < (1UL << 17))
+			init_user_reserve();
+
+		/* Default max is 8MB.  Leave alone if modified by operator. */
+		tmp = sysctl_admin_reserve_kbytes;
+		if (0 < tmp && tmp < (1UL << 13))
+			init_admin_reserve();
+
+		break;
+	case MEM_OFFLINE:
+		free_kbytes = global_page_state(NR_FREE_PAGES) << (PAGE_SHIFT - 10);
+
+		if (sysctl_user_reserve_kbytes > free_kbytes) {
+			init_user_reserve();
+			pr_info("vm.user_reserve_kbytes reset to %lu\n",
+				sysctl_user_reserve_kbytes);
+		}
+
+		if (sysctl_admin_reserve_kbytes > free_kbytes) {
+			init_admin_reserve();
+			pr_info("vm.admin_reserve_kbytes reset to %lu\n",
+				sysctl_admin_reserve_kbytes);
+		}
+		break;
+	default:
+		break;
+	}
+	return NOTIFY_OK;
+}
+
+static struct notifier_block reserve_mem_nb = {
+	.notifier_call = reserve_mem_notifier,
+};
+
+static int __meminit init_reserve_notifier(void)
+{
+	if (register_hotmemory_notifier(&reserve_mem_nb))
+		printk("Failed registering memory add/remove notifier for admin reserve");
+
+	return 0;
+}
+module_init(init_reserve_notifier)
_

Patches currently in -mm which might be from agshew@gmail.com are

origin.patch

