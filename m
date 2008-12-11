From: akpm@linux-foundation.org
Subject: + unicode-fix-cp437-table.patch added to -mm tree
Date: Thu, 11 Dec 2008 14:56:12 -0800
Message-ID: <200812112256.mBBMuDIc024493@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:56404 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1759161AbYLKW4n (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 11 Dec 2008 17:56:43 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: ib@wupperonline.de


The patch titled
     unicode: fix cp437 table
has been added to the -mm tree.  Its filename is
     unicode-fix-cp437-table.patch

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
Subject: unicode: fix cp437 table
From: Ingo Brueckl <ib@wupperonline.de>

There is a major bug in the cp437 to unicode translation table.  Char 0x7c
is mapped to U+00a5 which is the Yen sign and wrong.  The right mapping is
U+00a6 (broken bar).

Furthermore, a mapping for U+00b4 (a widely used character) is missing
even though easily possible.

The patch fixes these, as well as providing a few other useful mappings.

The changes are as follows:

0x0f (enhancement) enables a sort of currency symbol
0x27 (bug) enables a sort of acute accent which is a widely used character
0x44 (enhancement) enables a sort of icelandic capital letter eth
0x7c (major bug) corrects mapping
0xeb (enhancement) enables a sort of icelandic small letter eth
0xee (enhancement) enables a sort of math 'element of'

Signed-off-by: Ingo Brueckl <ib@wupperonline.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/char/cp437.uni |   12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

diff -puN drivers/char/cp437.uni~unicode-fix-cp437-table drivers/char/cp437.uni
--- a/drivers/char/cp437.uni~unicode-fix-cp437-table
+++ a/drivers/char/cp437.uni
@@ -27,7 +27,7 @@
 0x0c	U+2640
 0x0d	U+266a
 0x0e	U+266b
-0x0f	U+263c
+0x0f	U+263c U+00a4
 0x10	U+25b6 U+25ba
 0x11	U+25c0 U+25c4
 0x12	U+2195
@@ -55,7 +55,7 @@
 0x24	U+0024
 0x25	U+0025
 0x26	U+0026
-0x27	U+0027
+0x27	U+0027 U+00b4
 0x28	U+0028
 0x29	U+0029
 0x2a	U+002a
@@ -84,7 +84,7 @@
 0x41	U+0041 U+00c0 U+00c1 U+00c2 U+00c3
 0x42	U+0042
 0x43	U+0043 U+00a9
-0x44	U+0044
+0x44	U+0044 U+00d0
 0x45	U+0045 U+00c8 U+00ca U+00cb
 0x46	U+0046
 0x47	U+0047
@@ -140,7 +140,7 @@
 0x79	U+0079 U+00fd
 0x7a	U+007a
 0x7b	U+007b
-0x7c	U+007c U+00a5
+0x7c	U+007c U+00a6
 0x7d	U+007d
 0x7e	U+007e
 #
@@ -263,10 +263,10 @@
 0xe8	U+03a6 U+00d8
 0xe9	U+0398
 0xea	U+03a9 U+2126
-0xeb	U+03b4
+0xeb	U+03b4 U+00f0
 0xec	U+221e
 0xed	U+03c6 U+00f8
-0xee	U+03b5
+0xee	U+03b5 U+2208
 0xef	U+2229
 0xf0	U+2261
 0xf1	U+00b1
_

Patches currently in -mm which might be from ib@wupperonline.de are

unicode-fix-cp437-table.patch

