From: akpm@linux-foundation.org
Subject: + cs5535-mfgpt-dont-call-__init-function-from-__devinit.patch added to -mm tree
Date: Wed, 08 Feb 2012 14:16:47 -0800
Message-ID: <20120208221647.AEC38A0443@akpm.mtv.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-ey0-f202.google.com ([209.85.215.202]:54361 "EHLO
	mail-ey0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752501Ab2BHWQt (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 8 Feb 2012 17:16:49 -0500
Received: by eaaf13 with SMTP id f13so30751eaa.1
        for <mm-commits@vger.kernel.org>; Wed, 08 Feb 2012 14:16:48 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: danny.kukawka@bisect.de, dilinger@queued.net, greg@kroah.com


The patch titled
     Subject: cs5535-mfgpt: don't call __init function from __devinit
has been added to the -mm tree.  Its filename is
     cs5535-mfgpt-dont-call-__init-function-from-__devinit.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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
Subject: Subject: cs5535-mfgpt: don't call __init function from __devinit

Patches currently in -mm which might be from danny.kukawka@bisect.de are

linux-next.patch
cs5535-mfgpt-dont-call-__init-function-from-__devinit.patch

