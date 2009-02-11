From: akpm@linux-foundation.org
Subject: [folded] clocksource-pass-clocksource-to-read-callback-fix.patch removed from -mm tree
Date: Wed, 11 Feb 2009 13:21:47 -0800
Message-ID: <200902112121.n1BLLl6x023733@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:48665 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756768AbZBKVVv (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 11 Feb 2009 16:21:51 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: magnus.damm@gmail.com, lethal@linux-sh.org, mm-commits@vger.kernel.org


The patch titled
     clocksource-pass-clocksource-to-read-callback fix
has been removed from the -mm tree.  Its filename was
     clocksource-pass-clocksource-to-read-callback-fix.patch

This patch was dropped because it was folded into clocksource-pass-clocksource-to-read-callback.patch

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: clocksource-pass-clocksource-to-read-callback fix
From: Magnus Damm <magnus.damm@gmail.com>

post-conflict fixup

Cc: Paul Mundt <lethal@linux-sh.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/sh/kernel/time_32.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN arch/sh/kernel/time_32.c~clocksource-pass-clocksource-to-read-callback-fix arch/sh/kernel/time_32.c
--- a/arch/sh/kernel/time_32.c~clocksource-pass-clocksource-to-read-callback-fix
+++ a/arch/sh/kernel/time_32.c
@@ -208,7 +208,7 @@ unsigned long long sched_clock(void)
 	if (!clocksource_sh.rating)
 		return (unsigned long long)jiffies * (NSEC_PER_SEC / HZ);
 
-	cycles = clocksource_sh.read();
+	cycles = clocksource_sh.read(&clocksource_sh);
 	return cyc2ns(&clocksource_sh, cycles);
 }
 #endif
_

Patches currently in -mm which might be from magnus.damm@gmail.com are

linux-next.patch
clocksource-pass-clocksource-to-read-callback.patch
clocksource-pass-clocksource-to-read-callback-fix.patch

