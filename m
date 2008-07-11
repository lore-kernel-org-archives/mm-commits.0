From: akpm@linux-foundation.org
Subject: - drivers-input-tablet-gtcoc-eliminate-early-return.patch removed from -mm tree
Date: Fri, 11 Jul 2008 16:51:10 -0700
Message-ID: <200807112351.m6BNpAMF011018@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:40358 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754646AbYGKXvT (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 11 Jul 2008 19:51:19 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: julia@diku.dk, dtor@mail.ru, mm-commits@vger.kernel.org


The patch titled
     drivers/input/tablet/gtco.c: eliminate early return
has been removed from the -mm tree.  Its filename was
     drivers-input-tablet-gtcoc-eliminate-early-return.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: drivers/input/tablet/gtco.c: eliminate early return
From: Julia Lawall <julia@diku.dk>

There seems to be no reason why this error case should do less cleaning up
than the other adjacent ones, so the goto, which is currently dead code,
seems to be what is intended.

Signed-off-by: Julia Lawall <julia@diku.dk>
Cc: Dmitry Torokhov <dtor@mail.ru>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/input/tablet/gtco.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN drivers/input/tablet/gtco.c~drivers-input-tablet-gtcoc-eliminate-early-return drivers/input/tablet/gtco.c
--- a/drivers/input/tablet/gtco.c~drivers-input-tablet-gtcoc-eliminate-early-return
+++ a/drivers/input/tablet/gtco.c
@@ -863,7 +863,7 @@ static int gtco_probe(struct usb_interfa
 	gtco->urbinfo = usb_alloc_urb(0, GFP_KERNEL);
 	if (!gtco->urbinfo) {
 		err("Failed to allocate URB");
-		return -ENOMEM;
+		error = -ENOMEM;
 		goto err_free_buf;
 	}
 
_

Patches currently in -mm which might be from julia@diku.dk are

linux-next.patch

