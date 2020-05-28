From: Andrew Morton <akpm@linux-foundation.org>
Subject: [alternative-merged]
 twist-allow-disabling-k_spec-function-in-drivers-tty-vt-keyboardc.patch
 removed from -mm tree
Date: Thu, 28 May 2020 12:11:55 -0700
Message-ID: <20200528191155.ozuzs6NL1%akpm@linux-foundation.org>
References: <20200527222015.62ba8592af63dae12ab58ffe@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:45308 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2406165AbgE1TL5 (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Thu, 28 May 2020 15:11:57 -0400
In-Reply-To: <20200527222015.62ba8592af63dae12ab58ffe@linux-foundation.org>
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: ak@linux.intel.com, arnd@arndb.de, dvyukov@google.com, gregkh@linuxfoundation.org, jslaby@suse.com, mjg59@google.com, mm-commits@vger.kernel.org, penguin-kernel@I-love.SAKURA.ne.jp, peterz@infradead.org, pmladek@suse.com, rostedt@goodmis.org, sergey.senozhatsky@gmail.com, tytso@mit.edu, viro@zeniv.linux.org.uk


The patch titled
     Subject: twist: allow disabling k_spec() function in drivers/tty/vt/keyboard.c
has been removed from the -mm tree.  Its filename was
     twist-allow-disabling-k_spec-function-in-drivers-tty-vt-keyboardc.patch

This patch was dropped because an alternative patch was merged

------------------------------------------------------
From: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
Subject: twist: allow disabling k_spec() function in drivers/tty/vt/keyboard.c

syzbot is reporting unexpected kernel reboots [1].  This seems to be
caused by triggering Ctrl-Alt-Del event via k_spec() function in
drivers/tty/vt/keyboard.c file, for the console output includes normal
restart sequence.

  [   97.727327][    T1] systemd-shutdown[1]: Unmounting file systems.
  [   97.734278][    T1] systemd-shutdown[1]: Remounting '/' read-only with options ''.
  [   97.747758][   T21] usb 2-1: device descriptor read/8, error -71
  [   97.747850][ T3116] usb 1-1: device descriptor read/8, error -71
  [   97.764818][    T1] EXT4-fs (sda1): re-mounted. Opts:
  [   97.777551][    T1] systemd-shutdown[1]: Remounting '/' read-only with options ''.
  [   97.785448][    T1] EXT4-fs (sda1): re-mounted. Opts:
  [   97.790920][    T1] systemd-shutdown[1]: All filesystems unmounted.
  [   97.797352][    T1] systemd-shutdown[1]: Deactivating swaps.
  [   97.803451][    T1] systemd-shutdown[1]: All swaps deactivated.
  [   97.809626][    T1] systemd-shutdown[1]: Detaching loop devices.
  [   97.890294][    T1] systemd-shutdown[1]: All loop devices detached.
  [   98.967832][ T3116] usb 1-1: device descriptor read/8, error -71
  [  100.108406][    T1] sd 0:0:1:0: [sda] Synchronizing SCSI cache
  [  100.116036][    T1] reboot: Restarting system
  [  100.120636][    T1] reboot: machine restart
  SeaBIOS (version 1.8.2-20200402_173431-google)
  Total RAM Size = 0x00000001e0000000 = 7680 MiB
  CPUs found: 2     Max CPUs supported: 2
  Comparing RSDP and RSDP

Therefore, allow disabling only k_spec() function in order to allow
fuzzers to examine the remaining part in that file.

[1] https://syzkaller.appspot.com/bug?id=321861b1588b44d064b779b92293c5d55cfe8430

Link: http://lkml.kernel.org/r/20200421131951.4948-2-penguin-kernel@I-love.SAKURA.ne.jp
Signed-off-by: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
Cc: Alexander Viro <viro@zeniv.linux.org.uk>
Cc: Andi Kleen <ak@linux.intel.com>
Cc: Arnd Bergmann <arnd@arndb.de>
Cc: Dmitry Vyukov <dvyukov@google.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Jiri Slaby <jslaby@suse.com>
Cc: Matthew Garrett <mjg59@google.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Petr Mladek <pmladek@suse.com>
Cc: Sergey Senozhatsky <sergey.senozhatsky@gmail.com>
Cc: Steven Rostedt <rostedt@goodmis.org>
Cc: "Theodore Y . Ts'o" <tytso@mit.edu>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/tty/vt/keyboard.c |    2 ++
 lib/Kconfig.twist         |    7 +++++++
 2 files changed, 9 insertions(+)

--- a/drivers/tty/vt/keyboard.c~twist-allow-disabling-k_spec-function-in-drivers-tty-vt-keyboardc
+++ a/drivers/tty/vt/keyboard.c
@@ -633,6 +633,8 @@ static void k_spec(struct vc_data *vc, u
 	     kbd->kbdmode == VC_OFF) &&
 	     value != KVAL(K_SAK))
 		return;		/* SAK is allowed even in raw mode */
+	if (IS_ENABLED(CONFIG_TWIST_DISABLE_KBD_K_SPEC_HANDLER))
+		return;
 	fn_handler[value](vc);
 }
 
--- a/lib/Kconfig.twist~twist-allow-disabling-k_spec-function-in-drivers-tty-vt-keyboardc
+++ a/lib/Kconfig.twist
@@ -10,4 +10,11 @@ menuconfig TWIST_KERNEL_BEHAVIOR
 
 if TWIST_KERNEL_BEHAVIOR
 
+config TWIST_DISABLE_KBD_K_SPEC_HANDLER
+       bool "Disable k_spec() function in drivers/tty/vt/keyboard.c"
+       help
+	 k_spec() function allows triggering e.g. Ctrl-Alt-Del event.
+	 Such event is annoying for fuzz testing which wants to test
+	 kernel code without rebooting the system.
+
 endif # TWIST_KERNEL_BEHAVIOR
_

Patches currently in -mm which might be from penguin-kernel@I-love.SAKURA.ne.jp are

info-task-hung-in-generic_file_write_iter.patch
info-task-hung-in-generic_file_write-fix.patch
twist-add-option-for-selecting-twist-options-for-syzkallers-testing.patch
