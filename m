From: akpm@linux-foundation.org
Subject: + lkdtm-include-warn-format-string.patch added to -mm tree
Date: Wed, 08 Nov 2017 16:07:15 -0800
Message-ID: <5a039c33.aOx0HHc/0b8Ai/Up%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:57918 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753147AbdKIAHR (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 8 Nov 2017 19:07:17 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: keescook@chromium.org, arnd@arndb.de, fengguang.wu@intel.com, jpoimboe@redhat.com, mingo@kernel.org, peterz@infradead.org, mm-commits@vger.kernel.org


The patch titled
     Subject: lkdtm: include WARN format string
has been added to the -mm tree.  Its filename is
     lkdtm-include-warn-format-string.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/lkdtm-include-warn-format-string.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/lkdtm-include-warn-format-string.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Kees Cook <keescook@chromium.org>
Subject: lkdtm: include WARN format string

In order to test the ordering of WARN format strings, actually include one
in LKDTM.

Link: http://lkml.kernel.org/r/1510100869-73751-2-git-send-email-keescook@chromium.org
Signed-off-by: Kees Cook <keescook@chromium.org>
Cc: Arnd Bergmann <arnd@arndb.de>
Cc: Fengguang Wu <fengguang.wu@intel.com>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: Josh Poimboeuf <jpoimboe@redhat.com>
Cc: Peter Zijlstra (Intel) <peterz@infradead.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/misc/lkdtm_bugs.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff -puN drivers/misc/lkdtm_bugs.c~lkdtm-include-warn-format-string drivers/misc/lkdtm_bugs.c
--- a/drivers/misc/lkdtm_bugs.c~lkdtm-include-warn-format-string
+++ a/drivers/misc/lkdtm_bugs.c
@@ -63,9 +63,11 @@ void lkdtm_BUG(void)
 	BUG();
 }
 
+static int warn_counter;
+
 void lkdtm_WARNING(void)
 {
-	WARN_ON(1);
+	WARN(1, "Warning message trigger count: %d\n", warn_counter++);
 }
 
 void lkdtm_EXCEPTION(void)
_

Patches currently in -mm which might be from keescook@chromium.org are

writeback-convert-timers-to-use-timer_setup.patch
sh-boot-add-static-stack-protector-to-pre-kernel.patch
lkdtm-include-warn-format-string.patch
bug-define-the-cut-here-string-in-a-single-place.patch
bug-fix-cut-here-location-for-__warn_taint-architectures.patch
fs-nilfs2-convert-timers-to-use-timer_setup.patch

