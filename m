From: Andrew Morton <akpm@linux-foundation.org>
Subject: [patch 067/166] hv_balloon: don't check for
 memhp_auto_online manually
Date: Mon, 06 Apr 2020 20:07:32 -0700
Message-ID: <20200407030732.LbZajmtfs%akpm@linux-foundation.org>
References: <20200406200254.a69ebd9e08c4074e41ddebaf@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:52560 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726303AbgDGDHf (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Mon, 6 Apr 2020 23:07:35 -0400
In-Reply-To: <20200406200254.a69ebd9e08c4074e41ddebaf@linux-foundation.org>
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, benh@kernel.crashing.org, bhe@redhat.com, david@redhat.com, ehabkost@redhat.com, gregkh@linuxfoundation.org, haiyangz@microsoft.com, imammedo@redhat.com, kys@microsoft.com, linux-mm@kvack.org, mm-commits@vger.kernel.org, mpe@ellerman.id.au, osalvador@suse.de, paulus@samba.org, rafael@kernel.org, richard.weiyang@gmail.com, sthemmin@microsoft.com, torvalds@linux-foundation.org, vkuznets@redhat.com, wei.liu@kernel.org, yuhuang@redhat.com

From: David Hildenbrand <david@redhat.com>
Subject: hv_balloon: don't check for memhp_auto_online manually

We get the MEM_ONLINE notifier call if memory is added right from the
kernel via add_memory() or later from user space.

Let's get rid of the "ha_waiting" flag - the wait event has an inbuilt
mechanism (->done) for that.  Initialize the wait event only once and
reinitialize before adding memory.  Unconditionally call complete() and
wait_for_completion_timeout().

If there are no waiters, complete() will only increment ->done - which
will be reset by reinit_completion().  If complete() has already been
called, wait_for_completion_timeout() will not wait.

There is still the chance for a small race between concurrent
reinit_completion() and complete().  If complete() wins, we would not wait
- which is tolerable (and the race exists in current code as well).

Note: We only wait for "some" memory to get onlined, which seems to be
      good enough for now.

[akpm@linux-foundation.org: register_memory_notifier() after init_completion(), per David]
Link: http://lkml.kernel.org/r/20200317104942.11178-6-david@redhat.com
Signed-off-by: David Hildenbrand <david@redhat.com>
Reviewed-by: Vitaly Kuznetsov <vkuznets@redhat.com>
Reviewed-by: Baoquan He <bhe@redhat.com>
Cc: "K. Y. Srinivasan" <kys@microsoft.com>
Cc: Haiyang Zhang <haiyangz@microsoft.com>
Cc: Stephen Hemminger <sthemmin@microsoft.com>
Cc: Wei Liu <wei.liu@kernel.org>
Cc: Oscar Salvador <osalvador@suse.de>
Cc: "Rafael J. Wysocki" <rafael@kernel.org>
Cc: Wei Yang <richard.weiyang@gmail.com>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: Eduardo Habkost <ehabkost@redhat.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Igor Mammedov <imammedo@redhat.com>
Cc: Michael Ellerman <mpe@ellerman.id.au>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Yumei Huang <yuhuang@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/hv/hv_balloon.c |   25 ++++++++++---------------
 1 file changed, 10 insertions(+), 15 deletions(-)

--- a/drivers/hv/hv_balloon.c~hv_balloon-dont-check-for-memhp_auto_online-manually
+++ a/drivers/hv/hv_balloon.c
@@ -533,7 +533,6 @@ struct hv_dynmem_device {
 	 * State to synchronize hot-add.
 	 */
 	struct completion  ol_waitevent;
-	bool ha_waiting;
 	/*
 	 * This thread handles hot-add
 	 * requests from the host as well as notifying
@@ -634,10 +633,7 @@ static int hv_memory_notifier(struct not
 	switch (val) {
 	case MEM_ONLINE:
 	case MEM_CANCEL_ONLINE:
-		if (dm_device.ha_waiting) {
-			dm_device.ha_waiting = false;
-			complete(&dm_device.ol_waitevent);
-		}
+		complete(&dm_device.ol_waitevent);
 		break;
 
 	case MEM_OFFLINE:
@@ -726,8 +722,7 @@ static void hv_mem_hot_add(unsigned long
 		has->covered_end_pfn +=  processed_pfn;
 		spin_unlock_irqrestore(&dm_device.ha_lock, flags);
 
-		init_completion(&dm_device.ol_waitevent);
-		dm_device.ha_waiting = !memhp_auto_online;
+		reinit_completion(&dm_device.ol_waitevent);
 
 		nid = memory_add_physaddr_to_nid(PFN_PHYS(start_pfn));
 		ret = add_memory(nid, PFN_PHYS((start_pfn)),
@@ -753,15 +748,14 @@ static void hv_mem_hot_add(unsigned long
 		}
 
 		/*
-		 * Wait for the memory block to be onlined when memory onlining
-		 * is done outside of kernel (memhp_auto_online). Since the hot
-		 * add has succeeded, it is ok to proceed even if the pages in
-		 * the hot added region have not been "onlined" within the
-		 * allowed time.
+		 * Wait for memory to get onlined. If the kernel onlined the
+		 * memory when adding it, this will return directly. Otherwise,
+		 * it will wait for user space to online the memory. This helps
+		 * to avoid adding memory faster than it is getting onlined. As
+		 * adding succeeded, it is ok to proceed even if the memory was
+		 * not onlined in time.
 		 */
-		if (dm_device.ha_waiting)
-			wait_for_completion_timeout(&dm_device.ol_waitevent,
-						    5*HZ);
+		wait_for_completion_timeout(&dm_device.ol_waitevent, 5 * HZ);
 		post_status(&dm_device);
 	}
 }
@@ -1706,6 +1700,7 @@ static int balloon_probe(struct hv_devic
 
 #ifdef CONFIG_MEMORY_HOTPLUG
 	set_online_page_callback(&hv_online_page);
+	init_completion(&dm_device.ol_waitevent);
 	register_memory_notifier(&hv_memory_nb);
 #endif
 
_
