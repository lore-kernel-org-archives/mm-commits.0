From: akpm@linux-foundation.org
Subject: [merged] drivers-media-video-avoid-null-dereference.patch removed from -mm tree
Date: Tue, 04 May 2010 11:28:12 -0400
Message-ID: <201005041829.o44IThWr011399@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:38704 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932968Ab0EDSaj (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 4 May 2010 14:30:39 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: julia@diku.dk, mchehab@infradead.org, mmcclell@bigfoot.com, mm-commits@vger.kernel.org


The patch titled
     drivers/media/video: avoid NULL dereference
has been removed from the -mm tree.  Its filename was
     drivers-media-video-avoid-null-dereference.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: drivers/media/video: avoid NULL dereference
From: Julia Lawall <julia@diku.dk>

It seems impossible for ov to be NULL at this point.

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
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/media/video/ov511.c |    5 -----
 1 file changed, 5 deletions(-)

diff -puN drivers/media/video/ov511.c~drivers-media-video-avoid-null-dereference drivers/media/video/ov511.c
--- a/drivers/media/video/ov511.c~drivers-media-video-avoid-null-dereference
+++ a/drivers/media/video/ov511.c
@@ -5916,11 +5916,6 @@ ov51x_disconnect(struct usb_interface *i
 	mutex_lock(&ov->lock);
 	usb_set_intfdata (intf, NULL);
 
-	if (!ov) {
-		mutex_unlock(&ov->lock);
-		return;
-	}
