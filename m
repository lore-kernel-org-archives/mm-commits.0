From: akpm@linux-foundation.org
Subject: [merged] logfs-fix-logfs-build-errors-and-dependencies.patch
 removed from -mm tree
Date: Fri, 15 Jan 2016 14:31:23 -0800
Message-ID: <5699733b.S8lgjwnbEIViVkNB%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:58974 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752590AbcAOWbY (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 15 Jan 2016 17:31:24 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: arnd@arndb.de, joern@logfs.org, mmarek@suse.cz, peter.chen@freescale.com, prasadjoshi.linux@gmail.com, rdunlap@infradead.org, mm-commits@vger.kernel.org


The patch titled
     Subject: logfs: fix logfs build errors and dependencies
has been removed from the -mm tree.  Its filename was
     logfs-fix-logfs-build-errors-and-dependencies.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Arnd Bergmann <arnd@arndb.de>
Subject: logfs: fix logfs build errors and dependencies

Fix build errors that happen when CONFIG_LOGFS=y and CONFIG_MTD=m:

fs/built-in.o: In function `logfs_mount':
super.c:(.text+0x92a6f): undefined reference to `logfs_get_sb_mtd'
fs/built-in.o: In function `logfs_get_sb_bdev':
(.text+0x93530): undefined reference to `logfs_get_sb_mtd'

This patch avoids the error by changing the dependencies of
logfs in a way that we can no longer configure logfs as built-in
when the MTD core is a loadable module, while leaving the
dependency to require at least one of MTD or BLOCK to be
enabled.

Signed-off-by: Arnd Bergmann <arnd@arndb.de>
Signed-off-by: Randy Dunlap <rdunlap@infradead.org>
Cc: Michal Marek <mmarek@suse.cz>
Cc: Peter Chen <peter.chen@freescale.com>
Cc: Randy Dunlap <rdunlap@infradead.org>
Cc: Joern Engel <joern@logfs.org>
Cc: Prasad Joshi <prasadjoshi.linux@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/logfs/Kconfig |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN fs/logfs/Kconfig~logfs-fix-logfs-build-errors-and-dependencies fs/logfs/Kconfig
--- a/fs/logfs/Kconfig~logfs-fix-logfs-build-errors-and-dependencies
+++ a/fs/logfs/Kconfig
@@ -1,6 +1,6 @@
 config LOGFS
 	tristate "LogFS file system"
-	depends on (MTD || BLOCK)
+	depends on MTD || (!MTD && BLOCK)
 	select ZLIB_INFLATE
 	select ZLIB_DEFLATE
 	select CRC32
_

Patches currently in -mm which might be from arnd@arndb.de are

printk-nmi-generic-solution-for-safe-printk-in-nmi-v4-fix.patch
memstick-use-sector_div-instead-of-do_div.patch
mm-memcontrol-introduce-config_memcg_legacy_kmem-fix.patch
mm-memcontrol-clean-up-alloc-online-offline-free-functions-fix-2.patch

