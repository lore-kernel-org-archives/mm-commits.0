From: akpm@linux-foundation.org
Subject: [merged] drivers-scsi-ultrastorc-fix-asm-snippet.patch removed from -mm tree
Date: Wed, 25 May 2011 13:32:59 -0700
Message-ID: <201105252031.p4PKVNnS015060@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:52734 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932430Ab1EYUcL (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 25 May 2011 16:32:11 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: samuel.thibault@ens-lyon.org, James.Bottomley@HansenPartnership.com, deweerdt@free.fr, mm-commits@vger.kernel.org


The patch titled
     drivers/scsi/ultrastor.c: fix asm snippet
has been removed from the -mm tree.  Its filename was
     drivers-scsi-ultrastorc-fix-asm-snippet.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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

linux-next.patch
leds-route-kbd-leds-through-the-generic-leds-layer.patch

