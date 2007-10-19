From: akpm@linux-foundation.org
Subject: - uml-header_ops-conversion-needed-for-non-ethernet-drivers.patch removed from -mm tree
Date: Thu, 18 Oct 2007 20:39:57 -0700
Message-ID: <200710190339.l9J3dvda012649@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:44492 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1760588AbXJSDkJ (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 18 Oct 2007 23:40:09 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: jdike@addtoit.com, davem@davemloft.net, jdike@linux.intel.com, shemminger@linux-foundation.org, mm-commits@vger.kernel.org


The patch titled
     uml: header_ops conversion needed for non-ethernet drivers
has been removed from the -mm tree.  Its filename was
     uml-header_ops-conversion-needed-for-non-ethernet-drivers.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: uml: header_ops conversion needed for non-ethernet drivers
From: Jeff Dike <jdike@addtoit.com>

UML's two non-ethernet drivers need some header_ops conversion.

Signed-off-by: Jeff Dike <jdike@linux.intel.com>
Cc: "David S. Miller" <davem@davemloft.net>
Cc: Stephen Hemminger <shemminger@osdl.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/um/drivers/slip_kern.c  |    4 +---
 arch/um/drivers/slirp_kern.c |    4 +---
 2 files changed, 2 insertions(+), 6 deletions(-)

diff -puN arch/um/drivers/slip_kern.c~uml-header_ops-conversion-needed-for-non-ethernet-drivers arch/um/drivers/slip_kern.c
--- a/arch/um/drivers/slip_kern.c~uml-header_ops-conversion-needed-for-non-ethernet-drivers
+++ a/arch/um/drivers/slip_kern.c
@@ -30,10 +30,8 @@ void slip_init(struct net_device *dev, v
 	slip_proto_init(&spri->slip);
 
 	dev->init = NULL;
-	dev->header_cache_update = NULL;
-	dev->hard_header_cache = NULL;
-	dev->hard_header = NULL;
 	dev->hard_header_len = 0;
+	dev->header_ops = NULL;
 	dev->addr_len = 0;
 	dev->type = ARPHRD_SLIP;
 	dev->tx_queue_len = 256;
diff -puN arch/um/drivers/slirp_kern.c~uml-header_ops-conversion-needed-for-non-ethernet-drivers arch/um/drivers/slirp_kern.c
--- a/arch/um/drivers/slirp_kern.c~uml-header_ops-conversion-needed-for-non-ethernet-drivers
+++ a/arch/um/drivers/slirp_kern.c
@@ -31,9 +31,7 @@ void slirp_init(struct net_device *dev, 
 
 	dev->init = NULL;
 	dev->hard_header_len = 0;
-	dev->header_cache_update = NULL;
-	dev->hard_header_cache = NULL;
-	dev->hard_header = NULL;
+	dev->header_ops = NULL;
 	dev->addr_len = 0;
 	dev->type = ARPHRD_SLIP;
 	dev->tx_queue_len = 256;
_

Patches currently in -mm which might be from jdike@addtoit.com are

origin.patch
git-kvm.patch
