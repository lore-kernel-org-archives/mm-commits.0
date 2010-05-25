From: akpm@linux-foundation.org
Subject: + ipmi-handle-run_to_completion-properly-in-deliver_recv_msg.patch added to -mm tree
Date: Tue, 25 May 2010 11:00:54 -0700
Message-ID: <201005251800.o4PI0svW006188@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:58241 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754053Ab0EYSBD (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 25 May 2010 14:01:03 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: jkosina@suse.cz, minyard@acm.org


The patch titled
     ipmi: handle run_to_completion properly in deliver_recv_msg()
has been added to the -mm tree.  Its filename is
     ipmi-handle-run_to_completion-properly-in-deliver_recv_msg.patch

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
Subject: ipmi: handle run_to_completion properly in deliver_recv_msg()
From: Jiri Kosina <jkosina@suse.cz>

If run_to_completion flag is set, it means that we are running in a
single-threaded mode, and thus no locks are held.

This fixes a deadlock when IPMI notifier is being called during panic.

Signed-off-by: Jiri Kosina <jkosina@suse.cz>
Cc: Corey Minyard <minyard@acm.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/char/ipmi/ipmi_si_intf.c |   11 ++++++++---
 1 file changed, 8 insertions(+), 3 deletions(-)

diff -puN drivers/char/ipmi/ipmi_si_intf.c~ipmi-handle-run_to_completion-properly-in-deliver_recv_msg drivers/char/ipmi/ipmi_si_intf.c
--- a/drivers/char/ipmi/ipmi_si_intf.c~ipmi-handle-run_to_completion-properly-in-deliver_recv_msg
+++ a/drivers/char/ipmi/ipmi_si_intf.c
@@ -323,9 +323,14 @@ static void deliver_recv_msg(struct smi_
 {
 	/* Deliver the message to the upper layer with the lock
 	   released. */
-	spin_unlock(&(smi_info->si_lock));
-	ipmi_smi_msg_received(smi_info->intf, msg);
-	spin_lock(&(smi_info->si_lock));
+
+	if (smi_info->run_to_completion) {
+		ipmi_smi_msg_received(smi_info->intf, msg);
+	} else {
+		spin_unlock(&(smi_info->si_lock));
+		ipmi_smi_msg_received(smi_info->intf, msg);
+		spin_lock(&(smi_info->si_lock));
+	}
 }
 
 static void return_hosed_msg(struct smi_info *smi_info, int cCode)
_

Patches currently in -mm which might be from jkosina@suse.cz are

origin.patch
linux-next.patch
acpi-video-fix-acpi_backlight=video.patch
ipmi-handle-run_to_completion-properly-in-deliver_recv_msg.patch

