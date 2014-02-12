From: akpm@linux-foundation.org
Subject: + drivers-spi-spic-fix-max-warning.patch added to -mm tree
Date: Wed, 12 Feb 2014 12:24:24 -0800
Message-ID: <52fbd878.nkG6+qbWIaL1uV0k%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:52501 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753749AbaBLUYZ (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 12 Feb 2014 15:24:25 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, broonie@linaro.org, akpm@linux-foundation.org

Subject: + drivers-spi-spic-fix-max-warning.patch added to -mm tree
To: akpm@linux-foundation.org,broonie@linaro.org
From: akpm@linux-foundation.org
Date: Wed, 12 Feb 2014 12:24:24 -0800


The patch titled
     Subject: drivers/spi/spi.c: fix max() warning
has been added to the -mm tree.  Its filename is
     drivers-spi-spic-fix-max-warning.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/drivers-spi-spic-fix-max-warning.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/drivers-spi-spic-fix-max-warning.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: drivers/spi/spi.c: fix max() warning

drivers/spi/spi.c: In function 'spi_map_msg':
drivers/spi/spi.c:657: warning: comparison of distinct pointer types lacks a cast
drivers/spi/spi.c:660: warning: comparison of distinct pointer types lacks a cast

Cc: Mark Brown <broonie@linaro.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/spi/spi.c |    5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

diff -puN drivers/spi/spi.c~drivers-spi-spic-fix-max-warning drivers/spi/spi.c
--- a/drivers/spi/spi.c~drivers-spi-spic-fix-max-warning
+++ a/drivers/spi/spi.c
@@ -644,12 +644,11 @@ static int spi_map_msg(struct spi_master
 	struct device *tx_dev, *rx_dev;
 	struct spi_transfer *xfer;
 	void *tmp;
-	size_t max_tx, max_rx;
 	int ret;
 
 	if (master->flags & (SPI_MASTER_MUST_RX | SPI_MASTER_MUST_TX)) {
-		max_tx = 0;
-		max_rx = 0;
+		unsigned max_tx = 0;
+		unsigned max_rx = 0;
 
 		list_for_each_entry(xfer, &msg->transfers, transfer_list) {
 			if ((master->flags & SPI_MASTER_MUST_TX) &&
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

origin.patch
arch-alpha-kernel-systblss-remove-debug-check.patch
i-need-old-gcc.patch
input-route-kbd-leds-through-the-generic-leds-layer.patch
jffs2-avoid-soft-lockup-in-jffs2_reserve_space_gc-fix.patch
mm.patch
mm-hugetlb-improve-page-fault-scalability-fix.patch
mm-vmstat-fix-up-zone-state-accounting-fix.patch
mm-keep-page-cache-radix-tree-nodes-in-check-fix-fix.patch
drop_caches-add-some-documentation-and-info-message.patch
include-linux-syscallsh-add-sys32_quotactl-prototype-fix.patch
ncpfs-convert-dprintk-ddprintk-to-ncp_dbg-fix.patch
ncpfs-convert-dprintk-ddprintk-to-ncp_dbg-fix-fix.patch
kmod-run-usermodehelpers-only-on-cpus-allowed-for-kthreadd-v2-fix.patch
kmod-run-usermodehelpers-only-on-cpus-allowed-for-kthreadd-v2-checkpatch-fixes.patch
include-linux-crash_dumph-add-vmcore_cleanup-prototype-fix.patch
kernel-panicc-display-reason-at-end-pr_emerg-fix.patch
linux-next.patch
linux-next-git-rejects.patch
debugging-keep-track-of-page-owners.patch
journal_add_journal_head-debug.patch
kernel-forkc-export-kernel_thread-to-modules.patch
mutex-subsystem-synchro-test-module.patch
slab-leaks3-default-y.patch
put_bh-debug.patch
drivers-spi-spic-fix-max-warning.patch

