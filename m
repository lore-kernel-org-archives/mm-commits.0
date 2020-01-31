From: akpm@linux-foundation.org
Subject: [merged]
 ocfs2-dlm-move-bits_to_bytes-to-bitopsh-for-wider-use.patch removed from
 -mm tree
Date: Fri, 31 Jan 2020 15:17:06 -0800
Message-ID: <20200131231706.vdYH_6O0p%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:49070 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726319AbgAaXRH (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Fri, 31 Jan 2020 18:17:07 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: andriy.shevchenko@linux.intel.com, gechangwei@live.cn, ghe@suse.com, jlbec@evilplan.org, joseph.qi@linux.alibaba.com, junxiao.bi@oracle.com, mark@fasheh.com, mm-commits@vger.kernel.org, piaojun@huawei.com, skalluru@marvell.com


The patch titled
     Subject: ocfs2/dlm: move BITS_TO_BYTES() to bitops.h for wider use
has been removed from the -mm tree.  Its filename was
     ocfs2-dlm-move-bits_to_bytes-to-bitopsh-for-wider-use.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Subject: ocfs2/dlm: move BITS_TO_BYTES() to bitops.h for wider use

There are users already and will be more of BITS_TO_BYTES() macro.  Move
it to bitops.h for wider use.

In the case of ocfs2 the replacement is identical.

As for bnx2x, there are two places where floor version is used.  In the
first case to calculate the amount of structures that can fit one memory
page.  In this case obviously the ceiling variant is correct and original
code might have a potential bug, if amount of bits % 8 is not 0.  In the
second case the macro is used to calculate bytes transmitted in one
microsecond.  This will work for all speeds which is multiply of 1Gbps
without any change, for the rest new code will give ceiling value, for
instance 100Mbps will give 13 bytes, while old code gives 12 bytes and the
arithmetically correct one is 12.5 bytes.  Further the value is used to
setup timer threshold which in any case has its own margins due to certain
resolution.  I don't see here an issue with slightly shifting thresholds
for low speed connections, the card is supposed to utilize highest
available rate, which is usually 10Gbps.

Link: http://lkml.kernel.org/r/20200108121316.22411-1-andriy.shevchenko@linux.intel.com
Signed-off-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Reviewed-by: Joseph Qi <joseph.qi@linux.alibaba.com>
Acked-by: Sudarsana Reddy Kalluru <skalluru@marvell.com>
Cc: Mark Fasheh <mark@fasheh.com>
Cc: Joel Becker <jlbec@evilplan.org>
Cc: Junxiao Bi <junxiao.bi@oracle.com>
Cc: Changwei Ge <gechangwei@live.cn>
Cc: Gang He <ghe@suse.com>
Cc: Jun Piao <piaojun@huawei.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/net/ethernet/broadcom/bnx2x/bnx2x_init.h |    1 -
 fs/ocfs2/dlm/dlmcommon.h                         |    4 ----
 include/linux/bitops.h                           |    1 +
 3 files changed, 1 insertion(+), 5 deletions(-)

--- a/drivers/net/ethernet/broadcom/bnx2x/bnx2x_init.h~ocfs2-dlm-move-bits_to_bytes-to-bitopsh-for-wider-use
+++ a/drivers/net/ethernet/broadcom/bnx2x/bnx2x_init.h
@@ -296,7 +296,6 @@ static inline void bnx2x_dcb_config_qm(s
  *    possible, the driver should only write the valid vnics into the internal
  *    ram according to the appropriate port mode.
  */
-#define BITS_TO_BYTES(x) ((x)/8)
 
 /* CMNG constants, as derived from system spec calculations */
 
--- a/fs/ocfs2/dlm/dlmcommon.h~ocfs2-dlm-move-bits_to_bytes-to-bitopsh-for-wider-use
+++ a/fs/ocfs2/dlm/dlmcommon.h
@@ -688,10 +688,6 @@ struct dlm_begin_reco
 	__be32 pad2;
 };
 
-
-#define BITS_PER_BYTE 8
-#define BITS_TO_BYTES(bits) (((bits)+BITS_PER_BYTE-1)/BITS_PER_BYTE)
