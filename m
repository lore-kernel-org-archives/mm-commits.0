From: akpm@linux-foundation.org
Subject: [merged] drivers-memstick-core-mspro_block-use-kmemdup.patch
 removed from -mm tree
Date: Fri, 27 May 2016 11:43:52 -0700
Message-ID: <57489568.8j98UHJCutBS7HJ1%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:42534 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754400AbcE0Snx (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 27 May 2016 14:43:53 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: falakreyaz@gmail.com, mm-commits@vger.kernel.org


The patch titled
     Subject: drivers/memstick/core/mspro_block: use kmemdup
has been removed from the -mm tree.  Its filename was
     drivers-memstick-core-mspro_block-use-kmemdup.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Muhammad Falak R Wani <falakreyaz@gmail.com>
Subject: drivers/memstick/core/mspro_block: use kmemdup

Use kmemdup when some other buffer is immediately copied into allocated
region.  It replaces call to allocation followed by memcpy, by a single
call to kmemdup.

[akpm@linux-foundation.org: remove unneeded cast to void*]
Link: http://lkml.kernel.org/r/1463665743-16269-1-git-send-email-falakreyaz@gmail.com
Signed-off-by: Muhammad Falak R Wani <falakreyaz@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/memstick/core/mspro_block.c |    3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff -puN drivers/memstick/core/mspro_block.c~drivers-memstick-core-mspro_block-use-kmemdup drivers/memstick/core/mspro_block.c
--- a/drivers/memstick/core/mspro_block.c~drivers-memstick-core-mspro_block-use-kmemdup
+++ a/drivers/memstick/core/mspro_block.c
@@ -1033,12 +1033,11 @@ static int mspro_block_read_attributes(s
 	}
 	msb->attr_group.name = "media_attributes";
 
-	buffer = kmalloc(attr_len, GFP_KERNEL);
+	buffer = kmemdup(attr, attr_len, GFP_KERNEL);
 	if (!buffer) {
 		rc = -ENOMEM;
 		goto out_free_attr;
 	}
-	memcpy(buffer, (char *)attr, attr_len);
 
 	for (cnt = 0; cnt < attr_count; ++cnt) {
 		s_attr = kzalloc(sizeof(struct mspro_sys_attr), GFP_KERNEL);
_

Patches currently in -mm which might be from falakreyaz@gmail.com are


