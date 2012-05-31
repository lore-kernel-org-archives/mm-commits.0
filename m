From: akpm@linux-foundation.org
Subject: [merged] bug-introduce-build_bug_on_invalid-macro.patch removed from -mm tree
Date: Thu, 31 May 2012 12:14:39 -0700
Message-ID: <20120531191439.7796BA0203@akpm.mtv.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-vc0-f202.google.com ([209.85.220.202]:54332 "EHLO
	mail-vc0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932870Ab2EaTOl (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 31 May 2012 15:14:41 -0400
Received: by vcbfl13 with SMTP id fl13so134846vcb.1
        for <mm-commits@vger.kernel.org>; Thu, 31 May 2012 12:14:40 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: khlebnikov@openvz.org, geert@linux-m68k.org, hpa@zytor.com, hughd@google.com, torvalds@linux-foundation.org, xiyou.wangcong@gmail.com, mm-commits@vger.kernel.org


The patch titled
     Subject: bug: introduce BUILD_BUG_ON_INVALID() macro
has been removed from the -mm tree.  Its filename was
     bug-introduce-build_bug_on_invalid-macro.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
From: Konstantin Khlebnikov <khlebnikov@openvz.org>
Subject: bug: introduce BUILD_BUG_ON_INVALID() macro

Sometimes we want to check some expressions correctness at compile time. 
"(void)(e);" or "if (e);" can be dangerous if the expression has
side-effects, and gcc sometimes generates a lot of code, even if the
expression has no effect.

This patch introduces macro BUILD_BUG_ON_INVALID() for such checks, it
forces a compilation error if expression is invalid without any extra
code.

[Cast to "long" required because sizeof does not work for bit-fields.]

Signed-off-by: Konstantin Khlebnikov <khlebnikov@openvz.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Geert Uytterhoeven <geert@linux-m68k.org>
Cc: "H. Peter Anvin" <hpa@zytor.com>
Cc: Cong Wang <xiyou.wangcong@gmail.com>
Cc: Hugh Dickins <hughd@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/bug.h |    7 +++++++
 1 file changed, 7 insertions(+)

diff -puN include/linux/bug.h~bug-introduce-build_bug_on_invalid-macro include/linux/bug.h
--- a/include/linux/bug.h~bug-introduce-build_bug_on_invalid-macro
+++ a/include/linux/bug.h
@@ -30,6 +30,13 @@ struct pt_regs;
 #define BUILD_BUG_ON_ZERO(e) (sizeof(struct { int:-!!(e); }))
 #define BUILD_BUG_ON_NULL(e) ((void *)sizeof(struct { int:-!!(e); }))
 
+/*
+ * BUILD_BUG_ON_INVALID() permits the compiler to check the validity of the
+ * expression but avoids the generation of any code, even if that expression
+ * has side-effects.
+ */
+#define BUILD_BUG_ON_INVALID(e) ((void)(sizeof((__force long)(e))))
+
 /**
  * BUILD_BUG_ON - break compile if a condition is true.
  * @condition: the condition which the compiler should know is false.
_

Patches currently in -mm which might be from khlebnikov@openvz.org are

origin.patch
linux-next.patch
mm-correctly-synchronize-rss-counters-at-exit-exec.patch
proc-report-file-anon-bit-in-proc-pid-pagemap.patch
proc-smaps-carefully-handle-migration-entries.patch
proc-smaps-show-amount-of-nonlinear-ptes-in-vma.patch
proc-smaps-show-amount-of-hwpoison-pages.patch
fork-call-complete_vfork_done-after-clearing-child_tid-and-flushing-rss-counters.patch
c-r-prctl-add-ability-to-set-new-mm_struct-exe_file-update-after-mm-num_exe_file_vmas-removal.patch

