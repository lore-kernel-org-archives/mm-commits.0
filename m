From: akpm@linux-foundation.org
Subject: [merged] sysctl-fix-null-checking-in-bin_dn_node_address.patch removed from -mm tree
Date: Thu, 28 Feb 2013 12:16:50 -0800
Message-ID: <20130228201650.A3D065A41B6@corp2gmr1-2.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-yh0-f74.google.com ([209.85.213.74]:45405 "EHLO
	mail-yh0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759385Ab3B1UQv (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 28 Feb 2013 15:16:51 -0500
Received: by mail-yh0-f74.google.com with SMTP id z6so246711yhz.3
        for <mm-commits@vger.kernel.org>; Thu, 28 Feb 2013 12:16:51 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: xi.wang@gmail.com, ebiederm@xmission.com, stable@vger.kernel.org, mm-commits@vger.kernel.org


The patch titled
     Subject: sysctl: fix null checking in bin_dn_node_address()
has been removed from the -mm tree.  Its filename was
     sysctl-fix-null-checking-in-bin_dn_node_address.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Xi Wang <xi.wang@gmail.com>
Subject: sysctl: fix null checking in bin_dn_node_address()

The null check of `strchr() + 1' is broken, which is always non-null,
leading to OOB read.  Instead, check the result of strchr().

Signed-off-by: Xi Wang <xi.wang@gmail.com>
Cc: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/sysctl_binary.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff -puN kernel/sysctl_binary.c~sysctl-fix-null-checking-in-bin_dn_node_address kernel/sysctl_binary.c
--- a/kernel/sysctl_binary.c~sysctl-fix-null-checking-in-bin_dn_node_address
+++ a/kernel/sysctl_binary.c
@@ -1171,9 +1171,10 @@ static ssize_t bin_dn_node_address(struc
 
 		/* Convert the decnet address to binary */
 		result = -EIO;
-		nodep = strchr(buf, '.') + 1;
+		nodep = strchr(buf, '.');
 		if (!nodep)
 			goto out;
+		++nodep;
 
 		area = simple_strtoul(buf, NULL, 10);
 		node = simple_strtoul(nodep, NULL, 10);
_

Patches currently in -mm which might be from xi.wang@gmail.com are

origin.patch
drivers-usb-gadget-amd5536udcc-avoid-calling-dma_pool_create-with-null-dev.patch
mm-dmapoolc-fix-null-dev-in-dma_pool_create.patch

