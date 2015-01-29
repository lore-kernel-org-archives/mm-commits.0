From: akpm@linux-foundation.org
Subject: + mm-fix-arithmetic-overflow-in-__vm_enough_memory.patch added to -mm tree
Date: Thu, 29 Jan 2015 13:51:04 -0800
Message-ID: <54caab48.crnFYLBZIeKCwAEd%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:58672 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758860AbbA2VvF (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 29 Jan 2015 16:51:05 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: klamm@yandex-team.ru, agshew@gmail.com, khlebnikov@yandex-team.ru, riel@redhat.com, stable@vger.kernel.org, mm-commits@vger.kernel.org


The patch titled
     Subject: mm/mmap.c: fix arithmetic overflow in __vm_enough_memory()
has been added to the -mm tree.  Its filename is
     mm-fix-arithmetic-overflow-in-__vm_enough_memory.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-fix-arithmetic-overflow-in-__vm_enough_memory.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-fix-arithmetic-overflow-in-__vm_enough_memory.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Roman Gushchin <klamm@yandex-team.ru>
Subject: mm/mmap.c: fix arithmetic overflow in __vm_enough_memory()

I noticed, that "allowed" can easily overflow by falling below 0, because
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

 mm/mmap.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff -puN mm/mmap.c~mm-fix-arithmetic-overflow-in-__vm_enough_memory mm/mmap.c
--- a/mm/mmap.c~mm-fix-arithmetic-overflow-in-__vm_enough_memory
+++ a/mm/mmap.c
@@ -152,7 +152,7 @@ EXPORT_SYMBOL_GPL(vm_memory_committed);
  */
 int __vm_enough_memory(struct mm_struct *mm, long pages, int cap_sys_admin)
 {
-	unsigned long free, allowed, reserve;
+	long free, allowed, reserve;
 
 	VM_WARN_ONCE(percpu_counter_read(&vm_committed_as) <
 			-(s64)vm_committed_as_batch * num_online_cpus(),
@@ -220,7 +220,7 @@ int __vm_enough_memory(struct mm_struct
 	 */
 	if (mm) {
 		reserve = sysctl_user_reserve_kbytes >> (PAGE_SHIFT - 10);
-		allowed -= min(mm->total_vm / 32, reserve);
+		allowed -= min((long)mm->total_vm / 32, reserve);
 	}
 
 	if (percpu_counter_read_positive(&vm_committed_as) < allowed)
_

Patches currently in -mm which might be from klamm@yandex-team.ru are

mm-fix-arithmetic-overflow-in-__vm_enough_memory.patch
mm-fix-arithmetic-overflow-in-__vm_enough_memory-fix.patch

