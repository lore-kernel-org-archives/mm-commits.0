From: akpm@linux-foundation.org
Subject: [merged] drivers-md-mdc-use-strreplace.patch removed from -mm
 tree
Date: Mon, 29 Jun 2015 13:48:15 -0700
Message-ID: <5591af0f.15z5rT7heATydZvK%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:50935 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754228AbbF2UsR (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 29 Jun 2015 16:48:17 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: linux@rasmusvillemoes.dk, neilb@suse.de, mm-commits@vger.kernel.org


The patch titled
     Subject: drivers/md/md.c: use strreplace()
has been removed from the -mm tree.  Its filename was
     drivers-md-mdc-use-strreplace.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Rasmus Villemoes <linux@rasmusvillemoes.dk>
Subject: drivers/md/md.c: use strreplace()

There's no point in starting over when we meet a '/'.  This also
eliminates a stack variable and a little .text.

Signed-off-by: Rasmus Villemoes <linux@rasmusvillemoes.dk>
Acked-by: NeilBrown <neilb@suse.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/md/md.c |    4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

diff -puN drivers/md/md.c~drivers-md-mdc-use-strreplace drivers/md/md.c
--- a/drivers/md/md.c~drivers-md-mdc-use-strreplace
+++ a/drivers/md/md.c
@@ -2024,7 +2024,6 @@ static int bind_rdev_to_array(struct md_
 {
 	char b[BDEVNAME_SIZE];
 	struct kobject *ko;
-	char *s;
 	int err;
 
 	/* prevent duplicates */
@@ -2070,8 +2069,7 @@ static int bind_rdev_to_array(struct md_
 		return -EBUSY;
 	}
 	bdevname(rdev->bdev,b);
-	while ( (s=strchr(b, '/')) != NULL)
-		*s = '!';
+	strreplace(b, '/', '!');
 
 	rdev->mddev = mddev;
 	printk(KERN_INFO "md: bind<%s>\n", b);
_

Patches currently in -mm which might be from linux@rasmusvillemoes.dk are

origin.patch
linux-next.patch

