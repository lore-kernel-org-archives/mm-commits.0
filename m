From: akpm@linux-foundation.org
Subject: + mm-memcontrol-per-lruvec-stats-infrastructure-fix-5.patch added to -mm tree
Date: Mon, 19 Jun 2017 11:55:21 -0700
Message-ID: <59481e19.QOHmHDFAJCe/l1Xr%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:49450 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753564AbdFSSzW (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 19 Jun 2017 14:55:22 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: linux@roeck-us.net, hannes@cmpxchg.org, mm-commits@vger.kernel.org


The patch titled
     Subject: hexagon: fix build error caused by include file order
has been added to the -mm tree.  Its filename is
     mm-memcontrol-per-lruvec-stats-infrastructure-fix-5.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-memcontrol-per-lruvec-stats-infrastructure-fix-5.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-memcontrol-per-lruvec-stats-infrastructure-fix-5.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Guenter Roeck <linux@roeck-us.net>
Subject: hexagon: fix build error caused by include file order

hexagon builds fail with the following error message.
In file included from ./include/linux/memcontrol.h:30:0,
                 from ./include/linux/swap.h:8,
		 from ./arch/hexagon/include/asm/pgtable.h:27,
		from ./include/linux/mm.h:70,
		from arch/hexagon/kernel/asm-offsets.c:28:
./include/linux/vmstat.h: In function '__inc_zone_page_state':
./include/linux/vmstat.h:294:2: error:
	implicit declaration of function 'page_zone'

Drop unnecessary includes from header files and add missing
includes to source files to fix the problem.

Fixes: fb6646f52c45 ("mm: memcontrol: per-lruvec stats infrastructure")
Link: http://lkml.kernel.org/r/20170617153721.GA4382@roeck-us.net
Signed-off-by: Guenter Roeck <linux@roeck-us.net>
Acked-by: Johannes Weiner <hannes@cmpxchg.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/hexagon/include/asm/pgtable.h |    1 -
 arch/hexagon/kernel/asm-offsets.c  |    1 -
 arch/hexagon/mm/vm_tlb.c           |    1 +
 3 files changed, 1 insertion(+), 2 deletions(-)

diff -puN arch/hexagon/include/asm/pgtable.h~mm-memcontrol-per-lruvec-stats-infrastructure-fix-5 arch/hexagon/include/asm/pgtable.h
--- a/arch/hexagon/include/asm/pgtable.h~mm-memcontrol-per-lruvec-stats-infrastructure-fix-5
+++ a/arch/hexagon/include/asm/pgtable.h
@@ -24,7 +24,6 @@
 /*
  * Page table definitions for Qualcomm Hexagon processor.
  */
-#include <linux/swap.h>
 #include <asm/page.h>
 #define __ARCH_USE_5LEVEL_HACK
 #include <asm-generic/pgtable-nopmd.h>
diff -puN arch/hexagon/kernel/asm-offsets.c~mm-memcontrol-per-lruvec-stats-infrastructure-fix-5 arch/hexagon/kernel/asm-offsets.c
--- a/arch/hexagon/kernel/asm-offsets.c~mm-memcontrol-per-lruvec-stats-infrastructure-fix-5
+++ a/arch/hexagon/kernel/asm-offsets.c
@@ -25,7 +25,6 @@
 #include <linux/compat.h>
 #include <linux/types.h>
 #include <linux/sched.h>
-#include <linux/mm.h>
 #include <linux/interrupt.h>
 #include <linux/kbuild.h>
 #include <asm/ptrace.h>
diff -puN arch/hexagon/mm/vm_tlb.c~mm-memcontrol-per-lruvec-stats-infrastructure-fix-5 arch/hexagon/mm/vm_tlb.c
--- a/arch/hexagon/mm/vm_tlb.c~mm-memcontrol-per-lruvec-stats-infrastructure-fix-5
+++ a/arch/hexagon/mm/vm_tlb.c
@@ -24,6 +24,7 @@
  * be instantiated for it, differently from a native build.
  */
 #include <linux/mm.h>
+#include <linux/sched.h>
 #include <asm/page.h>
 #include <asm/hexagon_vm.h>
 
_

Patches currently in -mm which might be from linux@roeck-us.net are

mm-memcontrol-per-lruvec-stats-infrastructure-fix-5.patch

