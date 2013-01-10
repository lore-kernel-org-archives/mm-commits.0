From: akpm@linux-foundation.org
Subject: + include-linux-fsh-disable-preempt-when-acquire-i_size_seqcount-write-lock.patch added to -mm tree
Date: Thu, 10 Jan 2013 14:38:59 -0800
Message-ID: <20130110223859.96A41100048@wpzn3.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-yh0-f74.google.com ([209.85.213.74]:54910 "EHLO
	mail-yh0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753528Ab3AJWjA (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 10 Jan 2013 17:39:00 -0500
Received: by mail-yh0-f74.google.com with SMTP id w68so137688yhw.3
        for <mm-commits@vger.kernel.org>; Thu, 10 Jan 2013 14:39:00 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: fan.du@windriver.com


The patch titled
     Subject: include/linux/fs.h: disable preempt when acquire i_size_seqcount write lock
has been added to the -mm tree.  Its filename is
     include-linux-fsh-disable-preempt-when-acquire-i_size_seqcount-write-lock.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Fan Du <fan.du@windriver.com>
Subject: include/linux/fs.h: disable preempt when acquire i_size_seqcount write lock

Two rt tasks bind to one CPU core.

The higher priority rt task A preempts a lower priority rt task B which
has already taken the write seq lock, and then the higher priority rt task
A try to acquire read seq lock, it's doomed to lockup.

rt task A with lower priority: call write
i_size_write                                        rt task B with higher priority: call sync, and preempt task A
  write_seqcount_begin(&inode->i_size_seqcount);    i_size_read
  inode->i_size = i_size;                             read_seqcount_begin <-- lockup here...

So disable preempt when acquiring every i_size_seqcount *write* lock will
cure the problem.

Signed-off-by: Fan Du <fan.du@windriver.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/fs.h |    2 ++
 1 file changed, 2 insertions(+)

diff -puN include/linux/fs.h~include-linux-fsh-disable-preempt-when-acquire-i_size_seqcount-write-lock include/linux/fs.h
--- a/include/linux/fs.h~include-linux-fsh-disable-preempt-when-acquire-i_size_seqcount-write-lock
+++ a/include/linux/fs.h
@@ -675,9 +675,11 @@ static inline loff_t i_size_read(const s
 static inline void i_size_write(struct inode *inode, loff_t i_size)
 {
 #if BITS_PER_LONG==32 && defined(CONFIG_SMP)
+	preempt_disable();
 	write_seqcount_begin(&inode->i_size_seqcount);
 	inode->i_size = i_size;
 	write_seqcount_end(&inode->i_size_seqcount);
+	preempt_enable();
 #elif BITS_PER_LONG==32 && defined(CONFIG_PREEMPT)
 	preempt_disable();
 	inode->i_size = i_size;
_

Patches currently in -mm which might be from fan.du@windriver.com are

include-linux-fsh-disable-preempt-when-acquire-i_size_seqcount-write-lock.patch

