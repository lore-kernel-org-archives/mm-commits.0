From: akpm@linux-foundation.org
Subject: + kmod-add-test-driver-to-stress-test-the-module-loader-fix.patch added to -mm tree
Date: Fri, 30 Jun 2017 12:03:58 -0700
Message-ID: <5956a09e.vrkOSYTm8DwDsX+s%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:34104 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751918AbdF3TD7 (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 30 Jun 2017 15:03:59 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: arnd@arndb.de, mcgrof@kernel.org, mm-commits@vger.kernel.org


The patch titled
     Subject: kmod: add dependencies for test module
has been added to the -mm tree.  Its filename is
     kmod-add-test-driver-to-stress-test-the-module-loader-fix.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/kmod-add-test-driver-to-stress-test-the-module-loader-fix.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/kmod-add-test-driver-to-stress-test-the-module-loader-fix.patch

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
Cc: "Luis R. Rodriguez" <mcgrof@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/Kconfig.debug |    2 ++
 1 file changed, 2 insertions(+)

diff -puN lib/Kconfig.debug~kmod-add-test-driver-to-stress-test-the-module-loader-fix lib/Kconfig.debug
--- a/lib/Kconfig.debug~kmod-add-test-driver-to-stress-test-the-module-loader-fix
+++ a/lib/Kconfig.debug
@@ -1868,6 +1868,8 @@ config TEST_KMOD
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

mm-madvise-enable-softhard-offline-of-hugetlb-pages-at-pgd-level-fix.patch
mm-hugetlb-soft-offline-dissolve-source-hugepage-after-successful-migration-fix.patch
kernelh-handle-pointers-to-arrays-better-in-container_of-fix.patch
watchdog-provide-watchdog_reconfigure-for-arch-watchdogs-fix-2.patch
include-linux-stringh-add-the-option-of-fortified-stringh-functions-fix.patch
kmod-add-test-driver-to-stress-test-the-module-loader-fix.patch

