From: akpm@linux-foundation.org
Subject: + clockeventsc-fix-symbol-was-not-declared-noise.patch added to -mm tree
Date: Mon, 02 Nov 2009 16:22:20 -0800
Message-ID: <200911030022.nA30MKAl024444@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:46181 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755174AbZKCAWo (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 2 Nov 2009 19:22:44 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: hartleys@visionengravers.com, hsweeten@visionengravers.com, mingo@elte.hu, tglx@linutronix.de, yong.zhang0@gmail.com


The patch titled
     clockevents.c: fix symbol was not declared noise
has been added to the -mm tree.  Its filename is
     clockeventsc-fix-symbol-was-not-declared-noise.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://userweb.kernel.org/~akpm/stuff/added-to-mm.txt to find
out what to do about this

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

origin.patch
linux-next.patch
clockeventsc-fix-symbol-was-not-declared-noise.patch
drivers-misc-add-driver-for-texas-instruments-dac7512.patch
drivers-misc-add-driver-for-texas-instruments-dac7512-update.patch
init-mainc-fix-symbol-shadows-noise.patch
kernel-sysc-fix-warning-do-while-statement-is-not-a-compound-statement-noise.patch

