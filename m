From: Andrew Morton <akpm@linux-foundation.org>
Subject: [alternative-merged]
 add-kernel-config-option-for-twisting-kernel-behavior.patch removed from
 -mm tree
Date: Thu, 28 May 2020 12:11:52 -0700
Message-ID: <20200528191152.6G9NSTXFa%akpm@linux-foundation.org>
References: <20200527222015.62ba8592af63dae12ab58ffe@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:45270 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2406165AbgE1TLy (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Thu, 28 May 2020 15:11:54 -0400
In-Reply-To: <20200527222015.62ba8592af63dae12ab58ffe@linux-foundation.org>
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: ak@linux.intel.com, arnd@arndb.de, dvyukov@google.com, gregkh@linuxfoundation.org, jslaby@suse.com, mjg59@google.com, mm-commits@vger.kernel.org, penguin-kernel@I-love.SAKURA.ne.jp, peterz@infradead.org, pmladek@suse.com, rostedt@goodmis.org, sergey.senozhatsky@gmail.com, tytso@mit.edu, viro@zeniv.linux.org.uk


The patch titled
     Subject: add kernel config option for twisting kernel behavior.
has been removed from the -mm tree.  Its filename was
     add-kernel-config-option-for-twisting-kernel-behavior.patch

This patch was dropped because an alternative patch was merged

------------------------------------------------------
From: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
Subject: add kernel config option for twisting kernel behavior.

Existing kernel config options are defined based on "whether you want to
enable this module/feature or not". And such granularity is sometimes
too rough-grained for fuzzing tools which try to find bugs inside each
module/feature.

While syzkaller (one of fuzzing tools) is finding many bugs, sometimes
syzkaller examines stupid operations. Some examples of such operations
are: changing console loglevel which in turn makes it impossible to get
kernel messages when a crash happens, freezing filesystems which in turn
causes khungtaskd to needlessly complain, programmatically sending
Ctrl-Alt-Del which in turn causes the system to needlessly reboot.
Currently we prevent syzkaller from examining stupid operations by
blacklisting syscall arguments and/or disabling whole functionality
using existing kernel config options. But such approach is difficult to
maintain and needlessly prevents fuzzers from testing kernel code. [1]

We want fuzzers to test as much coverage as possible while we want
fuzzers not to try stupid operations. To achieve this goal, we want
cooperation from kernel side, and build-time branching (i.e. kernel
config options) will be the simplest and the most reliable.

Therefore, this patch introduces a kernel config option which allows
selecting fine-grained kernel config options for twisting kernel's
behavior. Each fine-grained kernel config option will be added by future
patches. For ease of management, grouping kernel config options for
allowing e.g. syzkaller to select all fine-grained kernel config options
which e.g. syzkaller wants would be added by future patches.

[1] https://lkml.kernel.org/r/CACT4Y+a6KExbggs4mg8pvoD554PcDqQNW4sM15X-tc=YONCzYw@mail.gmail.com

Link: http://lkml.kernel.org/r/20200421131951.4948-1-penguin-kernel@I-love.SAKURA.ne.jp
Signed-off-by: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Steven Rostedt <rostedt@goodmis.org>
Cc: Dmitry Vyukov <dvyukov@google.com>
Cc: Matthew Garrett <mjg59@google.com>
Cc: Andi Kleen <ak@linux.intel.com>
Cc: "Theodore Y . Ts'o" <tytso@mit.edu>
Cc: Alexander Viro <viro@zeniv.linux.org.uk>
Cc: Petr Mladek <pmladek@suse.com>
Cc: Sergey Senozhatsky <sergey.senozhatsky@gmail.com>
Cc: Arnd Bergmann <arnd@arndb.de>
Cc: Jiri Slaby <jslaby@suse.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/Kconfig.debug |    2 ++
 lib/Kconfig.twist |   13 +++++++++++++
 2 files changed, 15 insertions(+)

--- a/lib/Kconfig.debug~add-kernel-config-option-for-twisting-kernel-behavior
+++ a/lib/Kconfig.debug
@@ -2287,4 +2287,6 @@ config HYPERV_TESTING
 
 endmenu # "Kernel Testing and Coverage"
 
+source "lib/Kconfig.twist"
+
 endmenu # Kernel hacking
--- /dev/null
+++ a/lib/Kconfig.twist
@@ -0,0 +1,13 @@
+menuconfig TWIST_KERNEL_BEHAVIOR
+	bool "Twist kernel behavior"
+	help
+	  Saying Y here allows modifying kernel behavior via kernel
+	  config options which will become visible by selecting this
+	  config option. Since these kernel config options are intended
+	  for helping e.g. fuzz testing, behavior twisted by this kernel
+	  option might be unstable. Userspace applications should not
+	  count on this option being selected.
+
+if TWIST_KERNEL_BEHAVIOR
+
+endif # TWIST_KERNEL_BEHAVIOR
_

Patches currently in -mm which might be from penguin-kernel@I-love.SAKURA.ne.jp are

info-task-hung-in-generic_file_write_iter.patch
info-task-hung-in-generic_file_write-fix.patch
twist-allow-disabling-k_spec-function-in-drivers-tty-vt-keyboardc.patch
twist-add-option-for-selecting-twist-options-for-syzkallers-testing.patch
