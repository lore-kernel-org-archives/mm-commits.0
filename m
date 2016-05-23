From: akpm@linux-foundation.org
Subject: [folded-merged]
 drivers-memstick-core-mspro_block-use-kmemdup-fix.patch removed from -mm
 tree
Date: Mon, 23 May 2016 16:16:03 -0700
Message-ID: <57438f33./NUDa7BdboMagox4%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:42063 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752063AbcEWXQE (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 23 May 2016 19:16:04 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, falakreyaz@gmail.com, mm-commits@vger.kernel.org


The patch titled
     Subject: drivers-memstick-core-mspro_block-use-kmemdup-fix
has been removed from the -mm tree.  Its filename was
     drivers-memstick-core-mspro_block-use-kmemdup-fix.patch

This patch was dropped because it was folded into drivers-memstick-core-mspro_block-use-kmemdup.patch

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: drivers-memstick-core-mspro_block-use-kmemdup-fix

remove unneeded cast to void*

Cc: Muhammad Falak R Wani <falakreyaz@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/memstick/core/mspro_block.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN drivers/memstick/core/mspro_block.c~drivers-memstick-core-mspro_block-use-kmemdup-fix drivers/memstick/core/mspro_block.c
--- a/drivers/memstick/core/mspro_block.c~drivers-memstick-core-mspro_block-use-kmemdup-fix
+++ a/drivers/memstick/core/mspro_block.c
@@ -1033,7 +1033,7 @@ static int mspro_block_read_attributes(s
 	}
 	msb->attr_group.name = "media_attributes";
 
-	buffer = kmemdup((char *)attr, attr_len, GFP_KERNEL);
+	buffer = kmemdup(attr, attr_len, GFP_KERNEL);
 	if (!buffer) {
 		rc = -ENOMEM;
 		goto out_free_attr;
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

drivers-memstick-core-mspro_block-use-kmemdup.patch

