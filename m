From: akpm@linux-foundation.org
Subject: [folded-merged]
 kmod-add-test-driver-to-stress-test-the-module-loader-fix.patch removed
 from -mm tree
Date: Fri, 14 Jul 2017 14:42:01 -0700
Message-ID: <59693aa9.npzP/CR123cfW7Wn%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:54784 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751115AbdGNVmC (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 14 Jul 2017 17:42:02 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: arnd@arndb.de, mcgrof@kernel.org, mm-commits@vger.kernel.org


The patch titled
     Subject: kmod: add dependencies for test module
has been removed from the -mm tree.  Its filename was
     kmod-add-test-driver-to-stress-test-the-module-loader-fix.patch

This patch was dropped because it was folded into kmod-add-test-driver-to-stress-test-the-module-loader.patch

------------------------------------------------------
From: Arnd Bergmann <arnd@arndb.de>
Subject: kmod: add dependencies for test module

When we try to 'select' drivers whose dependencies are not met, we get a
kconfig warning and undefined behavior as further 'select' statements in
those drivers can not be honored:

warning: (TEST_KMOD) selects TUN which has unmet direct dependencies (NETDEVICES && NET_CORE && INET)
warning: (TEST_KMOD) selects XFS_FS which has unmet direct dependencies (BLOCK && (64BIT || LBDAF))
ERROR: "iomap_zero_range" [fs/xfs/xfs.ko] undefined!
ERROR: "iomap_fiemap" [fs/xfs/xfs.ko] undefined!
ERROR: "iomap_page_mkwrite" [fs/xfs/xfs.ko] undefined!

To work around that, this adds the dependencies required by the 'tun',
'xfs' and 'btrfs' modules for CONFIG_TEST_KMOD, guaranteeing that we can
always enable those, and fixing the 'randconfig' issues.

Unfortunately, there is another problem that I have not found a good
solution for: If any of the three drivers are built-in rather than
loadable modules, then the module load test will later fail at runtime.

Fixes: ec159fed8677 ("kmod: add test driver to stress test the module loader")
Link: http://lkml.kernel.org/r/20170630154834.3689272-1-arnd@arndb.de
Signed-off-by: Arnd Bergmann <arnd@arndb.de>
Acked-by: Luis R. Rodriguez <mcgrof@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/Kconfig.debug |    2 ++
 1 file changed, 2 insertions(+)

diff -puN lib/Kconfig.debug~kmod-add-test-driver-to-stress-test-the-module-loader-fix lib/Kconfig.debug
--- a/lib/Kconfig.debug~kmod-add-test-driver-to-stress-test-the-module-loader-fix
+++ a/lib/Kconfig.debug
@@ -1879,6 +1879,8 @@ config TEST_KMOD
 	tristate "kmod stress tester"
 	default n
 	depends on m
+	depends on BLOCK && (64BIT || LBDAF)	  # for XFS, BTRFS
+	depends on NETDEVICES && NET_CORE && INET # for TUN
 	select TEST_LKM
 	select XFS_FS
 	select TUN
_

Patches currently in -mm which might be from arnd@arndb.de are

kmod-add-test-driver-to-stress-test-the-module-loader.patch

