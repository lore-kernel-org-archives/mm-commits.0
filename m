From: akpm@linux-foundation.org
Subject: + memory-hotplug-reset-pgdat-kswapd-to-null-if-creating-kernel-thread-fails.patch added to -mm tree
Date: Wed, 22 Aug 2012 12:20:29 -0700
Message-ID: <20120822192030.09D4A200057@hpza10.eem.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-wg0-f74.google.com ([74.125.82.74]:62589 "EHLO
	mail-wg0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758806Ab2HVTUb (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 22 Aug 2012 15:20:31 -0400
Received: by wgbdt11 with SMTP id dt11so63914wgb.1
        for <mm-commits@vger.kernel.org>; Wed, 22 Aug 2012 12:20:30 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: wency@cn.fujitsu.com, minchan@kernel.org


The patch titled
     Subject: memory hotplug: reset pgdat->kswapd to NULL if creating kernel thread fails
has been added to the -mm tree.  Its filename is
     memory-hotplug-reset-pgdat-kswapd-to-null-if-creating-kernel-thread-fails.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Wen Congyang <wency@cn.fujitsu.com>
Subject: memory hotplug: reset pgdat->kswapd to NULL if creating kernel thread fails

If kthread_run() fails, pgdat->kswapd contains errno.  When we stop this
thread, we only check whether pgdat->kswapd is NULL and access it.  If it
contains errno, it will cause page fault.  Reset pgdat->kswapd to NULL
when creating kernel thread fails can avoid this problem.

Signed-off-by: Wen Congyang <wency@cn.fujitsu.com>
Reviewed-by: Minchan Kim <minchan@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/vmscan.c |    1 +
 1 file changed, 1 insertion(+)

diff -puN mm/vmscan.c~memory-hotplug-reset-pgdat-kswapd-to-null-if-creating-kernel-thread-fails mm/vmscan.c
--- a/mm/vmscan.c~memory-hotplug-reset-pgdat-kswapd-to-null-if-creating-kernel-thread-fails
+++ a/mm/vmscan.c
@@ -3112,6 +3112,7 @@ int kswapd_run(int nid)
 		/* failure at boot is fatal */
 		BUG_ON(system_state == SYSTEM_BOOTING);
 		printk("Failed to start kswapd on node %d\n",nid);
+		pgdat->kswapd = NULL;
 		ret = -1;
 	}
 	return ret;
_

Patches currently in -mm which might be from wency@cn.fujitsu.com are

memory-hotplug-reset-pgdat-kswapd-to-null-if-creating-kernel-thread-fails.patch
acpi_memhotplugc-fix-memory-leak-when-memory-device-is-unbound-from-the-module-acpi_memhotplug.patch
acpi_memhotplugc-free-memory-device-if-acpi_memory_enable_device-failed.patch
acpi_memhotplugc-remove-memory-info-from-list-before-freeing-it.patch
acpi_memhotplugc-dont-allow-to-eject-the-memory-device-if-it-is-being-used.patch
acpi_memhotplugc-bind-the-memory-device-when-the-driver-is-being-loaded.patch
acpi_memhotplugc-auto-bind-the-memory-device-which-is-hotplugged-before-the-driver-is-loaded.patch

