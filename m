From: akpm@linux-foundation.org
Subject: +
 dynamic_debug-replace-obselete-simple_strtoul-with-kstrtouint.patch added
 to -mm tree
Date: Fri, 24 Jan 2014 13:49:32 -0800
Message-ID: <52e2dfec.UWZu+oPakU2Yw7cu%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:45093 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751939AbaAXVtd (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 24 Jan 2014 16:49:33 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, jbaron@akamai.com, a.ryabinin@samsung.com

Subject: + dynamic_debug-replace-obselete-simple_strtoul-with-kstrtouint.patch added to -mm tree
To: a.ryabinin@samsung.com,jbaron@akamai.com
From: akpm@linux-foundation.org
Date: Fri, 24 Jan 2014 13:49:32 -0800


The patch titled
     Subject: dynamic_debug: replace obselete simple_strtoul() with kstrtouint()
has been added to the -mm tree.  Its filename is
     dynamic_debug-replace-obselete-simple_strtoul-with-kstrtouint.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/dynamic_debug-replace-obselete-simple_strtoul-with-kstrtouint.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/dynamic_debug-replace-obselete-simple_strtoul-with-kstrtouint.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Andrey Ryabinin <a.ryabinin@samsung.com>
Subject: dynamic_debug: replace obselete simple_strtoul() with kstrtouint()

Signed-off-by: Andrey Ryabinin <a.ryabinin@samsung.com>
Cc: Jason Baron <jbaron@akamai.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/dynamic_debug.c |    4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

diff -puN lib/dynamic_debug.c~dynamic_debug-replace-obselete-simple_strtoul-with-kstrtouint lib/dynamic_debug.c
--- a/lib/dynamic_debug.c~dynamic_debug-replace-obselete-simple_strtoul-with-kstrtouint
+++ a/lib/dynamic_debug.c
@@ -268,14 +268,12 @@ static int ddebug_tokenize(char *buf, ch
  */
 static inline int parse_lineno(const char *str, unsigned int *val)
 {
-	char *end = NULL;
 	BUG_ON(str == NULL);
 	if (*str == '\0') {
 		*val = 0;
 		return 0;
 	}
-	*val = simple_strtoul(str, &end, 10);
-	if (end == NULL || end == str || *end != '\0') {
+	if (kstrtouint(str, 10, val) < 0) {
 		pr_err("bad line-number: %s\n", str);
 		return -EINVAL;
 	}
_

Patches currently in -mm which might be from a.ryabinin@samsung.com are

dynamic_debug-remove-wrong-error-message.patch
dynamic_debug-fix-ddebug_parse_query.patch
dynamic_debug-replace-obselete-simple_strtoul-with-kstrtouint.patch

