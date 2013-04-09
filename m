From: akpm@linux-foundation.org
Subject: + printk-fix-failure-to-return-error-in-devkmsg_poll.patch added to -mm tree
Date: Tue, 09 Apr 2013 12:48:13 -0700
Message-ID: <20130409194813.866A55A425C@corp2gmr1-2.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-ie0-f201.google.com ([209.85.223.201]:52766 "EHLO
	mail-ie0-f201.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1762120Ab3DITsP (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 9 Apr 2013 15:48:15 -0400
Received: by mail-ie0-f201.google.com with SMTP id a11so1850233iee.4
        for <mm-commits@vger.kernel.org>; Tue, 09 Apr 2013 12:48:14 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: nikai@nikai.net, greg@kroah.com, kay.sievers@vrfy.org


The patch titled
     Subject: printk: fix failure to return error in devkmsg_poll()
has been added to the -mm tree.  Its filename is
     printk-fix-failure-to-return-error-in-devkmsg_poll.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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

printk-fix-failure-to-return-error-in-devkmsg_poll.patch

