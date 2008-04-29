From: akpm@linux-foundation.org
Subject: - ipmi-run-to-completion-fixes-fix.patch removed from -mm tree
Date: Mon, 28 Apr 2008 22:50:32 -0700
Message-ID: <200804290550.m3T5oWQo003841@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:39027 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753874AbYD2Fy6 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 29 Apr 2008 01:54:58 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: cminyard@mvista.com, mm-commits@vger.kernel.org


The patch titled
     ipmi: change barrier to cpu_relax in poweroff code
has been removed from the -mm tree.  Its filename was
     ipmi-run-to-completion-fixes-fix.patch

This patch was dropped because it was folded into ipmi-run-to-completion-fixes.patch

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

ipmi-hold-attn-until-upper-layer-ready.patch
ipmi-run-to-completion-fixes.patch
ipmi-run-to-completion-fixes-fix.patch
ipmi-run-to-completion-fixes-checkpatch-fixes.patch
ipmi-dont-grab-locks-in-run-to-completion-mode.patch
ipmi-dont-grab-locks-in-run-to-completion-mode-fix.patch
ipmi-dont-print-event-queue-full-on-every-event.patch
ipmi-update-driver-version.patch
ipmi-convert-locked-counters-to-atomics.patch
ipmi-convert-locked-counters-to-atomics-convert-message-handler-defines-to-an-enum.patch
ipmi-convert-locked-counters-to-atomics-in-the-system-interface.patch
ipmi-convert-locked-counters-to-atomics-in-the-system-interface-convert-system-interface-defines-to-an-enum.patch
ipmi-style-fixes-in-the-base-code.patch
ipmi-style-fixes-in-the-system-interface-code.patch
ipmi-style-fixes-in-the-system-interface-code-checkpatch-fixes.patch
ipmi-style-fixes-in-the-misc-code.patch
ipmi-make-comment-match-actual-preprocessor-check.patch
ipmi-make-alloc_recv_msg-static.patch
ipmi-fix-return-from-atca_oem_poweroff_hook.patch

