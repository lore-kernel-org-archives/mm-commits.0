From: akpm@linux-foundation.org
Subject: +
 sparc32-do-not-include-swaph-from-pgtable_32h-export-struct-mem_cgroup.patch added to -mm tree
Date: Tue, 04 Aug 2015 14:26:24 -0700
Message-ID: <55c12e00.G/XhujFjlg5mmu1x%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:56324 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752621AbbHDV0Z (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 4 Aug 2015 17:26:25 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mhocko@suse.com, davem@davemloft.net, linux@roeck-us.net, mm-commits@vger.kernel.org


The patch titled
     Subject: sparc32: do not include swap.h from pgtable_32.h
has been added to the -mm tree.  Its filename is
     sparc32-do-not-include-swaph-from-pgtable_32h-export-struct-mem_cgroup.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/sparc32-do-not-include-swaph-from-pgtable_32h-export-struct-mem_cgroup.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/sparc32-do-not-include-swaph-from-pgtable_32h-export-struct-mem_cgroup.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Michal Hocko <mhocko@suse.com>
Subject: sparc32: do not include swap.h from pgtable_32.h

"memcg: export struct mem_cgroup" will add includes into
linux/memcontrol.h which lead to further header dependency issues as
reported by Guenter Roeck:

In file included from include/linux/highmem.h:7:0,
                 from include/linux/bio.h:23,
                 from include/linux/writeback.h:192,
                 from include/linux/memcontrol.h:30,
                 from include/linux/swap.h:8,
                 from ./arch/sparc/include/asm/pgtable_32.h:17,
                 from ./arch/sparc/include/asm/pgtable.h:6,
                 from arch/sparc/kernel/traps_32.c:23:
include/linux/mm.h: In function 'is_vmalloc_addr':
include/linux/mm.h:371:17: error: 'VMALLOC_START' undeclared (first use in this function)
include/linux/mm.h:371:17: note: each undeclared identifier is reported only once for each function it appears in
include/linux/mm.h:371:41: error: 'VMALLOC_END' undeclared (first use in this function)
include/linux/mm.h: In function 'maybe_mkwrite':
include/linux/mm.h:556:3: error: implicit declaration of function 'pte_mkwrite'

The issue is that pgtable_32.h depends on swap.h to get swap_entry_t but
that goes all the way down to linux/mm.h which wants to have VMALLOC_*
which is defined later in pgtable_32.h, though.

swap_entry_t is defined in include/mm_types.h so it should be sufficient
to include this header without more dependencies.

Signed-off-by: Michal Hocko <mhocko@suse.com>
Reported-by: Guenter Roeck <linux@roeck-us.net>
Tested-by: Guenter Roeck <linux@roeck-us.net>
Cc: David Miller <davem@davemloft.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/sparc/include/asm/pgtable_32.h |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN arch/sparc/include/asm/pgtable_32.h~sparc32-do-not-include-swaph-from-pgtable_32h-export-struct-mem_cgroup arch/sparc/include/asm/pgtable_32.h
--- a/arch/sparc/include/asm/pgtable_32.h~sparc32-do-not-include-swaph-from-pgtable_32h-export-struct-mem_cgroup
+++ a/arch/sparc/include/asm/pgtable_32.h
@@ -14,7 +14,7 @@
 #include <asm-generic/4level-fixup.h>
 
 #include <linux/spinlock.h>
-#include <linux/swap.h>
+#include <linux/mm_types.h>
 #include <asm/types.h>
 #include <asm/pgtsrmmu.h>
 #include <asm/vaddrs.h>
_

Patches currently in -mm which might be from mhocko@suse.com are

mm-send-one-ipi-per-cpu-to-tlb-flush-all-entries-after-unmapping-pages-fix.patch
mm-oom-remove-unnecessary-variable.patch
sparc32-do-not-include-swaph-from-pgtable_32h-export-struct-mem_cgroup.patch
memcg-move-memcg_proto_active-from-sockh.patch
mm-srcu-ify-shrinkers.patch

