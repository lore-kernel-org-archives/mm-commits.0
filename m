From: akpm@linux-foundation.org
Subject: + drivers-isdn-misdn-use-array_size.patch added to -mm tree
Date: Wed, 12 Nov 2008 15:13:34 -0800
Message-ID: <200811122313.mACNDYT7015332@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:37434 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751261AbYKLXOM (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 12 Nov 2008 18:14:12 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: julia@diku.dk, kkeil@suse.de


The patch titled
     drivers/isdn/mISDN: use ARRAY_SIZE
has been added to the -mm tree.  Its filename is
     drivers-isdn-misdn-use-array_size.patch

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
Subject: drivers/isdn/mISDN: use ARRAY_SIZE
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

- (sizeof(E)/sizeof(T))
+ ARRAY_SIZE(E)
// </smpl>

Signed-off-by: Julia Lawall <julia@diku.dk>
Cc: Karsten Keil <kkeil@suse.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/isdn/mISDN/dsp_hwec.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN drivers/isdn/mISDN/dsp_hwec.c~drivers-isdn-misdn-use-array_size drivers/isdn/mISDN/dsp_hwec.c
--- a/drivers/isdn/mISDN/dsp_hwec.c~drivers-isdn-misdn-use-array_size
+++ a/drivers/isdn/mISDN/dsp_hwec.c
@@ -43,7 +43,7 @@ static struct mISDN_dsp_element dsp_hwec
 	.free = NULL,
 	.process_tx = NULL,
 	.process_rx = NULL,
-	.num_args = sizeof(args) / sizeof(struct mISDN_dsp_element_arg),
+	.num_args = ARRAY_SIZE(args),
 	.args = args,
 };
 struct mISDN_dsp_element *dsp_hwec = &dsp_hwec_p;
_

Patches currently in -mm which might be from julia@diku.dk are

linux-next.patch
drivers-isdn-misdn-use-array_size.patch
fs-namespacec-drop-code-after-return.patch
crypto-md4c-use-array_size.patch

