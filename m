From: akpm@linux-foundation.org
Subject: [merged] aoe-initialize-sysminor-to-avoid-compiler-warning.patch removed from -mm tree
Date: Tue, 18 Dec 2012 12:11:05 -0800
Message-ID: <20121218201105.B3E7F100047@wpzn3.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-vc0-f202.google.com ([209.85.220.202]:59455 "EHLO
	mail-vc0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755304Ab2LRULG (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 18 Dec 2012 15:11:06 -0500
Received: by mail-vc0-f202.google.com with SMTP id m8so126159vcd.1
        for <mm-commits@vger.kernel.org>; Tue, 18 Dec 2012 12:11:06 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: ecashin@coraid.com, mm-commits@vger.kernel.org


The patch titled
     Subject: aoe: initialize sysminor to avoid compiler warning
has been removed from the -mm tree.  Its filename was
     aoe-initialize-sysminor-to-avoid-compiler-warning.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Ed Cashin <ecashin@coraid.com>
Subject: aoe: initialize sysminor to avoid compiler warning

Because the minor_get and related functions use the return values for
errors, the compiler doesn't know that sysminor will always either 1) be
initialized in aoedev_by_aoeaddr by the call to minor_get, or 2) be unused
as the "goto out" is executed.

This patch avoids the compiler warning.

Signed-off-by: Ed Cashin <ecashin@coraid.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/block/aoe/aoedev.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN drivers/block/aoe/aoedev.c~aoe-initialize-sysminor-to-avoid-compiler-warning drivers/block/aoe/aoedev.c
--- a/drivers/block/aoe/aoedev.c~aoe-initialize-sysminor-to-avoid-compiler-warning
+++ a/drivers/block/aoe/aoedev.c
@@ -383,7 +383,7 @@ aoedev_by_aoeaddr(ulong maj, int min, in
 	struct aoedev *d;
 	int i;
 	ulong flags;
-	ulong sysminor;
+	ulong sysminor = 0;
 
 	spin_lock_irqsave(&devlist_lock, flags);
 
_

Patches currently in -mm which might be from ecashin@coraid.com are

origin.patch
linux-next.patch

