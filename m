From: akpm@linux-foundation.org
Subject: [merged]
 mm-nommuc-fix-arithmetic-overflow-in-__vm_enough_memory.patch removed from
 -mm tree
Date: Thu, 12 Feb 2015 11:39:12 -0800
Message-ID: <54dd0160.4WcJGn9HS5vKac0r%akpm__6394.4140253172$1423769958$gmane$org@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:58580 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752442AbbBLTjN (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 12 Feb 2015 14:39:13 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: klamm@yandex-team.ru, agshew@gmail.com, khlebnikov@yandex-team.ru, riel@redhat.com, stable@vger.kernel.org, mm-commits@vger.kernel.org


The patch titled
     Subject: mm/nommu.c: fix arithmetic overflow in __vm_enough_memory()
has been removed from the -mm tree.  Its filename was
     mm-nommuc-fix-arithmetic-overflow-in-__vm_enough_memory.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Roman Gushchin <klamm@yandex-team.ru>
Subject: mm/nommu.c: fix arithmetic overflow in __vm_enough_memory()

I noticed that "allowed" can easily overflow by falling below 0, because
(total_vm / 32) can be larger than "allowed".  The problem occurs in
OVERCOMMIT_NONE mode.

In this case, a huge allocation can success and overcommit the system
(despite OVERCOMMIT_NONE mode).  All subsequent allocations will fall
(system-wide), so system become unusable.

The problem was masked out by commit c9b1d0981fcc
("mm: limit growth of 3% hardcoded other user reserve"),
but it's easy to reproduce it on older kernels:
1) set overcommit_memory sysctl to 2
2) mmap() large file multiple times (with VM_SHARED flag)
3) try to malloc() large amount of memory

It also can be reproduced on newer kernels, but miss-configured
sysctl_user_reserve_kbytes is required.

Fix this issue by switching to signed arithmetic here.

Signed-off-by: Roman Gushchin <klamm@yandex-team.ru>
Cc: Andrew Shewmaker <agshew@gmail.com>
Cc: Rik van Riel <riel@redhat.com>
Cc: Konstantin Khlebnikov <khlebnikov@yandex-team.ru>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/nommu.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff -puN mm/nommu.c~mm-nommuc-fix-arithmetic-overflow-in-__vm_enough_memory mm/nommu.c
--- a/mm/nommu.c~mm-nommuc-fix-arithmetic-overflow-in-__vm_enough_memory
+++ a/mm/nommu.c
@@ -1928,7 +1928,7 @@ EXPORT_SYMBOL(unmap_mapping_range);
  */
 int __vm_enough_memory(struct mm_struct *mm, long pages, int cap_sys_admin)
 {
-	unsigned long free, allowed, reserve;
+	long free, allowed, reserve;
 
 	vm_acct_memory(pages);
 
@@ -1992,7 +1992,7 @@ int __vm_enough_memory(struct mm_struct
 	 */
 	if (mm) {
 		reserve = sysctl_user_reserve_kbytes >> (PAGE_SHIFT - 10);
-		allowed -= min(mm->total_vm / 32, reserve);
+		allowed -= min_t(long, mm->total_vm / 32, reserve);
 	}
 
 	if (percpu_counter_read_positive(&vm_committed_as) < allowed)
_

Patches currently in -mm which might be from klamm@yandex-team.ru are

origin.patch

