From: akpm@linux-foundation.org
Subject: + mm-break-circular-include-from-linux-mmzoneh.patch added to -mm tree
Date: Tue, 05 Feb 2013 13:18:05 -0800
Message-ID: <20130205211805.803AA31C107@corp2gmr1-1.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-ye0-f202.google.com ([209.85.213.202]:35243 "EHLO
	mail-ye0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754640Ab3BEVSH (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 5 Feb 2013 16:18:07 -0500
Received: by mail-ye0-f202.google.com with SMTP id r9so72441yen.3
        for <mm-commits@vger.kernel.org>; Tue, 05 Feb 2013 13:18:06 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: lig.fnst@cn.fujitsu.com, rientjes@google.com


The patch titled
     Subject: mm: break circular include from linux/mmzone.h
has been added to the -mm tree.  Its filename is
     mm-break-circular-include-from-linux-mmzoneh.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: liguang <lig.fnst@cn.fujitsu.com>
Subject: mm: break circular include from linux/mmzone.h

linux/mmzone.h included linux/memory_hotplug.h, and linux/memory_hotplug.h
also included linux/mmzone.h, so there's a bad cirlular.

Signed-off-by: liguang <lig.fnst@cn.fujitsu.com>
Cc: David Rientjes <rientjes@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/hwmon/coretemp.c    |    2 ++
 drivers/hwmon/via-cputemp.c |    2 ++
 include/linux/mmzone.h      |    1 -
 kernel/cpu.c                |    1 +
 kernel/smp.c                |    1 +
 lib/show_mem.c              |    1 +
 mm/memory_hotplug.c         |    1 +
 mm/nobootmem.c              |    1 +
 mm/sparse.c                 |    1 +
 9 files changed, 10 insertions(+), 1 deletion(-)

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
_

Patches currently in -mm which might be from lig.fnst@cn.fujitsu.com are

mm-break-circular-include-from-linux-mmzoneh.patch

