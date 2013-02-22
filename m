From: akpm@linux-foundation.org
Subject: [merged] lib-parserc-fix-up-comments-for-valid-return-values-from-match_number.patch removed from -mm tree
Date: Fri, 22 Feb 2013 12:42:33 -0800
Message-ID: <20130222204233.963CF31C265@corp2gmr1-1.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-qa0-f73.google.com ([209.85.216.73]:39856 "EHLO
	mail-qa0-f73.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757829Ab3BVUme (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 22 Feb 2013 15:42:34 -0500
Received: by mail-qa0-f73.google.com with SMTP id g10so119644qah.0
        for <mm-commits@vger.kernel.org>; Fri, 22 Feb 2013 12:42:34 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: namjae.jeon@samsung.com, a.sahrawat@samsung.com, mm-commits@vger.kernel.org


The patch titled
     Subject: lib/parser.c: fix up comments for valid return values from match_number
has been removed from the -mm tree.  Its filename was
     lib-parserc-fix-up-comments-for-valid-return-values-from-match_number.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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

