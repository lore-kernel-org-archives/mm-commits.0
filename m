From: akpm@linux-foundation.org
Subject: [merged] include-linux-bugh-fix-sparse-warning-related-to-build_bug_on_invalid.patch removed from -mm tree
Date: Fri, 30 Nov 2012 13:28:17 -0800
Message-ID: <20121130212818.5B0FC20004E@hpza10.eem.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-lb0-f202.google.com ([209.85.217.202]:34593 "EHLO
	mail-lb0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750888Ab2K3V2V (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 30 Nov 2012 16:28:21 -0500
Received: by mail-lb0-f202.google.com with SMTP id i15so71429lbo.1
        for <mm-commits@vger.kernel.org>; Fri, 30 Nov 2012 13:28:19 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: tushar.behera@linaro.org, khlebnikov@openvz.org, mm-commits@vger.kernel.org


The patch titled
     Subject: include/linux/bug.h: fix sparse warning related to BUILD_BUG_ON_INVALID
has been removed from the -mm tree.  Its filename was
     include-linux-bugh-fix-sparse-warning-related-to-build_bug_on_invalid.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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

origin.patch
linux-next.patch
drivers-rtc-rtc-s3cc-remove-unnecessary-err_nores-label.patch
drivers-rtc-rtc-s3cc-convert-to-use-devm_-api.patch

