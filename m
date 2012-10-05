From: akpm@linux-foundation.org
Subject: [merged] aoe-make-dynamic-block-minor-numbers-the-default.patch removed from -mm tree
Date: Fri, 05 Oct 2012 13:22:02 -0700
Message-ID: <20121005202202.958241E0049@wpzn4.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-gh0-f202.google.com ([209.85.160.202]:35153 "EHLO
	mail-gh0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932319Ab2JEUWD (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 5 Oct 2012 16:22:03 -0400
Received: by mail-gh0-f202.google.com with SMTP id z15so237104ghb.1
        for <mm-commits@vger.kernel.org>; Fri, 05 Oct 2012 13:22:02 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: ecashin@coraid.com, mm-commits@vger.kernel.org


The patch titled
     Subject: aoe: make dynamic block minor numbers the default
has been removed from the -mm tree.  Its filename was
     aoe-make-dynamic-block-minor-numbers-the-default.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Ed Cashin <ecashin@coraid.com>
Subject: aoe: make dynamic block minor numbers the default

Because udev use is so widespread, making the old static mapping the
default is too conservative, given the severe limitations it places on
usable AoE addresses.  Storage virtualization and larger shelves have made
the old limitations too confining.

These changes make the dynamic block device minor numbers the default,
removing the limitations on usable AoE addresses.

The static arrangement is still available with aoe_dyndevs=0, and the
aoe-stat tool from the userland aoetools package, the user space
counterpart to the aoe driver, recognizes the case where there is a
mismatch between the minor number in sysfs and the minor number in a
special device file.

Signed-off-by: Ed Cashin <ecashin@coraid.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/block/aoe/aoedev.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN drivers/block/aoe/aoedev.c~aoe-make-dynamic-block-minor-numbers-the-default drivers/block/aoe/aoedev.c
--- a/drivers/block/aoe/aoedev.c~aoe-make-dynamic-block-minor-numbers-the-default
+++ a/drivers/block/aoe/aoedev.c
@@ -19,7 +19,7 @@ static void aoedev_freedev(struct aoedev
 static void freetgt(struct aoedev *d, struct aoetgt *t);
 static void skbpoolfree(struct aoedev *d);
 
-static int aoe_dyndevs;
+static int aoe_dyndevs = 1;
 module_param(aoe_dyndevs, int, 0644);
 MODULE_PARM_DESC(aoe_dyndevs, "Use dynamic minor numbers for devices.");
 
_

Patches currently in -mm which might be from ecashin@coraid.com are

origin.patch

