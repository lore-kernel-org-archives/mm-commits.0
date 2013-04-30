From: akpm@linux-foundation.org
Subject: + parisc-remove-the-second-argument-of-kmap_atomic.patch added to -mm tree
Date: Tue, 30 Apr 2013 13:05:54 -0700
Message-ID: <20130430200554.79C8831C2AA@corp2gmr1-1.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-vb0-f74.google.com ([209.85.212.74]:45154 "EHLO
	mail-vb0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932708Ab3D3UFz (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 30 Apr 2013 16:05:55 -0400
Received: by mail-vb0-f74.google.com with SMTP id w8so96123vbf.1
        for <mm-commits@vger.kernel.org>; Tue, 30 Apr 2013 13:05:55 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: zhaohongjiang@huawei.com, deller@gmx.de, eike-kernel@sf-tec.de, jejb@parisc-linux.org


The patch titled
     Subject: parisc: remove the second argument of kmap_atomic()
has been added to the -mm tree.  Its filename is
     parisc-remove-the-second-argument-of-kmap_atomic.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Zhao Hongjiang <zhaohongjiang@huawei.com>
Subject: parisc: remove the second argument of kmap_atomic()

kmap_atomic() requires only one argument now.

Signed-off-by: Zhao Hongjiang <zhaohongjiang@huawei.com>
Cc: "James E.J. Bottomley" <jejb@parisc-linux.org>
Cc: Helge Deller <deller@gmx.de>
Cc: Rolf Eike Beer <eike-kernel@sf-tec.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/parisc/kernel/cache.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff -puN arch/parisc/kernel/cache.c~parisc-remove-the-second-argument-of-kmap_atomic arch/parisc/kernel/cache.c
--- a/arch/parisc/kernel/cache.c~parisc-remove-the-second-argument-of-kmap_atomic
+++ a/arch/parisc/kernel/cache.c
@@ -606,7 +606,7 @@ void clear_user_highpage(struct page *pa
 	/* Clear using TMPALIAS region.  The page doesn't need to
 	   be flushed but the kernel mapping needs to be purged.  */
 
-	vto = kmap_atomic(page, KM_USER0);
+	vto = kmap_atomic(page);
 
 	/* The PA-RISC 2.0 Architecture book states on page F-6:
 	   "Before a write-capable translation is enabled, *all*
@@ -641,8 +641,8 @@ void copy_user_highpage(struct page *to,
 	   the `to' page must be flushed in copy_user_page_asm since
 	   it can be used to bring in executable code.  */
 
-	vfrom = kmap_atomic(from, KM_USER0);
-	vto = kmap_atomic(to, KM_USER1);
+	vfrom = kmap_atomic(from);
+	vto = kmap_atomic(to);
 
 	purge_kernel_dcache_page_asm((unsigned long)vto);
 	purge_tlb_start(flags);
_

Patches currently in -mm which might be from zhaohongjiang@huawei.com are

parisc-remove-the-second-argument-of-kmap_atomic.patch
inotify-invalid-mask-should-return-a-error-number-but-not-set-it.patch
inotify-invalid-mask-should-return-a-error-number-but-not-set-it-fix.patch

