From: akpm@linux-foundation.org
Subject: - avr32-ratelimit-segfault-reporting-rate.patch removed from -mm tree
Date: Wed, 30 May 2007 16:28:19 -0700
Message-ID: <200705302328.l4UNSIqW007744@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([207.189.120.13]:49266 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752172AbXE3X2c (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 30 May 2007 19:28:32 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: righiandr@users.sourceforge.net, a.righi@cineca.it, hskinnemoen@atmel.com, mm-commits@vger.kernel.org


The patch titled
     avr32: ratelimit segfault reporting rate
has been removed from the -mm tree.  Its filename was
     avr32-ratelimit-segfault-reporting-rate.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: avr32: ratelimit segfault reporting rate
From: Andrea Righi <righiandr@users.sourceforge.net>

Limit the rate of the kernel logging for the segfaults of user
applications, to avoid potential message floods or denial-of-service
attacks.

Signed-off-by: Andrea Righi <a.righi@cineca.it>
Cc: Haavard Skinnemoen <hskinnemoen@atmel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/avr32/mm/fault.c |    2 +-
 1 files changed, 1 insertion(+), 1 deletion(-)

diff -puN arch/avr32/mm/fault.c~avr32-ratelimit-segfault-reporting-rate arch/avr32/mm/fault.c
--- a/arch/avr32/mm/fault.c~avr32-ratelimit-segfault-reporting-rate
+++ a/arch/avr32/mm/fault.c
@@ -158,7 +158,7 @@ bad_area:
 	up_read(&mm->mmap_sem);
 
 	if (user_mode(regs)) {
-		if (exception_trace)
+		if (exception_trace && printk_ratelimit())
 			printk("%s%s[%d]: segfault at %08lx pc %08lx "
 			       "sp %08lx ecr %lu\n",
 			       is_init(tsk) ? KERN_EMERG : KERN_INFO,
_

Patches currently in -mm which might be from righiandr@users.sourceforge.net are

git-avr32.patch
x86_64-ratelimit-segfault-reporting-rate.patch
