From: akpm@linux-foundation.org
Subject: + memstick-make-sure-number-of-command-retries-is-exactly-as-specified.patch added to -mm tree
Date: Wed, 05 Mar 2008 15:17:42 -0800
Message-ID: <200803052317.m25NHgEB026672@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:47286 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1765581AbYCEXSE (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 5 Mar 2008 18:18:04 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: oakad@yahoo.com


The patch titled
     memstick: make sure number of command retries is exactly as specified
has been added to the -mm tree.  Its filename is
     memstick-make-sure-number-of-command-retries-is-exactly-as-specified.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: memstick: make sure number of command retries is exactly as specified
From: Alex Dubov <oakad@yahoo.com>

Signed-off-by: Alex Dubov <oakad@yahoo.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/memstick/core/memstick.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN drivers/memstick/core/memstick.c~memstick-make-sure-number-of-command-retries-is-exactly-as-specified drivers/memstick/core/memstick.c
--- a/drivers/memstick/core/memstick.c~memstick-make-sure-number-of-command-retries-is-exactly-as-specified
+++ a/drivers/memstick/core/memstick.c
@@ -236,7 +236,7 @@ int memstick_next_req(struct memstick_ho
 		rc = host->card->next_request(host->card, mrq);
 
 	if (!rc)
-		host->retries = cmd_retries;
+		host->retries = cmd_retries > 1 ? cmd_retries - 1 : 1;
 	else
 		*mrq = NULL;
 
_

Patches currently in -mm which might be from oakad@yahoo.com are

memstick-introduce-correct-definitions-in-the-header.patch
memstick-add-memstick_suspend-resume_host-methods.patch
memstick-make-sure-number-of-command-retries-is-exactly-as-specified.patch
memstick-drop-driver_version-numbers-as-meaningless.patch
tifm-fix-the-memorystick-host-fifo-handling-code.patch
tifm-fix-memorystick-host-initialization-code.patch
tifm-clear-interrupt-mask-bits-before-setting-them-on-adapter-init.patch
memstick-add-support-for-decoding-specfile-media-attributes.patch
memstick-fix-parsing-of-assembly_date-attribute-field.patch
memstick-try-harder-to-recover-from-unsuccessful-interface-mode-switch.patch
memstick-add-support-for-jmicron-jmb38x-memorystick-host-controller.patch

