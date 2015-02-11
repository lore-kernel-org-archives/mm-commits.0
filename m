From: akpm@linux-foundation.org
Subject: [folded-merged]
 mm-fix-arithmetic-overflow-in-__vm_enough_memory-fix.patch removed from -mm tree
Date: Wed, 11 Feb 2015 15:20:11 -0800
Message-ID: <54dbe3ab.F5jvqeinVeykp+7j%akpm__32689.16558377$1423696822$gmane$org@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:43322 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752452AbbBKXUM (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 11 Feb 2015 18:20:12 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, agshew@gmail.com, khlebnikov@yandex-team.ru, klamm@yandex-team.ru, riel@redhat.com, stable@vger.kernel.org, mm-commits@vger.kernel.org


The patch titled
     Subject: mm-fix-arithmetic-overflow-in-__vm_enough_memory-fix
has been removed from the -mm tree.  Its filename was
     mm-fix-arithmetic-overflow-in-__vm_enough_memory-fix.patch

This patch was dropped because it was folded into mm-fix-arithmetic-overflow-in-__vm_enough_memory.patch

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: mm-fix-arithmetic-overflow-in-__vm_enough_memory-fix

use min_t

Cc: <stable@vger.kernel.org>
Cc: Andrew Shewmaker <agshew@gmail.com>
Cc: Konstantin Khlebnikov <khlebnikov@yandex-team.ru>
Cc: Rik van Riel <riel@redhat.com>
Cc: Roman Gushchin <klamm@yandex-team.ru>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/mmap.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN mm/mmap.c~mm-fix-arithmetic-overflow-in-__vm_enough_memory-fix mm/mmap.c
--- a/mm/mmap.c~mm-fix-arithmetic-overflow-in-__vm_enough_memory-fix
+++ a/mm/mmap.c
@@ -220,7 +220,7 @@ int __vm_enough_memory(struct mm_struct
 	 */
 	if (mm) {
 		reserve = sysctl_user_reserve_kbytes >> (PAGE_SHIFT - 10);
-		allowed -= min((long)mm->total_vm / 32, reserve);
+		allowed -= min_t(long, mm->total_vm / 32, reserve);
 	}
 
 	if (percpu_counter_read_positive(&vm_committed_as) < allowed)
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

origin.patch
mm-page_allocc-__alloc_pages_nodemask-dont-alter-arg-gfp_mask.patch
vmscan-force-scan-offline-memory-cgroups.patch
mm-memcontrol-default-hierarchy-interface-for-memory.patch
mm-memcontrol-fold-move_anon-and-move_file.patch
mm-compaction-enhance-tracepoint-output-for-compaction-begin-end.patch
mm-thp-allocate-transparent-hugepages-on-local-node.patch
docs-procs-describe-proc-pid-map_files-entry.patch
mm-page_ext-remove-unnecessary-stack_trace-field.patch
mm-fix-arithmetic-overflow-in-__vm_enough_memory.patch

