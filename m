From: akpm@linux-foundation.org
Subject: [obsolete] sched-use-for_each_set_bit.patch removed from -mm tree
Date: Wed, 03 Feb 2010 09:52:35 -0800
Message-ID: <201002031752.o13HqZJA008812@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:39408 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932806Ab0BCR7O (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 3 Feb 2010 12:59:14 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akinobu.mita@gmail.com, mingo@elte.hu, peterz@infradead.org, mm-commits@vger.kernel.org


The patch titled
     sched: use for_each_set_bit()
has been removed from the -mm tree.  Its filename was
     sched-use-for_each_set_bit.patch

This patch was dropped because it is obsolete

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: sched: use for_each_set_bit()
From: Akinobu Mita <akinobu.mita@gmail.com>

Replace open-coded loop with for_each_set_bit().

Signed-off-by: Akinobu Mita <akinobu.mita@gmail.com>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Peter Zijlstra <peterz@infradead.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/sched_cpupri.c |    4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

diff -puN kernel/sched_cpupri.c~sched-use-for_each_set_bit kernel/sched_cpupri.c
--- a/kernel/sched_cpupri.c~sched-use-for_each_set_bit
+++ a/kernel/sched_cpupri.c
@@ -47,9 +47,7 @@ static int convert_prio(int prio)
 }
 
 #define for_each_cpupri_active(array, idx)                    \
-  for (idx = find_first_bit(array, CPUPRI_NR_PRIORITIES);     \
-       idx < CPUPRI_NR_PRIORITIES;                            \
-       idx = find_next_bit(array, CPUPRI_NR_PRIORITIES, idx+1))
+	for_each_set_bit(idx, array, CPUPRI_NR_PRIORITIES)
 
 /**
  * cpupri_find - find the best (lowest-pri) CPU in the system
_

Patches currently in -mm which might be from akinobu.mita@gmail.com are

origin.patch
linux-next.patch
bitops-rename-for_each_bit-to-for_each_set_bit.patch
bitops-rename-for_each_bit-to-for_each_set_bit-fix.patch
hpet-use-for_each_set_bit.patch
intel-iommu-use-for_each_set_bit.patch
infiniband-use-for_each_set_bit.patch
ntfs-use-bitmap_weight.patch
phonet-use-for_each_set_bit.patch
atm-use-for_each_set_bit.patch
sched-use-for_each_set_bit.patch
bitmap-use-for_each_set_bit.patch
sgi-gru-use-for_each_set_bit.patch

