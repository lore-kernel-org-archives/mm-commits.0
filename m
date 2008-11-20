From: akpm@linux-foundation.org
Subject: - drivers-video-backlight-da903xc-introduce-missing-kfree.patch removed from -mm tree
Date: Thu, 20 Nov 2008 12:43:13 -0800
Message-ID: <200811202043.mAKKhDYi007385@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:43893 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755406AbYKTUnw (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 20 Nov 2008 15:43:52 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: julia@diku.dk, eric.miao@marvell.com, mike@compulab.co.il, rpurdie@linux.intel.com, mm-commits@vger.kernel.org


The patch titled
     drivers/video/backlight/da903x.c: introduce missing kfree
has been removed from the -mm tree.  Its filename was
     drivers-video-backlight-da903xc-introduce-missing-kfree.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: drivers/video/backlight/da903x.c: introduce missing kfree
From: Julia Lawall <julia@diku.dk>

Error handling code following a kzalloc should free the allocated data.

The semantic match that finds the problem is as follows:
(http://www.emn.fr/x-info/coccinelle/)

// <smpl>
@r exists@
local idexpression x;
statement S;
expression E;
identifier f,l;
position p1,p2;
expression *ptr != NULL;
@@

(
if ((x@p1 = \(kmalloc\|kzalloc\|kcalloc\)(...)) == NULL) S
|
x@p1 = \(kmalloc\|kzalloc\|kcalloc\)(...);
...
if (x == NULL) S
)
<... when != x
     when != if (...) { <+...x...+> }
x->f = E
...>
(
 return \(0\|<+...x...+>\|ptr\);
|
 return@p2 ...;
)

@script:python@
p1 << r.p1;
p2 << r.p2;
@@

print "* file: %s kmalloc %s return %s" % (p1[0].file,p1[0].line,p2[0].line)
// </smpl>

Signed-off-by: Julia Lawall <julia@diku.dk>
Cc: Mike Rapoport <mike@compulab.co.il>
Cc: Richard Purdie <rpurdie@linux.intel.com>
Cc: Eric Miao <eric.miao@marvell.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/video/backlight/da903x.c |    1 +
 1 file changed, 1 insertion(+)

diff -puN drivers/video/backlight/da903x.c~drivers-video-backlight-da903xc-introduce-missing-kfree drivers/video/backlight/da903x.c
--- a/drivers/video/backlight/da903x.c~drivers-video-backlight-da903xc-introduce-missing-kfree
+++ a/drivers/video/backlight/da903x.c
@@ -119,6 +119,7 @@ static int da903x_backlight_probe(struct
 	default:
 		dev_err(&pdev->dev, "invalid backlight device ID(%d)\n",
 				pdev->id);
+		kfree(data);
 		return -EINVAL;
 	}
 
_

Patches currently in -mm which might be from julia@diku.dk are

origin.patch
linux-next.patch
drivers-media-use-array_size.patch
drivers-mtd-maps-nettelc-use-array_size.patch
net-tipc-bcasth-use-array_size.patch
drivers-isdn-misdn-use-array_size.patch
drivers-message-fusion-use-array_size.patch
fs-namespacec-drop-code-after-return.patch
drivers-net-wireless-ath9k-rcc-use-array_size.patch
kernel-trace-tracec-introduce-missing-kfree.patch

