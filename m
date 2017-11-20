From: akpm@linux-foundation.org
Subject: [merged] mm-fix-nodemask-printing.patch removed from -mm
 tree
Date: Mon, 20 Nov 2017 13:22:34 -0800
Message-ID: <20171120212234.A3zvAcUUL%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:39920 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752882AbdKTVWg (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 20 Nov 2017 16:22:36 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: arnd@arndb.de, mhocko@kernel.org, mm-commits@vger.kernel.org, sfr@canb.auug.org.au, zhangshaokun@hisilicon.com


The patch titled
     Subject: mm: fix nodemask printing
has been removed from the -mm tree.  Its filename was
     mm-fix-nodemask-printing.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Arnd Bergmann <arnd@arndb.de>
Subject: mm: fix nodemask printing

The cleanup caused build warnings for constant mask pointers:

mm/mempolicy.c: In function `mpol_to_str':
./include/linux/nodemask.h:108:11: warning: the comparison will always evaluate as `true' for the address of `nodes' will never be NULL [-Waddress]

An earlier workaround I suggested was incorporated in the version that
got merged, but that only solved the problem for gcc-7 and higher, while
gcc-4.6 through gcc-6.x still warn.

This changes the printing again to use inline functions that make it
clear to the compiler that the line that does the NULL check has no
idea whether the argument is a constant NULL.

Link: http://lkml.kernel.org/r/20171117101545.119689-1-arnd@arndb.de
Fixes: 0205f75571e3 ("mm: simplify nodemask printing")
Signed-off-by: Arnd Bergmann <arnd@arndb.de>
Cc: Michal Hocko <mhocko@kernel.org>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: Zhangshaokun <zhangshaokun@hisilicon.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/nodemask.h |   13 ++++++++++---
 1 file changed, 10 insertions(+), 3 deletions(-)

diff -puN include/linux/nodemask.h~mm-fix-nodemask-printing include/linux/nodemask.h
--- a/include/linux/nodemask.h~mm-fix-nodemask-printing
+++ a/include/linux/nodemask.h
@@ -104,9 +104,16 @@ extern nodemask_t _unused_nodemask_arg_;
  *
  * Can be used to provide arguments for '%*pb[l]' when printing a nodemask.
  */
-#define nodemask_pr_args(maskp)				\
-	((maskp) != NULL) ? MAX_NUMNODES : 0,		\
-	((maskp) != NULL) ? (maskp)->bits : NULL
+#define nodemask_pr_args(maskp)	__nodemask_pr_numnodes(maskp), \
+				__nodemask_pr_bits(maskp)
+static inline unsigned int __nodemask_pr_numnodes(const nodemask_t *m)
+{
+	return m ? MAX_NUMNODES : 0;
+}
+static inline const unsigned long *__nodemask_pr_bits(const nodemask_t *m)
+{
+	return m ? m->bits : NULL;
+}
 
 /*
  * The inline keyword gives the compiler room to decide to inline, or
_

Patches currently in -mm which might be from arnd@arndb.de are


