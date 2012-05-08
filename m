From: akpm@linux-foundation.org
Subject: + lib-vsprintfc-%o0-becomes-0-instead-of-00.patch added to -mm tree
Date: Tue, 08 May 2012 16:28:24 -0700
Message-ID: <20120508232824.C907CA03B2@akpm.mtv.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-qa0-f74.google.com ([209.85.216.74]:34489 "EHLO
	mail-qa0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756311Ab2EHX20 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 8 May 2012 19:28:26 -0400
Received: by qabg24 with SMTP id g24so186066qab.1
        for <mm-commits@vger.kernel.org>; Tue, 08 May 2012 16:28:25 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: pierre@spotify.com, joe@perches.com, sfr@canb.auug.org.au


The patch titled
     Subject: lib/vsprintf.c: "%#o",0 becomes '0' instead of '00'
has been added to the -mm tree.  Its filename is
     lib-vsprintfc-%o0-becomes-0-instead-of-00.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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
@@ -383,6 +383,7 @@ char *number(char *buf, char *end, unsig
 	char locase;
 	int need_pfx = ((spec.flags & SPECIAL) && spec.base != 10);
 	int i;
+	bool is_zero = num == 0LL;
 
 	/* locase = 0 or 0x20. ORing digits or letters with 'locase'
 	 * produces same digits or (maybe lowercased) letters */
@@ -404,8 +405,9 @@ char *number(char *buf, char *end, unsig
 		}
 	}
 	if (need_pfx) {
-		spec.field_width--;
 		if (spec.base == 16)
+			spec.field_width -= 2;
+		else if (!is_zero)
 			spec.field_width--;
 	}
 
@@ -452,9 +454,11 @@ char *number(char *buf, char *end, unsig
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
Subject: Subject: lib/vsprintf.c: "%#o",0 becomes '0' instead of '00'

Patches currently in -mm which might be from pierre@spotify.com are

lib-vsprintfc-%o0-becomes-0-instead-of-00.patch

