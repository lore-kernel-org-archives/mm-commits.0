From: akpm@linux-foundation.org
Subject: [merged] kernel-printk-do-not-turn-off-bootconsole-in-printk_late_init-if-keep_bootcon.patch removed from -mm tree
Date: Fri, 26 Aug 2011 12:06:37 -0700
Message-ID: <201108261903.p7QJ3LuZ005675@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:57466 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753302Ab1HZTEM (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 26 Aug 2011 15:04:12 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: nacc@us.ibm.com, alan@lxorguk.ukuu.org.uk, davem@davemloft.net, fdinitto@redhat.com, gregkh@suse.de, stable@kernel.org, mm-commits@vger.kernel.org


The patch titled
     kernel/printk: do not turn off bootconsole in printk_late_init() if keep_bootcon
has been removed from the -mm tree.  Its filename was
     kernel-printk-do-not-turn-off-bootconsole-in-printk_late_init-if-keep_bootcon.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: kernel/printk: do not turn off bootconsole in printk_late_init() if keep_bootcon
From: Nishanth Aravamudan <nacc@us.ibm.com>

It seems that 7bf693951a8e ("console: allow to retain boot console via
boot option keep_bootcon") doesn't always achieve what it aims, as when
printk_late_init() runs it unconditionally turns off all boot consoles. 
With this patch, I am able to see more messages on the boot console in KVM
guests than I can without, when keep_bootcon is specified.

I think it is appropriate for the relevant -stable trees.  However, it's
more of an annoyance than a serious bug (ideally you don't need to keep
the boot console around as console handover should be working -- I was
encountering a situation where the console handover wasn't working and not
having the boot console available meant I couldn't see why).

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

origin.patch

