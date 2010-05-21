From: akpm@linux-foundation.org
Subject: + nuc900fb-release-correct-mem-region.patch added to -mm tree
Date: Fri, 21 May 2010 12:55:00 -0700
Message-ID: <201005211955.o4LJt0aU030960@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:33000 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758279Ab0EUTzQ (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 21 May 2010 15:55:16 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: mcuos.com@gmail.com, error27@gmail.com, rmk@arm.linux.org.uk, rurality.linux@gmail.com


The patch titled
     nuc900fb: release correct mem region
has been added to the -mm tree.  Its filename is
     nuc900fb-release-correct-mem-region.patch

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
Subject: nuc900fb: release correct mem region
From: Wan ZongShun <mcuos.com@gmail.com>

We should be releasing "res->start" here.

Signed-off-by: Dan Carpenter <error27@gmail.com>
Acked-by: Wan ZongShun <mcuos.com@gmail.com>
Cc: Wang Qiang <rurality.linux@gmail.com>
Cc: Russell King <rmk@arm.linux.org.uk>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/video/nuc900fb.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN drivers/video/nuc900fb.c~nuc900fb-release-correct-mem-region drivers/video/nuc900fb.c
--- a/drivers/video/nuc900fb.c~nuc900fb-release-correct-mem-region
+++ a/drivers/video/nuc900fb.c
@@ -667,7 +667,7 @@ release_irq:
 release_regs:
 	iounmap(fbi->io);
 release_mem_region:
-	release_mem_region((unsigned long)fbi->mem, size);
+	release_mem_region(res->start, size);
 free_fb:
 	framebuffer_release(fbinfo);
 	return ret;
_

Patches currently in -mm which might be from mcuos.com@gmail.com are

origin.patch
nuc900fb-release-correct-mem-region.patch

