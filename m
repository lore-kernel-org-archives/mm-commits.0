From: akpm@linux-foundation.org
Subject: + printk-fix-wrong-format-string-iter.patch added to -mm tree
Date: Tue, 07 Apr 2009 14:31:08 -0700
Message-ID: <200904072131.n37LV8ix006770@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:56316 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753692AbZDGVdr (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 7 Apr 2009 17:33:47 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: zhaolei@cn.fujitsu.com, fweisbec@gmail.com, laijs@cn.fujitsu.com


The patch titled
     printk: fix wrong format string iter
has been added to the -mm tree.  Its filename is
     printk-fix-wrong-format-string-iter.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://userweb.kernel.org/~akpm/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: printk: fix wrong format string iter
From: Zhaolei <zhaolei@cn.fujitsu.com>

printk("%Q");
Output before patch:
%QQ
Output after patch:
%Q

Signed-off-by: Zhao Lei <zhaolei@cn.fujitsu.com>
Reviewed-by: Lai Jiangshan <laijs@cn.fujitsu.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/vsprintf.c |   16 ----------------
 1 file changed, 16 deletions(-)

diff -puN lib/vsprintf.c~printk-fix-wrong-format-string-iter lib/vsprintf.c
--- a/lib/vsprintf.c~printk-fix-wrong-format-string-iter
+++ a/lib/vsprintf.c
@@ -1062,13 +1062,6 @@ int vsnprintf(char *buf, size_t size, co
 			if (str < end)
 				*str = '%';
 			++str;
-			if (*fmt) {
-				if (str < end)
-					*str = *fmt;
-				++str;
-			} else {
-				--fmt;
-			}
 			break;
 
 		case FORMAT_TYPE_NRCHARS: {
@@ -1356,8 +1349,6 @@ do {									\
 			break;
 
 		case FORMAT_TYPE_INVALID:
-			if (!*fmt)
-				--fmt;
 			break;
 
 		case FORMAT_TYPE_NRCHARS: {
@@ -1544,13 +1535,6 @@ int bstr_printf(char *buf, size_t size, 
 			if (str < end)
 				*str = '%';
 			++str;
-			if (*fmt) {
-				if (str < end)
-					*str = *fmt;
-				++str;
-			} else {
-				--fmt;
-			}
 			break;
 
 		case FORMAT_TYPE_NRCHARS:
_

Patches currently in -mm which might be from zhaolei@cn.fujitsu.com are

origin.patch
printk-add-support-for-the-of-hh-length-modifier.patch
printk-fix-wrong-format-string-iter.patch

