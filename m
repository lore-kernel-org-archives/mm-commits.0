From: akpm@linux-foundation.org
Subject: + lib-parserc-fix-up-comments-for-valid-return-values-from-match_number.patch added to -mm tree
Date: Thu, 17 Jan 2013 15:28:41 -0800
Message-ID: <20130117232841.D01D15A41EB@corp2gmr1-2.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-ie0-f202.google.com ([209.85.223.202]:38595 "EHLO
	mail-ie0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750963Ab3AQX2n (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 17 Jan 2013 18:28:43 -0500
Received: by mail-ie0-f202.google.com with SMTP id s9so814146iec.3
        for <mm-commits@vger.kernel.org>; Thu, 17 Jan 2013 15:28:42 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: namjae.jeon@samsung.com, a.sahrawat@samsung.com


The patch titled
     Subject: lib/parser.c: fix up comments for valid return values from match_number
has been added to the -mm tree.  Its filename is
     lib-parserc-fix-up-comments-for-valid-return-values-from-match_number.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Namjae Jeon <namjae.jeon@samsung.com>
Subject: lib/parser.c: fix up comments for valid return values from match_number

match_number() has return values of -ENOMEM, -EINVAL and -ERANGE.  So, for
all the functions calling match_number, the return value should include
these values.  Fix up the comments to reflect the correct values.

Signed-off-by: Namjae Jeon <namjae.jeon@samsung.com>
Signed-off-by: Amit Sahrawat <a.sahrawat@samsung.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/parser.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff -puN lib/parser.c~lib-parserc-fix-up-comments-for-valid-return-values-from-match_number lib/parser.c
--- a/lib/parser.c~lib-parserc-fix-up-comments-for-valid-return-values-from-match_number
+++ a/lib/parser.c
@@ -157,7 +157,7 @@ static int match_number(substring_t *s, 
  *
  * Description: Attempts to parse the &substring_t @s as a decimal integer. On
  * success, sets @result to the integer represented by the string and returns 0.
- * Returns either -ENOMEM or -EINVAL on failure.
+ * Returns -ENOMEM, -EINVAL, or -ERANGE on failure.
  */
 int match_int(substring_t *s, int *result)
 {
@@ -171,7 +171,7 @@ int match_int(substring_t *s, int *resul
  *
  * Description: Attempts to parse the &substring_t @s as an octal integer. On
  * success, sets @result to the integer represented by the string and returns
- * 0. Returns either -ENOMEM or -EINVAL on failure.
+ * 0. Returns -ENOMEM, -EINVAL, or -ERANGE on failure.
  */
 int match_octal(substring_t *s, int *result)
 {
@@ -185,7 +185,7 @@ int match_octal(substring_t *s, int *res
  *
  * Description: Attempts to parse the &substring_t @s as a hexadecimal integer.
  * On success, sets @result to the integer represented by the string and
- * returns 0. Returns either -ENOMEM or -EINVAL on failure.
+ * returns 0. Returns -ENOMEM, -EINVAL, or -ERANGE on failure.
  */
 int match_hex(substring_t *s, int *result)
 {
_

Patches currently in -mm which might be from namjae.jeon@samsung.com are

origin.patch
linux-next.patch
lib-parserc-fix-up-comments-for-valid-return-values-from-match_number.patch

