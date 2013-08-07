From: akpm@linux-foundation.org
Subject: + aoe-remove-custom-implementation-of-kbasename.patch added to
 -mm tree
Date: Wed, 07 Aug 2013 13:54:19 -0700
Message-ID: <5202b3fb.hkNZQ3dNhEz1NQbn%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:39964 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932387Ab3HGUyU (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 7 Aug 2013 16:54:20 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, ecashin@coraid.com, andriy.shevchenko@linux.intel.com

Subject: + aoe-remove-custom-implementation-of-kbasename.patch added to -mm tree
To: andriy.shevchenko@linux.intel.com,ecashin@coraid.com
From: akpm@linux-foundation.org
Date: Wed, 07 Aug 2013 13:54:19 -0700


The patch titled
     Subject: aoe: remove custom implementation of kbasename()
has been added to the -mm tree.  Its filename is
     aoe-remove-custom-implementation-of-kbasename.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/aoe-remove-custom-implementation-of-kbasename.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/aoe-remove-custom-implementation-of-kbasename.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Subject: aoe: remove custom implementation of kbasename()

In the kernel we have a nice helper that may be used here. This patch
substitutes the custom implementation by the native function call.

Signed-off-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Cc: Ed Cashin <ecashin@coraid.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/block/aoe/aoedev.c |    9 +++------
 1 file changed, 3 insertions(+), 6 deletions(-)

diff -puN drivers/block/aoe/aoedev.c~aoe-remove-custom-implementation-of-kbasename drivers/block/aoe/aoedev.c
--- a/drivers/block/aoe/aoedev.c~aoe-remove-custom-implementation-of-kbasename
+++ a/drivers/block/aoe/aoedev.c
@@ -12,6 +12,7 @@
 #include <linux/bitmap.h>
 #include <linux/kdev_t.h>
 #include <linux/moduleparam.h>
+#include <linux/string.h>
 #include "aoe.h"
 
 static void dummy_timer(ulong);
@@ -241,16 +242,12 @@ aoedev_downdev(struct aoedev *d)
 static int
 user_req(char *s, size_t slen, struct aoedev *d)
 {
-	char *p;
+	const char *p;
 	size_t lim;
 
 	if (!d->gd)
 		return 0;
-	p = strrchr(d->gd->disk_name, '/');
-	if (!p)
-		p = d->gd->disk_name;
-	else
-		p += 1;
+	p = kbasename(d->gd->disk_name);
 	lim = sizeof(d->gd->disk_name);
 	lim -= p - d->gd->disk_name;
 	if (slen < lim)
_

Patches currently in -mm which might be from andriy.shevchenko@linux.intel.com are

aoe-remove-custom-implementation-of-kbasename.patch
aoe-use-min-to-simplify-the-code.patch
linux-next.patch

