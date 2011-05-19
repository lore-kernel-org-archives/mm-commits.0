From: akpm@linux-foundation.org
Subject: + drivers-scsi-ultrastorc-fix-asm-snippet.patch added to -mm tree
Date: Thu, 19 May 2011 16:14:15 -0700
Message-ID: <201105192314.p4JNEFMr001942@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:52518 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S933815Ab1ESXOx (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 19 May 2011 19:14:53 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: samuel.thibault@ens-lyon.org, James.Bottomley@HansenPartnership.com, deweerdt@free.fr


The patch titled
     drivers/scsi/ultrastor.c: fix asm snippet
has been added to the -mm tree.  Its filename is
     drivers-scsi-ultrastorc-fix-asm-snippet.patch

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
Subject: drivers/scsi/ultrastor.c: fix asm snippet
From: Samuel Thibault <samuel.thibault@ens-lyon.org>

Commit 1292500b ("ultrastor: clean up inline asm warnings") replaced

"=m" (*field) : "1" (*field)

with

"=m" (*field) :

with comment "The following patch fixes it by using the '+' operator on
the (*field) operand, marking it as read-write to gcc."
'+' was actually forgotten.  This really puts it.

Signed-off-by: Samuel Thibault <samuel.thibault@ens-lyon.org>
Cc: Frederik Deweerdt <deweerdt@free.fr>
Cc: James Bottomley <James.Bottomley@HansenPartnership.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/scsi/ultrastor.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN drivers/scsi/ultrastor.c~drivers-scsi-ultrastorc-fix-asm-snippet drivers/scsi/ultrastor.c
--- a/drivers/scsi/ultrastor.c~drivers-scsi-ultrastorc-fix-asm-snippet
+++ a/drivers/scsi/ultrastor.c
@@ -307,7 +307,7 @@ static inline int find_and_clear_bit_16(
 	"0: bsfw %1,%w0\n\t"
 	"btr %0,%1\n\t"
 	"jnc 0b"
-	: "=&r" (rv), "=m" (*field) :);
+	: "=&r" (rv), "+m" (*field) :);
 
   return rv;
 }
_

Patches currently in -mm which might be from samuel.thibault@ens-lyon.org are

leds-route-kbd-leds-through-the-generic-leds-layer.patch
drivers-scsi-ultrastorc-fix-asm-snippet.patch

