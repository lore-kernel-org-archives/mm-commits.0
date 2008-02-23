From: akpm@linux-foundation.org
Subject: + lib-vsprintfc-fix-bug-omitting-minus-sign-of-numbers-module_param.patch added to -mm tree
Date: Fri, 22 Feb 2008 23:28:41 -0800
Message-ID: <200802230729.m1N7TU7m017904@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([207.189.120.13]:58121 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751979AbYBWHfD (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Sat, 23 Feb 2008 02:35:03 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: hnguyen@linux.vnet.ibm.com, hnguyen@de.ibm.com, yi.y.yang@intel.com


The patch titled
     lib/vsprintf.c: fix bug omitting minus sign of numbers (module_param)
has been added to the -mm tree.  Its filename is
     lib-vsprintfc-fix-bug-omitting-minus-sign-of-numbers-module_param.patch

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

lib-vsprintfc-fix-bug-omitting-minus-sign-of-numbers-module_param.patch
