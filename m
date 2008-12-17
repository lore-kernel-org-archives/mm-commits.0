From: akpm@linux-foundation.org
Subject: - drivers-media-video-cx88-cx88-alsac-adjust-error-handling-code.patch removed from -mm tree
Date: Wed, 17 Dec 2008 12:48:29 -0800
Message-ID: <200812172048.mBHKmTY4006849@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:42903 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751391AbYLQUtD (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 17 Dec 2008 15:49:03 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: julia@diku.dk, mchehab@infradead.org, mm-commits@vger.kernel.org


The patch titled
     drivers/media/video/cx88/cx88-alsa.c: Adjust error-handling code
has been removed from the -mm tree.  Its filename was
     drivers-media-video-cx88-cx88-alsac-adjust-error-handling-code.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: drivers/media/video/cx88/cx88-alsa.c: Adjust error-handling code
From: Julia Lawall <julia@diku.dk>

In the function cx88_audio_initdev, the value card has been created using
snd_card_new.  The other error handling code in this function frees the
value using snd_card_free.  I have thus changed the first error case to do
the same.  On the other hand, it may be that card is not sufficiently
initialized at this point to use snd_card_free, in which case something
else should be done to free the memory in the error case.

In the function snd_cx88_create the call kfree(chip) in one error case
looks suspicious, both because it is not done in the other error code, and
because chip points into the middle of the memory allocated by
snd_card_new, ie it is not itself associated with a separate kmalloc. 
Therefore I have removed it.

The semantic match that finds the first problem is as follows:
(http://www.emn.fr/x-info/coccinelle/)

// <smpl>
@r exists@
local idexpression x;
statement S,S1;
position p1,p2,p3;
expression E,E1;
type T,T1;
expression *ptr != NULL;
@@

(
 if ((x@p1 = snd_card_new(...)) == NULL) S
|
 x@p1 = snd_card_new(...);
)
 ... when != snd_card_free(...,(T)x,...)
     when != if (...) { <+... snd_card_free(...,(T)x,...) ...+> }
     when != true x == NULL || ...
     when != x = E
     when != E = (T)x
     when any
(
 if (x == NULL || ...) S1
|
 if@p2 (...) {
  ... when != snd_card_free(...,(T1)x,...)
      when != if (...) { <+... snd_card_free(...,(T1)x,...) ...+> }
      when != x = E1
      when != E1 = (T1)x
(
  return \(0\|<+...x...+>\|ptr\);
|
  return@p3 ...;
)
}
)

@ script:python @
p1 << r.p1;
p3 << r.p3;
@@

print "* file: %s snd_card_new: %s return: %s" % (p1[0].file,p1[0].line,p3[0].line)

// </smpl>

Signed-off-by: Julia Lawall <julia@diku.dk>
Cc: Mauro Carvalho Chehab <mchehab@infradead.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/media/video/cx88/cx88-alsa.c |    3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff -puN drivers/media/video/cx88/cx88-alsa.c~drivers-media-video-cx88-cx88-alsac-adjust-error-handling-code drivers/media/video/cx88/cx88-alsa.c
--- a/drivers/media/video/cx88/cx88-alsa.c~drivers-media-video-cx88-cx88-alsac-adjust-error-handling-code
+++ a/drivers/media/video/cx88/cx88-alsa.c
@@ -742,7 +742,6 @@ static int __devinit snd_cx88_create(str
 	core = cx88_core_get(pci);
 	if (NULL == core) {
 		err = -EINVAL;
-		kfree (chip);
 		return err;
 	}
 
@@ -812,7 +811,7 @@ static int __devinit cx88_audio_initdev(
 
 	err = snd_cx88_create(card, pci, &chip);
 	if (err < 0)
-		return (err);
+		goto error;
 
 	err = snd_cx88_pcm(chip, 0, "CX88 Digital");
 	if (err < 0)
_

Patches currently in -mm which might be from julia@diku.dk are

origin.patch
linux-next.patch
arch-avr32-eliminate-null-test-and-memset-after-alloc_bootmem.patch
powerpc-powermac-add-missing-of_node_put.patch
net-tipc-bcasth-use-array_size.patch
fs-namespacec-drop-code-after-return.patch
mm-page_allocc-eliminate-null-test-and-memset-after-alloc_bootmem.patch
drivers-macintosh-add-missing-of_node_put-in-therm_adt746xc.patch
drivers-rtc-correct-an-error-test.patch

