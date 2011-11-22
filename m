From: akpm@linux-foundation.org
Subject: + drivers-memstick-use-kmemdup-rather-than-duplicating-its-implementation.patch added to -mm tree
Date: Tue, 22 Nov 2011 15:42:06 -0800
Message-ID: <201111222342.pAMNg6pd013611@wpaz1.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-gx0-f202.google.com ([209.85.161.202]:63654 "EHLO
	mail-gx0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753701Ab1KVXmI (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 22 Nov 2011 18:42:08 -0500
Received: by ggdk5 with SMTP id k5so151165ggd.1
        for <mm-commits@vger.kernel.org>; Tue, 22 Nov 2011 15:42:08 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: thomas@m3y3r.de


The patch titled
     Subject: drivers/memstick: use kmemdup rather than duplicating its implementation
has been added to the -mm tree.  Its filename is
     drivers-memstick-use-kmemdup-rather-than-duplicating-its-implementation.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://userweb.kernel.org/~akpm/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
From: Thomas Meyer <thomas@m3y3r.de>
Subject: drivers/memstick: use kmemdup rather than duplicating its implementation

Use kmemdup rather than duplicating its implementation

The semantic patch that makes this change is available
in scripts/coccinelle/api/memdup.cocci.

Signed-off-by: Thomas Meyer <thomas@m3y3r.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/memstick/core/mspro_block.c |    3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff -puN drivers/memstick/core/mspro_block.c~drivers-memstick-use-kmemdup-rather-than-duplicating-its-implementation drivers/memstick/core/mspro_block.c
--- a/drivers/memstick/core/mspro_block.c~drivers-memstick-use-kmemdup-rather-than-duplicating-its-implementation
+++ a/drivers/memstick/core/mspro_block.c
@@ -1034,12 +1034,11 @@ static int mspro_block_read_attributes(s
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
Subject: Subject: drivers/memstick: use kmemdup rather than duplicating its implementation

Patches currently in -mm which might be from thomas@m3y3r.de are

origin.patch
linux-next.patch
drivers-memstick-use-kmemdup-rather-than-duplicating-its-implementation.patch

