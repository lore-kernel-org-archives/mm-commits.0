From: akpm@linux-foundation.org
Subject: + drivers-memstick-core-mspro_block-use-kmemdup.patch added to
 -mm tree
Date: Mon, 23 May 2016 15:14:02 -0700
Message-ID: <574380aa.u7Ud7d6RIAT/7ukf%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:41459 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751581AbcEWWOD (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 23 May 2016 18:14:03 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: falakreyaz@gmail.com, mm-commits@vger.kernel.org


The patch titled
     Subject: drivers/memstick/core/mspro_block: use kmemdup
has been added to the -mm tree.  Its filename is
     drivers-memstick-core-mspro_block-use-kmemdup.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/drivers-memstick-core-mspro_block-use-kmemdup.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/drivers-memstick-core-mspro_block-use-kmemdup.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Muhammad Falak R Wani <falakreyaz@gmail.com>
Subject: drivers/memstick/core/mspro_block: use kmemdup

Use kmemdup when some other buffer is immediately copied into allocated
region.  It replaces call to allocation followed by memcpy, by a single
call to kmemdup.

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
+	buffer = kmemdup((char *)attr, attr_len, GFP_KERNEL);
 	if (!buffer) {
 		rc = -ENOMEM;
 		goto out_free_attr;
 	}
-	memcpy(buffer, (char *)attr, attr_len);
 
 	for (cnt = 0; cnt < attr_count; ++cnt) {
 		s_attr = kzalloc(sizeof(struct mspro_sys_attr), GFP_KERNEL);
_

Patches currently in -mm which might be from falakreyaz@gmail.com are

drivers-memstick-core-mspro_block-use-kmemdup.patch

