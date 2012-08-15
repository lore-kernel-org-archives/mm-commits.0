From: akpm@linux-foundation.org
Subject: + lib-vsprintf-optimize-division-by-10-for-small-integers.patch added to -mm tree
Date: Wed, 15 Aug 2012 15:37:17 -0700
Message-ID: <20120815223718.466091E0043@wpzn4.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-ob0-f202.google.com ([209.85.214.202]:44296 "EHLO
	mail-ob0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750968Ab2HOWhT (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 15 Aug 2012 18:37:19 -0400
Received: by obbwc20 with SMTP id wc20so1513489obb.1
        for <mm-commits@vger.kernel.org>; Wed, 15 Aug 2012 15:37:19 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: linux@horizon.com, mina86@mina86.com, vda.linux@googlemail.com


The patch titled
     Subject: lib: vsprintf: optimize division by 10 for small integers
has been added to the -mm tree.  Its filename is
     lib-vsprintf-optimize-division-by-10-for-small-integers.patch

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
Subject: lib: vsprintf: optimize division by 10 for small integers

Shrink the reciprocal approximations used in put_dec_full4() based on the
comments in put_dec_full9().

Signed-off-by: George Spelvin <linux@horizon.com>
Cc: Denys Vlasenko <vda.linux@googlemail.com>
Cc: Michal Nazarewicz <mina86@mina86.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/vsprintf.c |    5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff -puN lib/vsprintf.c~lib-vsprintf-optimize-division-by-10-for-small-integers lib/vsprintf.c
--- a/lib/vsprintf.c~lib-vsprintf-optimize-division-by-10-for-small-integers
+++ a/lib/vsprintf.c
@@ -243,13 +243,14 @@ char *put_dec(char *buf, unsigned long l
 
 /* Second algorithm: valid only for 64-bit long longs */
 
+/* See comment in put_dec_full9 for choice of constants */
 static noinline_for_stack
 char *put_dec_full4(char *buf, unsigned q)
 {
 	unsigned r;
-	r      = (q * 0xcccd) >> 19;
+	r      = (q * 0xccd) >> 15;
 	*buf++ = (q - 10 * r) + '0';
-	q      = (r * 0x199a) >> 16;
+	q      = (r * 0xcd) >> 11;
 	*buf++ = (r - 10 * q)  + '0';
 	r      = (q * 0xcd) >> 11;
 	*buf++ = (q - 10 * r)  + '0';
_

Patches currently in -mm which might be from linux@horizon.com are

lib-vsprintf-optimize-division-by-10-for-small-integers.patch
lib-vsprintf-optimize-division-by-10000.patch
lib-vsprintf-optimize-put_dec_trunc8.patch
lib-vsprintf-fix-broken-comments.patch

