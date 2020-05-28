From: Andrew Morton <akpm@linux-foundation.org>
Subject: [alternative-merged]
 twist-add-option-for-selecting-twist-options-for-syzkallers-testing.patch
 removed from -mm tree
Date: Thu, 28 May 2020 12:11:58 -0700
Message-ID: <20200528191158.AJ75Nm615%akpm@linux-foundation.org>
References: <20200527222015.62ba8592af63dae12ab58ffe@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:45344 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2406165AbgE1TL7 (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Thu, 28 May 2020 15:11:59 -0400
In-Reply-To: <20200527222015.62ba8592af63dae12ab58ffe@linux-foundation.org>
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: ak@linux.intel.com, arnd@arndb.de, dvyukov@google.com, gregkh@linuxfoundation.org, jslaby@suse.com, mjg59@google.com, mm-commits@vger.kernel.org, penguin-kernel@I-love.SAKURA.ne.jp, peterz@infradead.org, pmladek@suse.com, rostedt@goodmis.org, sergey.senozhatsky@gmail.com, tytso@mit.edu, viro@zeniv.linux.org.uk


The patch titled
     Subject: twist: add option for selecting twist options for syzkaller's testing
has been removed from the -mm tree.  Its filename was
     twist-add-option-for-selecting-twist-options-for-syzkallers-testing.patch

This patch was dropped because an alternative patch was merged

------------------------------------------------------
From: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
Subject: twist: add option for selecting twist options for syzkaller's testing

When a kernel developer adds a kernel config option, they will not go and
update configs on all external testing systems.  This problem is also
common for "enable all boot tests that can run on this kernel", or
"configure a 'standard' debug build".  Currently doing these things
require all of expertise, sacred knowledge, checking all configs
one-by-one as well as checking every new kernel patch and that needs to be
done by everybody doing any kernel testing.

In order to reduce the burden of maintaining kernel config options, this
patch introduces a kernel config option which will select twist options
when building kernels for syzkaller's testing.

Link: http://lkml.kernel.org/r/20200421131951.4948-3-penguin-kernel@I-love.SAKURA.ne.jp
Signed-off-by: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
Signed-off-by: Dmitry Vyukov <dvyukov@google.com>
Cc: Alexander Viro <viro@zeniv.linux.org.uk>
Cc: Andi Kleen <ak@linux.intel.com>
Cc: Arnd Bergmann <arnd@arndb.de>
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

 lib/Kconfig.twist |    6 ++++++
 1 file changed, 6 insertions(+)

--- a/lib/Kconfig.twist~twist-add-option-for-selecting-twist-options-for-syzkallers-testing
+++ a/lib/Kconfig.twist
@@ -10,6 +10,12 @@ menuconfig TWIST_KERNEL_BEHAVIOR
 
 if TWIST_KERNEL_BEHAVIOR
 
+config TWIST_FOR_SYZKALLER_TESTING
+       bool "Select all twist options suitable for syzkaller testing"
+       select TWIST_DISABLE_KBD_K_SPEC_HANDLER
+       help
+	 Say N unless you are building kernels for syzkaller's testing.
+
 config TWIST_DISABLE_KBD_K_SPEC_HANDLER
        bool "Disable k_spec() function in drivers/tty/vt/keyboard.c"
        help
_

Patches currently in -mm which might be from penguin-kernel@I-love.SAKURA.ne.jp are

info-task-hung-in-generic_file_write_iter.patch
info-task-hung-in-generic_file_write-fix.patch
