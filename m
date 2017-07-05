From: akpm@linux-foundation.org
Subject: [to-be-updated]
 mm-change-cpuhotplug-lock-order-in-lru_add_drain_all.patch removed from -mm tree
Date: Wed, 05 Jul 2017 14:56:46 -0700
Message-ID: <595d609e.XxrZuQQlnjBfat6H%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:57758 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752030AbdGEV4r (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 5 Jul 2017 17:56:47 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: tglx@linutronix.de, aryabinin@virtuozzo.com, dkiper@net-space.pl, mhocko@kernel.org, vbabka@suse.cz, vdavydov.dev@gmail.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm: change cpuhotplug lock order in lru_add_drain_all()
has been removed from the -mm tree.  Its filename was
     mm-change-cpuhotplug-lock-order-in-lru_add_drain_all.patch

This patch was dropped because an updated version will be merged

------------------------------------------------------
From: Thomas Gleixner <tglx@linutronix.de>
Subject: mm: change cpuhotplug lock order in lru_add_drain_all()

[  131.022567] ============================================
[  131.023034] WARNING: possible recursive locking detected
[  131.023034] 4.12.0-rc7-next-20170630 #10 Not tainted
[  131.023034] --------------------------------------------
[  131.023034] bash/2266 is trying to acquire lock:
[  131.023034]  (cpu_hotplug_lock.rw_sem){++++++}, at: [<ffffffff8117fcd2>] lru_add_drain_all+0x42/0x190
[  131.023034] 
               but task is already holding lock:
[  131.023034]  (cpu_hotplug_lock.rw_sem){++++++}, at: [<ffffffff811d5489>] mem_hotplug_begin+0x9/0x20
[  131.023034] 
               other info that might help us debug this:
[  131.023034]  Possible unsafe locking scenario:

[  131.023034]        CPU0
[  131.023034]        ----
[  131.023034]   lock(cpu_hotplug_lock.rw_sem);
[  131.023034]   lock(cpu_hotplug_lock.rw_sem);
[  131.023034] 
                *** DEADLOCK ***

[  131.023034]  May be due to missing lock nesting notation

[  131.023034] 8 locks held by bash/2266:
[  131.023034]  #0:  (sb_writers#8){.+.+.+}, at: [<ffffffff811e81f8>] vfs_write+0x1a8/0x1d0
[  131.023034]  #1:  (&of->mutex){+.+.+.}, at: [<ffffffff81274b2c>] kernfs_fop_write+0xfc/0x1b0
[  131.023034]  #2:  (s_active#48){.+.+.+}, at: [<ffffffff81274b34>] kernfs_fop_write+0x104/0x1b0
[  131.023034]  #3:  (device_hotplug_lock){+.+.+.}, at: [<ffffffff816d4810>] lock_device_hotplug_sysfs+0x10/0x40
[  131.023034]  #4:  (cpu_hotplug_lock.rw_sem){++++++}, at: [<ffffffff811d5489>] mem_hotplug_begin+0x9/0x20
[  131.023034]  #5:  (mem_hotplug_lock.rw_sem){++++++}, at: [<ffffffff810ada81>] percpu_down_write+0x21/0x110
[  131.023034]  #6:  (&dev->mutex){......}, at: [<ffffffff816d5bd5>] device_offline+0x45/0xb0
[  131.023034]  #7:  (lock#3){+.+...}, at: [<ffffffff8117fccd>] lru_add_drain_all+0x3d/0x190
[  131.023034] 
               stack backtrace:
[  131.023034] CPU: 0 PID: 2266 Comm: bash Not tainted 4.12.0-rc7-next-20170630 #10
[  131.023034] Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS rel-1.10.2-0-g5f4c7b1-prebuilt.qemu-project.org 04/01/2014
[  131.023034] Call Trace:
[  131.023034]  dump_stack+0x85/0xc7
[  131.023034]  __lock_acquire+0x1747/0x17a0
[  131.023034]  ? lru_add_drain_all+0x3d/0x190
[  131.023034]  ? __mutex_lock+0x218/0x940
[  131.023034]  ? trace_hardirqs_on+0xd/0x10
[  131.023034]  lock_acquire+0x103/0x200
[  131.023034]  ? lock_acquire+0x103/0x200
[  131.023034]  ? lru_add_drain_all+0x42/0x190
[  131.023034]  cpus_read_lock+0x3d/0x80
[  131.023034]  ? lru_add_drain_all+0x42/0x190
[  131.023034]  lru_add_drain_all+0x42/0x190
[  131.023034]  __offline_pages.constprop.25+0x5de/0x870
[  131.023034]  offline_pages+0xc/0x10
[  131.023034]  memory_subsys_offline+0x43/0x70
[  131.023034]  device_offline+0x83/0xb0
[  131.023034]  store_mem_state+0xdb/0xe0
[  131.023034]  dev_attr_store+0x13/0x20
[  131.023034]  sysfs_kf_write+0x40/0x50
[  131.023034]  kernfs_fop_write+0x130/0x1b0
[  131.023034]  __vfs_write+0x23/0x130
[  131.023034]  ? rcu_read_lock_sched_held+0x6d/0x80
[  131.023034]  ? rcu_sync_lockdep_assert+0x2a/0x50
[  131.023034]  ? __sb_start_write+0xd4/0x1c0
[  131.023034]  ? vfs_write+0x1a8/0x1d0
[  131.023034]  vfs_write+0xc8/0x1d0
[  131.023034]  SyS_write+0x44/0xa0
[  131.023034]  entry_SYSCALL_64_fastpath+0x1f/0xbe

Reported-by: Andrey Ryabinin <aryabinin@virtuozzo.com>
Tested-by: Andrey Ryabinin <aryabinin@virtuozzo.com>
Cc: Michal Hocko <mhocko@kernel.org>
Cc: Vlastimil Babka <vbabka@suse.cz>
Cc: Daniel Kiper <dkiper@net-space.pl>
Cc: Vladimir Davydov <vdavydov.dev@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/swap.h |    1 +
 mm/memory_hotplug.c  |    4 ++--
 mm/swap.c            |   11 ++++++++---
 3 files changed, 11 insertions(+), 5 deletions(-)

diff -puN include/linux/swap.h~mm-change-cpuhotplug-lock-order-in-lru_add_drain_all include/linux/swap.h
--- a/include/linux/swap.h~mm-change-cpuhotplug-lock-order-in-lru_add_drain_all
+++ a/include/linux/swap.h
@@ -277,6 +277,7 @@ extern void mark_page_accessed(struct pa
 extern void lru_add_drain(void);
 extern void lru_add_drain_cpu(int cpu);
 extern void lru_add_drain_all(void);
+extern void lru_add_drain_all_cpuslocked(void);
 extern void rotate_reclaimable_page(struct page *page);
 extern void deactivate_file_page(struct page *page);
 extern void mark_page_lazyfree(struct page *page);
diff -puN mm/memory_hotplug.c~mm-change-cpuhotplug-lock-order-in-lru_add_drain_all mm/memory_hotplug.c
--- a/mm/memory_hotplug.c~mm-change-cpuhotplug-lock-order-in-lru_add_drain_all
+++ a/mm/memory_hotplug.c
@@ -1670,7 +1670,7 @@ repeat:
 		goto failed_removal;
 	ret = 0;
 	if (drain) {
-		lru_add_drain_all();
+		lru_add_drain_all_cpuslocked();
 		cond_resched();
 		drain_all_pages(zone);
 	}
@@ -1691,7 +1691,7 @@ repeat:
 		}
 	}
 	/* drain all zone's lru pagevec, this is asynchronous... */
