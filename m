From: akpm@linux-foundation.org
Subject: [merged] cs5535-mfgpt-dont-call-__init-function-from-__devinit.patch removed from -mm tree
Date: Mon, 13 Feb 2012 13:12:46 -0800
Message-ID: <20120213211246.63E5DA02E6@akpm.mtv.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-gx0-f202.google.com ([209.85.161.202]:42427 "EHLO
	mail-gx0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755901Ab2BMVMr (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 13 Feb 2012 16:12:47 -0500
Received: by ggnp1 with SMTP id p1so590762ggn.1
        for <mm-commits@vger.kernel.org>; Mon, 13 Feb 2012 13:12:46 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: danny.kukawka@bisect.de, dilinger@queued.net, greg@kroah.com, mm-commits@vger.kernel.org


The patch titled
     Subject: cs5535-mfgpt: don't call __init function from __devinit
has been removed from the -mm tree.  Its filename was
     cs5535-mfgpt-dont-call-__init-function-from-__devinit.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
From: Danny Kukawka <danny.kukawka@bisect.de>
Subject: cs5535-mfgpt: don't call __init function from __devinit

Fix and reset_all_timers() to be __devinit and not __init since the
function gets called from cs5535_mfgpt_probe which is __devinit.

Signed-off-by: Danny Kukawka <danny.kukawka@bisect.de>
Acked-by: Andres Salomon <dilinger@queued.net>
Cc: Greg KH <greg@kroah.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/misc/cs5535-mfgpt.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN drivers/misc/cs5535-mfgpt.c~cs5535-mfgpt-dont-call-__init-function-from-__devinit drivers/misc/cs5535-mfgpt.c
--- a/drivers/misc/cs5535-mfgpt.c~cs5535-mfgpt-dont-call-__init-function-from-__devinit
+++ a/drivers/misc/cs5535-mfgpt.c
@@ -246,7 +246,7 @@ EXPORT_SYMBOL_GPL(cs5535_mfgpt_write);
  * Jordan tells me that he and Mitch once played w/ it, but it's unclear
  * what the results of that were (and they experienced some instability).
  */
-static void __init reset_all_timers(void)
+static void __devinit reset_all_timers(void)
 {
 	uint32_t val, dummy;
 
_

Patches currently in -mm which might be from danny.kukawka@bisect.de are

origin.patch
linux-next.patch

