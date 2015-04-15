From: akpm@linux-foundation.org
Subject: [folded-merged]
 lib-string_helpersc-change-semantics-of-string_escape_mem-fix.patch removed from -mm tree
Date: Wed, 15 Apr 2015 15:46:00 -0700
Message-ID: <552eea28.0dKhxBXSDcxGvluE%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:52040 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752254AbbDOWqA (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 15 Apr 2015 18:46:00 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: andriy.shevchenko@linux.intel.com, linux@rasmusvillemoes.dk, mm-commits@vger.kernel.org


The patch titled
     Subject: sunrpc/cache: simplify qword_add
has been removed from the -mm tree.  Its filename was
     lib-string_helpersc-change-semantics-of-string_escape_mem-fix.patch

This patch was dropped because it was folded into lib-string_helpersc-change-semantics-of-string_escape_mem.patch

------------------------------------------------------
From: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Subject: sunrpc/cache: simplify qword_add

The commit 7572d3b29896 (lib/string_helpers.c: change semantics of
string_escape_mem) updates qword_add() to follow the changes in
lib/string_helpers.c. This patch simplifies the approach.

Andrew, I think this one can be folded in the mentioned commit by Rasmus.

Signed-off-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Cc: Rasmus Villemoes <linux@rasmusvillemoes.dk>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 net/sunrpc/cache.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff -puN net/sunrpc/cache.c~lib-string_helpersc-change-semantics-of-string_escape_mem-fix net/sunrpc/cache.c
--- a/net/sunrpc/cache.c~lib-string_helpersc-change-semantics-of-string_escape_mem-fix
+++ a/net/sunrpc/cache.c
@@ -1068,16 +1068,16 @@ void qword_add(char **bpp, int *lp, char
 {
 	char *bp = *bpp;
 	int len = *lp;
-	int ret, written;
+	int ret;
 
 	if (len < 0) return;
 
 	ret = string_escape_str(str, bp, len, ESCAPE_OCTAL, "\\ \n\t");
-	written = min(ret, len);
-	bp += written;
 	if (ret >= len)
+		bp += len;
 		len = -1;
 	else {
+		bp += ret;
 		len -= ret;
 		*bp++ = ' ';
 		len--;
_

Patches currently in -mm which might be from andriy.shevchenko@linux.intel.com are

origin.patch
lib-vsprintfc-fix-potential-null-deref-in-hex_string.patch
lib-string_helpersc-refactor-string_escape_mem.patch
lib-string_helpersc-change-semantics-of-string_escape_mem.patch
lib-string_helpersc-change-semantics-of-string_escape_mem-fix-fix.patch

