From: akpm@linux-foundation.org
Subject: [merged] include-linux-fsh-disable-preempt-when-acquire-i_size_seqcount-write-lock.patch removed from -mm tree
Date: Tue, 07 May 2013 10:47:38 -0700
Message-ID: <20130507174738.7E3F05A4174@corp2gmr1-2.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-gg0-f201.google.com ([209.85.161.201]:57855 "EHLO
	mail-gg0-f201.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759294Ab3EGRrk (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 7 May 2013 13:47:40 -0400
Received: by mail-gg0-f201.google.com with SMTP id k25so85112ggl.2
        for <mm-commits@vger.kernel.org>; Tue, 07 May 2013 10:47:39 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: fan.du@windriver.com, mm-commits@vger.kernel.org


The patch titled
     Subject: include/linux/fs.h: disable preempt when acquire i_size_seqcount write lock
has been removed from the -mm tree.  Its filename was
     include-linux-fsh-disable-preempt-when-acquire-i_size_seqcount-write-lock.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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

origin.patch

