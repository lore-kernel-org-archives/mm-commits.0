From: akpm@linux-foundation.org
Subject: + lib-vsprintf-fix-broken-comments.patch added to -mm tree
Date: Wed, 15 Aug 2012 15:37:26 -0700
Message-ID: <20120815223727.89AEE5C0060@hpza9.eem.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-we0-f202.google.com ([74.125.82.202]:62714 "EHLO
	mail-we0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751044Ab2HOWh3 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 15 Aug 2012 18:37:29 -0400
Received: by weyr1 with SMTP id r1so98764wey.1
        for <mm-commits@vger.kernel.org>; Wed, 15 Aug 2012 15:37:28 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: linux@horizon.com, mina86@mina86.com, vda.linux@googlemail.com


The patch titled
     Subject: lib: vsprintf: fix broken comments
has been added to the -mm tree.  Its filename is
     lib-vsprintf-fix-broken-comments.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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
@@ -182,19 +182,19 @@ char *put_dec_trunc8(char *buf, unsigned
 
 	if (r == 0)
 		return buf;
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
+	*buf++ = q + '0';		/* q <= 9 */
 	return buf;
 }
 
_

Patches currently in -mm which might be from linux@horizon.com are

lib-vsprintf-optimize-division-by-10-for-small-integers.patch
lib-vsprintf-optimize-division-by-10000.patch
lib-vsprintf-optimize-put_dec_trunc8.patch
lib-vsprintf-fix-broken-comments.patch

