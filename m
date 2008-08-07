From: akpm@linux-foundation.org
Subject: + lib-vsprintfc-wrong-conversion-function-used.patch added to -mm tree
Date: Thu, 07 Aug 2008 13:23:27 -0700
Message-ID: <200808072023.m77KNRb1003679@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:54165 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752730AbYHGUX5 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 7 Aug 2008 16:23:57 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: swen@vnet.ibm.com, yi.y.yang@intel.com


The patch titled
     lib/vsprintf.c: wrong conversion function used
has been added to the -mm tree.  Its filename is
     lib-vsprintfc-wrong-conversion-function-used.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: lib/vsprintf.c: wrong conversion function used
From: Swen Schillig <swen@vnet.ibm.com>

The macro define_strict_strtoux() is using the simple_strtoul () function
as opposed to the simple_strtoull() function.  This leads to false
conversions on non-64bit machines (here 31bit System z).

The following patch fixes the issue introduced by

commit 06b2a76d25d3cfbd14680021c1d356c91be6904e
Author: Yi Yang <yi.y.yang@intel.com>
Date:   Fri Feb 8 04:21:57 2008 -0800

Signed-off-by: Swen Schillig <swen@vnet.ibm.com>
Cc: Yi Yang <yi.y.yang@intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/vsprintf.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN lib/vsprintf.c~lib-vsprintfc-wrong-conversion-function-used lib/vsprintf.c
--- a/lib/vsprintf.c~lib-vsprintfc-wrong-conversion-function-used
+++ a/lib/vsprintf.c
@@ -220,7 +220,7 @@ int strict_strtou##type(const char *cp, 
 	if (len == 0)							\
 		return -EINVAL;						\
 									\
-	val = simple_strtoul(cp, &tail, base);				\
+	val = simple_strtoull(cp, &tail, base);				\
 	if ((*tail == '\0') ||						\
 		((len == (size_t)(tail - cp) + 1) && (*tail == '\n'))) {\
 		*res = val;						\
_

Patches currently in -mm which might be from swen@vnet.ibm.com are

lib-vsprintfc-wrong-conversion-function-used.patch

