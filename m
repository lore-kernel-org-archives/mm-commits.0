From: akpm@linux-foundation.org
Subject: + drivers-input-tablet-gtcoc-eliminate-early-return.patch added to -mm tree
Date: Mon, 30 Jun 2008 13:29:24 -0700
Message-ID: <200806302029.m5UKTOCu023930@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:43960 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750891AbYF3UaF (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 30 Jun 2008 16:30:05 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: julia@diku.dk, dtor@mail.ru


The patch titled
     drivers/input/tablet/gtco.c: eliminate early return
has been added to the -mm tree.  Its filename is
     drivers-input-tablet-gtcoc-eliminate-early-return.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

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

drivers-input-tablet-gtcoc-eliminate-early-return.patch

