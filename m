From: akpm@linux-foundation.org
Subject: + futex-avoid-kernel-taint-caused-by-get_robust_list.patch added to -mm tree
Date: Fri, 15 Feb 2013 14:26:52 -0800
Message-ID: <20130215222653.B8B115A41F0@corp2gmr1-2.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-gh0-f201.google.com ([209.85.160.201]:36939 "EHLO
	mail-gh0-f201.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751666Ab3BOW06 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 15 Feb 2013 17:26:58 -0500
Received: by mail-gh0-f201.google.com with SMTP id z19so337714ghb.0
        for <mm-commits@vger.kernel.org>; Fri, 15 Feb 2013 14:26:58 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: paul.gortmaker@windriver.com, davej@redhat.com, keescook@chromium.org, richard@nod.at, stable@vger.kernel.org, tglx@linutronix.de


The patch titled
     Subject: futex: avoid kernel taint caused by get_robust_list
has been added to the -mm tree.  Its filename is
     futex-avoid-kernel-taint-caused-by-get_robust_list.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Paul Gortmaker <paul.gortmaker@windriver.com>
Subject: futex: avoid kernel taint caused by get_robust_list

Commit ec0c4274e33c0373e4 ("futex: Mark get_robust_list as deprecated")
added these two WARN_ONCE calls.

However, WARN_ONCE taints the kernel, and we shouldn't be allowing any
user who wanders by to do this.  For example, the system fuzzer "trinity"
uses the tainted state as a metric for when to stop, assuming that it has
caused significant wreckage (and indeed that tool is what actually led me
to this change).

The ability to deprecate this code has been called into question[1], but
if that remains to be finalized, then making this change in the interim
seems to make sense.

[1] http://lkml.indiana.edu/hypermail/linux/kernel/1208.0/01081.html

Signed-off-by: Paul Gortmaker <paul.gortmaker@windriver.com>
Cc: Dave Jones <davej@redhat.com>
Cc: Richard Weinberger <richard@nod.at>
Cc: Kees Cook <keescook@chromium.org>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: <stable@vger.kernel.org>	[3.4+]
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/futex.c        |    2 +-
 kernel/futex_compat.c |    2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff -puN kernel/futex.c~futex-avoid-kernel-taint-caused-by-get_robust_list kernel/futex.c
--- a/kernel/futex.c~futex-avoid-kernel-taint-caused-by-get_robust_list
+++ a/kernel/futex.c
@@ -2472,7 +2472,7 @@ SYSCALL_DEFINE3(get_robust_list, int, pi
 	if (!futex_cmpxchg_enabled)
 		return -ENOSYS;
 
-	WARN_ONCE(1, "deprecated: get_robust_list will be deleted in 2013.\n");
+	printk_once(KERN_WARNING "deprecated: get_robust_list will be deleted in 2013.\n");
 
 	rcu_read_lock();
 
diff -puN kernel/futex_compat.c~futex-avoid-kernel-taint-caused-by-get_robust_list kernel/futex_compat.c
--- a/kernel/futex_compat.c~futex-avoid-kernel-taint-caused-by-get_robust_list
+++ a/kernel/futex_compat.c
@@ -143,7 +143,7 @@ COMPAT_SYSCALL_DEFINE3(get_robust_list, 
 	if (!futex_cmpxchg_enabled)
 		return -ENOSYS;
 
-	WARN_ONCE(1, "deprecated: get_robust_list will be deleted in 2013.\n");
+	printk_once(KERN_WARNING "deprecated: get_robust_list will be deleted in 2013.\n");
 
 	rcu_read_lock();
 
_

Patches currently in -mm which might be from paul.gortmaker@windriver.com are

linux-next.patch
compiler-gcc4h-reorder-macros-based-upon-gcc-ver.patch
compiler-gcch-add-gcc-recommended-gcc_version-macro.patch
compiler-gcc34h-use-gcc_version-macro.patch
compiler-gcc4h-bugh-remove-duplicate-macros.patch
bugh-fix-build_bug_on-macro-in-__checker__.patch
bugh-prevent-double-evaulation-of-in-build_bug_on.patch
bugh-make-build_bug_on-generate-compile-time-error.patch
compilerh-bugh-prevent-double-error-messages-with-build_bug_on.patch
bugh-compilerh-introduce-compiletime_assert-build_bug_on_msg.patch
inotify-remove-broken-mask-checks-causing-unmount-to-be-einval.patch
time-dont-inline-export_symbol-functions.patch
dca-convert-to-idr_alloc.patch
futex-avoid-kernel-taint-caused-by-get_robust_list.patch

