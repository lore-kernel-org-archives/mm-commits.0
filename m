From: akpm@linux-foundation.org
Subject: [merged] kasan-disable-memory-hotplug.patch removed from -mm tree
Date: Mon, 16 Feb 2015 12:17:52 -0800
Message-ID: <54e25070.KcsT+iM5xphnrRzu%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:51124 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751575AbbBPUS3 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 16 Feb 2015 15:18:29 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: a.ryabinin@samsung.com, adech.fo@gmail.com, andi@firstfloor.org, cl@linux.com, dave.hansen@intel.com, dmitryc@google.com, dvyukov@google.com, hpa@zytor.com, iamjoonsoo.kim@lge.com, kcc@google.com, koct9i@gmail.com, mingo@elte.hu, penberg@kernel.org, rientjes@google.com, sasha.levin@oracle.com, tetra2005@gmail.com, tglx@linutronix.de, mm-commits@vger.kernel.org


The patch titled
     Subject: kasan: disable memory hotplug
has been removed from the -mm tree.  Its filename was
     kasan-disable-memory-hotplug.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Andrey Ryabinin <a.ryabinin@samsung.com>
Subject: kasan: disable memory hotplug

Currently memory hotplug won't work with KASan.  As we don't have shadow
for hotplugged memory, kernel will crash on the first access to it.  To
make this work we will need to allocate shadow for new memory.

At some future point proper memory hotplug support will be implemented. 
Until then, print a warning at startup and disable memory hot-add.

Signed-off-by: Andrey Ryabinin <a.ryabinin@samsung.com>
Cc: Dmitry Vyukov <dvyukov@google.com>
Cc: Konstantin Serebryany <kcc@google.com>
Cc: Dmitry Chernenkov <dmitryc@google.com>
Signed-off-by: Andrey Konovalov <adech.fo@gmail.com>
Cc: Yuri Gribov <tetra2005@gmail.com>
Cc: Konstantin Khlebnikov <koct9i@gmail.com>
Cc: Sasha Levin <sasha.levin@oracle.com>
Cc: Christoph Lameter <cl@linux.com>
Cc: Joonsoo Kim <iamjoonsoo.kim@lge.com>
Cc: Dave Hansen <dave.hansen@intel.com>
Cc: Andi Kleen <andi@firstfloor.org>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: "H. Peter Anvin" <hpa@zytor.com>
Cc: Christoph Lameter <cl@linux.com>
Cc: Pekka Enberg <penberg@kernel.org>
Cc: David Rientjes <rientjes@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/kasan/kasan.c |   21 +++++++++++++++++++++
 1 file changed, 21 insertions(+)

diff -puN mm/kasan/kasan.c~kasan-disable-memory-hotplug mm/kasan/kasan.c
--- a/mm/kasan/kasan.c~kasan-disable-memory-hotplug
+++ a/mm/kasan/kasan.c
@@ -20,6 +20,7 @@
 #include <linux/init.h>
 #include <linux/kernel.h>
 #include <linux/memblock.h>
+#include <linux/memory.h>
 #include <linux/mm.h>
 #include <linux/printk.h>
 #include <linux/sched.h>
@@ -300,3 +301,23 @@ EXPORT_SYMBOL(__asan_storeN_noabort);
 /* to shut up compiler complaints */
 void __asan_handle_no_return(void) {}
 EXPORT_SYMBOL(__asan_handle_no_return);
+
+#ifdef CONFIG_MEMORY_HOTPLUG
+static int kasan_mem_notifier(struct notifier_block *nb,
+			unsigned long action, void *data)
+{
+	return (action == MEM_GOING_ONLINE) ? NOTIFY_BAD : NOTIFY_OK;
+}
+
+static int __init kasan_memhotplug_init(void)
+{
+	pr_err("WARNING: KASan doesn't support memory hot-add\n");
+	pr_err("Memory hot-add will be disabled\n");
+
+	hotplug_memory_notifier(kasan_mem_notifier, 0);
+
+	return 0;
+}
+
+module_init(kasan_memhotplug_init);
+#endif
_

Patches currently in -mm which might be from a.ryabinin@samsung.com are

origin.patch

