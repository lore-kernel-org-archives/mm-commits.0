From: akpm@linux-foundation.org
Subject: [patch 19/94] lkdtm: include WARN format string
Date: Fri, 17 Nov 2017 15:27:17 -0800
Message-ID: <20171117232717.PFXQ3YdNK%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:55336 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1423248AbdKQX1T (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 17 Nov 2017 18:27:19 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, arnd@arndb.de, fengguang.wu@intel.com, jpoimboe@redhat.com, keescook@chromium.org, mingo@kernel.org, mm-commits@vger.kernel.org, peterz@infradead.org, torvalds@linux-foundation.org

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
