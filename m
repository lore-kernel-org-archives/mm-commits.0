From: akpm@linux-foundation.org
Subject: + dynamic_debug-remove-wrong-error-message.patch added to -mm
 tree
Date: Fri, 24 Jan 2014 13:49:30 -0800
Message-ID: <52e2dfea.E3dhqCVtVmxWJvwI%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:45085 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751633AbaAXVtb (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 24 Jan 2014 16:49:31 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, jbaron@akamai.com, a.ryabinin@samsung.com

Subject: + dynamic_debug-remove-wrong-error-message.patch added to -mm tree
To: a.ryabinin@samsung.com,jbaron@akamai.com
From: akpm@linux-foundation.org
Date: Fri, 24 Jan 2014 13:49:30 -0800


The patch titled
     Subject: dynamic_debug: remove wrong error message
has been added to the -mm tree.  Its filename is
     dynamic_debug-remove-wrong-error-message.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/dynamic_debug-remove-wrong-error-message.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/dynamic_debug-remove-wrong-error-message.patch

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
Subject: dynamic_debug: remove wrong error message

parse_lineno() returns either negative error code or zero.  We don't need
to print something here because if parse_lineno fails it will print error
message.

Signed-off-by: Andrey Ryabinin <a.ryabinin@samsung.com>
Cc: Jason Baron <jbaron@akamai.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/dynamic_debug.c |    4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

diff -puN lib/dynamic_debug.c~dynamic_debug-remove-wrong-error-message lib/dynamic_debug.c
--- a/lib/dynamic_debug.c~dynamic_debug-remove-wrong-error-message
+++ a/lib/dynamic_debug.c
@@ -348,10 +348,8 @@ static int ddebug_parse_query(char *word
 			}
 			if (last)
 				*last++ = '\0';
-			if (parse_lineno(first, &query->first_lineno) < 0) {
-				pr_err("line-number is <0\n");
+			if (parse_lineno(first, &query->first_lineno) < 0)
 				return -EINVAL;
-			}
 			if (last) {
 				/* range <first>-<last> */
 				if (parse_lineno(last, &query->last_lineno)
_

Patches currently in -mm which might be from a.ryabinin@samsung.com are

dynamic_debug-remove-wrong-error-message.patch
dynamic_debug-fix-ddebug_parse_query.patch
dynamic_debug-replace-obselete-simple_strtoul-with-kstrtouint.patch

