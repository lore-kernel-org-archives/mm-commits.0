From: akpm@linux-foundation.org
Subject: [failures] aoe-use-min-to-simplify-the-code.patch removed from
 -mm tree
Date: Mon, 26 Aug 2013 13:59:14 -0700
Message-ID: <521bc1a2.8d8U+y0i2VXGANvk%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:57805 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752576Ab3HZU7P (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 26 Aug 2013 16:59:15 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, ecashin@coraid.com, andriy.shevchenko@linux.intel.com

Subject: [failures] aoe-use-min-to-simplify-the-code.patch removed from -mm tree
To: andriy.shevchenko@linux.intel.com,ecashin@coraid.com,mm-commits@vger.kernel.org
From: akpm@linux-foundation.org
Date: Mon, 26 Aug 2013 13:59:14 -0700


The patch titled
     Subject: aoe: use min() to simplify the code
has been removed from the -mm tree.  Its filename was
     aoe-use-min-to-simplify-the-code.patch

This patch was dropped because it had testing failures

------------------------------------------------------
From: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Subject: aoe: use min() to simplify the code

min() incorporates condition in it. In our case we could do assignment and
make a choice at once.

Signed-off-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Cc: Ed Cashin <ecashin@coraid.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/block/aoe/aoedev.c |    6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

diff -puN drivers/block/aoe/aoedev.c~aoe-use-min-to-simplify-the-code drivers/block/aoe/aoedev.c
--- a/drivers/block/aoe/aoedev.c~aoe-use-min-to-simplify-the-code
+++ a/drivers/block/aoe/aoedev.c
@@ -13,6 +13,7 @@
 #include <linux/kdev_t.h>
 #include <linux/moduleparam.h>
 #include <linux/string.h>
+#include <linux/kernel.h>
 #include "aoe.h"
 
 static void dummy_timer(ulong);
@@ -248,10 +249,7 @@ user_req(char *s, size_t slen, struct ao
 	if (!d->gd)
 		return 0;
 	p = kbasename(d->gd->disk_name);
-	lim = sizeof(d->gd->disk_name);
-	lim -= p - d->gd->disk_name;
-	if (slen < lim)
-		lim = slen;
+	lim = min(sizeof(d->gd->disk_name) - (p - d->gd->disk_name), slen);
 
 	return !strncmp(s, p, lim);
 }
_

Patches currently in -mm which might be from andriy.shevchenko@linux.intel.com are

aoe-remove-custom-implementation-of-kbasename.patch
aoe-suppress-compiler-warnings.patch
linux-next.patch

