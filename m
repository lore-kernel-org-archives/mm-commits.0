From: akpm@linux-foundation.org
Subject: [merged] printk-fix-wrong-format-string-iter.patch removed from -mm tree
Date: Fri, 10 Apr 2009 13:09:28 -0700
Message-ID: <200904102009.n3AK9SxS029862@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:40580 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752264AbZDJULu (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 10 Apr 2009 16:11:50 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: zhaolei@cn.fujitsu.com, fweisbec@gmail.com, laijs@cn.fujitsu.com, mm-commits@vger.kernel.org


The patch titled
     printk: fix wrong format string iter
has been removed from the -mm tree.  Its filename was
     printk-fix-wrong-format-string-iter.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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

