From: akpm@linux-foundation.org
Subject: + sm501-unsigned-ptr-cannot-be-negative.patch added to -mm tree
Date: Tue, 02 Dec 2008 14:05:43 -0800
Message-ID: <200812022205.mB2M5h2U025467@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:55988 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753147AbYLBWGZ (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 2 Dec 2008 17:06:25 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: roel.kluin@gmail.com, ben-linux@fluff.org, krzysztof.h1@poczta.fm


The patch titled
     sm501: unsigned ptr cannot be negative
has been added to the -mm tree.  Its filename is
     sm501-unsigned-ptr-cannot-be-negative.patch

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
Subject: sm501: unsigned ptr cannot be negative
From: roel kluin <roel.kluin@gmail.com>

unsigned ptr cannot be negative

Signed-off-by: Roel Kluin <roel.kluin@gmail.com>
Cc: Krzysztof Helt <krzysztof.h1@poczta.fm>
Cc: Ben Dooks <ben-linux@fluff.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/video/sm501fb.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff -puN drivers/video/sm501fb.c~sm501-unsigned-ptr-cannot-be-negative drivers/video/sm501fb.c
--- a/drivers/video/sm501fb.c~sm501-unsigned-ptr-cannot-be-negative
+++ a/drivers/video/sm501fb.c
@@ -159,6 +159,9 @@ static int sm501_alloc_mem(struct sm501f
 		break;
 
 	case SM501_MEMF_PANEL:
+		if (size > inf->fbmem_len)
+			return -ENOMEM;
+
 		ptr = inf->fbmem_len - size;
 		fbi = inf->fb[HEAD_CRT];
 
@@ -172,9 +175,6 @@ static int sm501_alloc_mem(struct sm501f
 		if (fbi && ptr < fbi->fix.smem_len)
 			return -ENOMEM;
 
-		if (ptr < 0)
-			return -ENOMEM;
