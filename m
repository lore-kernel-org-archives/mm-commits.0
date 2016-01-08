From: akpm@linux-foundation.org
Subject: + logfs-fix-logfs-build-errors-and-dependencies.patch added to
 -mm tree
Date: Fri, 08 Jan 2016 14:08:23 -0800
Message-ID: <56903357.anCglowIi2j8mth6%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:45078 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754508AbcAHWIY (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 8 Jan 2016 17:08:24 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: rdunlap@infradead.org, joern@logfs.org, prasadjoshi.linux@gmail.com, mm-commits@vger.kernel.org


The patch titled
     Subject: logfs: fix logfs build errors and dependencies
has been added to the -mm tree.  Its filename is
     logfs-fix-logfs-build-errors-and-dependencies.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/logfs-fix-logfs-build-errors-and-dependencies.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/logfs-fix-logfs-build-errors-and-dependencies.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Randy Dunlap <rdunlap@infradead.org>
Subject: logfs: fix logfs build errors and dependencies

Fix build errors that happen when CONFIG_LOGFS=y and CONFIG_MTD=m:

fs/built-in.o: In function `logfs_mount':
super.c:(.text+0x92a6f): undefined reference to `logfs_get_sb_mtd'
fs/built-in.o: In function `logfs_get_sb_bdev':
(.text+0x93530): undefined reference to `logfs_get_sb_mtd'

This change allows CONFIG_BLOCK and CONFIG_MTD to be disabled, but if
either of them is enabled, CONFIG_LOGFS is limited (restricted) by the
setting of the former symbol(s).

Signed-off-by: Randy Dunlap <rdunlap@infradead.org>
Cc: Joern Engel <joern@logfs.org>
Cc: Prasad Joshi <prasadjoshi.linux@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/logfs/Kconfig |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff -puN fs/logfs/Kconfig~logfs-fix-logfs-build-errors-and-dependencies fs/logfs/Kconfig
--- a/fs/logfs/Kconfig~logfs-fix-logfs-build-errors-and-dependencies
+++ a/fs/logfs/Kconfig
@@ -1,6 +1,7 @@
 config LOGFS
 	tristate "LogFS file system"
-	depends on (MTD || BLOCK)
+	depends on BLOCK || BLOCK=n
+	depends on MTD || MTD=n
 	select ZLIB_INFLATE
 	select ZLIB_DEFLATE
 	select CRC32
_

Patches currently in -mm which might be from rdunlap@infradead.org are

logfs-fix-logfs-build-errors-and-dependencies.patch

