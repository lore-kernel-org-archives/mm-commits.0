From: akpm@linux-foundation.org
Subject: [merged] lib-parserc-avoid-overflow-in-match_number.patch removed from -mm tree
Date: Fri, 05 Oct 2012 13:15:36 -0700
Message-ID: <20121005201536.A7AD5100047@wpzn3.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-gg0-f202.google.com ([209.85.161.202]:62099 "EHLO
	mail-gg0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754132Ab2JEUPh (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 5 Oct 2012 16:15:37 -0400
Received: by mail-gg0-f202.google.com with SMTP id i4so235203ggm.1
        for <mm-commits@vger.kernel.org>; Fri, 05 Oct 2012 13:15:37 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: elder@inktank.com, rdunlap@xenotime.net, mm-commits@vger.kernel.org


The patch titled
     Subject:  lib/parser.c: avoid overflow in match_number()
has been removed from the -mm tree.  Its filename was
     lib-parserc-avoid-overflow-in-match_number.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Alex Elder <elder@inktank.com>
Subject:  lib/parser.c: avoid overflow in match_number()

The result of converting an integer value to another signed integer type
that's unable to represent the original value is implementation defined. 
(See notes in section 6.3.1.3 of the C standard.)

In match_number(), the result of simple_strtol() (which returns type long)
is assigned to a value of type int.

Instead, handle the result of simple_strtol() in a well-defined way, and
return -ERANGE if the result won't fit in the int variable used to hold
the parsed result.

No current callers pay attention to the particular error value returned,
so this additional return code shouldn't do any harm.

[akpm@linux-foundation.org: coding-style tweaks]
Signed-off-by: Alex Elder <elder@inktank.com>
Cc: Randy Dunlap <rdunlap@xenotime.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/parser.c |   10 ++++++++--
 1 file changed, 8 insertions(+), 2 deletions(-)

diff -puN lib/parser.c~lib-parserc-avoid-overflow-in-match_number lib/parser.c
--- a/lib/parser.c~lib-parserc-avoid-overflow-in-match_number
+++ a/lib/parser.c
@@ -122,13 +122,14 @@ int match_token(char *s, const match_tab
  *
  * Description: Given a &substring_t and a base, attempts to parse the substring
  * as a number in that base. On success, sets @result to the integer represented
- * by the string and returns 0. Returns either -ENOMEM or -EINVAL on failure.
+ * by the string and returns 0. Returns -ENOMEM, -EINVAL, or -ERANGE on failure.
  */
 static int match_number(substring_t *s, int *result, int base)
 {
 	char *endp;
 	char *buf;
 	int ret;
+	long val;
 	size_t len = s->to - s->from;
 
 	buf = kmalloc(len + 1, GFP_KERNEL);
@@ -136,10 +137,15 @@ static int match_number(substring_t *s, 
 		return -ENOMEM;
 	memcpy(buf, s->from, len);
 	buf[len] = '\0';
-	*result = simple_strtol(buf, &endp, base);
+
 	ret = 0;
+	val = simple_strtol(buf, &endp, base);
 	if (endp == buf)
 		ret = -EINVAL;
+	else if (val < (long)INT_MIN || val > (long)INT_MAX)
+		ret = -ERANGE;
+	else
+		*result = (int) val;
 	kfree(buf);
 	return ret;
 }
_

Patches currently in -mm which might be from elder@inktank.com are

origin.patch
linux-next.patch

