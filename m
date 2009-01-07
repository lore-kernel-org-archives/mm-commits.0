From: akpm@linux-foundation.org
Subject: - sm501-unsigned-ptr-cannot-be-negative.patch removed from -mm tree
Date: Wed, 07 Jan 2009 14:19:59 -0800
Message-ID: <200901072219.n07MJxdf019250@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:39891 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932292AbZAGWiG (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 7 Jan 2009 17:38:06 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: roel.kluin@gmail.com, ben-linux@fluff.org, krzysztof.h1@poczta.fm, mm-commits@vger.kernel.org


The patch titled
     sm501: unsigned ptr cannot be negative
has been removed from the -mm tree.  Its filename was
     sm501-unsigned-ptr-cannot-be-negative.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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
