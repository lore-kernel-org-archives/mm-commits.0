From: akpm@linux-foundation.org
Subject: + logfs-clarify-mtd-dependency.patch added to -mm tree
Date: Wed, 13 Jan 2016 12:37:15 -0800
Message-ID: <5696b57b.7Qy93xoPnAa7kIIU%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:49625 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752824AbcAMUhQ (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 13 Jan 2016 15:37:16 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: arnd@arndb.de, joern@logfs.org, mmarek@suse.cz, peter.chen@freescale.com, prasadjoshi.linux@gmail.com, rdunlap@infradead.org, mm-commits@vger.kernel.org


The patch titled
     Subject: logfs: clarify MTD dependency
has been added to the -mm tree.  Its filename is
     logfs-clarify-mtd-dependency.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/logfs-clarify-mtd-dependency.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/logfs-clarify-mtd-dependency.patch

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
Subject: logfs: clarify MTD dependency

After a change to the way that composite modules work, we get
a logfs build error:

fs/built-in.o: In function `logfs_mount':
:(.text+0x139d34): undefined reference to `logfs_get_sb_mtd'
fs/built-in.o: In function `logfs_get_sb_bdev':
:(.text+0x13aa08): undefined reference to `logfs_get_sb_mtd'

This patch avoids the error by changing the dependencies of
logfs in a way that we can no longer configure logfs as built-in
when the MTD core is a loadable module, while leaving the
dependency to require at least one of MTD or BLOCK to be
enabled.

Another patch tried to work around the problem, but accidentally
dropped the dependency on 'BLOCK || MTD', allowing the file
system to be built if neither is selected.

Fixes: cf4f21938e13 ("kbuild: Allow to specify composite modules with modname-m")
Fixes: e6be296f680c ("logfs: fix logfs build errors and dependencies")
Signed-off-by: Arnd Bergmann <arnd@arndb.de>
Cc: Michal Marek <mmarek@suse.cz>
Cc: Peter Chen <peter.chen@freescale.com>
Cc: Randy Dunlap <rdunlap@infradead.org>
Cc: Joern Engel <joern@logfs.org>
Cc: Prasad Joshi <prasadjoshi.linux@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/logfs/Kconfig |    3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff -puN fs/logfs/Kconfig~logfs-clarify-mtd-dependency fs/logfs/Kconfig
--- a/fs/logfs/Kconfig~logfs-clarify-mtd-dependency
+++ a/fs/logfs/Kconfig
@@ -1,7 +1,6 @@
 config LOGFS
 	tristate "LogFS file system"
-	depends on BLOCK || BLOCK=n
-	depends on MTD || MTD=n
+	depends on MTD || (!MTD && BLOCK)
 	select ZLIB_INFLATE
 	select ZLIB_DEFLATE
 	select CRC32
_

Patches currently in -mm which might be from arnd@arndb.de are

logfs-clarify-mtd-dependency.patch
include-define-__phys_to_pfn-as-phys_pfn-fix-2.patch
arm-thp-remove-infrastructure-for-handling-splitting-pmds-fix.patch
printk-nmi-generic-solution-for-safe-printk-in-nmi-v4-fix.patch
memstick-use-sector_div-instead-of-do_div.patch
mm-memcontrol-introduce-config_memcg_legacy_kmem-fix.patch
mm-memcontrol-clean-up-alloc-online-offline-free-functions-fix-2.patch

