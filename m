From: akpm@linux-foundation.org
Subject: [alternative-merged] drivers-infiniband-hw-nes-nes_cmc-fix-unused-var-warning.patch removed from -mm tree
Date: Tue, 28 Apr 2009 12:21:11 -0700
Message-ID: <200904281921.n3SJLBEA018579@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:34363 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754534AbZD1TXa (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 28 Apr 2009 15:23:30 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: helight.xu@gmail.com, rolandd@cisco.com, mm-commits@vger.kernel.org


The patch titled
     drivers/infiniband/hw/nes/nes_cm.c: fix unused var warning
has been removed from the -mm tree.  Its filename was
     drivers-infiniband-hw-nes-nes_cmc-fix-unused-var-warning.patch

This patch was dropped because an alternative patch was merged

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: drivers/infiniband/hw/nes/nes_cm.c: fix unused var warning
From: Zhenwen Xu <helight.xu@gmail.com>

drivers/infiniband/hw/nes/nes_cm.c:862: warning: unused variable `tmp_addr'

The 'tmp_addr' is defined for debug, so it should be defined in
CONFIG_INFINIBAND_NES_DEBUG

Signed-off-by: Zhenwen Xu <helight.xu@gmail.com>
Cc: Roland Dreier <rolandd@cisco.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/infiniband/hw/nes/nes_cm.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff -puN drivers/infiniband/hw/nes/nes_cm.c~drivers-infiniband-hw-nes-nes_cmc-fix-unused-var-warning drivers/infiniband/hw/nes/nes_cm.c
--- a/drivers/infiniband/hw/nes/nes_cm.c~drivers-infiniband-hw-nes-nes_cmc-fix-unused-var-warning
+++ a/drivers/infiniband/hw/nes/nes_cm.c
@@ -854,8 +854,9 @@ static struct nes_cm_listener *find_list
 {
 	unsigned long flags;
 	struct nes_cm_listener *listen_node;
+#ifdef CONFIG_INFINIBAND_NES_DEBUG
 	__be32 tmp_addr = cpu_to_be32(dst_addr);
