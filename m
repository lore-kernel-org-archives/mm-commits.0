From: akpm@linux-foundation.org
Subject: [merged] lib-vsprintf-optimize-division-by-10-for-small-integers.patch removed from -mm tree
Date: Fri, 05 Oct 2012 13:14:06 -0700
Message-ID: <20121005201407.257D35C0060@hpza9.eem.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-ee0-f74.google.com ([74.125.83.74]:51306 "EHLO
	mail-ee0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932820Ab2JEUOI (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 5 Oct 2012 16:14:08 -0400
Received: by mail-ee0-f74.google.com with SMTP id b57so139472eek.1
        for <mm-commits@vger.kernel.org>; Fri, 05 Oct 2012 13:14:08 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: linux@horizon.com, mina86@mina86.com, vda.linux@googlemail.com, mm-commits@vger.kernel.org


The patch titled
     Subject: lib: vsprintf: optimize division by 10 for small integers
has been removed from the -mm tree.  Its filename was
     lib-vsprintf-optimize-division-by-10-for-small-integers.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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

origin.patch

