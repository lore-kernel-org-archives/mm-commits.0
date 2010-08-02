From: akpm@linux-foundation.org
Subject: + drivers-video-igafbc-introduce-lost-return.patch added to -mm tree
Date: Mon, 02 Aug 2010 15:58:45 -0700
Message-ID: <201008022258.o72Mwjhx016446@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:51328 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752760Ab0HBW7O (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 2 Aug 2010 18:59:14 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: segooon@gmail.com


The patch titled
     drivers/video/igafb.c: introduce lost 'return'
has been added to the -mm tree.  Its filename is
     drivers-video-igafbc-introduce-lost-return.patch

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
Subject: drivers/video/igafb.c: introduce lost 'return'
From: Kulikov Vasiliy <segooon@gmail.com>

If iga_init() fails, code releases resources and continues to use it.  It
seems that after releasing resources 'return' should be.

Signed-off-by: Kulikov Vasiliy <segooon@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/video/igafb.c |    1 +
 1 file changed, 1 insertion(+)

diff -puN drivers/video/igafb.c~drivers-video-igafbc-introduce-lost-return drivers/video/igafb.c
--- a/drivers/video/igafb.c~drivers-video-igafbc-introduce-lost-return
+++ a/drivers/video/igafb.c
@@ -531,6 +531,7 @@ int __init igafb_init(void)
 		iounmap(info->screen_base);
 		kfree(par->mmap_map);
 		kfree(info);
+		return -ENODEV;
         }
 
 #ifdef CONFIG_SPARC
_

Patches currently in -mm which might be from segooon@gmail.com are

linux-next.patch
cpqarray-check-put_user-result.patch
mm-vmallocc-check-kmalloc-return-value.patch
i2o-fix-overflow-of-copy_to_user.patch
i2o-check-return-code-from-put_user.patch
drivers-video-igafbc-introduce-lost-return.patch
edac-i5000-improve-handling-of-pci_enable_device-return-value.patch
edac-i5400-improve-handling-of-pci_enable_device-return-value.patch

