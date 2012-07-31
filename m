From: akpm@linux-foundation.org
Subject: [merged] drivers-message-i2o-i2o_configc-bound-allocation.patch removed from -mm tree
Date: Tue, 31 Jul 2012 11:51:58 -0700
Message-ID: <20120731185158.A254D10007F@wpzn3.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-ob0-f202.google.com ([209.85.214.202]:33060 "EHLO
	mail-ob0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756346Ab2GaSv7 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 31 Jul 2012 14:51:59 -0400
Received: by mail-ob0-f202.google.com with SMTP id wc20so4676512obb.1
        for <mm-commits@vger.kernel.org>; Tue, 31 Jul 2012 11:51:59 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: alan@linux.intel.com, mm-commits@vger.kernel.org


The patch titled
     Subject: drivers/message/i2o/i2o_config.c: bound allocation
has been removed from the -mm tree.  Its filename was
     drivers-message-i2o-i2o_configc-bound-allocation.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Alan Cox <alan@linux.intel.com>
Subject: drivers/message/i2o/i2o_config.c: bound allocation

Fix a case where users can try to allocate arbitarily large amounts of
memory. 64K is overkill for a config request so apply an upper bound.

Signed-off-by: Alan Cox <alan@linux.intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/message/i2o/i2o_config.c |    7 +++++++
 1 file changed, 7 insertions(+)

diff -puN drivers/message/i2o/i2o_config.c~drivers-message-i2o-i2o_configc-bound-allocation drivers/message/i2o/i2o_config.c
--- a/drivers/message/i2o/i2o_config.c~drivers-message-i2o-i2o_configc-bound-allocation
+++ a/drivers/message/i2o/i2o_config.c
@@ -188,6 +188,13 @@ static int i2o_cfg_parms(unsigned long a
 	if (!dev)
 		return -ENXIO;
 
+	/*
+	 * Stop users being able to try and allocate arbitary amounts
+	 * of DMA space. 64K is way more than sufficient for this.
+	 */
+	if (kcmd.oplen > 65536)
+		return -EMSGSIZE;
+
 	ops = memdup_user(kcmd.opbuf, kcmd.oplen);
 	if (IS_ERR(ops))
 		return PTR_ERR(ops);
_

Patches currently in -mm which might be from alan@linux.intel.com are

origin.patch
linux-next.patch
ppc-e500_tlb-memset-clears-nothing.patch

