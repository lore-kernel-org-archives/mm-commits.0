From: akpm@linux-foundation.org
Subject: + forcedeth-disable-msix.patch added to -mm tree
Date: Wed, 21 Feb 2007 13:26:14 -0800
Message-ID: <200702212126.l1LLQFaP026850@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:49451 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1423152AbXBUV0T (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Wed, 21 Feb 2007 16:26:19 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: aabdulla@nvidia.com


The patch titled
     forcedeth: disable msix
has been added to the -mm tree.  Its filename is
     forcedeth-disable-msix.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

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

forcedeth-fixed-missing-call-in-napi-poll.patch
forcedeth-disable-msix.patch
forcedeth-fix-checksum-feature-in-mcp65.patch
