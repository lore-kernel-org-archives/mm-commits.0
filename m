From: akpm@linux-foundation.org
Subject: [merged] printk-fix-failure-to-return-error-in-devkmsg_poll.patch removed from -mm tree
Date: Tue, 30 Apr 2013 11:50:59 -0700
Message-ID: <20130430185059.7A37731C27C@corp2gmr1-1.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-gg0-f202.google.com ([209.85.161.202]:35576 "EHLO
	mail-gg0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932669Ab3D3SvA (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 30 Apr 2013 14:51:00 -0400
Received: by mail-gg0-f202.google.com with SMTP id 4so86125ggm.5
        for <mm-commits@vger.kernel.org>; Tue, 30 Apr 2013 11:50:59 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: nikai@nikai.net, greg@kroah.com, kay.sievers@vrfy.org, mm-commits@vger.kernel.org


The patch titled
     Subject: printk: fix failure to return error in devkmsg_poll()
has been removed from the -mm tree.  Its filename was
     printk-fix-failure-to-return-error-in-devkmsg_poll.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Nicolas Kaiser <nikai@nikai.net>
Subject: printk: fix failure to return error in devkmsg_poll()

Error value got overwritten instantly.

Signed-off-by: Nicolas Kaiser <nikai@nikai.net>
Cc: Kay Sievers <kay.sievers@vrfy.org>
Cc: Greg KH <greg@kroah.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/printk.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff -puN kernel/printk.c~printk-fix-failure-to-return-error-in-devkmsg_poll kernel/printk.c
--- a/kernel/printk.c~printk-fix-failure-to-return-error-in-devkmsg_poll
+++ a/kernel/printk.c
@@ -601,7 +601,8 @@ static unsigned int devkmsg_poll(struct
 		/* return error when data has vanished underneath us */
 		if (user->seq < log_first_seq)
 			ret = POLLIN|POLLRDNORM|POLLERR|POLLPRI;
-		ret = POLLIN|POLLRDNORM;
+		else
+			ret = POLLIN|POLLRDNORM;
 	}
 	raw_spin_unlock_irq(&logbuf_lock);
 
_

Patches currently in -mm which might be from nikai@nikai.net are

origin.patch

