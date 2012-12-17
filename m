From: akpm@linux-foundation.org
Subject: + mm-suppress-mm-memoryo-warning-on-older-compilers-if-config_numa_balancing.patch added to -mm tree
Date: Mon, 17 Dec 2012 12:50:20 -0800
Message-ID: <20121217205021.1B614100048@wpzn3.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-qa0-f74.google.com ([209.85.216.74]:53301 "EHLO
	mail-qa0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753389Ab2LQUuW (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 17 Dec 2012 15:50:22 -0500
Received: by mail-qa0-f74.google.com with SMTP id r4so2090qaq.1
        for <mm-commits@vger.kernel.org>; Mon, 17 Dec 2012 12:50:21 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: mgorman@suse.de


The patch titled
     Subject: mm: suppress mm/memory.o warning on older compilers if !CONFIG_NUMA_BALANCING
has been added to the -mm tree.  Its filename is
     mm-suppress-mm-memoryo-warning-on-older-compilers-if-config_numa_balancing.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Mel Gorman <mgorman@suse.de>
Subject: mm: suppress mm/memory.o warning on older compilers if !CONFIG_NUMA_BALANCING

The kbuild test robot reported the following after the merge of Automatic
NUMA Balancing when cross-compiling for avr32.

mm/memory.c: In function 'do_pmd_numa_page':
mm/memory.c:3593: warning: no return statement in function returning non-void

The code is unreachable but the avr32 cross-compiler was not new enough
to know that. This patch suppresses the warning.

Signed-off-by: Mel Gorman <mgorman@suse.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memory.c |    1 +
 1 file changed, 1 insertion(+)

diff -puN mm/memory.c~mm-suppress-mm-memoryo-warning-on-older-compilers-if-config_numa_balancing mm/memory.c
--- a/mm/memory.c~mm-suppress-mm-memoryo-warning-on-older-compilers-if-config_numa_balancing
+++ a/mm/memory.c
@@ -3590,6 +3590,7 @@ static int do_pmd_numa_page(struct mm_st
 		     unsigned long addr, pmd_t *pmdp)
 {
 	BUG();
+	return 0;
 }
 #endif /* CONFIG_NUMA_BALANCING */
 
_

Patches currently in -mm which might be from mgorman@suse.de are

origin.patch
linux-next.patch
mm-memmap_init_zone-performance-improvement.patch
mm-allocate-kernel-pages-to-the-right-memcg.patch
mm-suppress-mm-memoryo-warning-on-older-compilers-if-config_numa_balancing.patch
mm-suppress-mm-memoryo-warning-on-older-compilers-if-config_numa_balancing-fix.patch

