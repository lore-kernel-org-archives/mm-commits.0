From: akpm@linux-foundation.org
Subject: - tracehook-config_have_arch_tracehook.patch removed from -mm tree
Date: Sat, 26 Jul 2008 15:04:37 -0700
Message-ID: <200807262204.m6QM4b3T021681@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:58346 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755518AbYGZWFT (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Sat, 26 Jul 2008 18:05:19 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: roland@redhat.com, mingo@elte.hu, oleg@tv-sign.ru, mm-commits@vger.kernel.org


The patch titled
     tracehook: CONFIG_HAVE_ARCH_TRACEHOOK
has been removed from the -mm tree.  Its filename was
     tracehook-config_have_arch_tracehook.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: tracehook: CONFIG_HAVE_ARCH_TRACEHOOK
From: Roland McGrath <roland@redhat.com>

This adds the generic HAVE_ARCH_TRACEHOOK kconfig item.  Each arch should
add to some Kconfig file:

	select HAVE_ARCH_TRACEHOOK

if the arch code uses all the latest hooks to enable newfangled tracing
and debugging code.  The comment in arch/Kconfig lists all the
prerequisite arch support.  When all these are available, setting
HAVE_ARCH_TRACEHOOK will allow enabling any new features that depend on
the modern arch interfaces.

Signed-off-by: Roland McGrath <roland@redhat.com>
Cc: Oleg Nesterov <oleg@tv-sign.ru>
Reviewed-by: Ingo Molnar <mingo@elte.hu>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/Kconfig |   18 ++++++++++++++++++
 1 file changed, 18 insertions(+)

diff -puN arch/Kconfig~tracehook-config_have_arch_tracehook arch/Kconfig
--- a/arch/Kconfig~tracehook-config_have_arch_tracehook
+++ a/arch/Kconfig
@@ -59,6 +59,24 @@ config HAVE_KPROBES
 config HAVE_KRETPROBES
 	def_bool n
 
+#
+# An arch should select this if it provides all these things:
+#
+#	task_pt_regs()		in asm/processor.h or asm/ptrace.h
+#	arch_has_single_step()	if there is hardware single-step support
+#	arch_has_block_step()	if there is hardware block-step support
+#	arch_ptrace()		and not #define __ARCH_SYS_PTRACE
+#	compat_arch_ptrace()	and #define __ARCH_WANT_COMPAT_SYS_PTRACE
+#	asm/syscall.h		supplying asm-generic/syscall.h interface
+#	linux/regset.h		user_regset interfaces
+#	CORE_DUMP_USE_REGSET	#define'd in linux/elf.h
+#	TIF_SYSCALL_TRACE	calls tracehook_report_syscall_{entry,exit}
+#	TIF_NOTIFY_RESUME	calls tracehook_notify_resume()
+#	signal delivery		calls tracehook_signal_handler()
+#
+config HAVE_ARCH_TRACEHOOK
+	def_bool n
+
 config HAVE_DMA_ATTRS
 	def_bool n
 
_

Patches currently in -mm which might be from roland@redhat.com are

origin.patch
tracehook-config_have_arch_tracehook.patch
x86-tracehook_signal_handler.patch
x86-tracehook-syscall.patch
x86-tracehook-asm-syscallh.patch
x86-signals-use-asm-syscallh.patch
x86-tracehook-tif_notify_resume.patch
x86-tracehook-config_have_arch_tracehook.patch

