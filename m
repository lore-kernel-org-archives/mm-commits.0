From: akpm@linux-foundation.org
Subject: [merged] clockeventsc-fix-symbol-was-not-declared-noise.patch removed from -mm tree
Date: Mon, 30 Nov 2009 12:34:05 -0800
Message-ID: <200911302034.nAUKY5Bj022694@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:53000 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751098AbZK3UnK (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 30 Nov 2009 15:43:10 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: hartleys@visionengravers.com, hsweeten@visionengravers.com, mingo@elte.hu, tglx@linutronix.de, yong.zhang0@gmail.com, mm-commits@vger.kernel.org


The patch titled
     clockevents.c: fix symbol was not declared noise
has been removed from the -mm tree.  Its filename was
     clockeventsc-fix-symbol-was-not-declared-noise.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: clockevents.c: fix symbol was not declared noise
From: "H Hartley Sweeten" <hartleys@visionengravers.com>

Include "tick-internal.h" in order to pick up the extern function
prototype for clockevents_shutdown().  This quiets the following sparse
build noise:

  warning: symbol 'clockevents_shutdown' was not declared. Should it be static?

Signed-off-by: H Hartley Sweeten <hsweeten@visionengravers.com>
Reviewed-by: Yong Zhang <yong.zhang0@gmail.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Ingo Molnar <mingo@elte.hu>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/time/clockevents.c |    2 ++
 1 file changed, 2 insertions(+)

diff -puN kernel/time/clockevents.c~clockeventsc-fix-symbol-was-not-declared-noise kernel/time/clockevents.c
--- a/kernel/time/clockevents.c~clockeventsc-fix-symbol-was-not-declared-noise
+++ a/kernel/time/clockevents.c
@@ -20,6 +20,8 @@
 #include <linux/sysdev.h>
 #include <linux/tick.h>
 
+#include "tick-internal.h"
+
 /* The registered clock event devices */
 static LIST_HEAD(clockevent_devices);
 static LIST_HEAD(clockevents_released);
_

Patches currently in -mm which might be from hartleys@visionengravers.com are

linux-next.patch
drivers-block-mg_diskc-use-resource_size.patch
security-min_addrc-make-init_mmap_min_addr-static.patch
drivers-misc-add-driver-for-texas-instruments-dac7512.patch
drivers-misc-add-driver-for-texas-instruments-dac7512-update.patch
init-mainc-fix-symbol-shadows-noise.patch
kernel-sysc-fix-warning-do-while-statement-is-not-a-compound-statement-noise.patch

