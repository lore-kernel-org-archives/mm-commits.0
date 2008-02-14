From: akpm@linux-foundation.org
Subject: + ipmi-run-to-completion-fixes-fix.patch added to -mm tree
Date: Thu, 14 Feb 2008 11:05:37 -0800
Message-ID: <200802141905.m1EJ5bCF030450@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:35384 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758129AbYBNTI0 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 14 Feb 2008 14:08:26 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: cminyard@mvista.com


The patch titled
     ipmi: change barrier to cpu_relax in poweroff code
has been added to the -mm tree.  Its filename is
     ipmi-run-to-completion-fixes-fix.patch

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
Subject: ipmi: change barrier to cpu_relax in poweroff code
From: Corey Minyard <cminyard@mvista.com>

Change a barrier to cpu_relax(), which is more appropriate for a
polling loop.

Signed-off-by: Corey Minyard <cminyard@mvista.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/char/ipmi/ipmi_poweroff.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN drivers/char/ipmi/ipmi_poweroff.c~ipmi-run-to-completion-fixes-fix drivers/char/ipmi/ipmi_poweroff.c
--- a/drivers/char/ipmi/ipmi_poweroff.c~ipmi-run-to-completion-fixes-fix
+++ a/drivers/char/ipmi/ipmi_poweroff.c
@@ -175,7 +175,7 @@ static int ipmi_request_in_rc_mode(ipmi_
 	 */
 	while (atomic_read(&dummy_count) > 0) {
 		ipmi_poll_interface(user);
-		barrier();
+		cpu_relax();
 	}
 
 	return halt_recv_msg.msg.data[0];
_

Patches currently in -mm which might be from cminyard@mvista.com are

git-watchdog.patch
ipmi-hold-attn-until-upper-layer-ready.patch
ipmi-change-device-node-ordering-to-reflect-probe-order.patch
ipmi-run-to-completion-fixes.patch
ipmi-run-to-completion-fixes-fix.patch
ipmi-run-to-completion-fixes-checkpatch-fixes.patch
ipmi-dont-grab-locks-in-run-to-completion-mode.patch
ipmi-dont-print-event-queue-full-on-every-event.patch
ipmi-update-driver-version.patch
