From: akpm@linux-foundation.org
Subject: [folded-merged]
 nilfs2-replace-nilfs_warning-with-nilfs_msg-fix.patch removed from -mm tree
Date: Tue, 02 Aug 2016 13:44:28 -0700
Message-ID: <57a1062c.pwCZbgldSuminYxy%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:59542 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753059AbcHBUo3 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 2 Aug 2016 16:44:29 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: arnd@arndb.de, konishi.ryusuke@lab.ntt.co.jp, mm-commits@vger.kernel.org


The patch titled
     Subject: nilfs: avoid warning about unused variables
has been removed from the -mm tree.  Its filename was
     nilfs2-replace-nilfs_warning-with-nilfs_msg-fix.patch

This patch was dropped because it was folded into nilfs2-replace-nilfs_warning-with-nilfs_msg.patch

------------------------------------------------------
From: Arnd Bergmann <arnd@arndb.de>
Subject: nilfs: avoid warning about unused variables

The newly added nilfs_msg() infrastructure caused a warning in
nilfs_clear_dirty_page() when it is disabled:

fs/nilfs2/page.c: In function 'nilfs_clear_dirty_page':
fs/nilfs2/page.c:402:22: error: unused variable 'sb' [-Werror=unused-variable]
  struct super_block *sb = inode->i_sb;

We can avoid the warning by adding a cast to void for the first
argument of the macro.

Fixes: aede53d223f0 ("nilfs2: replace nilfs_warning() with nilfs_msg()")
Link: http://lkml.kernel.org/r/20160615201945.3348205-1-arnd@arndb.de
Signed-off-by: Arnd Bergmann <arnd@arndb.de>
Cc: Ryusuke Konishi <konishi.ryusuke@lab.ntt.co.jp>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/nilfs2/nilfs.h |    5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff -puN fs/nilfs2/nilfs.h~nilfs2-replace-nilfs_warning-with-nilfs_msg-fix fs/nilfs2/nilfs.h
--- a/fs/nilfs2/nilfs.h~nilfs2-replace-nilfs_warning-with-nilfs_msg-fix
+++ a/fs/nilfs2/nilfs.h
@@ -317,7 +317,10 @@ void __nilfs_error(struct super_block *s
 #else
 
 #define nilfs_msg(sb, level, fmt, ...)					\
-	no_printk(fmt, ##__VA_ARGS__)
+	do {								\
+		no_printk(fmt, ##__VA_ARGS__);				\
+		(void)(sb);						\
+	} while (0)
 #define nilfs_error(sb, fmt, ...)					\
 	do {								\
 		no_printk(fmt, ##__VA_ARGS__);				\
_

Patches currently in -mm which might be from arnd@arndb.de are

procfs-avoid-32-bit-time_t-in-proc-stat.patch
crc32-use-ktime_get_ns-for-measurement.patch
nilfs2-replace-nilfs_warning-with-nilfs_msg.patch

