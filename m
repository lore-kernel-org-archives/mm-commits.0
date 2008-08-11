From: akpm@linux-foundation.org
Subject: - lib-vsprintfc-wrong-conversion-function-used.patch removed from -mm tree
Date: Sun, 10 Aug 2008 20:37:38 -0700
Message-ID: <200808110337.m7B3bcPO012980@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:34924 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753846AbYHKDhk (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Sun, 10 Aug 2008 23:37:40 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: swen@vnet.ibm.com, yi.y.yang@intel.com, mm-commits@vger.kernel.org


The patch titled
     lib/vsprintf.c: wrong conversion function used
has been removed from the -mm tree.  Its filename was
     lib-vsprintfc-wrong-conversion-function-used.patch

This patch was dropped because an updated version will be merged

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

