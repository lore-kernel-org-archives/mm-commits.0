From: akpm@linux-foundation.org
Subject: +
 mm-take-memory-hotplug-lock-within-numa_zonelist_order_handler.patch added
 to -mm tree
Date: Wed, 26 Jul 2017 15:22:11 -0700
Message-ID: <59791613.ChnFlFPnQfDUKLpr%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:42688 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751070AbdGZWWM (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 26 Jul 2017 18:22:12 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: heiko.carstens@de.ibm.com, kamezawa.hiroyu@jp.fujitsu.com, mhocko@suse.com, tglx@linutronix.de, vbabka@suse.cz, wild@linux.vnet.ibm.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm: take memory hotplug lock within numa_zonelist_order_handler()
has been added to the -mm tree.  Its filename is
     mm-take-memory-hotplug-lock-within-numa_zonelist_order_handler.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-take-memory-hotplug-lock-within-numa_zonelist_order_handler.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-take-memory-hotplug-lock-within-numa_zonelist_order_handler.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Heiko Carstens <heiko.carstens@de.ibm.com>
Subject: mm: take memory hotplug lock within numa_zonelist_order_handler()

Andre Wild reported the following warning:

WARNING: CPU: 2 PID: 1205 at kernel/cpu.c:240 lockdep_assert_cpus_held+0x4c/0x60
Modules linked in:
CPU: 2 PID: 1205 Comm: bash Not tainted 4.13.0-rc2-00022-gfd2b2c57ec20 #10
Hardware name: IBM 2964 N96 702 (z/VM 6.4.0)
task: 00000000701d8100 task.stack: 0000000073594000
Krnl PSW : 0704f00180000000 0000000000145e24 (lockdep_assert_cpus_held+0x4c/0x60)
...
Call Trace:
 lockdep_assert_cpus_held+0x42/0x60)
 stop_machine_cpuslocked+0x62/0xf0
 build_all_zonelists+0x92/0x150
 numa_zonelist_order_handler+0x102/0x150
 proc_sys_call_handler.isra.12+0xda/0x118
 proc_sys_write+0x34/0x48
 __vfs_write+0x3c/0x178
 vfs_write+0xbc/0x1a0
 SyS_write+0x66/0xc0
 system_call+0xc4/0x2b0
 locks held by bash/1205:
 #0:  (sb_writers#4){.+.+.+}, at: [<000000000037b29e>] vfs_write+0xa6/0x1a0
 #1:  (zl_order_mutex){+.+...}, at: [<00000000002c8e4c>] numa_zonelist_order_handler+0x44/0x150
 #2:  (zonelists_mutex){+.+...}, at: [<00000000002c8efc>] numa_zonelist_order_handler+0xf4/0x150
Last Breaking-Event-Address:
 [<0000000000145e20>] lockdep_assert_cpus_held+0x48/0x60

This can be easily triggered with e.g.

 >echo n > /proc/sys/vm/numa_zonelist_order

With 3f906ba23689a ("mm/memory-hotplug: switch locking to a
percpu rwsem") memory hotplug locking was changed to fix a potential
deadlock. This also switched the stop_machine() invocation within
build_all_zonelists() to stop_machine_cpuslocked() which now expects
that online cpus are locked when being called.

This assumption is not true if build_all_zonelists() is being called
from numa_zonelist_order_handler(). In order to fix this simply add a
mem_hotplug_begin()/mem_hotplug_done() pair to numa_zonelist_order_handler().

Link: http://lkml.kernel.org/r/20170726111738.38768-1-heiko.carstens@de.ibm.com
Fixes: 3f906ba23689a ("mm/memory-hotplug: switch locking to a percpu rwsem")
Signed-off-by: Heiko Carstens <heiko.carstens@de.ibm.com>
Reported-by: Andre Wild <wild@linux.vnet.ibm.com>
Cc: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Vlastimil Babka <vbabka@suse.cz>
Cc: Thomas Gleixner <tglx@linutronix.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/page_alloc.c |    2 ++
 1 file changed, 2 insertions(+)

diff -puN mm/page_alloc.c~mm-take-memory-hotplug-lock-within-numa_zonelist_order_handler mm/page_alloc.c
--- a/mm/page_alloc.c~mm-take-memory-hotplug-lock-within-numa_zonelist_order_handler
+++ a/mm/page_alloc.c
@@ -4891,9 +4891,11 @@ int numa_zonelist_order_handler(struct c
 				NUMA_ZONELIST_ORDER_LEN);
 			user_zonelist_order = oldval;
 		} else if (oldval != user_zonelist_order) {
+			mem_hotplug_begin();
 			mutex_lock(&zonelists_mutex);
 			build_all_zonelists(NULL, NULL);
 			mutex_unlock(&zonelists_mutex);
+			mem_hotplug_done();
 		}
 	}
 out:
_

Patches currently in -mm which might be from heiko.carstens@de.ibm.com are

mm-take-memory-hotplug-lock-within-numa_zonelist_order_handler.patch

