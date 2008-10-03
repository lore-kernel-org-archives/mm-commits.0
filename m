From: akpm@linux-foundation.org
Subject: + add-config_core_dump_default_elf_headers.patch added to -mm tree
Date: Thu, 02 Oct 2008 22:55:37 -0700
Message-ID: <200810030555.m935tbrb013339@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:58951 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752398AbYJCF41 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 3 Oct 2008 01:56:27 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: roland@redhat.com, alan@lxorguk.ukuu.org.uk, andi@firstfloor.org, davej@redhat.com, hidehiro.kawai.ez@hitachi.com, kosaki.motohiro@jp.fujitsu.com, mingo@elte.hu, mtk.manpages@googlemail.com, oleg@tv-sign.ru


The patch titled
     add CONFIG_CORE_DUMP_DEFAULT_ELF_HEADERS
has been added to the -mm tree.  Its filename is
     add-config_core_dump_default_elf_headers.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://userweb.kernel.org/~akpm/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: add CONFIG_CORE_DUMP_DEFAULT_ELF_HEADERS
From: Roland McGrath <roland@redhat.com>

This adds a kconfig option to change the /proc/PID/coredump_filter default.
Fedora has been carrying a trivial patch to change the hard-wired value for
this default, since Fedora 8.  The default default can't change safely
because there are old GDB versions out there (all before 6.7) that are
confused by the core dump files created by the MMF_DUMP_ELF_HEADERS setting.

Signed-off-by: Roland McGrath <roland@redhat.com>
Cc: Michael Kerrisk <mtk.manpages@googlemail.com>
Cc: Oleg Nesterov <oleg@tv-sign.ru>
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: Andi Kleen <andi@firstfloor.org>
Cc: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Cc: Kawai Hidehiro <hidehiro.kawai.ez@hitachi.com>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: David Jones <davej@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/Kconfig.binfmt     |   22 ++++++++++++++++++++++
 include/linux/sched.h |    8 +++++++-
 2 files changed, 29 insertions(+), 1 deletion(-)

diff -puN fs/Kconfig.binfmt~add-config_core_dump_default_elf_headers fs/Kconfig.binfmt
--- a/fs/Kconfig.binfmt~add-config_core_dump_default_elf_headers
+++ a/fs/Kconfig.binfmt
@@ -40,6 +40,28 @@ config BINFMT_ELF_FDPIC
 
 	  It is also possible to run FDPIC ELF binaries on MMU linux also.
 
+config CORE_DUMP_DEFAULT_ELF_HEADERS
+	bool "Write ELF core dumps with partial segments"
+	default n
+	depends on BINFMT_ELF
+	help
+	  ELF core dump files describe each memory mapping of the crashed
+	  process, and can contain or omit the memory contents of each one.
+	  The contents of an unmodified text mapping are omitted by default.
+
+	  For an unmodified text mapping of an ELF object, including just
+	  the first page of the file in a core dump makes it possible to
+	  identify the build ID bits in the file, without paying the i/o
+	  cost and disk space to dump all the text.  However, versions of
+	  GDB before 6.7 are confused by ELF core dump files in this format.
+
+	  The core dump behavior can be controlled per process using
+	  the /proc/PID/coredump_filter pseudo-file; this setting is
+	  inherited.  See Documentation/filesystems/proc.txt for details.
+
+	  This config option changes the default setting of coredump_filter
+	  seen at boot time.  If unsure, say N.
+
 config BINFMT_FLAT
 	bool "Kernel support for flat binaries"
 	depends on !MMU && (!FRV || BROKEN)
diff -puN include/linux/sched.h~add-config_core_dump_default_elf_headers include/linux/sched.h
--- a/include/linux/sched.h~add-config_core_dump_default_elf_headers
+++ a/include/linux/sched.h
@@ -411,7 +411,13 @@ extern int get_dumpable(struct mm_struct
 	(((1 << MMF_DUMP_FILTER_BITS) - 1) << MMF_DUMP_FILTER_SHIFT)
 #define MMF_DUMP_FILTER_DEFAULT \
 	((1 << MMF_DUMP_ANON_PRIVATE) |	(1 << MMF_DUMP_ANON_SHARED) |\
-	 (1 << MMF_DUMP_HUGETLB_PRIVATE))
+	 (1 << MMF_DUMP_HUGETLB_PRIVATE) | MMF_DUMP_MASK_DEFAULT_ELF)
+
+#ifdef CONFIG_CORE_DUMP_DEFAULT_ELF_HEADERS
+# define MMF_DUMP_MASK_DEFAULT_ELF	(1 << MMF_DUMP_ELF_HEADERS)
+#else
+# define MMF_DUMP_MASK_DEFAULT_ELF	0
+#endif
 
 struct sighand_struct {
 	atomic_t		count;
_

Patches currently in -mm which might be from roland@redhat.com are

git-x86.patch
posix-timers-dont-switch-to-group_leader-if-it_process-dies.patch
posix-timers-always-do-get_task_structtimer-it_process.patch
posix-timers-sys_timer_create-remove-the-buggy-pf_exiting-check.patch
posix-timers-sys_timer_create-simplify-and-s-tasklist-rcu.patch
posix-timers-move-the-initialization-of-timer-sigq-from-send-to-create-path.patch
posix-timers-sys_timer_create-cleanup-the-error-handling.patch
posix-timers-kill-it_sigev_signo-and-it_sigev_value.patch
posix-timers-lock_timer-kill-the-bogus-it_id-check.patch
posix-timers-lock_timer-make-it-readable.patch
posix-timers-use-struct-pid-instead-of-struct-task_struct.patch
posix-timers-check-it_signal-instead-of-it_pid-to-validate-the-timer.patch
posix-timers-simplify-de_thread-exit_itimers-path.patch
make-ptrace_untrace-static.patch
coredump-format_corename-dont-append-%pid-if-multi-threaded.patch
add-config_core_dump_default_elf_headers.patch
kthread_bind-use-wait_task_inactivetask_uninterruptible.patch

