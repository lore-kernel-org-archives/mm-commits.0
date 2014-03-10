From: akpm@linux-foundation.org
Subject: [wrecked] w1-fix-refcount-leak-in-netlink-connector.patch removed from -mm tree
Date: Mon, 10 Mar 2014 13:55:24 -0700
Message-ID: <531e26bc.6kkpmOBoFcKuKDfU%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:40936 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754848AbaCJUzZ (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 10 Mar 2014 16:55:25 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, zbr@ioremap.net, greg@kroah.com, richard@nod.at

Subject: [wrecked] w1-fix-refcount-leak-in-netlink-connector.patch removed from -mm tree
To: richard@nod.at,greg@kroah.com,zbr@ioremap.net,mm-commits@vger.kernel.org
From: akpm@linux-foundation.org
Date: Mon, 10 Mar 2014 13:55:24 -0700


The patch titled
     Subject: drivers/w1/w1_netlink.c: fix refcount leak in netlink connector
has been removed from the -mm tree.  Its filename was
     w1-fix-refcount-leak-in-netlink-connector.patch

This patch was dropped because other changes were merged, which wrecked this patch

------------------------------------------------------
From: Richard Weinberger <richard@nod.at>
Subject: drivers/w1/w1_netlink.c: fix refcount leak in netlink connector

If userspace sends a w1 message of length 0 we leak the refcount.

Signed-off-by: Richard Weinberger <richard@nod.at>
Cc: Evgeniy Polyakov <zbr@ioremap.net>
Cc: Greg KH <greg@kroah.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/w1/w1_netlink.c |    5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff -puN drivers/w1/w1_netlink.c~w1-fix-refcount-leak-in-netlink-connector drivers/w1/w1_netlink.c
--- a/drivers/w1/w1_netlink.c~w1-fix-refcount-leak-in-netlink-connector
+++ a/drivers/w1/w1_netlink.c
@@ -355,7 +355,7 @@ static void w1_cn_callback(struct cn_msg
 
 		err = 0;
 		if (!mlen)
-			goto out_cont;
+			goto out_dec;
 
 		mutex_lock(&dev->mutex);
 
@@ -384,10 +384,11 @@ static void w1_cn_callback(struct cn_msg
 			mlen -= cmd->len + sizeof(struct w1_netlink_cmd);
 		}
 out_up:
+		mutex_unlock(&dev->mutex);
+out_dec:
 		atomic_dec(&dev->refcnt);
 		if (sl)
 			atomic_dec(&sl->refcnt);
-		mutex_unlock(&dev->mutex);
 out_cont:
 		if (!cmd || err)
 			w1_netlink_send_error(msg, m, cmd, err);
_

Patches currently in -mm which might be from richard@nod.at are

linux-next.patch
asm-systemh-um-arch_align_stack-moved-to-asm-exech.patch

