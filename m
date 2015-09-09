From: akpm@linux-foundation.org
Subject: [merged]
 sparc32-do-not-include-swaph-from-pgtable_32h-export-struct-mem_cgroup.patch removed from -mm tree
Date: Wed, 09 Sep 2015 12:45:42 -0700
Message-ID: <55f08c66.01jPR2K3VEd1dLwZ%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:39035 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753141AbbIITpn (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 9 Sep 2015 15:45:43 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mhocko@suse.com, davem@davemloft.net, linux@roeck-us.net, mm-commits@vger.kernel.org


The patch titled
     Subject: sparc32: do not include swap.h from pgtable_32.h
has been removed from the -mm tree.  Its filename was
     sparc32-do-not-include-swaph-from-pgtable_32h-export-struct-mem_cgroup.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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


