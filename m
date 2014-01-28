From: akpm@linux-foundation.org
Subject: [merged] dynamic_debug-remove-wrong-error-message.patch removed
 from -mm tree
Date: Tue, 28 Jan 2014 11:09:15 -0800
Message-ID: <52e8005b.EjRJVYnNfpas0GqM%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:45477 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755143AbaA1TJP (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 28 Jan 2014 14:09:15 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, jbaron@akamai.com, a.ryabinin@samsung.com

Subject: [merged] dynamic_debug-remove-wrong-error-message.patch removed from -mm tree
To: a.ryabinin@samsung.com,jbaron@akamai.com,mm-commits@vger.kernel.org
From: akpm@linux-foundation.org
Date: Tue, 28 Jan 2014 11:09:15 -0800


The patch titled
     Subject: dynamic_debug: remove wrong error message
has been removed from the -mm tree.  Its filename was
     dynamic_debug-remove-wrong-error-message.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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

origin.patch

