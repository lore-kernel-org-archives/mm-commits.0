From: akpm@linux-foundation.org
Subject: + kernel-printk-do-not-turn-off-bootconsole-in-printk_late_init-if-keep_bootcon.patch added to -mm tree
Date: Fri, 19 Aug 2011 17:10:42 -0700
Message-ID: <201108200010.p7K0AgAo000435@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:38687 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756680Ab1HTAL1 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 19 Aug 2011 20:11:27 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: nacc@us.ibm.com, alan@lxorguk.ukuu.org.uk, davem@davemloft.net, fdinitto@redhat.com, gregkh@suse.de, stable@kernel.org


The patch titled
     kernel/printk: do not turn off bootconsole in printk_late_init() if keep_bootcon
has been added to the -mm tree.  Its filename is
     kernel-printk-do-not-turn-off-bootconsole-in-printk_late_init-if-keep_bootcon.patch

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
Subject: kernel/printk: do not turn off bootconsole in printk_late_init() if keep_bootcon
From: Nishanth Aravamudan <nacc@us.ibm.com>

It seems that 7bf693951a8e ("console: allow to retain boot console via
boot option keep_bootcon") doesn't always achieve what it aims, as when
printk_late_init() runs it unconditionally turns off all boot consoles. 
With this patch, I am able to see more messages on the boot console in KVM
guests than I can without, when keep_bootcon is specified.

Signed-off-by: Nishanth Aravamudan <nacc@us.ibm.com>
Cc: David S. Miller <davem@davemloft.net>
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: Greg KH <gregkh@suse.de>
Acked-by: Fabio M. Di Nitto <fdinitto@redhat.com>
Cc: <stable@kernel.org>		[2.6.39.x, 3.0.x]
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/printk.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN kernel/printk.c~kernel-printk-do-not-turn-off-bootconsole-in-printk_late_init-if-keep_bootcon kernel/printk.c
--- a/kernel/printk.c~kernel-printk-do-not-turn-off-bootconsole-in-printk_late_init-if-keep_bootcon
+++ a/kernel/printk.c
@@ -1604,7 +1604,7 @@ static int __init printk_late_init(void)
 	struct console *con;
 
 	for_each_console(con) {
-		if (con->flags & CON_BOOT) {
+		if (!keep_bootcon && con->flags & CON_BOOT) {
 			printk(KERN_INFO "turn off boot console %s%d\n",
 				con->name, con->index);
 			unregister_console(con);
_

Patches currently in -mm which might be from nacc@us.ibm.com are

kernel-printk-do-not-turn-off-bootconsole-in-printk_late_init-if-keep_bootcon.patch

