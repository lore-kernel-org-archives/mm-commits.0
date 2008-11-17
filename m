From: akpm@linux-foundation.org
Subject: - misc-c2port-needs-linux-schedh.patch removed from -mm tree
Date: Mon, 17 Nov 2008 13:27:18 -0800
Message-ID: <200811172127.mAHLRIlf024203@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:33816 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752073AbYKQV2A (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 17 Nov 2008 16:28:00 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: geert@linux-m68k.org, mm-commits@vger.kernel.org


The patch titled
     misc: C2port needs <linux/sched.h>
has been removed from the -mm tree.  Its filename was
     misc-c2port-needs-linux-schedh.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: misc: C2port needs <linux/sched.h>
From: Geert Uytterhoeven <geert@linux-m68k.org>

m68k allmodconfig:

| drivers/misc/c2port/core.c: In function 'c2port_reset':
| drivers/misc/c2port/core.c:73: error: dereferencing pointer to incomplete type
| drivers/misc/c2port/core.c: In function 'c2port_strobe_ck':
| drivers/misc/c2port/core.c:91: error: dereferencing pointer to incomplete type

Include <linux/sched.h> to fix it, as m68k's local_irq_enable() needs to know
about struct task_struct.

Signed-off-by: Geert Uytterhoeven <geert@linux-m68k.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/misc/c2port/core.c |    1 +
 1 file changed, 1 insertion(+)

diff -puN drivers/misc/c2port/core.c~misc-c2port-needs-linux-schedh drivers/misc/c2port/core.c
--- a/drivers/misc/c2port/core.c~misc-c2port-needs-linux-schedh
+++ a/drivers/misc/c2port/core.c
@@ -18,6 +18,7 @@
 #include <linux/ctype.h>
 #include <linux/delay.h>
 #include <linux/idr.h>
+#include <linux/sched.h>
 
 #include <linux/c2port.h>
 
_

Patches currently in -mm which might be from geert@linux-m68k.org are

fb-clean-the-penguins-dirty-feet.patch
linux-next.patch
fbdev-fix-typo-in-drivers-video-modedbc.patch

