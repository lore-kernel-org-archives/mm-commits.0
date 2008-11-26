From: akpm@linux-foundation.org
Subject: - init-mainc-use-ktime-accessor-function-in-initcall_debug-code.patch removed from -mm tree
Date: Wed, 26 Nov 2008 12:46:38 -0800
Message-ID: <200811262046.mAQKkcuW010896@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:36318 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752943AbYKZU5O (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 26 Nov 2008 15:57:14 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: will.newton@gmail.com, mingo@elte.hu, tglx@linutronix.de, tim.bird@am.sony.com, mm-commits@vger.kernel.org


The patch titled
     init/main.c: use ktime accessor function in initcall_debug code.
has been removed from the -mm tree.  Its filename was
     init-mainc-use-ktime-accessor-function-in-initcall_debug-code.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: init/main.c: use ktime accessor function in initcall_debug code.
From: "Will Newton" <will.newton@gmail.com>

The initcall_debug code access the tv64 member of ktime.  This won't work
correctly for large deltas on platforms that don't use the scalar ktime
implementation.

Signed-off-by: Will Newton <will.newton@gmail.com>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Thomas Gleixner <tglx@linutronix.de>
Acked-by: Tim Bird <tim.bird@am.sony.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 init/main.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN init/main.c~init-mainc-use-ktime-accessor-function-in-initcall_debug-code init/main.c
--- a/init/main.c~init-mainc-use-ktime-accessor-function-in-initcall_debug-code
+++ a/init/main.c
@@ -726,7 +726,7 @@ int do_one_initcall(initcall_t fn)
 	if (initcall_debug) {
 		it.rettime = ktime_get();
 		delta = ktime_sub(it.rettime, it.calltime);
-		it.duration = (unsigned long long) delta.tv64 >> 10;
+		it.duration = (unsigned long long) ktime_to_ns(delta) >> 10;
 		printk("initcall %pF returned %d after %Ld usecs\n", fn,
 			it.result, it.duration);
 		trace_boot(&it, fn);
_

Patches currently in -mm which might be from will.newton@gmail.com are

linux-next.patch

