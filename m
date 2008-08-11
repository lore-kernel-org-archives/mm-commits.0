From: akpm@linux-foundation.org
Subject: + lib-vsprintfc-wrong-conversion-function-usedpatch-added-to-mm-tree.patch added to -mm tree
Date: Sun, 10 Aug 2008 20:38:42 -0700
Message-ID: <200808110338.m7B3cgHW012992@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:33605 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753832AbYHKDjR (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Sun, 10 Aug 2008 23:39:17 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: yi.y.yang@intel.com, swen@vnet.ibm.com


The patch titled
     lib/vsprintf.c: wrong conversion function used
has been added to the -mm tree.  Its filename is
     lib-vsprintfc-wrong-conversion-function-usedpatch-added-to-mm-tree.patch

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
From: Yi Yang <yi.y.yang@intel.com>

Fix wrong conversion function used by strict_strtou*

Signed-off-by: Yi Yang <yi.y.yang@intel.com>
Reported-by: Swen Schillig <swen@vnet.ibm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/vsprintf.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN lib/vsprintf.c~lib-vsprintfc-wrong-conversion-function-usedpatch-added-to-mm-tree lib/vsprintf.c
--- a/lib/vsprintf.c~lib-vsprintfc-wrong-conversion-function-usedpatch-added-to-mm-tree
+++ a/lib/vsprintf.c
@@ -220,7 +220,7 @@ int strict_strtou##type(const char *cp, 
 	if (len == 0)							\
 		return -EINVAL;						\
 									\
-	val = simple_strtoul(cp, &tail, base);				\
+	val = simple_strtou##type(cp, &tail, base);			\
 	if ((*tail == '\0') ||						\
 		((len == (size_t)(tail - cp) + 1) && (*tail == '\n'))) {\
 		*res = val;						\
_

Patches currently in -mm which might be from yi.y.yang@intel.com are

lib-vsprintfc-wrong-conversion-function-usedpatch-added-to-mm-tree.patch

