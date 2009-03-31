From: akpm@linux-foundation.org
Subject: + x86-hookup-sys_rt_tgsigqueueinfo.patch added to -mm tree
Date: Tue, 31 Mar 2009 16:42:05 -0700
Message-ID: <200903312342.n2VNg5Vq012229@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:43669 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756346AbZCaXrI (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 31 Mar 2009 19:47:08 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: tglx@linutronix.de, drepper@redhat.com, linux-abi@vger.kernel.org, linux-arch@vger.kernel.org, oleg@redhat.com, roland@redhat.com


The patch titled
     x86: hook up sys_rt_tgsigqueueinfo
has been added to the -mm tree.  Its filename is
     x86-hookup-sys_rt_tgsigqueueinfo.patch

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
Subject: x86: hook up sys_rt_tgsigqueueinfo
From: Thomas Gleixner <tglx@linutronix.de>

Make the new sys_rt_tgsigqueueinfo available for x86.

Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Reviewed-by: Oleg Nesterov <oleg@redhat.com>
Cc: Roland McGrath <roland@redhat.com>
Cc: Ulrich Drepper <drepper@redhat.com>
Cc: <linux-abi@vger.kernel.org>
Cc: <linux-arch@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/x86/ia32/ia32entry.S          |    1 +
 arch/x86/include/asm/unistd_32.h   |    1 +
 arch/x86/include/asm/unistd_64.h   |    2 ++
 arch/x86/kernel/syscall_table_32.S |    1 +
 4 files changed, 5 insertions(+)

diff -puN arch/x86/ia32/ia32entry.S~x86-hookup-sys_rt_tgsigqueueinfo arch/x86/ia32/ia32entry.S
--- a/arch/x86/ia32/ia32entry.S~x86-hookup-sys_rt_tgsigqueueinfo
+++ a/arch/x86/ia32/ia32entry.S
@@ -828,4 +828,5 @@ ia32_sys_call_table:
 	.quad sys_dup3			/* 330 */
 	.quad sys_pipe2
 	.quad sys_inotify_init1
+	.quad compat_sys_rt_tgsigqueueinfo
 ia32_syscall_end:
diff -puN arch/x86/include/asm/unistd_32.h~x86-hookup-sys_rt_tgsigqueueinfo arch/x86/include/asm/unistd_32.h
--- a/arch/x86/include/asm/unistd_32.h~x86-hookup-sys_rt_tgsigqueueinfo
+++ a/arch/x86/include/asm/unistd_32.h
@@ -338,6 +338,7 @@
 #define __NR_dup3		330
 #define __NR_pipe2		331
 #define __NR_inotify_init1	332
+#define __NR_rt_tgsigqueueinfo	333
 
 #ifdef __KERNEL__
 
diff -puN arch/x86/include/asm/unistd_64.h~x86-hookup-sys_rt_tgsigqueueinfo arch/x86/include/asm/unistd_64.h
--- a/arch/x86/include/asm/unistd_64.h~x86-hookup-sys_rt_tgsigqueueinfo
+++ a/arch/x86/include/asm/unistd_64.h
@@ -653,6 +653,8 @@ __SYSCALL(__NR_dup3, sys_dup3)
 __SYSCALL(__NR_pipe2, sys_pipe2)
 #define __NR_inotify_init1			294
 __SYSCALL(__NR_inotify_init1, sys_inotify_init1)
+#define __NR_rt_tgsigqueueinfo			295
+__SYSCALL(__NR_rt_tgsigqueueinfo, sys_rt_tgsigqueueinfo)
 
 
 #ifndef __NO_STUBS
diff -puN arch/x86/kernel/syscall_table_32.S~x86-hookup-sys_rt_tgsigqueueinfo arch/x86/kernel/syscall_table_32.S
--- a/arch/x86/kernel/syscall_table_32.S~x86-hookup-sys_rt_tgsigqueueinfo
+++ a/arch/x86/kernel/syscall_table_32.S
@@ -332,3 +332,4 @@ ENTRY(sys_call_table)
 	.long sys_dup3			/* 330 */
 	.long sys_pipe2
 	.long sys_inotify_init1
+	.long sys_rt_tgsigqueueinfo
_

Patches currently in -mm which might be from tglx@linutronix.de are

origin.patch
introduce-debug_kmap_atomic.patch
use-debug_kmap_atomic.patch
linux-next.patch
thinkpad-acpi-split-delayed-leds-stuff-clean-up-code.patch
x86-simplify-highmem-related-kconfig-entries.patch
clocksource-pass-clocksource-to-read-callback.patch
clocksource-add-enable-and-disable-callbacks.patch
clocksource-sanity-check-sysfs-clocksource-changes.patch
kernel-time-tick-broadcastc-tick_broadcast_device-can-become-static.patch
scsi-mpt-suppress-debugobjects-warning.patch
signals-remove-handler-parameter-to-tracehook-functions.patch
signals-split-do_tkill.patch
signals-implement-sys_rt_tgsigqueueinfo.patch
x86-hookup-sys_rt_tgsigqueueinfo.patch
sgi-gru-exclude-uv-definitions-on-32-bit-x86.patch
sgi-gru-add-definitions-of-x86_64-gru-mmrs.patch
sgi-gru-add-macros-for-using-the-uv-hub-to-send-interrupts.patch
preadv-pwritev-add-preadv-and-pwritev-system-calls.patch

