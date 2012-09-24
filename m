From: akpm@linux-foundation.org
Subject: + lib-vsprintf-optimize-put_dec_trunc8-fix.patch added to -mm tree
Date: Mon, 24 Sep 2012 15:54:59 -0700
Message-ID: <20120924225500.14B3B5C0063@hpza9.eem.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-wg0-f74.google.com ([74.125.82.74]:44440 "EHLO
	mail-wg0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750757Ab2IXWzD (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 24 Sep 2012 18:55:03 -0400
Received: by wgbdt11 with SMTP id dt11so355603wgb.1
        for <mm-commits@vger.kernel.org>; Mon, 24 Sep 2012 15:55:01 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: linux@horizon.com, mina86@mina86.com, rabin@rab.in, vda.linux@googlemail.com


The patch titled
     Subject: lib-vsprintf-optimize-put_dec_trunc8-fix
has been added to the -mm tree.  Its filename is
     lib-vsprintf-optimize-put_dec_trunc8-fix.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: "George Spelvin" <linux@horizon.com>
Subject: lib-vsprintf-optimize-put_dec_trunc8-fix

Rabin Vincent <rabin@rab.in> wrote:
> This patch breaks IP address printing with "%pI4" (and by extension,
> nfsroot).  Example:
>
>  - Before: 10.0.0.1
>  - After: 10...1

Mea culpa, and thank you for catching it!  As I said in my earlier
comment, I tested this most extensively wrapped by some sprintf code
that liked 0 converted to a 0-length string, as that works naturally
with the ANSI spec for %.0u.  And it turns out not to matter for the
usual printf code, as num_to_str special-cases that anyway.

The fix is straightforward:

Signed-off-by: "George Spelvin" <linux@horizon.com>
Cc: Rabin Vincent <rabin@rab.in>
Cc: Denys Vlasenko <vda.linux@googlemail.com>
Cc: Michal Nazarewicz <mina86@mina86.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/vsprintf.c |    2 --
 1 file changed, 2 deletions(-)

diff -puN lib/vsprintf.c~lib-vsprintf-optimize-put_dec_trunc8-fix lib/vsprintf.c
--- a/lib/vsprintf.c~lib-vsprintf-optimize-put_dec_trunc8-fix
+++ a/lib/vsprintf.c
@@ -180,8 +180,6 @@ char *put_dec_trunc8(char *buf, unsigned
 		*buf++ = q - 10*r;
 	}
 
-	if (r == 0)
-		return buf;
 	q      = (r * 0x199a) >> 16;
 	*buf++ = (r - 10 * q)  + '0'; /* 6 */
 	if (q == 0)
_

Patches currently in -mm which might be from linux@horizon.com are

lib-vsprintf-optimize-division-by-10-for-small-integers.patch
lib-vsprintf-optimize-division-by-10000.patch
lib-vsprintf-optimize-put_dec_trunc8.patch
lib-vsprintf-optimize-put_dec_trunc8-fix.patch
lib-vsprintf-fix-broken-comments.patch

