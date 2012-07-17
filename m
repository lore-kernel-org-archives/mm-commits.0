From: akpm@linux-foundation.org
Subject: [merged] hfsplus-get-rid-of-write_super-v3.patch removed from -mm tree
Date: Tue, 17 Jul 2012 13:05:01 -0700
Message-ID: <20120717200501.9EE35100048@wpzn3.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-gh0-f202.google.com ([209.85.160.202]:39099 "EHLO
	mail-gh0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756539Ab2GQUFC (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 17 Jul 2012 16:05:02 -0400
Received: by ghbz15 with SMTP id z15so81283ghb.1
        for <mm-commits@vger.kernel.org>; Tue, 17 Jul 2012 13:05:02 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: artem.bityutskiy@linux.intel.com, hch@lst.de, viro@zeniv.linux.org.uk, mm-commits@vger.kernel.org


The patch titled
     Subject: hfsplus-get-rid-of-write_super-v3
has been removed from the -mm tree.  Its filename was
     hfsplus-get-rid-of-write_super-v3.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Artem Bityutskiy <artem.bityutskiy@linux.intel.com>
Subject: hfsplus-get-rid-of-write_super-v3

Remove 'cancel_delayed_work()' from 'hfsplus_sync_fs()' because it is not
enough to just cancel the job, we need to set the work_queued flag to zero
as well.  I could do this, but it is simpler to just remove this tiny
optimization - we do not gain much with it.  I caught this bug while doing
some more testing.

Signed-off-by: Artem Bityutskiy <artem.bityutskiy@linux.intel.com>
Cc: Al Viro <viro@zeniv.linux.org.uk>
Cc: Christoph Hellwig <hch@lst.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/hfsplus/super.c |    2 --
 1 file changed, 2 deletions(-)

diff -puN fs/hfsplus/super.c~hfsplus-get-rid-of-write_super-v3 fs/hfsplus/super.c
--- a/fs/hfsplus/super.c~hfsplus-get-rid-of-write_super-v3
+++ a/fs/hfsplus/super.c
@@ -173,8 +173,6 @@ static int hfsplus_sync_fs(struct super_
 
 	dprint(DBG_SUPER, "hfsplus_sync_fs\n");
 
-	cancel_delayed_work(&sbi->sync_work);
