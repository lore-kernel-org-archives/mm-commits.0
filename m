From: akpm@linux-foundation.org
Subject: + aoe-fix-use-after-free-in-aoedev_by_aoeaddr.patch added to -mm tree
Date: Fri, 07 Dec 2012 15:36:05 -0800
Message-ID: <20121207233606.B599782004A@wpzn4.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-qc0-f202.google.com ([209.85.216.202]:62529 "EHLO
	mail-qc0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753921Ab2LGXgN (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 7 Dec 2012 18:36:13 -0500
Received: by mail-qc0-f202.google.com with SMTP id s25so110608qcq.1
        for <mm-commits@vger.kernel.org>; Fri, 07 Dec 2012 15:36:13 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: dan.carpenter@oracle.com, ecashin@coraid.com


The patch titled
     Subject: aoe: fix use after free in aoedev_by_aoeaddr()
has been added to the -mm tree.  Its filename is
     aoe-fix-use-after-free-in-aoedev_by_aoeaddr.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Dan Carpenter <dan.carpenter@oracle.com>
Subject: aoe: fix use after free in aoedev_by_aoeaddr()

We should return NULL on failure instead of returning a freed pointer.

Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
Cc: Ed Cashin <ecashin@coraid.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/block/aoe/aoedev.c |    1 +
 1 file changed, 1 insertion(+)

diff -puN drivers/block/aoe/aoedev.c~aoe-fix-use-after-free-in-aoedev_by_aoeaddr drivers/block/aoe/aoedev.c
--- a/drivers/block/aoe/aoedev.c~aoe-fix-use-after-free-in-aoedev_by_aoeaddr
+++ a/drivers/block/aoe/aoedev.c
@@ -461,6 +461,7 @@ aoedev_by_aoeaddr(ulong maj, int min, in
 	d->targets = kcalloc(NTARGETS, sizeof(*d->targets), GFP_ATOMIC);
 	if (!d->targets) {
 		kfree(d);
+		d = NULL;
 		goto out;
 	}
 	d->ntargets = NTARGETS;
_

Patches currently in -mm which might be from dan.carpenter@oracle.com are

origin.patch
linux-next.patch
aoe-print-warning-regarding-a-common-reason-for-dropped-transmits-fix.patch
aoe-fix-use-after-free-in-aoedev_by_aoeaddr.patch

