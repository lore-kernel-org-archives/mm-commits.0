From: akpm@linux-foundation.org
Subject: + make-firmware-dsp56k-bootstrapasm-buildable-on-a56.patch added to -mm tree
Date: Thu, 30 Oct 2008 15:34:29 -0700
Message-ID: <200810302234.m9UMYTbC011530@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:56816 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751690AbYJ3Wex (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 30 Oct 2008 18:34:53 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: rmh@aybabtu.com, dwmw2@infradead.org, jaswinder@infradead.org


The patch titled
     make firmware/dsp56k/bootstrap.asm buildable on a56
has been added to the -mm tree.  Its filename is
     make-firmware-dsp56k-bootstrapasm-buildable-on-a56.patch

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
Subject: make firmware/dsp56k/bootstrap.asm buildable on a56
From: Robert Millan <rmh@aybabtu.com>

Make firmware/dsp56k/bootstrap.asm buildable on a56, the free Motorola
DSP56001 assembler (http://www.zdomain.com/a56.html).

Summary of changes:

  - Remove '<' and '>' candy (they specify explicit addressing modes,
    which a56 don't grok, but uses implicitly anyway).

  - Replace 'move' with 'movem' when accessing program memory.

  - Rename a few labels to avoid duplicates (which a56 can't handle).

Signed-off-by: Robert Millan <rmh@aybabtu.com>
Cc: Jaswinder Singh <jaswinder@infradead.org>
Cc: David Woodhouse <dwmw2@infradead.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 firmware/dsp56k/bootstrap.asm |   26 +++++++++++++-------------
 1 file changed, 13 insertions(+), 13 deletions(-)

diff -puN firmware/dsp56k/bootstrap.asm~make-firmware-dsp56k-bootstrapasm-buildable-on-a56 firmware/dsp56k/bootstrap.asm
--- a/firmware/dsp56k/bootstrap.asm~make-firmware-dsp56k-bootstrapasm-buildable-on-a56
+++ a/firmware/dsp56k/bootstrap.asm
@@ -51,19 +51,19 @@ start   jmp     <$40
         ; Copy DSP program control
         move    #real,r0
         move    #upload,r1
-        do      #upload_end-upload,<_copy
-        move    P:(r0)+,x0
-        move    x0,P:(r1)+
-_copy   movep   #>4,X:<<M_HCR
-        movep   #>$c00,X:<<M_IPR
+        do      #upload_end-upload,_copy
+        movem    P:(r0)+,x0
+        movem    x0,P:(r1)+
+_copy   movep   #4,X:<<M_HCR
+        movep   #$c00,X:<<M_IPR
         and     #<$fe,mr
         jmp     upload
 
 real
         org     P:$7ea9
 upload
-        movep   #>1,X:<<M_PBC
-        movep   #>0,X:<<M_BCR
+        movep   #1,X:<<M_PBC
+        movep   #0,X:<<M_BCR
 
 next    jclr    #0,X:<<M_HSR,*
         movep   X:<<M_HRX,A
@@ -81,18 +81,18 @@ _get_length
         cmp     x0,A
         jeq     load_Y
 
-load_P  do      y0,_load
+load_P  do      y0,_load_P
         jclr    #0,X:<<M_HSR,*
         movep   X:<<M_HRX,P:(r0)+
-_load   jmp     next
-load_X  do      y0,_load
+_load_P jmp     next
+load_X  do      y0,_load_X
         jclr    #0,X:<<M_HSR,*
         movep   X:<<M_HRX,X:(r0)+
-_load   jmp     next
-load_Y  do      y0,_load
+_load_X jmp     next
+load_Y  do      y0,_load_Y
         jclr    #0,X:<<M_HSR,*
         movep   X:<<M_HRX,Y:(r0)+
-_load   jmp     next
+_load_Y jmp     next
 
 upload_end
         end
_

Patches currently in -mm which might be from rmh@aybabtu.com are

make-firmware-dsp56k-bootstrapasm-buildable-on-a56.patch

