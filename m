From: akpm@linux-foundation.org
Subject: + nilfs2-replace-nilfs_warning-with-nilfs_msg-fix.patch added to
 -mm tree
Date: Wed, 15 Jun 2016 13:28:09 -0700
Message-ID: <5761ba59.rxeBv7H60hCmeae1%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:33472 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1161028AbcFOU2K (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 15 Jun 2016 16:28:10 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: arnd@arndb.de, konishi.ryusuke@lab.ntt.co.jp, mm-commits@vger.kernel.org


The patch titled
     Subject: nilfs: avoid warning about unused variables
has been added to the -mm tree.  Its filename is
     nilfs2-replace-nilfs_warning-with-nilfs_msg-fix.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/nilfs2-replace-nilfs_warning-with-nilfs_msg-fix.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/nilfs2-replace-nilfs_warning-with-nilfs_msg-fix.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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

nilfs2-replace-nilfs_warning-with-nilfs_msg-fix.patch

