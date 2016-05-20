From: akpm@linux-foundation.org
Subject: [patch 072/117] mm/mmap: kill hook arch_rebalance_pgtables()
Date: Thu, 19 May 2016 17:12:32 -0700
Message-ID: <573e5670.08iosOV7zqluvavJ%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:46380 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932831AbcETAMd (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 19 May 2016 20:12:33 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: torvalds@linux-foundation.org, mm-commits@vger.kernel.org, akpm@linux-foundation.org, koct9i@gmail.com

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
