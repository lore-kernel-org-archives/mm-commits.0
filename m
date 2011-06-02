From: akpm@linux-foundation.org
Subject: + xen-balloon-memory-hotplug-support-for-xen-balloon-driver.patch added to -mm tree
Date: Thu, 02 Jun 2011 12:27:26 -0700
Message-ID: <201106021927.p52JRQ3k004154@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:42048 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754361Ab1FBT1f (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 2 Jun 2011 15:27:35 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: dkiper@net-space.pl, ian.campbell@citrix.com, jeremy@goop.org, konrad.wilk@oracle.com


The patch titled
     xen/balloon: memory hotplug support for Xen balloon driver
has been added to the -mm tree.  Its filename is
     xen-balloon-memory-hotplug-support-for-xen-balloon-driver.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://userweb.kernel.org/~akpm/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: xen/balloon: memory hotplug support for Xen balloon driver
From: Daniel Kiper <dkiper@net-space.pl>

Memory hotplug support for Xen balloon driver.  It should be mentioned
that hotplugged memory is not onlined automatically.  It should be onlined
by user through standard sysfs interface.

Memory could be hotplugged in following steps:

  1) dom0: xl mem-max <domU> <maxmem>
     where <maxmem> is >= requested memory size,

  2) dom0: xl mem-set <domU> <memory>
     where <memory> is requested memory size; alternatively memory
     could be added by writing proper value to
     /sys/devices/system/xen_memory/xen_memory0/target or
     /sys/devices/system/xen_memory/xen_memory0/target_kb on dumU,

  3) domU: for i in /sys/devices/system/memory/memory*/state; do \
             [ "`cat "$i"`" = offline ] && echo online > "$i"; done

Memory could be onlined automatically on domU by adding following line to
udev rules:

SUBSYSTEM=="memory", ACTION=="add", RUN+="/bin/sh -c '[ -f /sys$devpath/state ] && echo online > /sys$devpath/state'"

In that case step 3 should be omitted.

Signed-off-by: Daniel Kiper <dkiper@net-space.pl>
Acked-by: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Cc: Ian Campbell <ian.campbell@citrix.com>
Cc: Jeremy Fitzhardinge <jeremy@goop.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/xen/Kconfig   |   30 ++++++++
 drivers/xen/balloon.c |  139 +++++++++++++++++++++++++++++++++++++++-
 include/xen/balloon.h |    4 +
 3 files changed, 171 insertions(+), 2 deletions(-)

diff -puN drivers/xen/Kconfig~xen-balloon-memory-hotplug-support-for-xen-balloon-driver drivers/xen/Kconfig
--- a/drivers/xen/Kconfig~xen-balloon-memory-hotplug-support-for-xen-balloon-driver
+++ a/drivers/xen/Kconfig
@@ -9,6 +9,36 @@ config XEN_BALLOON
 	  the system to expand the domain's memory allocation, or alternatively
 	  return unneeded memory to the system.
 
+config XEN_BALLOON_MEMORY_HOTPLUG
+	bool "Memory hotplug support for Xen balloon driver"
+	default n
+	depends on XEN_BALLOON && MEMORY_HOTPLUG
+	help
+	  Memory hotplug support for Xen balloon driver allows expanding memory
+	  available for the system above limit declared at system startup.
+	  It is very useful on critical systems which require long
+	  run without rebooting.
+
+	  Memory could be hotplugged in following steps:
+
+	    1) dom0: xl mem-max <domU> <maxmem>
+	       where <maxmem> is >= requested memory size,
+
+	    2) dom0: xl mem-set <domU> <memory>
+	       where <memory> is requested memory size; alternatively memory
+	       could be added by writing proper value to
+	       /sys/devices/system/xen_memory/xen_memory0/target or
+	       /sys/devices/system/xen_memory/xen_memory0/target_kb on dumU,
+
+	    3) domU: for i in /sys/devices/system/memory/memory*/state; do \
+	               [ "`cat "$i"`" = offline ] && echo online > "$i"; done
+
+	  Memory could be onlined automatically on domU by adding following line to udev rules:
+
+	  SUBSYSTEM=="memory", ACTION=="add", RUN+="/bin/sh -c '[ -f /sys$devpath/state ] && echo online > /sys$devpath/state'"
+
+	  In that case step 3 should be omitted.
+
 config XEN_SCRUB_PAGES
 	bool "Scrub pages before returning them to system"
 	depends on XEN_BALLOON
