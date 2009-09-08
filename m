From: akpm@linux-foundation.org
Subject: + kconfig-cross_compile-option.patch added to -mm tree
Date: Tue, 08 Sep 2009 16:06:52 -0700
Message-ID: <200909082306.n88N6qnL007243@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:39824 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752553AbZIHXH3 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 8 Sep 2009 19:07:29 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: roland@redhat.com, sam@ravnborg.org


The patch titled
     kconfig CROSS_COMPILE option
has been added to the -mm tree.  Its filename is
     kconfig-cross_compile-option.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://userweb.kernel.org/~akpm/stuff/added-to-mm.txt to find
out what to do about this

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
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Makefile     |    4 +++-
 init/Kconfig |    8 ++++++++
 2 files changed, 11 insertions(+), 1 deletion(-)

diff -puN Makefile~kconfig-cross_compile-option Makefile
--- a/Makefile~kconfig-cross_compile-option
+++ a/Makefile
@@ -177,11 +177,13 @@ SUBARCH := $(shell uname -m | sed -e s/i
 # CROSS_COMPILE can be set on the command line
 # make CROSS_COMPILE=ia64-linux-
 # Alternatively CROSS_COMPILE can be set in the environment.
+# A third alternative is to store a setting in .config so that plain
+# "make" in the configured kernel build directory always uses that.
 # Default value for CROSS_COMPILE is not to prefix executables
 # Note: Some architectures assign CROSS_COMPILE in their arch/*/Makefile
 export KBUILD_BUILDHOST := $(SUBARCH)
 ARCH		?= $(SUBARCH)
-CROSS_COMPILE	?=
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
kconfig-cross_compile-option.patch
proc_flush_task-flush-proc-tid-task-pid-when-a-sub-thread-exits.patch
ptrace-__ptrace_detach-do-__wake_up_parent-if-we-reap-the-tracee.patch
do_wait-wakeup-optimization-shift-security_task_wait-from-eligible_child-to-wait_consider_task.patch
do_wait-wakeup-optimization-change-__wake_up_parent-to-use-filtered-wakeup.patch
do_wait-wakeup-optimization-change-__wake_up_parent-to-use-filtered-wakeup-selinux_bprm_committed_creds-use-__wake_up_parent.patch
do_wait-wakeup-optimization-child_wait_callback-check-__wnothread-case.patch
do_wait-wakeup-optimization-fix-child_wait_callback-eligible_child-usage.patch
do_wait-wakeup-optimization-simplify-task_pid_type.patch
do_wait-optimization-do-not-place-sub-threads-on-task_struct-children-list.patch
wait_consider_task-kill-parent-argument.patch
do_wait-fix-sys_waitid-specific-behaviour.patch
wait_noreap_copyout-check-for-wo_info-=-null.patch
signals-introduce-do_send_sig_info-helper.patch
signals-send_sigio-use-do_send_sig_info-to-avoid-check_kill_permission.patch
fcntl-add-f_etown_ex.patch
signals-inline-__fatal_signal_pending.patch
signals-tracehook_notify_jctl-change.patch
signals-tracehook_notify_jctl-change-do_signal_stop-do-not-call-tracehook_notify_jctl-in-task_stopped-state.patch
signals-introduce-tracehook_finish_jctl-helper.patch
utrace-core.patch
exec-fix-set_binfmt-vs-sys_delete_module-race.patch
elf-clean-up-fill_note_info.patch
elf-clean-up-fill_note_info-fix.patch
fork-disable-clone_parent-for-init.patch
pidns-deny-clone_parentclone_newpid-combination.patch
task_struct-cleanup-move-binfmt-field-to-mm_struct.patch

