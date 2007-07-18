From: akpm@linux-foundation.org
Subject: - x86_64-ratelimit-segfault-reporting-rate.patch removed from -mm tree
Date: Wed, 18 Jul 2007 09:34:37 -0700
Message-ID: <200707181634.l6IGYbEq018338@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:55579 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S934474AbXGRQe4 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 18 Jul 2007 12:34:56 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: righiandr@users.sourceforge.net, a.righi@cineca.it, ak@suse.de, mm-commits@vger.kernel.org


The patch titled
     x86_64: ratelimit segfault reporting rate
has been removed from the -mm tree.  Its filename was
     x86_64-ratelimit-segfault-reporting-rate.patch

This patch was dropped because it was nacked

------------------------------------------------------
Subject: x86_64: ratelimit segfault reporting rate
From: Andrea Righi <righiandr@users.sourceforge.net>

Limit the rate of the kernel logging for the segfaults of user
applications, to avoid potential message floods or denial-of-service
attacks.

Signed-off-by: Andrea Righi <a.righi@cineca.it>
Cc: Andi Kleen <ak@suse.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/x86_64/mm/fault.c |    3 ++-
 1 files changed, 2 insertions(+), 1 deletion(-)

diff -puN arch/x86_64/mm/fault.c~x86_64-ratelimit-segfault-reporting-rate arch/x86_64/mm/fault.c
--- a/arch/x86_64/mm/fault.c~x86_64-ratelimit-segfault-reporting-rate
+++ a/arch/x86_64/mm/fault.c
@@ -495,7 +495,8 @@ bad_area_nosemaphore:
 		    (address >> 32))
 			return;
 
-		if (exception_trace && unhandled_signal(tsk, SIGSEGV)) {
+		if (exception_trace && unhandled_signal(tsk, SIGSEGV) &&
+		    printk_ratelimit()) {
 			printk(
 		       "%s%s[%d]: segfault at %016lx rip %016lx rsp %016lx error %lx\n",
 					tsk->pid > 1 ? KERN_INFO : KERN_EMERG,
_

Patches currently in -mm which might be from righiandr@users.sourceforge.net are

x86_64-ratelimit-segfault-reporting-rate.patch