diff -puN drivers/xen/balloon.c~xen-balloon-memory-hotplug-support-for-xen-balloon-driver drivers/xen/balloon.c
--- a/drivers/xen/balloon.c~xen-balloon-memory-hotplug-support-for-xen-balloon-driver
+++ a/drivers/xen/balloon.c
@@ -4,6 +4,12 @@
  * Copyright (c) 2003, B Dragovic
  * Copyright (c) 2003-2004, M Williamson, K Fraser
  * Copyright (c) 2005 Dan M. Smith, IBM Corporation
+ * Copyright (c) 2010 Daniel Kiper
+ *
+ * Memory hotplug support was written by Daniel Kiper. Work on
+ * it was sponsored by Google under Google Summer of Code 2010
+ * program. Jeremy Fitzhardinge from Citrix was the mentor for
+ * this project.
  *
  * This program is free software; you can redistribute it and/or
  * modify it under the terms of the GNU General Public License version 2
@@ -40,6 +46,9 @@
 #include <linux/mutex.h>
 #include <linux/list.h>
 #include <linux/gfp.h>
+#include <linux/notifier.h>
+#include <linux/memory.h>
+#include <linux/memory_hotplug.h>
 
 #include <asm/page.h>
 #include <asm/pgalloc.h>
@@ -194,6 +203,87 @@ static enum bp_state update_schedule(enu
 	return BP_EAGAIN;
 }
 
+#ifdef CONFIG_XEN_BALLOON_MEMORY_HOTPLUG
+static long current_credit(void)
+{
+	return balloon_stats.target_pages - balloon_stats.current_pages -
+		balloon_stats.hotplug_pages;
+}
+
+static bool balloon_is_inflated(void)
+{
+	if (balloon_stats.balloon_low || balloon_stats.balloon_high ||
+			balloon_stats.balloon_hotplug)
+		return true;
+	else
+		return false;
+}
+
+/*
+ * reserve_additional_memory() adds memory region of size >= credit above
+ * max_pfn. New region is section aligned and size is modified to be multiple
+ * of section size. Those features allow optimal use of address space and
+ * establish proper alignment when this function is called first time after
+ * boot (last section not fully populated at boot time contains unused memory
+ * pages with PG_reserved bit not set; online_pages_range() does not allow page
+ * onlining in whole range if first onlined page does not have PG_reserved
+ * bit set). Real size of added memory is established at page onlining stage.
+ */
+
+static enum bp_state reserve_additional_memory(long credit)
+{
+	int nid, rc;
+	u64 hotplug_start_paddr;
+	unsigned long balloon_hotplug = credit;
+
+	hotplug_start_paddr = PFN_PHYS(SECTION_ALIGN_UP(max_pfn));
+	balloon_hotplug = round_up(balloon_hotplug, PAGES_PER_SECTION);
+	nid = memory_add_physaddr_to_nid(hotplug_start_paddr);
+
+	rc = add_memory(nid, hotplug_start_paddr, balloon_hotplug << PAGE_SHIFT);
+
+	if (rc) {
+		pr_info("xen_balloon: %s: add_memory() failed: %i\n", __func__, rc);
+		return BP_EAGAIN;
+	}
+
+	balloon_hotplug -= credit;
+
+	balloon_stats.hotplug_pages += credit;
+	balloon_stats.balloon_hotplug = balloon_hotplug;
+
+	return BP_DONE;
+}
+
+static void xen_online_page(struct page *page)
+{
+	__online_page_set_limits(page);
+
+	mutex_lock(&balloon_mutex);
+
+	__balloon_append(page);
+
+	if (balloon_stats.hotplug_pages)
+		--balloon_stats.hotplug_pages;
+	else
+		--balloon_stats.balloon_hotplug;
+
+	mutex_unlock(&balloon_mutex);
+}
+
+static int xen_memory_notifier(struct notifier_block *nb, unsigned long val, void *v)
+{
+	if (val == MEM_ONLINE)
+		schedule_delayed_work(&balloon_worker, 0);
+
+	return NOTIFY_OK;
+}
+
+static struct notifier_block xen_memory_nb = {
+	.notifier_call = xen_memory_notifier,
+	.priority = 0
+};
+#else
 static long current_credit(void)
 {
 	unsigned long target = balloon_stats.target_pages;
@@ -206,6 +296,21 @@ static long current_credit(void)
 	return target - balloon_stats.current_pages;
 }
 
