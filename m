From: akpm@linux-foundation.org
Subject: +
 signal-use-build_bug-instead-of-_nsig_words_is_unsupported_sizefix.patch
 added to -mm tree
Date: Mon, 29 Sep 2014 14:31:18 -0700
Message-ID: <5429cfa6.RKTFaVP+g6TAn7Wa%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:41768 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754745AbaI2VbS (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 29 Sep 2014 17:31:18 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: sfr@canb.auug.org.au, oleg@redhat.com, mm-commits@vger.kernel.org


The patch titled
     Subject: signal-use-build_bug-instead-of-_nsig_words_is_unsupported_size.fix
has been added to the -mm tree.  Its filename is
     signal-use-build_bug-instead-of-_nsig_words_is_unsupported_sizefix.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/signal-use-build_bug-instead-of-_nsig_words_is_unsupported_sizefix.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/signal-use-build_bug-instead-of-_nsig_words_is_unsupported_sizefix.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Stephen Rothwell <sfr@canb.auug.org.au>
Subject: signal-use-build_bug-instead-of-_nsig_words_is_unsupported_size.fix

Fixes signal-use-build_bug-instead-of-_nsig_words_is_unsupported_size.patch
which caused the build failure on powerpc.

Add missing "include <linux/bug.h>" which defines BUILD_BUG()
used by that patch.

Signed-off-by: Stephen Rothwell <sfr@canb.auug.org.au>
Signed-off-by: Oleg Nesterov <oleg@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/signal.h |    1 +
 1 file changed, 1 insertion(+)

diff -puN include/linux/signal.h~signal-use-build_bug-instead-of-_nsig_words_is_unsupported_sizefix include/linux/signal.h
--- a/include/linux/signal.h~signal-use-build_bug-instead-of-_nsig_words_is_unsupported_sizefix
+++ a/include/linux/signal.h
@@ -2,6 +2,7 @@
 #define _LINUX_SIGNAL_H
 
 #include <linux/list.h>
+#include <linux/bug.h>
 #include <uapi/linux/signal.h>
 
 struct task_struct;
_

Patches currently in -mm which might be from sfr@canb.auug.org.au are

prctl-pr_set_mm-introduce-pr_set_mm_map-operation-v4-fix.patch
signal-use-build_bug-instead-of-_nsig_words_is_unsupported_sizefix.patch
try-to-use-automatic-variable-in-kexec-purgatory-makefile.patch
linux-next.patch
watchdog-control-hard-lockup-detection-default-fix-2.patch
kernel-forkc-export-kernel_thread-to-modules.patch

