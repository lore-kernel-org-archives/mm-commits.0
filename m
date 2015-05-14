From: akpm@linux-foundation.org
Subject: + netconsole-make-all-dynamic-netconsoles-share-a-mutex.patch
 added to -mm tree
Date: Thu, 14 May 2015 13:28:58 -0700
Message-ID: <5555058a.UDJyb0gXqQGxL/DM%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:46725 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932953AbbENU27 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 14 May 2015 16:28:59 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: tj@kernel.org, davem@davemloft.net, kay@vrfy.org, penguin-kernel@I-love.SAKURA.ne.jp, pmladek@suse.cz, mm-commits@vger.kernel.org


The patch titled
     Subject: netconsole: make all dynamic netconsoles share a mutex
has been added to the -mm tree.  Its filename is
     netconsole-make-all-dynamic-netconsoles-share-a-mutex.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/netconsole-make-all-dynamic-netconsoles-share-a-mutex.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/netconsole-make-all-dynamic-netconsoles-share-a-mutex.patch

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
Subject: netconsole: make all dynamic netconsoles share a mutex

Currently, each dynamic netconsole_target uses its own separate mutex to
synchronize the configuration operations.  This patch replaces the
per-netconsole_target mutexes with a single mutex -
dynamic_netconsole_mutex.  The reduced granularity doesn't hurt anything,
the code is minutely simpler and this'd allow adding operations which
should be synchronized across all dynamic netconsoles.

Signed-off-by: Tejun Heo <tj@kernel.org>
Cc: David Miller <davem@davemloft.net>
Cc: Kay Sievers <kay@vrfy.org>
Cc: Petr Mladek <pmladek@suse.cz>
Cc: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/net/netconsole.c |    8 +++-----
 1 file changed, 3 insertions(+), 5 deletions(-)

diff -puN drivers/net/netconsole.c~netconsole-make-all-dynamic-netconsoles-share-a-mutex drivers/net/netconsole.c
--- a/drivers/net/netconsole.c~netconsole-make-all-dynamic-netconsoles-share-a-mutex
+++ a/drivers/net/netconsole.c
@@ -105,13 +105,13 @@ struct netconsole_target {
 	struct config_item	item;
 #endif
 	bool			enabled;
-	struct mutex		mutex;
 	struct netpoll		np;
 };
 
 #ifdef	CONFIG_NETCONSOLE_DYNAMIC
 
 static struct configfs_subsystem netconsole_subsys;
+static DEFINE_MUTEX(dynamic_netconsole_mutex);
 
 static int __init dynamic_netconsole_init(void)
 {
@@ -185,7 +185,6 @@ static struct netconsole_target *alloc_p
 	strlcpy(nt->np.dev_name, "eth0", IFNAMSIZ);
 	nt->np.local_port = 6665;
 	nt->np.remote_port = 6666;
-	mutex_init(&nt->mutex);
 	eth_broadcast_addr(nt->np.remote_mac);
 
 	/* Parse parameters and setup netpoll */
@@ -562,10 +561,10 @@ static ssize_t netconsole_target_attr_st
 	struct netconsole_target_attr *na =
 		container_of(attr, struct netconsole_target_attr, attr);
 
-	mutex_lock(&nt->mutex);
+	mutex_lock(&dynamic_netconsole_mutex);
 	if (na->store)
 		ret = na->store(nt, buf, count);
-	mutex_unlock(&nt->mutex);
+	mutex_unlock(&dynamic_netconsole_mutex);
 
 	return ret;
 }
@@ -604,7 +603,6 @@ static struct config_item *make_netconso
 	strlcpy(nt->np.dev_name, "eth0", IFNAMSIZ);
 	nt->np.local_port = 6665;
 	nt->np.remote_port = 6666;
-	mutex_init(&nt->mutex);
 	eth_broadcast_addr(nt->np.remote_mac);
 
 	/* Initialize the config_item member */
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

