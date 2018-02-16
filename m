From: akpm@linux-foundation.org
Subject: + taint-consolidate-documentation.patch added to -mm tree
Date: Fri, 16 Feb 2018 13:03:35 -0800
Message-ID: <5a874727.VCY+7rswv5Yg+Pv7%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:57110 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750730AbeBPVDg (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 16 Feb 2018 16:03:36 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: keescook@chromium.org, adobriyan@gmail.com, akpm@linux-foundation.org, corbet@lwn.net, rdunlap@infradead.org, viro@zeniv.linux.org.uk, mm-commits@vger.kernel.org


The patch titled
     Subject: taint: consolidate documentation
has been added to the -mm tree.  Its filename is
     taint-consolidate-documentation.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/taint-consolidate-documentation.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/taint-consolidate-documentation.patch

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
Subject: taint: consolidate documentation

This consolidates the taint bit documentation into a single place with
both numeric and letter values.  Additionally adds the missing TAINT_AUX
documentation.

Link: http://lkml.kernel.org/r/1518752264-47238-3-git-send-email-keescook@chromium.org
Signed-off-by: Kees Cook <keescook@chromium.org>
Reviewed-by: Andrew Morton <akpm@linux-foundation.org>
Cc: Alexey Dobriyan <adobriyan@gmail.com>
Cc: Al Viro <viro@zeniv.linux.org.uk>
Cc: Jonathan Corbet <corbet@lwn.net>
Cc: Randy Dunlap <rdunlap@infradead.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/sysctl/kernel.txt |   51 +++++++++++++++---------------
 kernel/panic.c                  |   23 ++-----------
 2 files changed, 30 insertions(+), 44 deletions(-)

diff -puN Documentation/sysctl/kernel.txt~taint-consolidate-documentation Documentation/sysctl/kernel.txt
--- a/Documentation/sysctl/kernel.txt~taint-consolidate-documentation
+++ a/Documentation/sysctl/kernel.txt
@@ -964,32 +964,33 @@ detect a hard lockup condition.
 
 tainted:
 
-Non-zero if the kernel has been tainted.  Numeric values, which
-can be ORed together:
+Non-zero if the kernel has been tainted. Numeric values, which can be
+ORed together. The letters are seen in "Tainted" line of Oops reports.
 
-   1 - A module with a non-GPL license has been loaded, this
-       includes modules with no license.
-       Set by modutils >= 2.4.9 and module-init-tools.
-   2 - A module was force loaded by insmod -f.
-       Set by modutils >= 2.4.9 and module-init-tools.
-   4 - Unsafe SMP processors: SMP with CPUs not designed for SMP.
-   8 - A module was forcibly unloaded from the system by rmmod -f.
-  16 - A hardware machine check error occurred on the system.
-  32 - A bad page was discovered on the system.
-  64 - The user has asked that the system be marked "tainted".  This
-       could be because they are running software that directly modifies
-       the hardware, or for other reasons.
- 128 - The system has died.
- 256 - The ACPI DSDT has been overridden with one supplied by the user
-        instead of using the one provided by the hardware.
- 512 - A kernel warning has occurred.
-1024 - A module from drivers/staging was loaded.
-2048 - The system is working around a severe firmware bug.
-4096 - An out-of-tree module has been loaded.
-8192 - An unsigned module has been loaded in a kernel supporting module
-       signature.
-16384 - A soft lockup has previously occurred on the system.
-32768 - The kernel has been live patched.
+     1 (P):  A module with a non-GPL license has been loaded, this
+             includes modules with no license.
+             Set by modutils >= 2.4.9 and module-init-tools.
+     2 (F): A module was force loaded by insmod -f.
+            Set by modutils >= 2.4.9 and module-init-tools.
+     4 (S): Unsafe SMP processors: SMP with CPUs not designed for SMP.
+     8 (R): A module was forcibly unloaded from the system by rmmod -f.
+    16 (M): A hardware machine check error occurred on the system.
+    32 (B): A bad page was discovered on the system.
+    64 (U): The user has asked that the system be marked "tainted". This
+            could be because they are running software that directly modifies
+            the hardware, or for other reasons.
+   128 (D): The system has died.
+   256 (A): The ACPI DSDT has been overridden with one supplied by the user
+            instead of using the one provided by the hardware.
+   512 (W): A kernel warning has occurred.
+  1024 (C): A module from drivers/staging was loaded.
+  2048 (I): The system is working around a severe firmware bug.
+  4096 (O): An out-of-tree module has been loaded.
+  8192 (E): An unsigned module has been loaded in a kernel supporting module
+            signature.
+ 16384 (L): A soft lockup has previously occurred on the system.
+ 32768 (K): The kernel has been live patched.
+ 65536 (X): Auxiliary taint, defined and used by for distros.
 
 ==============================================================
 
diff -puN kernel/panic.c~taint-consolidate-documentation kernel/panic.c
--- a/kernel/panic.c~taint-consolidate-documentation
+++ a/kernel/panic.c
@@ -328,27 +328,12 @@ const struct taint_flag taint_flags[TAIN
 };
 
 /**
- *	print_tainted - return a string to represent the kernel taint state.
+ * print_tainted - return a string to represent the kernel taint state.
  *
- *  'P' - Proprietary module has been loaded.
- *  'F' - Module has been forcibly loaded.
- *  'S' - SMP with CPUs not designed for SMP.
- *  'R' - User forced a module unload.
- *  'M' - System experienced a machine check exception.
- *  'B' - System has hit bad_page.
- *  'U' - Userspace-defined naughtiness.
- *  'D' - Kernel has oopsed before
- *  'A' - ACPI table overridden.
- *  'W' - Taint on warning.
- *  'C' - modules from drivers/staging are loaded.
- *  'I' - Working around severe firmware bug.
- *  'O' - Out-of-tree module has been loaded.
- *  'E' - Unsigned module has been loaded.
- *  'L' - A soft lockup has previously occurred.
- *  'K' - Kernel has been live patched.
- *  'X' - Auxiliary taint, for distros' use.
+ * For individual taint flag meanings, see Documentation/sysctl/kernel.txt
  *
- *	The string is overwritten by the next call to print_tainted().
+ * The string is overwritten by the next call to print_tainted(),
+ * but is always NULL terminated.
  */
 const char *print_tainted(void)
 {
_

Patches currently in -mm which might be from keescook@chromium.org are

taint-convert-to-enum-and-indexed-initialization.patch
taint-consolidate-documentation.patch
taint-add-taint-for-randstruct.patch
exec-pass-stack-rlimit-into-mm-layout-functions.patch
exec-introduce-finalize_exec-before-start_thread.patch
exec-pin-stack-limit-during-exec.patch

