From: akpm@linux-foundation.org
Subject: [failures] mm-break-circular-include-from-linux-mmzoneh.patch removed from -mm tree
Date: Wed, 06 Feb 2013 13:34:42 -0800
Message-ID: <20130206213442.E311A5A42B7@corp2gmr1-2.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-vb0-f73.google.com ([209.85.212.73]:55235 "EHLO
	mail-vb0-f73.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758539Ab3BFVeo (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 6 Feb 2013 16:34:44 -0500
Received: by mail-vb0-f73.google.com with SMTP id fj18so201831vbb.4
        for <mm-commits@vger.kernel.org>; Wed, 06 Feb 2013 13:34:43 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: lig.fnst@cn.fujitsu.com, akpm@linux-foundation.org, mhocko@suse.cz, rientjes@google.com, sfr@canb.auug.org.au, mm-commits@vger.kernel.org


The patch titled
     Subject: mm: break circular include from linux/mmzone.h
has been removed from the -mm tree.  Its filename was
     mm-break-circular-include-from-linux-mmzoneh.patch

This patch was dropped because it had testing failures

------------------------------------------------------
From: liguang <lig.fnst@cn.fujitsu.com>
Subject: mm: break circular include from linux/mmzone.h

linux/mmzone.h included linux/memory_hotplug.h, and linux/memory_hotplug.h
also included linux/mmzone.h, so there's a bad cirlular.

Signed-off-by: liguang <lig.fnst@cn.fujitsu.com>
Cc: David Rientjes <rientjes@google.com>
From: Andrew Morton <akpm@linux-foundation.org>
Subject: mm/slub.c: include memory_hotplug.h

x86_64 allnoconfig:

mm/slub.c: In function 'show_slab_objects':
mm/slub.c:4281: error: implicit declaration of function 'lock_memory_hotplug'
mm/slub.c:4322: error: implicit declaration of function 'unlock_memory_hotplug'

Cc: liguang <lig.fnst@cn.fujitsu.com>
From: Andrew Morton <akpm@linux-foundation.org>
Subject: mm-break-circular-include-from-linux-mmzoneh-fix-fix

Cc: liguang <lig.fnst@cn.fujitsu.com>
From: Andrew Morton <akpm@linux-foundation.org>
Subject: mm-break-circular-include-from-linux-mmzoneh-fix-fix-fix

drivers/input/keyboard/adp5520-keys.c:19: error: field 'notifier' has incomplete type
drivers/input/keyboard/adp5520-keys.c: In function 'adp5520_keys_notifier':
drivers/input/keyboard/adp5520-keys.c:43: warning: type defaults to 'int' in declaration of '__mptr'
drivers/input/keyboard/adp5520-keys.c:43: warning: initialization from incompatible pointer type

Cc: liguang <lig.fnst@cn.fujitsu.com>
From: David Rientjes <rientjes@google.com>
Subject: mm: break circular include from linux/mmzone.h fix fix fix fix

kernel/jump_label.c: In function `jump_label_module_notify':
kernel/jump_label.c:393:2: error: implicit declaration of function `notifier_from_errno' [-Werror=implicit-function-declaration]
kernel/jump_label.c: At top level:
kernel/jump_label.c:396:8: error: variable `jump_label_module_nb' has initializer but incomplete type
kernel/jump_label.c:397:2: error: unknown field `notifier_call' specified in initializer
kernel/jump_label.c:397:2: warning: excess elements in struct initializer [enabled by default]
kernel/jump_label.c:397:2: warning: (near initialization for `jump_label_module_nb') [enabled by default]
kernel/jump_label.c:398:2: error: unknown field `priority' specified in initializer
kernel/jump_label.c:398:2: warning: excess elements in struct initializer [enabled by default]
kernel/jump_label.c:398:2: warning: (near initialization for `jump_label_module_nb') [enabled by default]

Signed-off-by: David Rientjes <rientjes@google.com>
Cc: liguang <lig.fnst@cn.fujitsu.com>
From: Michal Hocko <mhocko@suse.cz>
Subject: mm-break-circular-include-from-linux-mmzoneh-fix-fix-fix-fix-fix

Cc: liguang <lig.fnst@cn.fujitsu.com>
From: Andrew Morton <akpm@linux-foundation.org>
Subject: mm-break-circular-include-from-linux-mmzoneh-fix-fix-fix-fix-fix-fix

Cc: liguang <lig.fnst@cn.fujitsu.com>
Reported-by: Stephen Rothwell <sfr@canb.auug.org.au>
From: Andrew Morton <akpm@linux-foundation.org>
Subject: mm-break-circular-include-from-linux-mmzoneh-fix-fix-fix-fix-fix-fix-fix

Cc: liguang <lig.fnst@cn.fujitsu.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/powerpc/mm/mem.c                           |    1 +
 arch/powerpc/platforms/pseries/hotplug-memory.c |    1 +
 block/blk-iopoll.c                              |    1 +
 drivers/hwmon/coretemp.c                        |    2 ++
 drivers/hwmon/via-cputemp.c                     |    2 ++
 drivers/input/keyboard/adp5520-keys.c           |    1 +
 drivers/power/da9030_battery.c                  |    1 +
 include/linux/mmzone.h                          |    1 -
 kernel/cpu.c                                    |    1 +
 kernel/gcov/base.c                              |    1 +
 kernel/jump_label.c                             |    1 +
 kernel/smp.c                                    |    1 +
 lib/show_mem.c                                  |    1 +
 mm/bootmem.c                                    |    1 +
 mm/memory_hotplug.c                             |    1 +
 mm/nobootmem.c                                  |    1 +
 mm/slub.c                                       |    1 +
 mm/sparse.c                                     |    1 +
 18 files changed, 19 insertions(+), 1 deletion(-)

diff -puN drivers/hwmon/coretemp.c~mm-break-circular-include-from-linux-mmzoneh drivers/hwmon/coretemp.c
--- a/drivers/hwmon/coretemp.c~mm-break-circular-include-from-linux-mmzoneh
+++ a/drivers/hwmon/coretemp.c
@@ -36,6 +36,8 @@
 #include <linux/cpu.h>
 #include <linux/smp.h>
 #include <linux/moduleparam.h>
+#include <linux/notifier.h>
+
 #include <asm/msr.h>
 #include <asm/processor.h>
 #include <asm/cpu_device_id.h>
diff -puN drivers/hwmon/via-cputemp.c~mm-break-circular-include-from-linux-mmzoneh drivers/hwmon/via-cputemp.c
--- a/drivers/hwmon/via-cputemp.c~mm-break-circular-include-from-linux-mmzoneh
+++ a/drivers/hwmon/via-cputemp.c
@@ -35,6 +35,8 @@
 #include <linux/list.h>
 #include <linux/platform_device.h>
 #include <linux/cpu.h>
+#include <linux/notifier.h>
+
 #include <asm/msr.h>
 #include <asm/processor.h>
 #include <asm/cpu_device_id.h>
diff -puN include/linux/mmzone.h~mm-break-circular-include-from-linux-mmzoneh include/linux/mmzone.h
--- a/include/linux/mmzone.h~mm-break-circular-include-from-linux-mmzoneh
+++ a/include/linux/mmzone.h
@@ -768,7 +768,6 @@ static inline bool pgdat_is_empty(pg_dat
 	return !pgdat->node_start_pfn && !pgdat->node_spanned_pages;
 }
 
-#include <linux/memory_hotplug.h>
 
 extern struct mutex zonelists_mutex;
 void build_all_zonelists(pg_data_t *pgdat, struct zone *zone);
diff -puN kernel/cpu.c~mm-break-circular-include-from-linux-mmzoneh kernel/cpu.c
--- a/kernel/cpu.c~mm-break-circular-include-from-linux-mmzoneh
+++ a/kernel/cpu.c
@@ -19,6 +19,7 @@
 #include <linux/mutex.h>
 #include <linux/gfp.h>
 #include <linux/suspend.h>
+#include <linux/memory_hotplug.h>
 
 #include "smpboot.h"
 
diff -puN kernel/smp.c~mm-break-circular-include-from-linux-mmzoneh kernel/smp.c
--- a/kernel/smp.c~mm-break-circular-include-from-linux-mmzoneh
+++ a/kernel/smp.c
@@ -12,6 +12,7 @@
 #include <linux/gfp.h>
 #include <linux/smp.h>
 #include <linux/cpu.h>
+#include <linux/notifier.h>
 
 #include "smpboot.h"
 
diff -puN lib/show_mem.c~mm-break-circular-include-from-linux-mmzoneh lib/show_mem.c
--- a/lib/show_mem.c~mm-break-circular-include-from-linux-mmzoneh
+++ a/lib/show_mem.c
@@ -6,6 +6,7 @@
  */
 
 #include <linux/mm.h>
+#include <linux/memory_hotplug.h>
 #include <linux/nmi.h>
 #include <linux/quicklist.h>
 
diff -puN mm/memory_hotplug.c~mm-break-circular-include-from-linux-mmzoneh mm/memory_hotplug.c
--- a/mm/memory_hotplug.c~mm-break-circular-include-from-linux-mmzoneh
+++ a/mm/memory_hotplug.c
@@ -23,6 +23,7 @@
 #include <linux/vmalloc.h>
 #include <linux/ioport.h>
 #include <linux/delay.h>
+#include <linux/notifier.h>
 #include <linux/migrate.h>
 #include <linux/page-isolation.h>
 #include <linux/pfn.h>
diff -puN mm/nobootmem.c~mm-break-circular-include-from-linux-mmzoneh mm/nobootmem.c
--- a/mm/nobootmem.c~mm-break-circular-include-from-linux-mmzoneh
+++ a/mm/nobootmem.c
@@ -16,6 +16,7 @@
 #include <linux/kmemleak.h>
 #include <linux/range.h>
 #include <linux/memblock.h>
+#include <linux/memory_hotplug.h>
 
 #include <asm/bug.h>
 #include <asm/io.h>
diff -puN mm/sparse.c~mm-break-circular-include-from-linux-mmzoneh mm/sparse.c
--- a/mm/sparse.c~mm-break-circular-include-from-linux-mmzoneh
+++ a/mm/sparse.c
@@ -13,6 +13,7 @@
 #include <asm/dma.h>
 #include <asm/pgalloc.h>
 #include <asm/pgtable.h>
+#include <linux/memory_hotplug.h>
 
 /*
  * Permanent SPARSEMEM data:
diff -puN mm/slub.c~mm-break-circular-include-from-linux-mmzoneh mm/slub.c
--- a/mm/slub.c~mm-break-circular-include-from-linux-mmzoneh
+++ a/mm/slub.c
@@ -23,6 +23,7 @@
 #include <linux/cpu.h>
 #include <linux/cpuset.h>
 #include <linux/mempolicy.h>
+#include <linux/memory_hotplug.h>
 #include <linux/ctype.h>
 #include <linux/debugobjects.h>
 #include <linux/kallsyms.h>
diff -puN kernel/gcov/base.c~mm-break-circular-include-from-linux-mmzoneh kernel/gcov/base.c
--- a/kernel/gcov/base.c~mm-break-circular-include-from-linux-mmzoneh
+++ a/kernel/gcov/base.c
@@ -17,6 +17,7 @@
 
 #include <linux/init.h>
 #include <linux/module.h>
+#include <linux/notifier.h>
 #include <linux/mutex.h>
 #include "gcov.h"
 
diff -puN drivers/input/keyboard/adp5520-keys.c~mm-break-circular-include-from-linux-mmzoneh drivers/input/keyboard/adp5520-keys.c
--- a/drivers/input/keyboard/adp5520-keys.c~mm-break-circular-include-from-linux-mmzoneh
+++ a/drivers/input/keyboard/adp5520-keys.c
@@ -10,6 +10,7 @@
 #include <linux/kernel.h>
 #include <linux/init.h>
 #include <linux/platform_device.h>
+#include <linux/notifier.h>
 #include <linux/input.h>
 #include <linux/mfd/adp5520.h>
 #include <linux/slab.h>
diff -puN kernel/jump_label.c~mm-break-circular-include-from-linux-mmzoneh kernel/jump_label.c
--- a/kernel/jump_label.c~mm-break-circular-include-from-linux-mmzoneh
+++ a/kernel/jump_label.c
@@ -13,6 +13,7 @@
 #include <linux/sort.h>
 #include <linux/err.h>
 #include <linux/static_key.h>
+#include <linux/notifier.h>
 
 #ifdef HAVE_JUMP_LABEL
 
diff -puN drivers/power/da9030_battery.c~mm-break-circular-include-from-linux-mmzoneh drivers/power/da9030_battery.c
--- a/drivers/power/da9030_battery.c~mm-break-circular-include-from-linux-mmzoneh
+++ a/drivers/power/da9030_battery.c
@@ -15,6 +15,7 @@
 #include <linux/types.h>
 #include <linux/device.h>
 #include <linux/workqueue.h>
+#include <linux/notifier.h>
 #include <linux/module.h>
 #include <linux/platform_device.h>
 #include <linux/power_supply.h>
diff -puN arch/powerpc/mm/mem.c~mm-break-circular-include-from-linux-mmzoneh arch/powerpc/mm/mem.c
--- a/arch/powerpc/mm/mem.c~mm-break-circular-include-from-linux-mmzoneh
+++ a/arch/powerpc/mm/mem.c
@@ -28,6 +28,7 @@
 #include <linux/stddef.h>
 #include <linux/init.h>
 #include <linux/bootmem.h>
+#include <linux/memory_hotplug.h>
 #include <linux/highmem.h>
 #include <linux/initrd.h>
 #include <linux/pagemap.h>
diff -puN arch/powerpc/platforms/pseries/hotplug-memory.c~mm-break-circular-include-from-linux-mmzoneh arch/powerpc/platforms/pseries/hotplug-memory.c
--- a/arch/powerpc/platforms/pseries/hotplug-memory.c~mm-break-circular-include-from-linux-mmzoneh
+++ a/arch/powerpc/platforms/pseries/hotplug-memory.c
@@ -11,6 +11,7 @@
 
 #include <linux/of.h>
 #include <linux/memblock.h>
+#include <linux/memory_hotplug.h>
 #include <linux/vmalloc.h>
 #include <linux/memory.h>
 
diff -puN mm/bootmem.c~mm-break-circular-include-from-linux-mmzoneh mm/bootmem.c
--- a/mm/bootmem.c~mm-break-circular-include-from-linux-mmzoneh
+++ a/mm/bootmem.c
@@ -12,6 +12,7 @@
 #include <linux/pfn.h>
 #include <linux/slab.h>
 #include <linux/bootmem.h>
+#include <linux/memory_hotplug.h>
 #include <linux/export.h>
 #include <linux/kmemleak.h>
 #include <linux/range.h>
diff -puN block/blk-iopoll.c~mm-break-circular-include-from-linux-mmzoneh block/blk-iopoll.c
--- a/block/blk-iopoll.c~mm-break-circular-include-from-linux-mmzoneh
+++ a/block/blk-iopoll.c
@@ -7,6 +7,7 @@
 #include <linux/init.h>
 #include <linux/bio.h>
 #include <linux/blkdev.h>
+#include <linux/notifier.h>
 #include <linux/interrupt.h>
 #include <linux/cpu.h>
 #include <linux/blk-iopoll.h>
_

Patches currently in -mm which might be from lig.fnst@cn.fujitsu.com are


