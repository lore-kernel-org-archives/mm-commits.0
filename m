From: akpm@linux-foundation.org
Subject: [folded-dropped] lib-vsprintf-optimize-put_dec_trunc8-fix.patch removed from -mm tree
Date: Thu, 04 Oct 2012 16:54:27 -0700
Message-ID: <20121004235427.969C3100047@wpzn3.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-gh0-f202.google.com ([209.85.160.202]:34762 "EHLO
	mail-gh0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750907Ab2JDXy2 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 4 Oct 2012 19:54:28 -0400
Received: by mail-gh0-f202.google.com with SMTP id z15so129010ghb.1
        for <mm-commits@vger.kernel.org>; Thu, 04 Oct 2012 16:54:28 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: linux@horizon.com, mina86@mina86.com, rabin@rab.in, vda.linux@googlemail.com, mm-commits@vger.kernel.org


The patch titled
     Subject: lib-vsprintf-optimize-put_dec_trunc8-fix
has been removed from the -mm tree.  Its filename was
     lib-vsprintf-optimize-put_dec_trunc8-fix.patch

This patch was dropped because it was folded into lib-vsprintf-optimize-put_dec_trunc8.patch

------------------------------------------------------
From: George Spelvin <linux@horizon.com>
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

Signed-off-by: George Spelvin <linux@horizon.com>
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
lib-vsprintf-fix-broken-comments.patch

