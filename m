From: akpm@linux-foundation.org
Subject: + mm-thp-avoid-unnecessary-swapin-in-khugepaged-fix-2.patch added to -mm tree
Date: Fri, 27 May 2016 13:05:29 -0700
Message-ID: <5748a889.19hoxoA397f627+v%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:43949 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756150AbcE0UFb (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 27 May 2016 16:05:31 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: ebru.akagunduz@gmail.com, aarcange@redhat.com, aneesh.kumar@linux.vnet.ibm.com, gorcunov@openvz.org, hannes@cmpxchg.org, hughd@google.com, iamjoonsoo.kim@lge.com, kirill.shutemov@linux.intel.com, mgorman@suse.de, mhocko@suse.cz, minchan.kim@gmail.com, n-horiguchi@ah.jp.nec.com, riel@redhat.com, rientjes@google.com, vbabka@suse.cz, mm-commits@vger.kernel.org


The patch titled
     Subject: mm, thp: fix possible circular locking dependency caused by sum_vm_event()
has been added to the -mm tree.  Its filename is
     mm-thp-avoid-unnecessary-swapin-in-khugepaged-fix-2.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-thp-avoid-unnecessary-swapin-in-khugepaged-fix-2.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-thp-avoid-unnecessary-swapin-in-khugepaged-fix-2.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Ebru Akagunduz <ebru.akagunduz@gmail.com>
Subject: mm, thp: fix possible circular locking dependency caused by sum_vm_event()

Nested circular locking dependency detected by kernel robot (udevadm).

  udevadm/221 is trying to acquire lock:
   (&mm->mmap_sem){++++++}, at: [<ffffffff81262543>] __might_fault+0x83/0x150
  but task is already holding lock:
   (s_active#12){++++.+}, at: [<ffffffff813315ee>] kernfs_fop_write+0x8e/0x250
  which lock already depends on the new lock.

 Possible unsafe locking scenario:

 CPU0                    CPU1
 ----                    ----
 lock(s_active);
                         lock(cpu_hotplug.lock);
                         lock(s_active);
 lock(&mm->mmap_sem);

 the existing dependency chain (in reverse order) is:
 -> #2 (s_active#12){++++.+}:
        [<ffffffff8117da2c>] lock_acquire+0xac/0x180
        [<ffffffff8132f50a>] __kernfs_remove+0x2da/0x410
        [<ffffffff81330630>] kernfs_remove_by_name_ns+0x40/0x90
        [<ffffffff813339fb>] sysfs_remove_file_ns+0x2b/0x70
        [<ffffffff81ba8a16>] device_del+0x166/0x320
        [<ffffffff81ba943c>] device_destroy+0x3c/0x50
        [<ffffffff8105aa61>] cpuid_class_cpu_callback+0x51/0x70
        [<ffffffff81131ce9>] notifier_call_chain+0x59/0x190
        [<ffffffff81132749>] __raw_notifier_call_chain+0x9/0x10
        [<ffffffff810fe6b0>] __cpu_notify+0x40/0x90
        [<ffffffff810fe890>] cpu_notify_nofail+0x10/0x30
        [<ffffffff810fe8d7>] notify_dead+0x27/0x1e0
        [<ffffffff810fe273>] cpuhp_down_callbacks+0x93/0x190
        [<ffffffff82096062>] _cpu_down+0xc2/0x1e0
        [<ffffffff810ff727>] do_cpu_down+0x37/0x50
        [<ffffffff8110003b>] cpu_down+0xb/0x10
        [<ffffffff81038e4d>] _debug_hotplug_cpu+0x7d/0xd0
        [<ffffffff8435d6bb>] debug_hotplug_cpu+0xd/0x11
        [<ffffffff84352426>] do_one_initcall+0x138/0x1cf
        [<ffffffff8435270a>] kernel_init_freeable+0x24d/0x2de
        [<ffffffff8209533a>] kernel_init+0xa/0x120
        [<ffffffff820a7972>] ret_from_fork+0x22/0x50

 -> #1 (cpu_hotplug.lock#2){+.+.+.}:
        [<ffffffff8117da2c>] lock_acquire+0xac/0x180
        [<ffffffff820a20d1>] mutex_lock_nested+0x71/0x4c0
        [<ffffffff810ff526>] get_online_cpus+0x66/0x80
        [<ffffffff81246fb3>] sum_vm_event+0x23/0x1b0
        [<ffffffff81293768>] collapse_huge_page+0x118/0x10b0
        [<ffffffff81294c5d>] khugepaged+0x55d/0xe80
        [<ffffffff81130304>] kthread+0x134/0x1a0
        [<ffffffff820a7972>] ret_from_fork+0x22/0x50

 -> #0 (&mm->mmap_sem){++++++}:
        [<ffffffff8117bf61>] __lock_acquire+0x2861/0x31f0
        [<ffffffff8117da2c>] lock_acquire+0xac/0x180
        [<ffffffff8126257e>] __might_fault+0xbe/0x150
        [<ffffffff8133160f>] kernfs_fop_write+0xaf/0x250
        [<ffffffff812a8933>] __vfs_write+0x43/0x1a0
        [<ffffffff812a8d3a>] vfs_write+0xda/0x240
        [<ffffffff812a8f84>] SyS_write+0x44/0xa0
        [<ffffffff820a773c>] entry_SYSCALL_64_fastpath+0x1f/0xbd

This patch moves sum_vm_event() before taking down_write(&mm->mmap_sem)
to solve dependency lock.

Link: http://lkml.kernel.org/r/1464335964-6510-3-git-send-email-ebru.akagunduz@gmail.com
Signed-off-by: Ebru Akagunduz <ebru.akagunduz@gmail.com>
Cc: Hugh Dickins <hughd@google.com>
Cc: Rik van Riel <riel@redhat.com>
Cc: "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>
Cc: Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>
Cc: Andrea Arcangeli <aarcange@redhat.com>
Cc: Joonsoo Kim <iamjoonsoo.kim@lge.com>
Cc: Cyrill Gorcunov <gorcunov@openvz.org>
Cc: Mel Gorman <mgorman@suse.de>
Cc: David Rientjes <rientjes@google.com>
Cc: Vlastimil Babka <vbabka@suse.cz>
Cc: Aneesh Kumar K.V <aneesh.kumar@linux.vnet.ibm.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Michal Hocko <mhocko@suse.cz>
Cc: Minchan Kim <minchan.kim@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/huge_memory.c |    5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff -puN mm/huge_memory.c~mm-thp-avoid-unnecessary-swapin-in-khugepaged-fix-2 mm/huge_memory.c
--- a/mm/huge_memory.c~mm-thp-avoid-unnecessary-swapin-in-khugepaged-fix-2
+++ a/mm/huge_memory.c
@@ -2451,6 +2451,9 @@ static void collapse_huge_page(struct mm
 		goto out_nolock;
 	}
 
+	swap = get_mm_counter(mm, MM_SWAPENTS);
+	curr_allocstall = sum_vm_event(ALLOCSTALL);
+
 	/*
 	 * Prevent all access to pagetables with the exception of
 	 * gup_fast later hanlded by the ptep_clear_flush and the VM
@@ -2483,8 +2486,6 @@ static void collapse_huge_page(struct mm
 		goto out;
 	}
 
-	swap = get_mm_counter(mm, MM_SWAPENTS);
-	curr_allocstall = sum_vm_event(ALLOCSTALL);
 	/*
 	 * Don't perform swapin readahead when the system is under pressure,
 	 * to avoid unnecessary resource consumption.
_

Patches currently in -mm which might be from ebru.akagunduz@gmail.com are

mm-make-optimistic-check-for-swapin-readahead.patch
mm-make-optimistic-check-for-swapin-readahead-fix-3.patch
mm-make-swapin-readahead-to-improve-thp-collapse-rate.patch
mm-vmstat-calculate-particular-vm-event.patch
mm-thp-avoid-unnecessary-swapin-in-khugepaged.patch
mm-thp-avoid-unnecessary-swapin-in-khugepaged-fix-2.patch
mm-thp-make-swapin-readahead-under-down_read-of-mmap_sem.patch

