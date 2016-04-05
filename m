From: akpm@linux-foundation.org
Subject: + mm-mmap-kill-hook-arch_rebalance_pgtables.patch added to -mm
 tree
Date: Tue, 05 Apr 2016 13:33:05 -0700
Message-ID: <57042101.CXb1ibUHqalJA0TA%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:49736 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751544AbcDEUdG (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 5 Apr 2016 16:33:06 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: koct9i@gmail.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm/mmap: kill hook arch_rebalance_pgtables()
has been added to the -mm tree.  Its filename is
     mm-mmap-kill-hook-arch_rebalance_pgtables.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-mmap-kill-hook-arch_rebalance_pgtables.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-mmap-kill-hook-arch_rebalance_pgtables.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Konstantin Khlebnikov <koct9i@gmail.com>
Subject: mm/mmap: kill hook arch_rebalance_pgtables()

Nobody uses it.

Signed-off-by: Konstantin Khlebnikov <koct9i@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/mmap.c |    5 -----
 1 file changed, 5 deletions(-)

diff -puN mm/mmap.c~mm-mmap-kill-hook-arch_rebalance_pgtables mm/mmap.c
--- a/mm/mmap.c~mm-mmap-kill-hook-arch_rebalance_pgtables
+++ a/mm/mmap.c
@@ -55,10 +55,6 @@
 #define arch_mmap_check(addr, len, flags)	(0)
 #endif
 
-#ifndef arch_rebalance_pgtables
-#define arch_rebalance_pgtables(addr, len)		(addr)
-#endif
