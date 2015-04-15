From: akpm@linux-foundation.org
Subject: [merged]
 mm-migrate-mark-unmap_and_move-noinline-to-avoid-ice-in-gcc-473.patch
 removed from -mm tree
Date: Wed, 15 Apr 2015 12:08:56 -0700
Message-ID: <552eb748.F3HGrgfoaH2uDRTb%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:47915 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932695AbbDOTI5 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 15 Apr 2015 15:08:57 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: geert+renesas@glider.be, khilman@kernel.org, khilman@linaro.org, lina.iyer@linaro.org, marc.zyngier@arm.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm/migrate: mark unmap_and_move() "noinline" to avoid ICE in gcc 4.7.3
has been removed from the -mm tree.  Its filename was
     mm-migrate-mark-unmap_and_move-noinline-to-avoid-ice-in-gcc-473.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Geert Uytterhoeven <geert+renesas@glider.be>
Subject: mm/migrate: mark unmap_and_move() "noinline" to avoid ICE in gcc 4.7.3

With gcc version 4.7.3 (Ubuntu/Linaro 4.7.3-12ubuntu1) :

    mm/migrate.c: In function `migrate_pages':
    mm/migrate.c:1148:1: internal compiler error: in push_minipool_fix, at config/arm/arm.c:13500
    Please submit a full bug report,
    with preprocessed source if appropriate.
    See <file:///usr/share/doc/gcc-4.7/README.Bugs> for instructions.
    Preprocessed source stored into /tmp/ccPoM1tr.out file, please attach this to your bugreport.
    make[1]: *** [mm/migrate.o] Error 1
    make: *** [mm/migrate.o] Error 2

Mark unmap_and_move() (which is used in a single place only) "noinline"
to work around this compiler bug.

[akpm@linux-foundation.org: make it conditional on gcc-4.7.3 and arm]
[khilman@kernel.org: fine-tune compiler versions]
[akpm@linux-foundation.org: fix comment]
Signed-off-by: Geert Uytterhoeven <geert+renesas@glider.be>
Reported-by: Kevin Hilman <khilman@kernel.org>
Cc: Marc Zyngier <marc.zyngier@arm.com>
Tested-by: Kevin Hilman <khilman@linaro.org>
Tested-by: Lina Iyer <lina.iyer@linaro.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/migrate.c |   17 ++++++++++++++---
 1 file changed, 14 insertions(+), 3 deletions(-)

diff -puN mm/migrate.c~mm-migrate-mark-unmap_and_move-noinline-to-avoid-ice-in-gcc-473 mm/migrate.c
--- a/mm/migrate.c~mm-migrate-mark-unmap_and_move-noinline-to-avoid-ice-in-gcc-473
+++ a/mm/migrate.c
@@ -901,12 +901,23 @@ out:
 }
 
 /*
+ * gcc 4.7 and 4.8 on arm get an ICEs when inlining unmap_and_move().  Work
+ * around it.
+ */
+#if (GCC_VERSION >= 40700 && GCC_VERSION < 40900) && defined(CONFIG_ARM)
+#define ICE_noinline noinline
+#else
+#define ICE_noinline
+#endif
+
+/*
  * Obtain the lock on page, remove all ptes and migrate the page
  * to the newly allocated page in newpage.
  */
-static int unmap_and_move(new_page_t get_new_page, free_page_t put_new_page,
-			unsigned long private, struct page *page, int force,
-			enum migrate_mode mode)
+static ICE_noinline int unmap_and_move(new_page_t get_new_page,
+				   free_page_t put_new_page,
+				   unsigned long private, struct page *page,
+				   int force, enum migrate_mode mode)
 {
 	int rc = 0;
 	int *result = NULL;
_

Patches currently in -mm which might be from geert+renesas@glider.be are

origin.patch
lib-vsprintf-document-%p-parameters-passed-by-reference.patch
lib-vsprintf-move-integer-format-types-to-the-top.patch
lib-vsprintf-add-%pcnr-format-specifiers-for-clocks.patch
lib-vsprintf-add-%pcnr-format-specifiers-for-clocks-fix.patch
linux-next.patch

