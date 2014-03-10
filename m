From: akpm@linux-foundation.org
Subject: + w1-fix-refcount-leak-in-netlink-connector.patch added to -mm
 tree
Date: Mon, 10 Mar 2014 12:13:53 -0700
Message-ID: <531e0ef1.V5p6xWktAWz3zpMe%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:40350 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752435AbaCJTNy (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 10 Mar 2014 15:13:54 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, zbr@ioremap.net, greg@kroah.com, richard@nod.at

Subject: + w1-fix-refcount-leak-in-netlink-connector.patch added to -mm tree
To: richard@nod.at,greg@kroah.com,zbr@ioremap.net
From: akpm@linux-foundation.org
Date: Mon, 10 Mar 2014 12:13:53 -0700


The patch titled
     Subject: drivers/w1/w1_netlink.c: fix refcount leak in netlink connector
has been added to the -mm tree.  Its filename is
     w1-fix-refcount-leak-in-netlink-connector.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/w1-fix-refcount-leak-in-netlink-connector.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/w1-fix-refcount-leak-in-netlink-connector.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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

w1-fix-refcount-leak-in-netlink-connector.patch
linux-next.patch
asm-systemh-um-arch_align_stack-moved-to-asm-exech.patch

