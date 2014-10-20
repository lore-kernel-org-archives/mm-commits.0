From: akpm@linux-foundation.org
Subject: +
 memory-hotplug-clear-pgdat-which-is-allocated-by-bootmem-in-try_offline_node.patch added to -mm tree
Date: Mon, 20 Oct 2014 15:42:01 -0700
Message-ID: <54458fb9.pX925e5nnApCOovV%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:57583 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753946AbaJTWmB (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 20 Oct 2014 18:42:01 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: isimatu.yasuaki@jp.fujitsu.com, dave.hansen@intel.com, rientjes@google.com, tangchen@cn.fujitsu.com, toshi.kani@hp.com, wangnan0@huawei.com, zhenzhang.zhang@huawei.com, mm-commits@vger.kernel.org


The patch titled
     Subject: memory-hotplug: clear pgdat which is allocated by bootmem in try_offline_node()
has been added to the -mm tree.  Its filename is
     memory-hotplug-clear-pgdat-which-is-allocated-by-bootmem-in-try_offline_node.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/memory-hotplug-clear-pgdat-which-is-allocated-by-bootmem-in-try_offline_node.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/memory-hotplug-clear-pgdat-which-is-allocated-by-bootmem-in-try_offline_node.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Yasuaki Ishimatsu <isimatu.yasuaki@jp.fujitsu.com>
Subject: memory-hotplug: clear pgdat which is allocated by bootmem in try_offline_node()

When hot adding the same memory after hot removal, the following messages
are shown:

WARNING: CPU: 20 PID: 6 at mm/page_alloc.c:4968 free_area_init_node+0x3fe/0x426()
...
Call Trace:
 [<...>] dump_stack+0x46/0x58
 [<...>] warn_slowpath_common+0x81/0xa0
 [<...>] warn_slowpath_null+0x1a/0x20
 [<...>] free_area_init_node+0x3fe/0x426
 [<...>] ? up+0x32/0x50
 [<...>] hotadd_new_pgdat+0x90/0x110
 [<...>] add_memory+0xd4/0x200
 [<...>] acpi_memory_device_add+0x1aa/0x289
 [<...>] acpi_bus_attach+0xfd/0x204
 [<...>] ? device_register+0x1e/0x30
 [<...>] acpi_bus_attach+0x178/0x204
 [<...>] acpi_bus_scan+0x6a/0x90
 [<...>] ? acpi_bus_get_status+0x2d/0x5f
 [<...>] acpi_device_hotplug+0xe8/0x418
 [<...>] acpi_hotplug_work_fn+0x1f/0x2b
 [<...>] process_one_work+0x14e/0x3f0
 [<...>] worker_thread+0x11b/0x510
 [<...>] ? rescuer_thread+0x350/0x350
 [<...>] kthread+0xe1/0x100
 [<...>] ? kthread_create_on_node+0x1b0/0x1b0
 [<...>] ret_from_fork+0x7c/0xb0
 [<...>] ? kthread_create_on_node+0x1b0/0x1b0

The detaled explanation is as follows:

When hot removing memory, pgdat is set to 0 in try_offline_node().  But if
the pgdat is allocated by bootmem allocator, the clearing step is skipped.
 And when hot adding the same memory, the uninitialized pgdat is reused. 
But free_area_init_node() chacks wether pgdat is set to zero.  As a
result, free_area_init_node() hits WARN_ON().

This patch clears pgdat which is allocated by bootmem allocator in
try_offline_node().

Signed-off-by: Yasuaki Ishimatsu <isimatu.yasuaki@jp.fujitsu.com>
Cc: Zhang Zhen <zhenzhang.zhang@huawei.com>
Cc: Wang Nan <wangnan0@huawei.com>
Cc: Tang Chen <tangchen@cn.fujitsu.com>
Cc: Toshi Kani <toshi.kani@hp.com>
Cc: Dave Hansen <dave.hansen@intel.com>
Cc: David Rientjes <rientjes@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memory_hotplug.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff -puN mm/memory_hotplug.c~memory-hotplug-clear-pgdat-which-is-allocated-by-bootmem-in-try_offline_node mm/memory_hotplug.c
--- a/mm/memory_hotplug.c~memory-hotplug-clear-pgdat-which-is-allocated-by-bootmem-in-try_offline_node
+++ a/mm/memory_hotplug.c
@@ -1943,7 +1943,7 @@ void try_offline_node(int nid)
 
 	if (!PageSlab(pgdat_page) && !PageCompound(pgdat_page))
 		/* node data is allocated from boot memory */
-		return;
+		goto out;
 
 	/* free waittable in each zone */
 	for (i = 0; i < MAX_NR_ZONES; i++) {
@@ -1957,6 +1957,7 @@ void try_offline_node(int nid)
 			vfree(zone->wait_table);
 	}
 
+out:
 	/*
 	 * Since there is no way to guarentee the address of pgdat/zone is not
 	 * on stack of any kernel threads or used by other kernel objects
_

Patches currently in -mm which might be from isimatu.yasuaki@jp.fujitsu.com are

memory-hotplug-clear-pgdat-which-is-allocated-by-bootmem-in-try_offline_node.patch
mm-introduce-single-zone-pcplists-drain.patch
mm-page_isolation-drain-single-zone-pcplists.patch
mm-cma-drain-single-zone-pcplists.patch
mm-memory_hotplug-failure-drain-single-zone-pcplists.patch

