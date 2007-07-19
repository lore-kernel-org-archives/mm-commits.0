From: akpm@linux-foundation.org
Subject: - x86_64-untangle-asm-hpeth-from-asm-timexh.patch removed from -mm tree
Date: Thu, 19 Jul 2007 13:10:41 -0700
Message-ID: <200707192010.l6JKAf62020695@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:37671 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932095AbXGSUTS (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 19 Jul 2007 16:19:18 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: chrisw@sous-sol.org, ak@suse.de, johnstul@us.ibm.com, mingo@elte.hu, tglx@linutronix.de, mm-commits@vger.kernel.org


The patch titled
     x86_64: untangle asm/hpet.h from asm/timex.h
has been removed from the -mm tree.  Its filename was
     x86_64-untangle-asm-hpeth-from-asm-timexh.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: x86_64: untangle asm/hpet.h from asm/timex.h
From: Chris Wright <chrisw@sous-sol.org>

When making changes to x86_64 timers, I noticed that touching hpet.h triggered
an unreasonably large rebuild.  Untangling it from timex.h quiets the extra
rebuild quite a bit.

Signed-off-by: Chris Wright <chrisw@sous-sol.org>
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Cc: john stultz <johnstul@us.ibm.com>
Cc: Andi Kleen <ak@suse.de>
Cc: Ingo Molnar <mingo@elte.hu>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/char/rtc.c         |    2 +-
 include/asm-x86_64/apic.h  |    2 ++
 include/asm-x86_64/hpet.h  |    1 -
 include/asm-x86_64/timex.h |    1 -
 4 files changed, 3 insertions(+), 3 deletions(-)

diff -puN drivers/char/rtc.c~x86_64-untangle-asm-hpeth-from-asm-timexh drivers/char/rtc.c
--- a/drivers/char/rtc.c~x86_64-untangle-asm-hpeth-from-asm-timexh
+++ a/drivers/char/rtc.c
@@ -82,7 +82,7 @@
 #include <asm/uaccess.h>
 #include <asm/system.h>
 
-#if defined(__i386__)
+#ifdef CONFIG_X86
 #include <asm/hpet.h>
 #endif
 
diff -puN include/asm-x86_64/apic.h~x86_64-untangle-asm-hpeth-from-asm-timexh include/asm-x86_64/apic.h
--- a/include/asm-x86_64/apic.h~x86_64-untangle-asm-hpeth-from-asm-timexh
+++ a/include/asm-x86_64/apic.h
@@ -86,6 +86,8 @@ extern void setup_apic_routing(void);
 extern void setup_APIC_extened_lvt(unsigned char lvt_off, unsigned char vector,
 				   unsigned char msg_type, unsigned char mask);
 
+extern int apic_is_clustered_box(void);
+
 #define K8_APIC_EXT_LVT_BASE    0x500
 #define K8_APIC_EXT_INT_MSG_FIX 0x0
 #define K8_APIC_EXT_INT_MSG_SMI 0x2
diff -puN include/asm-x86_64/hpet.h~x86_64-untangle-asm-hpeth-from-asm-timexh include/asm-x86_64/hpet.h
--- a/include/asm-x86_64/hpet.h~x86_64-untangle-asm-hpeth-from-asm-timexh
+++ a/include/asm-x86_64/hpet.h
@@ -55,7 +55,6 @@
 
 extern int is_hpet_enabled(void);
 extern int hpet_rtc_timer_init(void);
-extern int apic_is_clustered_box(void);
 extern int hpet_arch_init(void);
 extern int hpet_timer_stop_set_go(unsigned long tick);
 extern int hpet_reenable(void);
diff -puN include/asm-x86_64/timex.h~x86_64-untangle-asm-hpeth-from-asm-timexh include/asm-x86_64/timex.h
--- a/include/asm-x86_64/timex.h~x86_64-untangle-asm-hpeth-from-asm-timexh
+++ a/include/asm-x86_64/timex.h
@@ -9,7 +9,6 @@
 #include <asm/8253pit.h>
 #include <asm/msr.h>
 #include <asm/vsyscall.h>
-#include <asm/hpet.h>
 #include <asm/system.h>
 #include <asm/processor.h>
 #include <asm/tsc.h>
_

Patches currently in -mm which might be from chrisw@sous-sol.org are

origin.patch
ntp-move-the-cmos-update-code-into-ntpc.patch
x86_64-restore-restore-nohpet-cmdline.patch
x86_64-prep-idle-loop-for-dynticks.patch
x86_64-enable-high-resolution-timers-and-dynticks.patch
security-convert-lsm-into-a-static-interface.patch
security-convert-lsm-into-a-static-interface-fix.patch
implement-file-posix-capabilities.patch
implement-file-posix-capabilities-fix.patch
file-capabilities-introduce-cap_setfcap.patch
file-capabilities-get_file_caps-cleanups.patch
file-caps-update-selinux-xattr-hooks.patch
file-capabilities-clear-caps-cleanup.patch
file-capabilities-clear-caps-cleanup-fix.patch
file-capabilities-change-xattr-format-v2.patch
file-capabilities-change-fe-to-a-bool.patch
