From: akpm@linux-foundation.org
Subject: [merged] lib-bitmap-simplify-bitmap_parselist.patch removed from
 -mm tree
Date: Thu, 07 Aug 2014 13:08:25 -0700
Message-ID: <53e3dcb9.dOwVg3JRiFF6FTiW%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-ig0-f202.google.com ([209.85.213.202]:42746 "EHLO
	mail-ig0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755411AbaHGUI0 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 7 Aug 2014 16:08:26 -0400
Received: by mail-ig0-f202.google.com with SMTP id r2so880544igi.5
        for <mm-commits@vger.kernel.org>; Thu, 07 Aug 2014 13:08:25 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: linux@rasmusvillemoes.dk, mm-commits@vger.kernel.org


The patch titled
     Subject: lib: bitmap: simplify bitmap_parselist
has been removed from the -mm tree.  Its filename was
     lib-bitmap-simplify-bitmap_parselist.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Rasmus Villemoes <linux@rasmusvillemoes.dk>
Subject: lib: bitmap: simplify bitmap_parselist

We want len to be the index of the first '\n', or the length of the string
if there is no newline.  This is a good example of the usefulness of
strchrnul().  Use that instead, thus eliminating a branch and a call to
strlen().

Signed-off-by: Rasmus Villemoes <linux@rasmusvillemoes.dk>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/bitmap.c |    9 ++-------
 1 file changed, 2 insertions(+), 7 deletions(-)

diff -puN lib/bitmap.c~lib-bitmap-simplify-bitmap_parselist lib/bitmap.c
--- a/lib/bitmap.c~lib-bitmap-simplify-bitmap_parselist
+++ a/lib/bitmap.c
@@ -665,13 +665,8 @@ static int __bitmap_parselist(const char
 
 int bitmap_parselist(const char *bp, unsigned long *maskp, int nmaskbits)
 {
-	char *nl  = strchr(bp, '\n');
-	int len;
