From: akpm@linux-foundation.org
Subject: [merged] initramfs-handle-unrecognised-decompressor-when-unpacking.patch removed from -mm tree
Date: Mon, 26 Apr 2010 10:27:09 -0400
Message-ID: <201004261728.o3QHSigs009132@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:36517 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753164Ab0DZR3h (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 26 Apr 2010 13:29:37 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: phillip@lougher.demon.co.uk, aaro.koskinen@iki.fi, mm-commits@vger.kernel.org


The patch titled
     initramfs: handle unrecognised decompressor when unpacking
has been removed from the -mm tree.  Its filename was
     initramfs-handle-unrecognised-decompressor-when-unpacking.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: initramfs: handle unrecognised decompressor when unpacking
From: Phillip Lougher <phillip@lougher.demon.co.uk>

The unpack routine fails to handle the decompress_method() returning
unrecognised decompressor (compress_name == NULL).  This results in the
routine looping eventually oopsing on an out of bounds memory access.

Note this bug is usually hidden, only triggering on trailing junk after
one or more correct compressed blocks.  The case of the compressed archive
being complete junk is (by accident?) caught by the if (state != Reset)
check because state is initialised to Start, but not updated due to the
decompressor not having been called.  Obviously if the junk is trailing a
correctly decompressed buffer, state == Reset from the previous call to
the decompressor.

Signed-off-by: Phillip Lougher <phillip@lougher.demon.co.uk>
Reported-by: Aaro Koskinen <aaro.koskinen@iki.fi>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 init/initramfs.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff -puN init/initramfs.c~initramfs-handle-unrecognised-decompressor-when-unpacking init/initramfs.c
--- a/init/initramfs.c~initramfs-handle-unrecognised-decompressor-when-unpacking
+++ a/init/initramfs.c
@@ -457,7 +457,8 @@ static char * __init unpack_to_rootfs(ch
 					 compress_name);
 				message = msg_buf;
 			}
-		}
+		} else
+			error("junk in compressed archive");
 		if (state != Reset)
 			error("junk in compressed archive");
 		this_header = saved_offset + my_inptr;
_

Patches currently in -mm which might be from phillip@lougher.demon.co.uk are

origin.patch

