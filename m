From: akpm@linux-foundation.org
Subject: + drivers-media-video-cx88-cx88-alsac-adjust-error-handling-code.patch added to -mm tree
Date: Tue, 02 Dec 2008 11:34:52 -0800
Message-ID: <200812021934.mB2JYroq005977@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:55826 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751459AbYLBTf1 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 2 Dec 2008 14:35:27 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: julia@diku.dk, mchehab@infradead.org


The patch titled
     drivers/media/video/cx88/cx88-alsa.c: Adjust error-handling code
has been added to the -mm tree.  Its filename is
     drivers-media-video-cx88-cx88-alsac-adjust-error-handling-code.patch

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

linux-next.patch
drivers-char-agp-add-missing-pci_dev_get.patch
arch-arm-eliminate-null-test-and-memset-after-alloc_bootmem.patch
arch-avr32-eliminate-null-test-and-memset-after-alloc_bootmem.patch
arch-powerpc-eliminate-null-test-and-memset-after-alloc_bootmem.patch
drivers-media-video-cx88-cx88-alsac-adjust-error-handling-code.patch
arch-ia64-eliminate-null-test-and-memset-after-alloc_bootmem.patch
drivers-mtd-maps-nettelc-use-array_size.patch
drivers-mtd-nand-pasemi_nandc-add-missing-pci_dev_put.patch
net-tipc-bcasth-use-array_size.patch
drivers-isdn-misdn-use-array_size.patch
fs-namespacec-drop-code-after-return.patch
mm-page_allocc-eliminate-null-test-and-memset-after-alloc_bootmem.patch

