From: akpm@linux-foundation.org
Subject: [merged] lib-vsprintfc-%o0-becomes-0-instead-of-00.patch removed from -mm tree
Date: Thu, 31 May 2012 12:20:14 -0700
Message-ID: <20120531192014.75070A0203@akpm.mtv.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-wg0-f74.google.com ([74.125.82.74]:46086 "EHLO
	mail-wg0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757596Ab2EaTUP (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 31 May 2012 15:20:15 -0400
Received: by mail-wg0-f74.google.com with SMTP id dt11so76227wgb.1
        for <mm-commits@vger.kernel.org>; Thu, 31 May 2012 12:20:15 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: pierre@spotify.com, joe@perches.com, sfr@canb.auug.org.au, mm-commits@vger.kernel.org


The patch titled
     Subject: lib/vsprintf.c: "%#o",0 becomes '0' instead of '00'
has been removed from the -mm tree.  Its filename was
     lib-vsprintfc-%o0-becomes-0-instead-of-00.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
From: Pierre Carrier <pierre@spotify.com>
Subject: lib/vsprintf.c: "%#o",0 becomes '0' instead of '00'

number()'s behaviour is slighly changed: 0 becomes "0" instead of "00"
when using the flag SPECIAL and base 8.

Before:
Number\Format  %o    %#o  %x    %#x
            0     0   00    0   0x0
            1     1   01    1   0x1
           16    20  020   10  0x10

After:
Number\Format  %o    %#o  %x    %#x
            0     0    0    0   0x0
            1     1   01    1   0x1
           16    20  020   10  0x10

Signed-off-by: Pierre Carrier <pierre@spotify.com>
Acked-by: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: Joe Perches <joe@perches.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/vsprintf.c |   12 ++++++++----
 1 file changed, 8 insertions(+), 4 deletions(-)

diff -puN lib/vsprintf.c~lib-vsprintfc-%o0-becomes-0-instead-of-00 lib/vsprintf.c
--- a/lib/vsprintf.c~lib-vsprintfc-%o0-becomes-0-instead-of-00
+++ a/lib/vsprintf.c
@@ -284,6 +284,7 @@ char *number(char *buf, char *end, unsig
 	char locase;
 	int need_pfx = ((spec.flags & SPECIAL) && spec.base != 10);
 	int i;
+	bool is_zero = num == 0LL;
 
 	/* locase = 0 or 0x20. ORing digits or letters with 'locase'
 	 * produces same digits or (maybe lowercased) letters */
@@ -305,8 +306,9 @@ char *number(char *buf, char *end, unsig
 		}
 	}
 	if (need_pfx) {
-		spec.field_width--;
 		if (spec.base == 16)
+			spec.field_width -= 2;
+		else if (!is_zero)
 			spec.field_width--;
 	}
 
@@ -353,9 +355,11 @@ char *number(char *buf, char *end, unsig
 	}
 	/* "0x" / "0" prefix */
 	if (need_pfx) {
-		if (buf < end)
-			*buf = '0';
-		++buf;
+		if (spec.base == 16 || !is_zero) {
+			if (buf < end)
+				*buf = '0';
+			++buf;
+		}
 		if (spec.base == 16) {
 			if (buf < end)
 				*buf = ('X' | locase);
_

Patches currently in -mm which might be from pierre@spotify.com are

origin.patch

