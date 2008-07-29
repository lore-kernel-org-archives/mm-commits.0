From: akpm@linux-foundation.org
Subject: - remove-export_symbol-for-bio_integrity_init_slab.patch removed from -mm tree
Date: Tue, 29 Jul 2008 13:30:08 -0700
Message-ID: <200807292030.m6TKU853019774@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:56022 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753437AbYG2Uab (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 29 Jul 2008 16:30:31 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: yoichi_yuasa@tripeaks.co.jp, jens.axboe@oracle.com, martin.petersen@oracle.com, mm-commits@vger.kernel.org


The patch titled
     bio-integrity: remove EXPORT_SYMBOL for bio_integrity_init_slab()
has been removed from the -mm tree.  Its filename was
     remove-export_symbol-for-bio_integrity_init_slab.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: bio-integrity: remove EXPORT_SYMBOL for bio_integrity_init_slab()
From: Yoichi Yuasa <yoichi_yuasa@tripeaks.co.jp>

I got section mismatch message about bio_integrity_init_slab().

WARNING: fs/built-in.o(__ksymtab+0xb60): Section mismatch in reference from the variable __ksymtab_bio_integrity_init_slab to the function .init.text:bio_integrity_init_slab()

The symbol bio_integrity_init_slab is exported and annotated __init Fix
this by removing the __init annotation of bio_integrity_init_slab or drop
the export.

It only call from init_bio().  The EXPORT_SYMBOL() can be removed.

Signed-off-by: Yoichi Yuasa <yoichi_yuasa@tripeaks.co.jp>
Cc: "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: Jens Axboe <jens.axboe@oracle.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/bio-integrity.c |    1 -
 1 file changed, 1 deletion(-)

diff -puN fs/bio-integrity.c~remove-export_symbol-for-bio_integrity_init_slab fs/bio-integrity.c
--- a/fs/bio-integrity.c~remove-export_symbol-for-bio_integrity_init_slab
+++ a/fs/bio-integrity.c
@@ -705,7 +705,6 @@ void __init bio_integrity_init_slab(void
 	bio_integrity_slab = KMEM_CACHE(bio_integrity_payload,
 					SLAB_HWCACHE_ALIGN|SLAB_PANIC);
 }
-EXPORT_SYMBOL(bio_integrity_init_slab);
 
 static int __init integrity_init(void)
 {
_

Patches currently in -mm which might be from yoichi_yuasa@tripeaks.co.jp are


