From: akpm@linux-foundation.org
Subject: + dio-array_size-cleanup-update.patch added to -mm tree
Date: Mon, 26 Nov 2007 15:46:42 -0800
Message-ID: <200711262346.lAQNkggN029272@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:43527 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756527AbXKZXrC (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 26 Nov 2007 18:47:02 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: geert@linux-m68k.org, alex@flawedcode.org, ricknu-0@student.ltu.se


The patch titled
     dio: ARRAY_SIZE() cleanup (update)
has been added to the -mm tree.  Its filename is
     dio-array_size-cleanup-update.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: dio: ARRAY_SIZE() cleanup (update)
From: Geert Uytterhoeven <geert@linux-m68k.org>

On Tue, 20 Nov 2007, Richard Knutsson wrote:
> Geert Uytterhoeven wrote:
>
> > -#define NUMNAMES (sizeof(names) / sizeof(struct dioname))
> > +#define NUMNAMES ARRAY_SIZE(names)
>
> Why not replace NUMNAMES?

Good idea! Updated patch below.

---

Subject: dio: ARRAY_SIZE() cleanup


dio: ARRAY_SIZE() cleanup

[Geert: eliminate NUMNAMES, as suggested by Richard Knutsson ]

Signed-off-by: Alejandro Martinez Ruiz <alex@flawedcode.org>
Signed-off-by: Geert Uytterhoeven <geert@linux-m68k.org>
Cc: Richard Knutsson <ricknu-0@student.ltu.se>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/dio/dio.c |    4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

diff -puN drivers/dio/dio.c~dio-array_size-cleanup-update drivers/dio/dio.c
--- a/drivers/dio/dio.c~dio-array_size-cleanup-update
+++ a/drivers/dio/dio.c
@@ -88,8 +88,6 @@ static struct dioname names[] = 
 #undef DIONAME
 #undef DIOFBNAME
 
-#define NUMNAMES ARRAY_SIZE(names)
-
 static const char *unknowndioname 
         = "unknown DIO board -- please email <linux-m68k@lists.linux-m68k.org>!";
 
@@ -97,7 +95,7 @@ static const char *dio_getname(int id)
 {
         /* return pointer to a constant string describing the board with given ID */
 	unsigned int i;
-        for (i = 0; i < NUMNAMES; i++)
+        for (i = 0; i < ARRAY_SIZE(names); i++)
                 if (names[i].id == id) 
                         return names[i].name;
 
_

Patches currently in -mm which might be from geert@linux-m68k.org are

m68k-export-atari_keyb_init.patch
amiga-zorro-bus-add-missing-zorro_device_remove.patch
mac68k-mailing-list-addresss.patch
m68k-zorro7xx-needs-asm-amigahwh.patch
git-scsi-misc.patch
m68k-use-cc-cross-prefix.patch
m68k-array_size-cleanup.patch
dio-array_size-cleanup.patch
dio-array_size-cleanup-update.patch
m68k-balance-ioremap-and-iounmap-in-m68k-atari-hades-pcic.patch
nubus-kill-drivers-nubus-nubus_symsc.patch
m68k-kill-arch-m68k-mac-mac_ksymsc.patch
m68k-kill-arch-m68k-hp300-ksymsc.patch
m68k-kill-arch-m68k-amiga-amiga_ksymsc.patch
m68k-kill-arch-m68k-atari-atari_ksymsc.patch
m68k-kill-arch-m68k-mvme16x-mvme16x_ksymsc.patch
mac68k-macii-adb-comment-correction.patch
mac68k-remove-dead-code.patch
mac68k-add-nubus-card-definitions-and-a-typo-fix.patch
mac68k-remove-dead-mac_adbkeycodes.patch
uml-borrow-consth-techniques.patch
remove-pointless-casts-from-void-pointers.patch
cleanup-after-apus-removal.patch
add-cmpxchg_local-to-m86k.patch
