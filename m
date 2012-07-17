From: akpm@linux-foundation.org
Subject: [merged] hfsplus-remove-useless-check.patch removed from -mm tree
Date: Tue, 17 Jul 2012 13:04:51 -0700
Message-ID: <20120717200451.A72CA1E0043@wpzn4.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-yx0-f202.google.com ([209.85.213.202]:65360 "EHLO
	mail-yx0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756543Ab2GQUE6 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 17 Jul 2012 16:04:58 -0400
Received: by mail-yx0-f202.google.com with SMTP id l3so81417yen.1
        for <mm-commits@vger.kernel.org>; Tue, 17 Jul 2012 13:04:57 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: artem.bityutskiy@linux.intel.com, hch@lst.de, viro@zeniv.linux.org.uk, mm-commits@vger.kernel.org


The patch titled
     Subject: hfsplus: remove useless check
has been removed from the -mm tree.  Its filename was
     hfsplus-remove-useless-check.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Artem Bityutskiy <artem.bityutskiy@linux.intel.com>
Subject: hfsplus: remove useless check

This check is useless because we always have 'sb->s_fs_info' to be non-NULL.

Signed-off-by: Artem Bityutskiy <artem.bityutskiy@linux.intel.com>
Cc: Al Viro <viro@zeniv.linux.org.uk>
Cc: Christoph Hellwig <hch@lst.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/hfsplus/super.c |    3 ---
 1 file changed, 3 deletions(-)

diff -puN fs/hfsplus/super.c~hfsplus-remove-useless-check fs/hfsplus/super.c
--- a/fs/hfsplus/super.c~hfsplus-remove-useless-check
+++ a/fs/hfsplus/super.c
@@ -240,9 +240,6 @@ static void hfsplus_put_super(struct sup
 
 	dprint(DBG_SUPER, "hfsplus_put_super\n");
 
-	if (!sb->s_fs_info)
-		return;
