From: akpm@linux-foundation.org
Subject: + lib-crc32c-fix-unused-variables-warnings.patch added to -mm tree
Date: Wed, 25 Jul 2012 14:07:17 -0700
Message-ID: <20120725210717.9F2A61E0043@wpzn4.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-vb0-f74.google.com ([209.85.212.74]:41844 "EHLO
	mail-vb0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751394Ab2GYVHT (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 25 Jul 2012 17:07:19 -0400
Received: by vbnl22 with SMTP id l22so137579vbn.1
        for <mm-commits@vger.kernel.org>; Wed, 25 Jul 2012 14:07:18 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: trbecker@trbecker.org, djwong@us.ibm.com, rpearson@systemfabricworks.com


The patch titled
     Subject: lib/crc32.c: fix unused variables warnings
has been added to the -mm tree.  Its filename is
     lib-crc32c-fix-unused-variables-warnings.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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
Subject: Subject: lib/crc32.c: fix unused variables warnings

Patches currently in -mm which might be from trbecker@trbecker.org are

lib-crc32c-fix-unused-variables-warnings.patch

