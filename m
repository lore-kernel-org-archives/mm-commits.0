From: akpm@linux-foundation.org
Subject: - use-is_power_of_2-in-cxgb3-cxgb3_mainc.patch removed from -mm tree
Date: Tue, 10 Jul 2007 12:48:58 -0700
Message-ID: <200707101948.l6AJmwi0026041@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:53364 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755289AbXGJTtG (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 10 Jul 2007 15:49:06 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: vignesh.babu@wipro.com, mm-commits@vger.kernel.org


The patch titled
     use is_power_of_2() in cxgb3/cxgb3_main.c
has been removed from the -mm tree.  Its filename was
     use-is_power_of_2-in-cxgb3-cxgb3_mainc.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: use is_power_of_2() in cxgb3/cxgb3_main.c
From: vignesh babu <vignesh.babu@wipro.com>

Replace (n & (n-1)) with is_power_of_2()

Signed-off-by: vignesh babu <vignesh.babu@wipro.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/net/cxgb3/cxgb3_main.c |    5 +++--
 1 files changed, 3 insertions(+), 2 deletions(-)

diff -puN drivers/net/cxgb3/cxgb3_main.c~use-is_power_of_2-in-cxgb3-cxgb3_mainc drivers/net/cxgb3/cxgb3_main.c
--- a/drivers/net/cxgb3/cxgb3_main.c~use-is_power_of_2-in-cxgb3-cxgb3_mainc
+++ a/drivers/net/cxgb3/cxgb3_main.c
@@ -43,6 +43,7 @@
 #include <linux/proc_fs.h>
 #include <linux/rtnetlink.h>
 #include <linux/firmware.h>
+#include <linux/log2.h>
 #include <asm/uaccess.h>
 
 #include "common.h"
@@ -1818,8 +1819,8 @@ static int cxgb_extension_ioctl(struct n
 			return -EBUSY;
 		if (copy_from_user(&m, useraddr, sizeof(m)))
 			return -EFAULT;
-		if (!m.rx_pg_sz || (m.rx_pg_sz & (m.rx_pg_sz - 1)) ||
-			!m.tx_pg_sz || (m.tx_pg_sz & (m.tx_pg_sz - 1)))
+		if (!is_power_of_2(m.rx_pg_sz) ||
+			!is_power_of_2(m.tx_pg_sz))
 			return -EINVAL;	/* not power of 2 */
 		if (!(m.rx_pg_sz & 0x14000))
 			return -EINVAL;	/* not 16KB or 64KB */
_

Patches currently in -mm which might be from vignesh.babu@wipro.com are

git-ubi.patch
git-netdev-all.patch
git-xfs.patch
is_power_of_2-ext3-superc.patch
is_power_of_2-jbd.patch
is_power_of_2-kernel-kfifoc.patch
is_power_of_2-ufs-superc.patch
is_power_of_2-ext4-superc.patch
