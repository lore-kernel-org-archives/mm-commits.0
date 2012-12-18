From: akpm@linux-foundation.org
Subject: [merged] aoe-return-real-minor-number-for-static-minors.patch removed from -mm tree
Date: Tue, 18 Dec 2012 12:11:08 -0800
Message-ID: <20121218201109.10B4220004E@hpza10.eem.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-wi0-f202.google.com ([209.85.212.202]:51056 "EHLO
	mail-wi0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755304Ab2LRULL (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 18 Dec 2012 15:11:11 -0500
Received: by mail-wi0-f202.google.com with SMTP id hn17so63459wib.1
        for <mm-commits@vger.kernel.org>; Tue, 18 Dec 2012 12:11:10 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: ecashin@coraid.com, mm-commits@vger.kernel.org


The patch titled
     Subject: aoe: return real minor number for static minors
has been removed from the -mm tree.  Its filename was
     aoe-return-real-minor-number-for-static-minors.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Ed Cashin <ecashin@coraid.com>
Subject: aoe: return real minor number for static minors

The value returned by the static minor device number number allocator is
the real minor number, so it must be multiplied by the supported number of
partitions per aoedev.

Without this fix the support for systems without udev is incomplete, and
the few users of aoe on such systems will have surprising results when
device nodes names do not match the AoE target.

Signed-off-by: Ed Cashin <ecashin@coraid.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/block/aoe/aoedev.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN drivers/block/aoe/aoedev.c~aoe-return-real-minor-number-for-static-minors drivers/block/aoe/aoedev.c
--- a/drivers/block/aoe/aoedev.c~aoe-return-real-minor-number-for-static-minors
+++ a/drivers/block/aoe/aoedev.c
@@ -95,7 +95,7 @@ minor_get_static(ulong *sysminor, ulong 
 	} else
 		set_bit(n, used_minors);
 	spin_unlock_irqrestore(&used_minors_lock, flags);
-	*sysminor = n;
+	*sysminor = n * AOE_PARTITIONS;
 out:
 	return error;
 }
_

Patches currently in -mm which might be from ecashin@coraid.com are

origin.patch
linux-next.patch

