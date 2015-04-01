From: akpm@linux-foundation.org
Subject: +
 mm-migrate-mark-unmap_and_move-noinline-to-avoid-ice-in-gcc-473-fix-fix.patch added to -mm tree
Date: Wed, 01 Apr 2015 14:59:54 -0700
Message-ID: <551c6a5a.DMsryp9pLXFIGF8t%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:36505 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753004AbbDAV7z (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 1 Apr 2015 17:59:55 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: khilman@kernel.org, geert+renesas@glider.be, marc.zyngier@arm.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm-migrate-mark-unmap_and_move-noinline-to-avoid-ice-in-gcc-473-fix-fix
has been added to the -mm tree.  Its filename is
     mm-migrate-mark-unmap_and_move-noinline-to-avoid-ice-in-gcc-473-fix-fix.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-migrate-mark-unmap_and_move-noinline-to-avoid-ice-in-gcc-473-fix-fix.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-migrate-mark-unmap_and_move-noinline-to-avoid-ice-in-gcc-473-fix-fix.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Kevin Hilman <khilman@kernel.org>
Subject: mm-migrate-mark-unmap_and_move-noinline-to-avoid-ice-in-gcc-473-fix-fix

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
mm-migrate-mark-unmap_and_move-noinline-to-avoid-ice-in-gcc-473-fix.patch
mm-migrate-mark-unmap_and_move-noinline-to-avoid-ice-in-gcc-473-fix-fix.patch
linux-next.patch

