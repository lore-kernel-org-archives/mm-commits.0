From: akpm@linux-foundation.org
Subject: + kcmp-make-it-depend-on-checkpoint_restore.patch added to -mm tree
Date: Tue, 19 Feb 2013 15:04:42 -0800
Message-ID: <20130219230443.1EE9E31C03C@corp2gmr1-1.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-ye0-f201.google.com ([209.85.213.201]:46373 "EHLO
	mail-ye0-f201.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932846Ab3BSXEo (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 19 Feb 2013 18:04:44 -0500
Received: by mail-ye0-f201.google.com with SMTP id r11so734992yen.0
        for <mm-commits@vger.kernel.org>; Tue, 19 Feb 2013 15:04:43 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: gorcunov@openvz.org, avagin@openvz.org, hpa@zytor.com, xemul@parallels.com


The patch titled
     Subject: kcmp: make it depend on CHECKPOINT_RESTORE
has been added to the -mm tree.  Its filename is
     kcmp-make-it-depend-on-checkpoint_restore.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Cyrill Gorcunov <gorcunov@openvz.org>
Subject: kcmp: make it depend on CHECKPOINT_RESTORE

Since kcmp syscall has been implemented (initially on x86 architecture) a
number of other archs wire it up as well: xtensa, sparc, sh, s390, mips,
microblaze, m68k (not taking into account those who uses
<asm-generic/unistd.h> for syscall numbers definitions).

But the Makefile, which turns kcmp.o generation on still depends on former
config-x86.  Thus get rid of this limitation and make kcmp.o depend on
CHECKPOINT_RESTORE option.

Signed-off-by: Cyrill Gorcunov <gorcunov@openvz.org>
Cc: Pavel Emelyanov <xemul@parallels.com>
Cc: Andrey Vagin <avagin@openvz.org>
Cc: "H. Peter Anvin" <hpa@zytor.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/Makefile |    4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

diff -puN kernel/Makefile~kcmp-make-it-depend-on-checkpoint_restore kernel/Makefile
--- a/kernel/Makefile~kcmp-make-it-depend-on-checkpoint_restore
+++ a/kernel/Makefile
@@ -25,9 +25,7 @@ endif
 obj-y += sched/
 obj-y += power/
 
-ifeq ($(CONFIG_CHECKPOINT_RESTORE),y)
-obj-$(CONFIG_X86) += kcmp.o
-endif
+obj-$(CONFIG_CHECKPOINT_RESTORE) += kcmp.o
 obj-$(CONFIG_FREEZER) += freezer.o
 obj-$(CONFIG_PROFILING) += profile.o
 obj-$(CONFIG_STACKTRACE) += stacktrace.o
_

Patches currently in -mm which might be from gorcunov@openvz.org are

linux-next.patch
signal-allow-to-send-any-siginfo-to-itself.patch
seq-file-use-seek_-macros-instead-of-hardcoded-numbers.patch
fs-seq_filec-seq_lseek-fix-switch-statement-indenting.patch
fs-seq_filec-seq_lseek-fix-switch-statement-indenting-checkpatch-fixes.patch
kcmp-make-it-depend-on-checkpoint_restore.patch

