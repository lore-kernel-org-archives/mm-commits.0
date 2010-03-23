From: akpm@linux-foundation.org
Subject: + drivers-media-video-avoid-null-dereference.patch added to -mm tree
Date: Mon, 22 Mar 2010 23:14:48 -0400
Message-ID: <201003230615.o2N6FeGk017708@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:36437 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754524Ab0CWGQA (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 23 Mar 2010 02:16:00 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: julia@diku.dk, laurent.pinchart@ideasonboard.com, mchehab@infradead.org, mmcclell@bigfoot.com


The patch titled
     drivers/media/video: avoid NULL dereference
has been added to the -mm tree.  Its filename is
     drivers-media-video-avoid-null-dereference.patch

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
Subject: drivers/media/video: avoid NULL dereference
From: Julia Lawall <julia@diku.dk>

If ov is NULL, it will not be possible to take the lock in the first place,
so move the test up earlier.

The semantic match that finds the problem is as follows:
(http://coccinelle.lip6.fr/)

// <smpl>
@r exists@
expression E, E1;
identifier f;
statement S1,S3;
iterator iter;
@@

if ((E == NULL && ...) || ...)
{
  ... when != false ((E == NULL && ...) || ...)
      when != true  ((E != NULL && ...) || ...)
      when != iter(E,...) S1
      when != E = E1
(
  sizeof(E->f)
|
* E->f
)
  ... when any
  return ...;
}
else S3
// </smpl>

Signed-off-by: Julia Lawall <julia@diku.dk>
Cc: Mark McClelland <mmcclell@bigfoot.com>
Cc: Mauro Carvalho Chehab <mchehab@infradead.org>
Cc: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/media/video/ov511.c |    8 +++-----
 1 file changed, 3 insertions(+), 5 deletions(-)

diff -puN drivers/media/video/ov511.c~drivers-media-video-avoid-null-dereference drivers/media/video/ov511.c
--- a/drivers/media/video/ov511.c~drivers-media-video-avoid-null-dereference
+++ a/drivers/media/video/ov511.c
@@ -5913,14 +5913,12 @@ ov51x_disconnect(struct usb_interface *i
 
 	PDEBUG(3, "");
 
+	if (!ov)
+		return;
+
 	mutex_lock(&ov->lock);
 	usb_set_intfdata (intf, NULL);
 
-	if (!ov) {
-		mutex_unlock(&ov->lock);
-		return;
-	}