+static bool balloon_is_inflated(void)
+{
+	if (balloon_stats.balloon_low || balloon_stats.balloon_high)
+		return true;
+	else
+		return false;
+}
+
+static enum bp_state reserve_additional_memory(long credit)
+{
+	balloon_stats.target_pages = balloon_stats.current_pages;
+	return BP_DONE;
+}
+#endif /* CONFIG_XEN_BALLOON_MEMORY_HOTPLUG */
+
 static enum bp_state increase_reservation(unsigned long nr_pages)
 {
 	int rc;
@@ -217,6 +322,15 @@ static enum bp_state increase_reservatio
 		.domid        = DOMID_SELF
 	};
 
+#ifdef CONFIG_XEN_BALLOON_MEMORY_HOTPLUG
+	if (!balloon_stats.balloon_low && !balloon_stats.balloon_high) {
+		nr_pages = min(nr_pages, balloon_stats.balloon_hotplug);
+		balloon_stats.hotplug_pages += nr_pages;
+		balloon_stats.balloon_hotplug -= nr_pages;
+		return BP_DONE;
+	}
+#endif
+
 	if (nr_pages > ARRAY_SIZE(frame_list))
 		nr_pages = ARRAY_SIZE(frame_list);
 
@@ -279,6 +393,15 @@ static enum bp_state decrease_reservatio
 		.domid        = DOMID_SELF
 	};
 
+#ifdef CONFIG_XEN_BALLOON_MEMORY_HOTPLUG
+	if (balloon_stats.hotplug_pages) {
+		nr_pages = min(nr_pages, balloon_stats.hotplug_pages);
+		balloon_stats.hotplug_pages -= nr_pages;
+		balloon_stats.balloon_hotplug += nr_pages;
+		return BP_DONE;
+	}
+#endif
+
 	if (nr_pages > ARRAY_SIZE(frame_list))
 		nr_pages = ARRAY_SIZE(frame_list);
 
@@ -340,8 +463,12 @@ static void balloon_process(struct work_
 	do {
 		credit = current_credit();
 
-		if (credit > 0)
-			state = increase_reservation(credit);
+		if (credit > 0) {
+			if (balloon_is_inflated())
+				state = increase_reservation(credit);
+			else
+				state = reserve_additional_memory(credit);
+		}
 
 		if (credit < 0)
 			state = decrease_reservation(-credit, GFP_BALLOON);
@@ -448,6 +575,14 @@ static int __init balloon_init(void)
 	balloon_stats.retry_count = 1;
 	balloon_stats.max_retry_count = RETRY_UNLIMITED;
 
+#ifdef CONFIG_XEN_BALLOON_MEMORY_HOTPLUG
+	balloon_stats.hotplug_pages = 0;
+	balloon_stats.balloon_hotplug = 0;
+
+	set_online_page_callback(&xen_online_page);
+	register_memory_notifier(&xen_memory_nb);
+#endif
+
 	/*
 	 * Initialise the balloon with excess memory space.  We need
 	 * to make sure we don't add memory which doesn't exist or
diff -puN include/xen/balloon.h~xen-balloon-memory-hotplug-support-for-xen-balloon-driver include/xen/balloon.h
--- a/include/xen/balloon.h~xen-balloon-memory-hotplug-support-for-xen-balloon-driver
+++ a/include/xen/balloon.h
@@ -15,6 +15,10 @@ struct balloon_stats {
 	unsigned long max_schedule_delay;
 	unsigned long retry_count;
 	unsigned long max_retry_count;
+#ifdef CONFIG_XEN_BALLOON_MEMORY_HOTPLUG
+	unsigned long hotplug_pages;
+	unsigned long balloon_hotplug;
+#endif
 };
 
 extern struct balloon_stats balloon_stats;
_

Patches currently in -mm which might be from dkiper@net-space.pl are

mm-extend-memory-hotplug-api-to-allow-memory-hotplug-in-virtual-machines.patch
mm-extend-memory-hotplug-api-to-allow-memory-hotplug-in-virtual-machines-fix.patch
xen-balloon-memory-hotplug-support-for-xen-balloon-driver.patch

