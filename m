From: akpm@linux-foundation.org
Subject: [merged] lib-vsprintf-fix-broken-comments.patch removed from -mm tree
Date: Fri, 05 Oct 2012 13:14:18 -0700
Message-ID: <20121005201419.28B005C0050@hpza9.eem.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-lb0-f202.google.com ([209.85.217.202]:34885 "EHLO
	mail-lb0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932820Ab2JEUOV (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 5 Oct 2012 16:14:21 -0400
Received: by mail-lb0-f202.google.com with SMTP id l12so140979lbo.1
        for <mm-commits@vger.kernel.org>; Fri, 05 Oct 2012 13:14:20 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: linux@horizon.com, mina86@mina86.com, vda.linux@googlemail.com, mm-commits@vger.kernel.org


The patch titled
     Subject: lib: vsprintf: fix broken comments
has been removed from the -mm tree.  Its filename was
     lib-vsprintf-fix-broken-comments.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: George Spelvin <linux@horizon.com>
Subject: lib: vsprintf: fix broken comments

Numbering the 8 potential digits 2 though 9 never did make a lot of sense.

Signed-off-by: George Spelvin <linux@horizon.com>
Cc: Denys Vlasenko <vda.linux@googlemail.com>
Cc: Michal Nazarewicz <mina86@mina86.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/vsprintf.c |   14 +++++++-------
 1 file changed, 7 insertions(+), 7 deletions(-)

diff -puN lib/vsprintf.c~lib-vsprintf-fix-broken-comments lib/vsprintf.c
--- a/lib/vsprintf.c~lib-vsprintf-fix-broken-comments
+++ a/lib/vsprintf.c
@@ -180,19 +180,19 @@ char *put_dec_trunc8(char *buf, unsigned
 		*buf++ = q - 10*r;
 	}
 
-	q      = (r * 0x199a) >> 16;
-	*buf++ = (r - 10 * q)  + '0'; /* 6 */
+	q      = (r * 0x199a) >> 16;	/* r <= 9999 */
+	*buf++ = (r - 10 * q)  + '0';
 	if (q == 0)
 		return buf;
-	r      = (q * 0xcd) >> 11;
-	*buf++ = (q - 10 * r)  + '0'; /* 7 */
+	r      = (q * 0xcd) >> 11;	/* q <= 999 */
+	*buf++ = (q - 10 * r)  + '0';
 	if (r == 0)
 		return buf;
-	q      = (r * 0xcd) >> 11;
-	*buf++ = (r - 10 * q) + '0'; /* 8 */
+	q      = (r * 0xcd) >> 11;	/* r <= 99 */
+	*buf++ = (r - 10 * q) + '0';
 	if (q == 0)
 		return buf;
-	*buf++ = q + '0'; /* 9 */
+	*buf++ = q + '0';		 /* q <= 9 */
 	return buf;
 }
 
_

Patches currently in -mm which might be from linux@horizon.com are

origin.patch

