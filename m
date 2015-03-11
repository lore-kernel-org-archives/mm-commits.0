From: akpm@linux-foundation.org
Subject: +
 lib-string_helpersc-change-semantics-of-string_escape_mem-fix-fix.patch
 added to -mm tree
Date: Wed, 11 Mar 2015 15:57:02 -0700
Message-ID: <5500c83e.SoeuKlV4MlvDCUpi%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:53035 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752556AbbCKW5D (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 11 Mar 2015 18:57:03 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: andriy.shevchenko@linux.intel.com, linux@rasmusvillemoes.dk, mm-commits@vger.kernel.org


The patch titled
     Subject: lib-string_helpersc-change-semantics-of-string_escape_mem-fix-fix
has been added to the -mm tree.  Its filename is
     lib-string_helpersc-change-semantics-of-string_escape_mem-fix-fix.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/lib-string_helpersc-change-semantics-of-string_escape_mem-fix-fix.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/lib-string_helpersc-change-semantics-of-string_escape_mem-fix-fix.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Subject: lib-string_helpersc-change-semantics-of-string_escape_mem-fix-fix

- add missed curly braces (grr... I have them in initial comment)

Signed-off-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Cc: Rasmus Villemoes <linux@rasmusvillemoes.dk>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 net/sunrpc/cache.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff -puN net/sunrpc/cache.c~lib-string_helpersc-change-semantics-of-string_escape_mem-fix-fix net/sunrpc/cache.c
--- a/net/sunrpc/cache.c~lib-string_helpersc-change-semantics-of-string_escape_mem-fix-fix
+++ a/net/sunrpc/cache.c
@@ -1073,10 +1073,10 @@ void qword_add(char **bpp, int *lp, char
 	if (len < 0) return;
 
 	ret = string_escape_str(str, bp, len, ESCAPE_OCTAL, "\\ \n\t");
-	if (ret >= len)
+	if (ret >= len) {
 		bp += len;
 		len = -1;
-	else {
+	} else {
 		bp += ret;
 		len -= ret;
 		*bp++ = ' ';
_

Patches currently in -mm which might be from andriy.shevchenko@linux.intel.com are

origin.patch
lib-vsprintfc-fix-potential-null-deref-in-hex_string.patch
lib-string_helpersc-refactor-string_escape_mem.patch
lib-string_helpersc-change-semantics-of-string_escape_mem.patch
lib-string_helpersc-change-semantics-of-string_escape_mem-fix.patch
lib-string_helpersc-change-semantics-of-string_escape_mem-fix-fix.patch
linux-next.patch

