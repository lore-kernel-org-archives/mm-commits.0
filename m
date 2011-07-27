From: akpm@linux-foundation.org
Subject: + minix-describe-usage-of-different-magic-numbers.patch added to -mm tree
Date: Wed, 27 Jul 2011 14:35:17 -0700
Message-ID: <201107272135.p6RLZHXF009407@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:53018 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755312Ab1G0Vfz (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 27 Jul 2011 17:35:55 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: kerolasa@iki.fi


The patch titled
     minix: describe usage of different magic numbers
has been added to the -mm tree.  Its filename is
     minix-describe-usage-of-different-magic-numbers.patch

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
Subject: minix: describe usage of different magic numbers
From: Sami Kerola <kerolasa@iki.fi>

One can get this information from minix/inode.c, but adding the
explanations at the definition sites is more appropriate.

Signed-off-by: Sami Kerola <kerolasa@iki.fi>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/magic.h |   10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

diff -puN include/linux/magic.h~minix-describe-usage-of-different-magic-numbers include/linux/magic.h
--- a/include/linux/magic.h~minix-describe-usage-of-different-magic-numbers
+++ a/include/linux/magic.h
@@ -30,11 +30,11 @@
 #define ANON_INODE_FS_MAGIC	0x09041934
 #define PSTOREFS_MAGIC		0x6165676C
 
-#define MINIX_SUPER_MAGIC	0x137F		/* original minix fs */
-#define MINIX_SUPER_MAGIC2	0x138F		/* minix fs, 30 char names */
-#define MINIX2_SUPER_MAGIC	0x2468		/* minix V2 fs */
-#define MINIX2_SUPER_MAGIC2	0x2478		/* minix V2 fs, 30 char names */
-#define MINIX3_SUPER_MAGIC	0x4d5a		/* minix V3 fs */
+#define MINIX_SUPER_MAGIC	0x137F		/* minix v1 fs, 14 char names */
+#define MINIX_SUPER_MAGIC2	0x138F		/* minix v1 fs, 30 char names */
+#define MINIX2_SUPER_MAGIC	0x2468		/* minix v2 fs, 14 char names */
+#define MINIX2_SUPER_MAGIC2	0x2478		/* minix v2 fs, 30 char names */
+#define MINIX3_SUPER_MAGIC	0x4d5a		/* minix v3 fs, 60 char names */
 
 #define MSDOS_SUPER_MAGIC	0x4d44		/* MD */
 #define NCP_SUPER_MAGIC		0x564c		/* Guess, what 0x564c is :-) */
_

Patches currently in -mm which might be from kerolasa@iki.fi are

minix-describe-usage-of-different-magic-numbers.patch

