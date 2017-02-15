From: akpm@linux-foundation.org
Subject: + mm-add-arch-independent-testcases-for-rodata-fix.patch added to -mm tree
Date: Wed, 15 Feb 2017 13:00:24 -0800
Message-ID: <58a4c168.7IfsFxoEcjGOSBtx%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:43480 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751383AbdBOVAa (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 15 Feb 2017 16:00:30 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: jinb.park7@gmail.com, keescook@chromium.org, valentinrothberg@gmail.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm: testcases for RODATA: fix config dependency
has been added to the -mm tree.  Its filename is
     mm-add-arch-independent-testcases-for-rodata-fix.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-add-arch-independent-testcases-for-rodata-fix.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-add-arch-independent-testcases-for-rodata-fix.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Jinbum Park <jinb.park7@gmail.com>
Subject: mm: testcases for RODATA: fix config dependency

Since DEBUG_RODATA has renamed to STRICT_KERNEL_RWX,
Fix the config dependency.

Link: http://lkml.kernel.org/r/20170209131625.GA16954@pjb1027-Latitude-E5410
Signed-off-by: Jinbum Park <jinb.park7@gmail.com>
Reported-by: Valentin Rothberg <valentinrothberg@gmail.com>
Cc: Kees Cook <keescook@chromium.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/Kconfig.debug |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN mm/Kconfig.debug~mm-add-arch-independent-testcases-for-rodata-fix mm/Kconfig.debug
--- a/mm/Kconfig.debug~mm-add-arch-independent-testcases-for-rodata-fix
+++ a/mm/Kconfig.debug
@@ -93,7 +93,7 @@ config DEBUG_PAGE_REF
 
 config DEBUG_RODATA_TEST
     bool "Testcase for the marking rodata read-only"
-    depends on DEBUG_RODATA
+    depends on STRICT_KERNEL_RWX
     ---help---
       This option enables a testcase for the setting rodata read-only.
 
_

Patches currently in -mm which might be from jinb.park7@gmail.com are

scripts-spellingtxt-add-some-typo-words.patch
mm-add-arch-independent-testcases-for-rodata.patch
mm-add-arch-independent-testcases-for-rodata-fix.patch

