From: akpm@linux-foundation.org
Subject: + sxc-avoid-referencing-freed-memory-if-copy_from_user-fails.patch added to -mm tree
Date: Thu, 19 Feb 2009 13:23:44 -0800
Message-ID: <200902192123.n1JLNiS0023952@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:55697 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753017AbZBSVYN (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 19 Feb 2009 16:24:13 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: error27@gmail.com, ilpo.jarvinen@helsinki.fi


The patch titled
     sx.c: avoid referencing freed memory if copy_from_user() fails
has been added to the -mm tree.  Its filename is
     sxc-avoid-referencing-freed-memory-if-copy_from_user-fails.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your cod=
e ***

See http://userweb.kernel.org/~akpm/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mm=
otm/

------------------------------------------------------
Subject: sx.c: avoid referencing freed memory if copy_from_user() fails
=46rom: Dan Carpenter <error27@gmail.com>

The "break" would just result in reusing a free'd pointer.  I don't hav=
e
the cards myself to test it though.  :/

Signed-off-by: Dan Carpenter <error27@gmail.com>
Cc: Ilpo J=E4rvinen <ilpo.jarvinen@helsinki.fi>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/char/sx.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN drivers/char/sx.c~sxc-avoid-referencing-freed-memory-if-copy_=
from_user-fails drivers/char/sx.c
--- a/drivers/char/sx.c~sxc-avoid-referencing-freed-memory-if-copy_from=
_user-fails
+++ a/drivers/char/sx.c
@@ -1789,7 +1789,7 @@ static long sx_fw_ioctl(struct file *fil
 						nbytes - i : SX_CHUNK_SIZE)) {
 					kfree(tmp);
 					rc =3D -EFAULT;
-					break;
+					goto out;
 				}
 				memcpy_toio(board->base2 + offset + i, tmp,
 						(i + SX_CHUNK_SIZE > nbytes) ?
_

Patches currently in -mm which might be from error27@gmail.com are

origin.patch
sxc-fix-dbl-statement-if-add-missing-braces.patch
sxc-avoid-referencing-freed-memory-if-copy_from_user-fails.patch
linux-next.patch

--
To unsubscribe from this list: send the line "unsubscribe mm-commits" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
