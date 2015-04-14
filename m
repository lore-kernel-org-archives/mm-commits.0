From: akpm@linux-foundation.org
Subject: [folded-merged]
 mm-migrate-mark-unmap_and_move-noinline-to-avoid-ice-in-gcc-473-fix-fix.patch removed from -mm tree
Date: Tue, 14 Apr 2015 15:11:54 -0700
Message-ID: <552d90aa.S9hnInLlZlxTkWq6%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:54268 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932322AbbDNWLz (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 14 Apr 2015 18:11:55 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: khilman@kernel.org, geert+renesas@glider.be, marc.zyngier@arm.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm-migrate-mark-unmap_and_move-noinline-to-avoid-ice-in-gcc-473-fix-fix
has been removed from the -mm tree.  Its filename was
     mm-migrate-mark-unmap_and_move-noinline-to-avoid-ice-in-gcc-473-fix-fix.patch

This patch was dropped because it was folded into mm-migrate-mark-unmap_and_move-noinline-to-avoid-ice-in-gcc-473.patch

------------------------------------------------------
From: Kevin Hilman <khilman@kernel.org>
Subject: mm-migrate-mark-unmap_and_move-noinline-to-avoid-ice-in-gcc-473-fix-fix

fine-tune compiler versions

Your patch on top of Geert's still compiles fine for me with gcc-4.7.3.
However, I'm not sure how specific we can be on the versions.

/me goes to test a few more compilers...   OK...

ICE: 4.7.1, 4.7.3, 4.8.3
OK: 4.6.3, 4.9.2, 4.9.3

The diff below[2] on top of yours compiles fine here and at least covers
the compilers I *know* to trigger the ICE.

Cc: Geert Uytterhoeven <geert+renesas@glider.be>
Cc: Kevin Hilman <khilman@kernel.org>
Cc: Marc Zyngier <marc.zyngier@arm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/migrate.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff -puN mm/migrate.c~mm-migrate-mark-unmap_and_move-noinline-to-avoid-ice-in-gcc-473-fix-fix mm/migrate.c
--- a/mm/migrate.c~mm-migrate-mark-unmap_and_move-noinline-to-avoid-ice-in-gcc-473-fix-fix
+++ a/mm/migrate.c
@@ -901,10 +901,10 @@ out:
 }
 
 /*
- * gcc-4.7.3 on arm gets an ICE when inlining unmap_and_move().  Work around
+ * gcc 4.7 and 4.8 on arm gets an ICE when inlining unmap_and_move().  Work around
  * it.
  */
-#if GCC_VERSION == 40703 && defined(CONFIG_ARM)
+#if (GCC_VERSION >= 40700 && GCC_VERSION < 40900) && defined(CONFIG_ARM)
 #define ICE_noinline noinline
 #else
 #define ICE_noinline
_

Patches currently in -mm which might be from khilman@kernel.org are

mm-migrate-mark-unmap_and_move-noinline-to-avoid-ice-in-gcc-473.patch
mm-migrate-mark-unmap_and_move-noinline-to-avoid-ice-in-gcc-473-fix-fix-fix.patch

