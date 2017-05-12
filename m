From: akpm@linux-foundation.org
Subject: [patch 02/15] time: delete current_fs_time()
Date: Fri, 12 May 2017 15:46:29 -0700
Message-ID: <20170512224629.vPxtKowdW%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:38650 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1756700AbdELWqa (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 12 May 2017 18:46:30 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, arnd@arndb.de, deepa.kernel@gmail.com, john.stultz@linaro.org, mm-commits@vger.kernel.org, tglx@linutronix.de, torvalds@linux-foundation.org

From: Deepa Dinamani <deepa.kernel@gmail.com>
Subject: time: delete current_fs_time()

All uses of the current_fs_time() function have been replaced by other
time interfaces.

And, its use cases can be fulfilled by current_time() or ktime_get_*
variants.

Link: http://lkml.kernel.org/r/1491613030-11599-13-git-send-email-deepa.kernel@gmail.com
Signed-off-by: Deepa Dinamani <deepa.kernel@gmail.com>
Reviewed-by: Arnd Bergmann <arnd@arndb.de>
Cc: John Stultz <john.stultz@linaro.org>
Cc: Thomas Gleixner <tglx@linutronix.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/fs.h |    1 -
 kernel/time/time.c |   14 --------------
 2 files changed, 15 deletions(-)

diff -puN include/linux/fs.h~time-delete-current_fs_time-function include/linux/fs.h
--- a/include/linux/fs.h~time-delete-current_fs_time-function
+++ a/include/linux/fs.h
@@ -1431,7 +1431,6 @@ static inline void i_gid_write(struct in
 	inode->i_gid = make_kgid(inode->i_sb->s_user_ns, gid);
 }
 
-extern struct timespec current_fs_time(struct super_block *sb);
 extern struct timespec current_time(struct inode *inode);
 
 /*
diff -puN kernel/time/time.c~time-delete-current_fs_time-function kernel/time/time.c
--- a/kernel/time/time.c~time-delete-current_fs_time-function
+++ a/kernel/time/time.c
@@ -230,20 +230,6 @@ SYSCALL_DEFINE1(adjtimex, struct timex _
 	return copy_to_user(txc_p, &txc, sizeof(struct timex)) ? -EFAULT : ret;
 }
 
-/**
- * current_fs_time - Return FS time
- * @sb: Superblock.
- *
- * Return the current time truncated to the time granularity supported by
- * the fs.
- */
-struct timespec current_fs_time(struct super_block *sb)
-{
-	struct timespec now = current_kernel_time();
-	return timespec_trunc(now, sb->s_time_gran);
-}
-EXPORT_SYMBOL(current_fs_time);
