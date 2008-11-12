From: akpm@linux-foundation.org
Subject: + drivers-mtd-maps-nettelc-use-array_size.patch added to -mm tree
Date: Wed, 12 Nov 2008 15:34:49 -0800
Message-ID: <200811122334.mACNYnMx026062@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:36494 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755850AbYKLXfR (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 12 Nov 2008 18:35:17 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: julia@diku.dk


The patch titled
     drivers/mtd/maps/nettel.c: use ARRAY_SIZE
has been added to the -mm tree.  Its filename is
     drivers-mtd-maps-nettelc-use-array_size.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://userweb.kernel.org/~akpm/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: drivers/mtd/maps/nettel.c: use ARRAY_SIZE
From: Julia Lawall <julia@diku.dk>

ARRAY_SIZE is more concise to use when the size of an array is divided by
the size of its type or the size of its first element.

The semantic patch that makes this change is as follows:
(http://www.emn.fr/x-info/coccinelle/)

// <smpl>
@i@
@@

#include <linux/kernel.h>

@depends on i using "paren.iso"@
type T;
T[] E;
@@

- (sizeof(E)/sizeof(E[...]))
+ ARRAY_SIZE(E)
// </smpl>

Signed-off-by: Julia Lawall <julia@diku.dk>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/mtd/maps/nettel.c |    3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff -puN drivers/mtd/maps/nettel.c~drivers-mtd-maps-nettelc-use-array_size drivers/mtd/maps/nettel.c
--- a/drivers/mtd/maps/nettel.c~drivers-mtd-maps-nettelc-use-array_size
+++ a/drivers/mtd/maps/nettel.c
@@ -362,8 +362,7 @@ static int __init nettel_init(void)
 
 	intel_mtd->owner = THIS_MODULE;
 
-	num_intel_partitions = sizeof(nettel_intel_partitions) /
-		sizeof(nettel_intel_partitions[0]);
+	num_intel_partitions = ARRAY_SIZE(nettel_intel_partitions);
 
 	if (intelboot) {
 		/*
_

Patches currently in -mm which might be from julia@diku.dk are

linux-next.patch
drivers-media-use-array_size.patch
drivers-mtd-maps-nettelc-use-array_size.patch
drivers-isdn-misdn-use-array_size.patch
drivers-message-fusion-use-array_size.patch
fs-namespacec-drop-code-after-return.patch
crypto-md4c-use-array_size.patch

