From: akpm@linux-foundation.org
Subject: + include-linux-bugh-fix-sparse-warning-related-to-build_bug_on_invalid.patch added to -mm tree
Date: Mon, 19 Nov 2012 13:30:29 -0800
Message-ID: <20121119213029.BBFDC82004A@wpzn4.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-yh0-f74.google.com ([209.85.213.74]:43349 "EHLO
	mail-yh0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751851Ab2KSVaa (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 19 Nov 2012 16:30:30 -0500
Received: by mail-yh0-f74.google.com with SMTP id 10so607890yhl.1
        for <mm-commits@vger.kernel.org>; Mon, 19 Nov 2012 13:30:30 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: tushar.behera@linaro.org, khlebnikov@openvz.org


The patch titled
     Subject: include/linux/bug.h: fix sparse warning related to BUILD_BUG_ON_INVALID
has been added to the -mm tree.  Its filename is
     include-linux-bugh-fix-sparse-warning-related-to-build_bug_on_invalid.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Tushar Behera <tushar.behera@linaro.org>
Subject: include/linux/bug.h: fix sparse warning related to BUILD_BUG_ON_INVALID

commit baf05aa9271b ("bug: introduce BUILD_BUG_ON_INVALID() macro")
introduces this macro only when _CHECKER_ is not defined.  Define a silent
macro in the else condition to fix following sparse warning.

mm/filemap.c:395:9: error: undefined identifier 'BUILD_BUG_ON_INVALID'
mm/filemap.c:396:9: error: undefined identifier 'BUILD_BUG_ON_INVALID'
mm/filemap.c:397:9: error: undefined identifier 'BUILD_BUG_ON_INVALID'
include/linux/mm.h:419:9: error: undefined identifier 'BUILD_BUG_ON_INVALID'
include/linux/mm.h:419:9: error: not a function <noident>

Signed-off-by: Tushar Behera <tushar.behera@linaro.org>
Acked-by: Konstantin Khlebnikov <khlebnikov@openvz.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/bug.h |    1 +
 1 file changed, 1 insertion(+)

diff -puN include/linux/bug.h~include-linux-bugh-fix-sparse-warning-related-to-build_bug_on_invalid include/linux/bug.h
--- a/include/linux/bug.h~include-linux-bugh-fix-sparse-warning-related-to-build_bug_on_invalid
+++ a/include/linux/bug.h
@@ -15,6 +15,7 @@ struct pt_regs;
 #define BUILD_BUG_ON_NOT_POWER_OF_2(n)
 #define BUILD_BUG_ON_ZERO(e) (0)
 #define BUILD_BUG_ON_NULL(e) ((void*)0)
+#define BUILD_BUG_ON_INVALID(e) (0)
 #define BUILD_BUG_ON(condition)
 #define BUILD_BUG() (0)
 #else /* __CHECKER__ */
_

Patches currently in -mm which might be from tushar.behera@linaro.org are

include-linux-bugh-fix-sparse-warning-related-to-build_bug_on_invalid.patch

