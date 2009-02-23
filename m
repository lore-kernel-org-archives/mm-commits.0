From: akpm@linux-foundation.org
Subject: [merged] sxc-avoid-referencing-freed-memory-if-copy_from_user-fails.patch removed from -mm tree
Date: Mon, 23 Feb 2009 12:06:42 -0800
Message-ID: <200902232006.n1NK6gXm013415@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:34053 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753446AbZBWURI (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 23 Feb 2009 15:17:08 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: error27@gmail.com, ilpo.jarvinen@helsinki.fi, mm-commits@vger.kernel.org


The patch titled
     sx.c: avoid referencing freed memory if copy_from_user() fails
has been removed from the -mm tree.  Its filename was
     sxc-avoid-referencing-freed-memory-if-copy_from_user-fails.patch

This patch was dropped because it was merged into mainline or a subsyst=
em tree

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

linux-next.patch

--
To unsubscribe from this list: send the line "unsubscribe mm-commits" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
