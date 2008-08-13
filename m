From: akpm@linux-foundation.org
Subject: - lib-vsprintfc-wrong-conversion-function-usedpatch-added-to-mm-tree.patch removed from -mm tree
Date: Wed, 13 Aug 2008 01:53:01 -0700
Message-ID: <200808130853.m7D8r1Mv008279@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:33770 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752804AbYHMJCu (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 13 Aug 2008 05:02:50 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: yi.y.yang@intel.com, swen@vnet.ibm.com, mm-commits@vger.kernel.org


The patch titled
     lib/vsprintf.c: wrong conversion function used
has been removed from the -mm tree.  Its filename was
     lib-vsprintfc-wrong-conversion-function-usedpatch-added-to-mm-tree.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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

linux-next.patch

