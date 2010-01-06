From: akpm@linux-foundation.org
Subject: [merged] kconfig-cross_compile-option.patch removed from -mm tree
Date: Wed, 06 Jan 2010 13:33:47 -0800
Message-ID: <201001062133.o06LXlQr019143@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:59608 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753178Ab0AFVeZ (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 6 Jan 2010 16:34:25 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: roland@redhat.com, anibal@debian.org, mmarek@suse.cz, rostedt@goodmis.org, sam@ravnborg.org, mm-commits@vger.kernel.org


The patch titled
     kconfig CROSS_COMPILE option
has been removed from the -mm tree.  Its filename was
     kconfig-cross_compile-option.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: kconfig CROSS_COMPILE option
From: Roland McGrath <roland@redhat.com>

This adds CROSS_COMPILE as a kconfig string so you can store it in
.config.  Then you can use plain "make" in the configured kernel build
directory to do the right cross compilation without setting the
command-line or environment variable every time.

With this, you can set up different build directories for different kernel
configurations, whether native or cross-builds, and then use the simple:

	make -C /build/dir M=module-source-dir

idiom to build modules for any given target kernel, indicating which one
by nothing but the build directory chosen.

I tried a version that defaults the string with env="CROSS_COMPILE" so
that in a "make oldconfig" with CROSS_COMPILE in the environment you can
just hit return to store the way you're building it.  But the kconfig
prompt for strings doesn't give you any way to say you want an empty
string instead of the default, so I punted that.

Signed-off-by: Roland McGrath <roland@redhat.com>
Cc: Sam Ravnborg <sam@ravnborg.org>
Cc: Anibal Monsalve Salazar <anibal@debian.org>
Cc: Steven Rostedt <rostedt@goodmis.org>
Cc: Michal Marek <mmarek@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Makefile     |    3 +++
 init/Kconfig |    8 ++++++++
 2 files changed, 11 insertions(+)

diff -puN Makefile~kconfig-cross_compile-option Makefile
--- a/Makefile~kconfig-cross_compile-option
+++ a/Makefile
@@ -184,11 +184,14 @@ SUBARCH := $(shell uname -m | sed -e s/i
 # CROSS_COMPILE can be set on the command line
 # make CROSS_COMPILE=ia64-linux-
 # Alternatively CROSS_COMPILE can be set in the environment.
+# A third alternative is to store a setting in .config so that plain
+# "make" in the configured kernel build directory always uses that.
 # Default value for CROSS_COMPILE is not to prefix executables
 # Note: Some architectures assign CROSS_COMPILE in their arch/*/Makefile
 export KBUILD_BUILDHOST := $(SUBARCH)
 ARCH		?= $(SUBARCH)
 CROSS_COMPILE	?=
+CROSS_COMPILE	?= $(CONFIG_CROSS_COMPILE:"%"=%)
 
 # Architecture as present in compile.h
 UTS_MACHINE 	:= $(ARCH)
diff -puN init/Kconfig~kconfig-cross_compile-option init/Kconfig
--- a/init/Kconfig~kconfig-cross_compile-option
+++ a/init/Kconfig
@@ -76,6 +76,14 @@ config INIT_ENV_ARG_LIMIT
 	  variables passed to init from the kernel command line.
 
 
+config CROSS_COMPILE
+	string "Cross-compiler tool prefix"
+	help
+	  Same as running 'make CROSS_COMPILE=prefix-' but stored for
+	  default make runs in this kernel build directory.  You don't
+	  need to set this unless you want the configured kernel build
+	  directory to select the cross-compiler automatically.
+
 config LOCALVERSION
 	string "Local version - append to kernel release"
 	help
_

Patches currently in -mm which might be from roland@redhat.com are

linux-next.patch
mm-pass-mm-flags-as-a-coredump-parameter-for-consistency.patch
tracehooks-kill-some-pt_ptraced-checks.patch
tracehooks-check-pt_ptraced-before-reporting-the-single-step.patch
ptrace_signal-check-pt_ptraced-before-reporting-a-signal.patch
export-__ptrace_detach-and-do_notify_parent_cldstop.patch
reorder-the-code-in-kernel-ptracec.patch
implement-utrace-ptrace.patch
utrace-core.patch
copy_signal-cleanup-use-zalloc-and-remove-initializations.patch
copy_signal-cleanup-kill-taskstats_tgid_init-and-acct_init_pacct.patch
copy_signal-cleanup-clean-thread_group_cputime_init.patch
copy_signal-cleanup-clean-tty_audit_fork.patch

