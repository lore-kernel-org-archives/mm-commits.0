From: akpm@linux-foundation.org
Subject: + eeepc-laptop-enable-camera-by-default.patch added to -mm tree
Date: Fri, 05 Jun 2009 13:07:29 -0700
Message-ID: <200906052007.n55K7TbS014596__40034.6678369262$1244232525$gmane$org@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:57763 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752056AbZFEUIg (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 5 Jun 2009 16:08:36 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: penberg@cs.helsinki.fi, acpi4asus-user@lists.sourceforge.net, corentincj@iksaif.net, len.brown@intel.com, mjg@redhat.com


The patch titled
     eeepc-laptop: enable camera by default
has been added to the -mm tree.  Its filename is
     eeepc-laptop-enable-camera-by-default.patch

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
Subject: eeepc-laptop: enable camera by default
From: Pekka Enberg <penberg@cs.helsinki.fi>

If we leave the camera disabled by default, userspace programs (e.g. 
Skype, Cheese) leave the user out in the cold saying that the machine "has
no camera." Therefore, it's better to enable camera by default and let
people who really don't want it just disable the thing.

Cc: <acpi4asus-user@lists.sourceforge.net>
Cc: Len Brown <len.brown@intel.com>
Signed-off-by: Pekka Enberg <penberg@cs.helsinki.fi>
Cc: Corentin Chary <corentincj@iksaif.net>
Cc: Matthew Garrett <mjg@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/platform/x86/eeepc-laptop.c |   16 ++++++++++++++++
 1 file changed, 16 insertions(+)

diff -puN drivers/platform/x86/eeepc-laptop.c~eeepc-laptop-enable-camera-by-default drivers/platform/x86/eeepc-laptop.c
--- a/drivers/platform/x86/eeepc-laptop.c~eeepc-laptop-enable-camera-by-default
+++ a/drivers/platform/x86/eeepc-laptop.c
@@ -331,6 +331,19 @@ static const struct rfkill_ops eeepc_rfk
 };
 
 /*
+ * Camera helpers
+ */
+
+static void eeepc_enable_camera(void)
+{
+	int err;
+
+	err = set_acpi(CM_ASL_CAMERA, 1);
+	if (err)
+		printk(EEEPC_WARNING "Unable to enable camera %d\n", err);
+}
+
+/*
  * Sys helpers
  */
 static int parse_arg(const char *buf, unsigned long count, int *val)
@@ -1036,6 +1049,9 @@ static int __init eeepc_laptop_init(void
 	result = eeepc_hwmon_init(dev);
 	if (result)
 		goto fail_hwmon;
+
+	eeepc_enable_camera();
+
 	/* Register platform stuff */
 	result = platform_driver_register(&platform_driver);
 	if (result)
_

Patches currently in -mm which might be from penberg@cs.helsinki.fi are

repeatable-slab-corruption-with-ltp-msgctl08.patch
linux-next.patch
eeepc-laptop-enable-camera-by-default.patch
cpusets-restructure-the-function-cpuset_update_task_memory_state.patch
cpusets-update-tasks-page-slab-spread-flags-in-time.patch
cpusetmm-update-tasks-mems_allowed-in-time.patch
cpusetmm-update-tasks-mems_allowed-in-time-fix.patch
cpusetmm-update-tasks-mems_allowed-in-time-cleanup.patch
page-allocator-replace-__alloc_pages_internal-with-__alloc_pages_nodemask.patch
page-allocator-do-not-sanity-check-order-in-the-fast-path.patch
page-allocator-do-not-sanity-check-order-in-the-fast-path-fix.patch
page-allocator-do-not-check-numa-node-id-when-the-caller-knows-the-node-is-valid.patch
page-allocator-check-only-once-if-the-zonelist-is-suitable-for-the-allocation.patch
page-allocator-break-up-the-allocator-entry-point-into-fast-and-slow-paths.patch
page-allocator-move-check-for-disabled-anti-fragmentation-out-of-fastpath.patch
page-allocator-calculate-the-preferred-zone-for-allocation-only-once.patch
page-allocator-calculate-the-preferred-zone-for-allocation-only-once-fix.patch
page-allocator-calculate-the-migratetype-for-allocation-only-once.patch
page-allocator-calculate-the-alloc_flags-for-allocation-only-once.patch
page-allocator-remove-a-branch-by-assuming-__gfp_high-==-alloc_high.patch
page-allocator-inline-__rmqueue_smallest.patch
page-allocator-inline-buffered_rmqueue.patch
page-allocator-inline-__rmqueue_fallback.patch
page-allocator-do-not-call-get_pageblock_migratetype-more-than-necessary.patch
page-allocator-do-not-disable-interrupts-in-free_page_mlock.patch
page-allocator-do-not-setup-zonelist-cache-when-there-is-only-one-node.patch
page-allocator-do-not-check-for-compound-pages-during-the-page-allocator-sanity-checks.patch
page-allocator-use-allocation-flags-as-an-index-to-the-zone-watermark.patch
page-allocator-use-allocation-flags-as-an-index-to-the-zone-watermark-replace-the-watermark-related-union-in-struct-zone-with-a-watermark-array.patch
page-allocator-update-nr_free_pages-only-as-necessary.patch
page-allocator-update-nr_free_pages-only-as-necessary-fix.patch
page-allocator-get-the-pageblock-migratetype-without-disabling-interrupts.patch
page-allocator-use-a-pre-calculated-value-instead-of-num_online_nodes-in-fast-paths.patch
page-allocator-slab-use-nr_online_nodes-to-check-for-a-numa-platform.patch
page-allocator-move-free_page_mlock-to-page_allocc.patch
slab-leaks3-default-y.patch

