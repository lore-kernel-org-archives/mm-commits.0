From: akpm@linux-foundation.org
Subject: + kmsg-dev-kmsg-properly-return-possible-copy_from_user-failure.patch added to -mm tree
Date: Tue, 05 Jun 2012 17:00:44 -0700
Message-ID: <20120606000044.B9A6BA0137@akpm.mtv.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-ey0-f202.google.com ([209.85.215.202]:34727 "EHLO
	mail-ey0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753731Ab2FFAAq (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 5 Jun 2012 20:00:46 -0400
Received: by eaao13 with SMTP id o13so333894eaa.1
        for <mm-commits@vger.kernel.org>; Tue, 05 Jun 2012 17:00:45 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: kay@vrfy.org, akpm@linux-foundation.org


The patch titled
     Subject: kmsg: /dev/kmsg - properly return possible copy_from_user() failure
has been added to the -mm tree.  Its filename is
     kmsg-dev-kmsg-properly-return-possible-copy_from_user-failure.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Kay Sievers <kay@vrfy.org>
Subject: kmsg: /dev/kmsg - properly return possible copy_from_user() failure

Reported-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Kay Sievers <kay@vrfy.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/printk.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff -puN kernel/printk.c~kmsg-dev-kmsg-properly-return-possible-copy_from_user-failure kernel/printk.c
--- a/kernel/printk.c~kmsg-dev-kmsg-properly-return-possible-copy_from_user-failure
+++ a/kernel/printk.c
@@ -365,8 +365,10 @@ static ssize_t devkmsg_writev(struct kio
 
 	line = buf;
 	for (i = 0; i < count; i++) {
-		if (copy_from_user(line, iv[i].iov_base, iv[i].iov_len))
+		if (copy_from_user(line, iv[i].iov_base, iv[i].iov_len)) {
+			ret = -EFAULT;
 			goto out;
+		}
 		line += iv[i].iov_len;
 	}
 
_
Subject: Subject: kmsg: /dev/kmsg - properly return possible copy_from_user() failure

Patches currently in -mm which might be from kay@vrfy.org are

kmsg-dev-kmsg-properly-return-possible-copy_from_user-failure.patch

