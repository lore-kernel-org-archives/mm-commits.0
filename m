From: akpm@linux-foundation.org
Subject: - forcedeth-disable-msix.patch removed from -mm tree
Date: Wed, 28 Feb 2007 15:52:37 -0800
Message-ID: <200702282352.l1SNqbn3031009@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:48260 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932629AbXB1Xwo (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Wed, 28 Feb 2007 18:52:44 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: aabdulla@nvidia.com, mm-commits@vger.kernel.org


The patch titled
     forcedeth: disable msix
has been removed from the -mm tree.  Its filename was
     forcedeth-disable-msix.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: forcedeth: disable msix
From: Ayaz Abdulla <aabdulla@nvidia.com>

There seems to be an issue when both MSI-X is enabled and NAPI is configured. 
This patch disables MSI-X until the issue is root caused.

Signed-off-by: Ayaz Abdulla <aabdulla@nvidia.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/net/forcedeth.c |    2 +-
 1 files changed, 1 insertion(+), 1 deletion(-)

diff -puN drivers/net/forcedeth.c~forcedeth-disable-msix drivers/net/forcedeth.c
--- a/drivers/net/forcedeth.c~forcedeth-disable-msix
+++ a/drivers/net/forcedeth.c
@@ -839,7 +839,7 @@ enum {
 	NV_MSIX_INT_DISABLED,
 	NV_MSIX_INT_ENABLED
 };
-static int msix = NV_MSIX_INT_ENABLED;
+static int msix = NV_MSIX_INT_DISABLED;
 
 /*
  * DMA 64bit
_

Patches currently in -mm which might be from aabdulla@nvidia.com are
