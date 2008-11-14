From: akpm@linux-foundation.org
Subject: + misc-c2port-needs-linux-schedh.patch added to -mm tree
Date: Fri, 14 Nov 2008 00:09:23 -0800
Message-ID: <200811140809.mAE89NTB021847@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:37102 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751206AbYKNIJ5 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 14 Nov 2008 03:09:57 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: geert@linux-m68k.org


The patch titled
     misc: C2port needs <linux/sched.h>
has been added to the -mm tree.  Its filename is
     misc-c2port-needs-linux-schedh.patch

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
misc-c2port-needs-linux-schedh.patch
linux-next.patch
fbdev-fix-typo-in-drivers-video-modedbc.patch

