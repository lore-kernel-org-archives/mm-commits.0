From: akpm@linux-foundation.org
Subject: [merged] lib-crc32c-fix-unused-variables-warnings.patch removed from -mm tree
Date: Tue, 31 Jul 2012 11:51:52 -0700
Message-ID: <20120731185152.B817810007F@wpzn3.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-ob0-f202.google.com ([209.85.214.202]:33060 "EHLO
	mail-ob0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756254Ab2GaSvx (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 31 Jul 2012 14:51:53 -0400
Received: by mail-ob0-f202.google.com with SMTP id wc20so4676512obb.1
        for <mm-commits@vger.kernel.org>; Tue, 31 Jul 2012 11:51:53 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: trbecker@trbecker.org, djwong@us.ibm.com, rpearson@systemfabricworks.com, mm-commits@vger.kernel.org


The patch titled
     Subject: lib/crc32.c: fix unused variables warnings
has been removed from the -mm tree.  Its filename was
     lib-crc32c-fix-unused-variables-warnings.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Thiago Rafael Becker <trbecker@trbecker.org>
Subject: lib/crc32.c: fix unused variables warnings

Variables t4, t5, t6 and t7 are only used when CRC_LE_BITS != 32.  Fix the
following compilation warnings:

lib/crc32.c: In function 'crc32_body':
lib/crc32.c:77:55: warning: unused variable 't7'
lib/crc32.c:77:41: warning: unused variable 't6'
lib/crc32.c:77:27: warning: unused variable 't5'
lib/crc32.c:77:13: warning: unused variable 't4'

Signed-off-by: Thiago Rafael Becker <trbecker@trbecker.org>
Cc: "Darrick J. Wong" <djwong@us.ibm.com>
Cc: Bob Pearson <rpearson@systemfabricworks.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/crc32.c |    2 ++
 1 file changed, 2 insertions(+)

diff -puN lib/crc32.c~lib-crc32c-fix-unused-variables-warnings lib/crc32.c
--- a/lib/crc32.c~lib-crc32c-fix-unused-variables-warnings
+++ a/lib/crc32.c
@@ -74,7 +74,9 @@ crc32_body(u32 crc, unsigned char const 
 	size_t i;
 # endif
 	const u32 *t0=tab[0], *t1=tab[1], *t2=tab[2], *t3=tab[3];
+# if CRC_LE_BITS != 32
 	const u32 *t4 = tab[4], *t5 = tab[5], *t6 = tab[6], *t7 = tab[7];
+# endif
 	u32 q;
 
 	/* Align it */
_

Patches currently in -mm which might be from trbecker@trbecker.org are

origin.patch