-	lru_add_drain_all();
+	lru_add_drain_all_cpuslocked();
 	yield();
 	/* drain pcp pages, this is synchronous. */
 	drain_all_pages(zone);
diff -puN mm/swap.c~mm-change-cpuhotplug-lock-order-in-lru_add_drain_all mm/swap.c
--- a/mm/swap.c~mm-change-cpuhotplug-lock-order-in-lru_add_drain_all
+++ a/mm/swap.c
@@ -688,7 +688,7 @@ static void lru_add_drain_per_cpu(struct
 
 static DEFINE_PER_CPU(struct work_struct, lru_add_drain_work);
 
-void lru_add_drain_all(void)
+void lru_add_drain_all_cpuslocked(void)
 {
 	static DEFINE_MUTEX(lock);
 	static struct cpumask has_work;
@@ -702,7 +702,6 @@ void lru_add_drain_all(void)
 		return;
 
 	mutex_lock(&lock);
-	get_online_cpus();
 	cpumask_clear(&has_work);
 
 	for_each_online_cpu(cpu) {
@@ -722,10 +721,16 @@ void lru_add_drain_all(void)
 	for_each_cpu(cpu, &has_work)
 		flush_work(&per_cpu(lru_add_drain_work, cpu));
 
-	put_online_cpus();
 	mutex_unlock(&lock);
 }
 
+void lru_add_drain_all(void)
+{
+	get_online_cpus();
+	lru_add_drain_all_cpuslocked();
+	put_online_cpus();
+}
+
 /**
  * release_pages - batched put_page()
  * @pages: array of pages to release
_

Patches currently in -mm which might be from tglx@linutronix.de are


