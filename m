From: akpm@linux-foundation.org
Subject: +
 netconsole-remove-unnecessary-netconsole_target_get-out-from-write_msg.patch added to -mm tree
Date: Thu, 14 May 2015 13:28:54 -0700
Message-ID: <55550586.uTFz6lKse50ZZ3Ob%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:46714 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932771AbbENU2z (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 14 May 2015 16:28:55 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: tj@kernel.org, davem@davemloft.net, kay@vrfy.org, penguin-kernel@I-love.SAKURA.ne.jp, pmladek@suse.cz, mm-commits@vger.kernel.org


The patch titled
     Subject: netconsole: remove unnecessary netconsole_target_get/out() from write_msg()
has been added to the -mm tree.  Its filename is
     netconsole-remove-unnecessary-netconsole_target_get-out-from-write_msg.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/netconsole-remove-unnecessary-netconsole_target_get-out-from-write_msg.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/netconsole-remove-unnecessary-netconsole_target_get-out-from-write_msg.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Tejun Heo <tj@kernel.org>
Subject: netconsole: remove unnecessary netconsole_target_get/out() from write_msg()

write_msg() grabs target_list_lock and walks target_list invoking
netpool_send_udp() on each target.  Curiously, it protects each iteration
with netconsole_target_get/put() even though it never releases
target_list_lock which protects all the members.

While this doesn't harm anything, it doesn't serve any purpose either. 
The items on the list can't go away while target_list_lock is held. 
Remove the unnecessary get/put pair.

Signed-off-by: Tejun Heo <tj@kernel.org>
Cc: David Miller <davem@davemloft.net>
Cc: Kay Sievers <kay@vrfy.org>
Cc: Petr Mladek <pmladek@suse.cz>
Cc: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/net/netconsole.c |    2 --
 1 file changed, 2 deletions(-)

diff -puN drivers/net/netconsole.c~netconsole-remove-unnecessary-netconsole_target_get-out-from-write_msg drivers/net/netconsole.c
--- a/drivers/net/netconsole.c~netconsole-remove-unnecessary-netconsole_target_get-out-from-write_msg
+++ a/drivers/net/netconsole.c
@@ -744,7 +744,6 @@ static void write_msg(struct console *co
 
 	spin_lock_irqsave(&target_list_lock, flags);
 	list_for_each_entry(nt, &target_list, list) {
-		netconsole_target_get(nt);
 		if (nt->enabled && netif_running(nt->np.dev)) {
 			/*
 			 * We nest this inside the for-each-target loop above
@@ -760,7 +759,6 @@ static void write_msg(struct console *co
 				left -= frag;
 			}
 		}
-		netconsole_target_put(nt);
 	}
 	spin_unlock_irqrestore(&target_list_lock, flags);
 }
_

Patches currently in -mm which might be from tj@kernel.org are

origin.patch
gfp-add-__gfp_noaccount.patch
gfp-add-__gfp_noaccount-v2.patch
gfp-add-__gfp_noaccount-v2-fix.patch
kernfs-do-not-account-ino_ida-allocations-to-memcg.patch
block-restore-proc-partitions-to-not-display-non-partitionable-removable-devices.patch
fs-mpagec-forgotten-write_sync-in-case-of-data-integrity-write.patch
printk-guard-the-amount-written-per-line-by-devkmsg_read.patch
printk-factor-out-message-formatting-from-devkmsg_read.patch
printk-implement-support-for-extended-console-drivers.patch
netconsole-remove-unnecessary-netconsole_target_get-out-from-write_msg.patch
netconsole-make-netconsole_target-enabled-a-bool.patch
netconsole-make-all-dynamic-netconsoles-share-a-mutex.patch
netconsole-implement-extended-console-support.patch
bitmap-remove-explicit-newline-handling-using-scnprintf-format-string.patch
bitmap-remove-explicit-newline-handling-using-scnprintf-format-string-fix.patch
ipc-msgc-msgsnd-use-freezable-blocking-call.patch
msgrcv-use-freezable-blocking-call.patch
linux-next.patch
printk-improve-the-description-of-dev-kmsg-line-format.patch

