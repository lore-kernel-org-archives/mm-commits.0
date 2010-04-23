From: akpm@linux-foundation.org
Subject: + initramfs-handle-unrecognised-decompressor-when-unpacking.patch added to -mm tree
Date: Fri, 23 Apr 2010 12:21:42 -0700
Message-ID: <201004231921.o3NJLgQm007161@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:42401 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755839Ab0DWTWq (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 23 Apr 2010 15:22:46 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: phillip@lougher.demon.co.uk, aaro.koskinen@iki.fi


The patch titled
     initramfs: handle unrecognised decompressor when unpacking
has been added to the -mm tree.  Its filename is
     initramfs-handle-unrecognised-decompressor-when-unpacking.patch

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

initramfs-handle-unrecognised-decompressor-when-unpacking.patch

