From: akpm@linux-foundation.org
Subject: [merged] disable-wframe-larger-than-warnings-with-kasan=y.patch
 removed from -mm tree
Date: Fri, 30 Oct 2015 12:44:45 -0700
Message-ID: <5633c8ad.CxDjt5MMAcgEBirZ%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:42032 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760469AbbJ3Toq (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 30 Oct 2015 15:44:46 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: aryabinin@virtuozzo.com, andi@firstfloor.org, aospan@netup.ru, fengguang.wu@intel.com, m.chehab@samsung.com, mingo@kernel.org, serjk@netup.ru, mm-commits@vger.kernel.org


The patch titled
     Subject: lib/Kconfig.debug: disable -Wframe-larger-than warnings with KASAN=y
has been removed from the -mm tree.  Its filename was
     disable-wframe-larger-than-warnings-with-kasan=y.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Andrey Ryabinin <aryabinin@virtuozzo.com>
Subject: lib/Kconfig.debug: disable -Wframe-larger-than warnings with KASAN=y

When the kernel compiled with KASAN=y, GCC adds redzones for each variable
on stack.  This enlarges function's stack frame and causes:

	'warning: the frame size of X bytes is larger than Y bytes'

The worst case I've seen for now is following:
 ../net/wireless/nl80211.c: In function `nl80211_send_wiphy':
 ../net/wireless/nl80211.c:1731:1: warning: the frame size of 5448 bytes is larger than 2048 bytes [-Wframe-larger-than=]
  }

That kind of warning becomes useless with KASAN=y.  It doesn't necessarily
indicate that there is some problem in the code, thus we should turn it
off.

(The KASAN=y stack size in increased from 16k to 32k for this reason)

Signed-off-by: Andrey Ryabinin <aryabinin@virtuozzo.com>
Reported-by: Fengguang Wu <fengguang.wu@intel.com>
Acked-by: Abylay Ospan <aospan@netup.ru>
Cc: Andi Kleen <andi@firstfloor.org>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: Mauro Carvalho Chehab <m.chehab@samsung.com>
Cc: Kozlov Sergey <serjk@netup.ru>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/Kconfig.debug |    1 +
 1 file changed, 1 insertion(+)

diff -puN lib/Kconfig.debug~disable-wframe-larger-than-warnings-with-kasan=y lib/Kconfig.debug
--- a/lib/Kconfig.debug~disable-wframe-larger-than-warnings-with-kasan=y
+++ a/lib/Kconfig.debug
@@ -197,6 +197,7 @@ config ENABLE_MUST_CHECK
 config FRAME_WARN
 	int "Warn for stack frames larger than (needs gcc 4.4)"
 	range 0 8192
+	default 0 if KASAN
 	default 1024 if !64BIT
 	default 2048 if 64BIT
 	help
_

Patches currently in -mm which might be from aryabinin@virtuozzo.com are

mm-slub-kasan-enable-user-tracking-by-default-with-kasan=y.patch
kasan-always-taint-kernel-on-report.patch

