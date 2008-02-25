From: akpm@linux-foundation.org
Subject: - lib-vsprintfc-fix-bug-omitting-minus-sign-of-numbers-module_param.patch removed from -mm tree
Date: Sun, 24 Feb 2008 16:44:41 -0800
Message-ID: <200802250044.m1P0ifqk006129@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([207.189.120.13]:50266 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753374AbYBYApa (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Sun, 24 Feb 2008 19:45:30 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: hnguyen@linux.vnet.ibm.com, hnguyen@de.ibm.com, yi.y.yang@intel.com, mm-commits@vger.kernel.org


The patch titled
     lib/vsprintf.c: fix bug omitting minus sign of numbers (module_param)
has been removed from the -mm tree.  Its filename was
     lib-vsprintfc-fix-bug-omitting-minus-sign-of-numbers-module_param.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: lib/vsprintf.c: fix bug omitting minus sign of numbers (module_param)
From: Hoang-Nam Nguyen <hnguyen@linux.vnet.ibm.com>

lib/vsprintf.c: Fix bug omitting minus sign of numbers (module_param)

Signed-off-by: Hoang-Nam Nguyen <hnguyen@de.ibm.com>
Cc: Yi Yang <yi.y.yang@intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/vsprintf.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN lib/vsprintf.c~lib-vsprintfc-fix-bug-omitting-minus-sign-of-numbers-module_param lib/vsprintf.c
--- a/lib/vsprintf.c~lib-vsprintfc-fix-bug-omitting-minus-sign-of-numbers-module_param
+++ a/lib/vsprintf.c
@@ -234,7 +234,7 @@ int strict_strto##type(const char *cp, u
 	int ret;							\
 	if (*cp == '-') {						\
 		ret = strict_strtou##type(cp+1, base, res);		\
-		if (ret != 0)						\
+		if (!ret)						\
 			*res = -(*res);					\
 	} else								\
 		ret = strict_strtou##type(cp, base, res);		\
_

Patches currently in -mm which might be from hnguyen@linux.vnet.ibm.com are
