From: akpm@linux-foundation.org
Subject: [merged] uwb-rename-random32-to-prandom_u32.patch removed from -mm tree
Date: Tue, 30 Apr 2013 12:02:44 -0700
Message-ID: <20130430190244.7353C31C07C@corp2gmr1-1.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-ve0-f201.google.com ([209.85.128.201]:45017 "EHLO
	mail-ve0-f201.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933507Ab3D3TCq (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 30 Apr 2013 15:02:46 -0400
Received: by mail-ve0-f201.google.com with SMTP id m1so78129ves.2
        for <mm-commits@vger.kernel.org>; Tue, 30 Apr 2013 12:02:44 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akinobu.mita@gmail.com, greg@kroah.com, mm-commits@vger.kernel.org


The patch titled
     Subject: uwb: rename random32() to prandom_u32()
has been removed from the -mm tree.  Its filename was
     uwb-rename-random32-to-prandom_u32.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Akinobu Mita <akinobu.mita@gmail.com>
Subject: uwb: rename random32() to prandom_u32()

Use preferable function name which implies using a pseudo-random
number generator.

Signed-off-by: Akinobu Mita <akinobu.mita@gmail.com>
Cc: Greg KH <greg@kroah.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/uwb/rsv.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff -puN drivers/uwb/rsv.c~uwb-rename-random32-to-prandom_u32 drivers/uwb/rsv.c
--- a/drivers/uwb/rsv.c~uwb-rename-random32-to-prandom_u32
+++ a/drivers/uwb/rsv.c
@@ -231,7 +231,7 @@ void uwb_rsv_backoff_win_increment(struc
 		return;
 
 	bow->window <<= 1;
-	bow->n = random32() & (bow->window - 1);
+	bow->n = prandom_u32() & (bow->window - 1);
 	dev_dbg(dev, "new_window=%d, n=%d\n: ", bow->window, bow->n);
 
 	/* reset the timer associated variables */
@@ -557,7 +557,7 @@ int uwb_rsv_establish(struct uwb_rsv *rs
 	if (ret)
 		goto out;
 
-	rsv->tiebreaker = random32() & 1;
+	rsv->tiebreaker = prandom_u32() & 1;
 	/* get available mas bitmap */
 	uwb_drp_available(rc, &available);
 
_

Patches currently in -mm which might be from akinobu.mita@gmail.com are

origin.patch
linux-next.patch
drivers-net-rename-random32-to-prandom_u32.patch
drivers-net-rename-random32-to-prandom_u32-fix.patch
drivers-net-rename-random32-to-prandom_u32-fix-fix.patch
remove-unused-random32-and-srandom32.patch
notifier-error-inject-fix-module-names-in-kconfig.patch

