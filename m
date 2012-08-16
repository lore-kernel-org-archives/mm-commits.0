From: akpm@linux-foundation.org
Subject: + lib-parserc-avoid-overflow-in-match_number.patch added to -mm tree
Date: Thu, 16 Aug 2012 13:20:16 -0700
Message-ID: <20120816202016.A978F100047@wpzn3.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-ob0-f202.google.com ([209.85.214.202]:46307 "EHLO
	mail-ob0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030338Ab2HPUUR (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 16 Aug 2012 16:20:17 -0400
Received: by obbwc20 with SMTP id wc20so2212154obb.1
        for <mm-commits@vger.kernel.org>; Thu, 16 Aug 2012 13:20:17 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: elder@inktank.com, rdunlap@xenotime.net


The patch titled
     Subject:  lib/parser.c: avoid overflow in match_number()
has been added to the -mm tree.  Its filename is
     lib-parserc-avoid-overflow-in-match_number.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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
+	else if (val < (long) INT_MIN || val > (long) INT_MAX)
+		ret = -ERANGE;
+	else
+		*result = (int) val;
 	kfree(buf);
 	return ret;
 }
_

Patches currently in -mm which might be from elder@inktank.com are

lib-parserc-avoid-overflow-in-match_number.patch

