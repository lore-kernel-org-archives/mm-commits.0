From: akpm@linux-foundation.org
Subject: + fix-typo-in-tick-broadcastc.patch added to -mm tree
Date: Fri, 22 Feb 2008 23:32:22 -0800
Message-ID: <200802230733.m1N7XBk2018196@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([207.189.120.13]:58970 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754130AbYBWHyi (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Sat, 23 Feb 2008 02:54:38 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: gcosta@redhat.com, tglx@linutronix.de


The patch titled
     fix typo in tick-broadcast.c
has been added to the -mm tree.  Its filename is
     fix-typo-in-tick-broadcastc.patch

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
Subject: fix typo in tick-broadcast.c
From: Glauber Costa <gcosta@redhat.com>

braodcast -> broadcast

Signed-off-by: Glauber Costa <gcosta@redhat.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/time/tick-broadcast.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN kernel/time/tick-broadcast.c~fix-typo-in-tick-broadcastc kernel/time/tick-broadcast.c
--- a/kernel/time/tick-broadcast.c~fix-typo-in-tick-broadcastc
+++ a/kernel/time/tick-broadcast.c
@@ -262,7 +262,7 @@ out:
 void tick_broadcast_on_off(unsigned long reason, int *oncpu)
 {
 	if (!cpu_isset(*oncpu, cpu_online_map))
-		printk(KERN_ERR "tick-braodcast: ignoring broadcast for "
+		printk(KERN_ERR "tick-broadcast: ignoring broadcast for "
 		       "offline CPU #%d\n", *oncpu);
 	else
 		smp_call_function_single(*oncpu, tick_do_broadcast_on_off,
_

Patches currently in -mm which might be from gcosta@redhat.com are

remove-is_processor_present-prototype.patch
acpi-use-acpi_debug_print-instead-of-printk.patch
git-kvm.patch
fix-typo-in-tick-broadcastc.patch
