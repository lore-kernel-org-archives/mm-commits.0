From: akpm@linux-foundation.org
Subject: [merged] hfsplus-use-enomem-when-kzalloc-fails.patch removed from -mm tree
Date: Tue, 31 Jul 2012 11:53:21 -0700
Message-ID: <20120731185321.AC4111E006E@wpzn4.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-ob0-f202.google.com ([209.85.214.202]:33060 "EHLO
	mail-ob0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756359Ab2GaSxW (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 31 Jul 2012 14:53:22 -0400
Received: by mail-ob0-f202.google.com with SMTP id wc20so4676512obb.1
        for <mm-commits@vger.kernel.org>; Tue, 31 Jul 2012 11:53:22 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: linkinjeon@gmail.com, hch@lst.de, mm-commits@vger.kernel.org


The patch titled
     Subject: hfsplus: use -ENOMEM when kzalloc() fails
has been removed from the -mm tree.  Its filename was
     hfsplus-use-enomem-when-kzalloc-fails.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Namjae Jeon <linkinjeon@gmail.com>
Subject: hfsplus: use -ENOMEM when kzalloc() fails

Use -ENOMEM return value instead of -EINVAL when kzalloc() fails.

Signed-off-by: Namjae Jeon <linkinjeon@gmail.com>
Cc: Christoph Hellwig <hch@lst.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/hfsplus/super.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN fs/hfsplus/super.c~hfsplus-use-enomem-when-kzalloc-fails fs/hfsplus/super.c
--- a/fs/hfsplus/super.c~hfsplus-use-enomem-when-kzalloc-fails
+++ a/fs/hfsplus/super.c
@@ -365,7 +365,7 @@ static int hfsplus_fill_super(struct sup
 	u64 last_fs_block, last_fs_page;
 	int err;
 
-	err = -EINVAL;
+	err = -ENOMEM;
 	sbi = kzalloc(sizeof(*sbi), GFP_KERNEL);
 	if (!sbi)
 		goto out;
_

Patches currently in -mm which might be from linkinjeon@gmail.com are

origin.patch
linux-next.patch

