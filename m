From: akpm@linux-foundation.org
Subject: + fs-affs-replace-time_t-with-time64_t.patch added to -mm tree
Date: Fri, 18 Dec 2015 16:19:33 -0800
Message-ID: <5674a295.HwCtvAQ7i7A8Gbk5%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:51826 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751422AbbLSATe (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 18 Dec 2015 19:19:34 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: chao.deng@linaro.org, arnd@arndb.de, mm-commits@vger.kernel.org


The patch titled
     Subject: fs/affs: replace time_t with time64_t
has been added to the -mm tree.  Its filename is
     fs-affs-replace-time_t-with-time64_t.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/fs-affs-replace-time_t-with-time64_t.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/fs-affs-replace-time_t-with-time64_t.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: DengChao <chao.deng@linaro.org>
Subject: fs/affs: replace time_t with time64_t

The affs code uses time_t and get_seconds().  This will cause problems
on 32-bit architectures in 2038 when time_t overflows.  This patch
replaces them with time64_t and ktime_get_real_seconds().

Signed-off-by: DengChao <chao.deng@linaro.org>
Reviewed-by: Arnd Bergmann <arnd@arndb.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/affs/affs.h     |    2 +-
 fs/affs/amigaffs.c |   13 +++++++------
 fs/affs/super.c    |    2 +-
 3 files changed, 9 insertions(+), 8 deletions(-)

diff -puN fs/affs/affs.h~fs-affs-replace-time_t-with-time64_t fs/affs/affs.h
--- a/fs/affs/affs.h~fs-affs-replace-time_t-with-time64_t
+++ a/fs/affs/affs.h
@@ -138,7 +138,7 @@ extern int	affs_remove_hash(struct inode
 extern int	affs_remove_header(struct dentry *dentry);
 extern u32	affs_checksum_block(struct super_block *sb, struct buffer_head *bh);
 extern void	affs_fix_checksum(struct super_block *sb, struct buffer_head *bh);
-extern void	secs_to_datestamp(time_t secs, struct affs_date *ds);
+extern void	secs_to_datestamp(time64_t secs, struct affs_date *ds);
 extern umode_t	prot_to_mode(u32 prot);
 extern void	mode_to_prot(struct inode *inode);
 __printf(3, 4)
diff -puN fs/affs/amigaffs.c~fs-affs-replace-time_t-with-time64_t fs/affs/amigaffs.c
--- a/fs/affs/amigaffs.c~fs-affs-replace-time_t-with-time64_t
+++ a/fs/affs/amigaffs.c
@@ -8,6 +8,7 @@
  *  Please send bug reports to: hjw@zvw.de
  */
 
+#include <linux/math64.h>
 #include "affs.h"
 
 /*
@@ -366,22 +367,22 @@ affs_fix_checksum(struct super_block *sb
 }
 
 void
-secs_to_datestamp(time_t secs, struct affs_date *ds)
+secs_to_datestamp(time64_t secs, struct affs_date *ds)
 {
 	u32	 days;
 	u32	 minute;
+	s32	 rem;
 
 	secs -= sys_tz.tz_minuteswest * 60 + ((8 * 365 + 2) * 24 * 60 * 60);
 	if (secs < 0)
 		secs = 0;
-	days    = secs / 86400;
-	secs   -= days * 86400;
-	minute  = secs / 60;
-	secs   -= minute * 60;
+	days    = div_s64_rem(secs, 86400, &rem);
+	minute  = rem / 60;
+	rem    -= minute * 60;
 
 	ds->days = cpu_to_be32(days);
 	ds->mins = cpu_to_be32(minute);
-	ds->ticks = cpu_to_be32(secs * 50);
+	ds->ticks = cpu_to_be32(rem * 50);
 }
 
 umode_t
diff -puN fs/affs/super.c~fs-affs-replace-time_t-with-time64_t fs/affs/super.c
--- a/fs/affs/super.c~fs-affs-replace-time_t-with-time64_t
+++ a/fs/affs/super.c
@@ -32,7 +32,7 @@ affs_commit_super(struct super_block *sb
 	struct affs_root_tail *tail = AFFS_ROOT_TAIL(sb, bh);
 
 	lock_buffer(bh);
-	secs_to_datestamp(get_seconds(), &tail->disk_change);
+	secs_to_datestamp(ktime_get_real_seconds(), &tail->disk_change);
 	affs_fix_checksum(sb, bh);
 	unlock_buffer(bh);
 
_

Patches currently in -mm which might be from chao.deng@linaro.org are

fs-affs-replace-time_t-with-time64_t.patch

