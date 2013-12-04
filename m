From: akpm@linux-foundation.org
Subject: + test-add-minimal-module-for-verification-testing.patch added to -mm tree
Date: Wed, 04 Dec 2013 14:22:36 -0800
Message-ID: <529fab2c.EplmR+CBCvin1F61%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:35816 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752802Ab3LDWWh (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 4 Dec 2013 17:22:37 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, rusty@rustcorp.com.au, joe@perches.com, keescook@chromium.org

Subject: + test-add-minimal-module-for-verification-testing.patch added to -mm tree
To: keescook@chromium.org,joe@perches.com,rusty@rustcorp.com.au
From: akpm@linux-foundation.org
Date: Wed, 04 Dec 2013 14:22:36 -0800


The patch titled
     Subject: test: add minimal module for verification testing
has been added to the -mm tree.  Its filename is
     test-add-minimal-module-for-verification-testing.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/test-add-minimal-module-for-verification-testing.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/test-add-minimal-module-for-verification-testing.patch

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
Subject: test: add minimal module for verification testing

This is a pair of test modules I'd like to see in the tree.  Instead of
putting these in lkdtm, where I've been adding various tests that trigger
crashes, these don't make sense there since they need to be either
distinctly separate, or their pass/fail state don't need to crash the
machine.

These live in lib/ for now, along with a few other in-kernel test modules,
and use the slightly more common "test_" naming convention, instead of
"test-".  We should likely standardize on the former:

$ find . -name 'test_*.c' | grep -v /tools/ | wc -l
4
$ find . -name 'test-*.c' | grep -v /tools/ | wc -l
2

The first is entirely a no-op module, designed to allow simple testing of
the module loading and verification interface.  It's useful to have a
module that has no other uses or dependencies so it can be reliably used
for just testing module loading and verification.

The second is a module that exercises the user memory access functions, in
an effort to make sure that we can quickly catch any regressions in
boundary checking (e.g.  like what was recently fixed on ARM).


This patch (of 2):

When doing module loading verification tests (for example, with module
singing, or LSM hooks), it is very handy to have a module that can be
built on all systems under test, isn't auto-loaded at boot, and has no
device or similar dependencies.  This creates the "test_module.ko" module
for that purpose, which only reports its load and unload to printk.

Signed-off-by: Kees Cook <keescook@chromium.org>
Cc: Rusty Russell <rusty@rustcorp.com.au>
Cc: Joe Perches <joe@perches.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/Kconfig.debug |   14 ++++++++++++++
 lib/Makefile      |    1 +
 lib/test_module.c |   33 +++++++++++++++++++++++++++++++++
 3 files changed, 48 insertions(+)

diff -puN lib/Kconfig.debug~test-add-minimal-module-for-verification-testing lib/Kconfig.debug
--- a/lib/Kconfig.debug~test-add-minimal-module-for-verification-testing
+++ a/lib/Kconfig.debug
@@ -1578,6 +1578,20 @@ config DMA_API_DEBUG
 	  This option causes a performance degredation.  Use only if you want
 	  to debug device drivers. If unsure, say N.
 
+config TEST_MODULE
+	tristate "Test module loading with 'hello world' module"
+	default n
+	depends on m
+	help
+	  This builds the "test_module" module that emits "Hello, world"
+	  on printk when loaded. It is designed to be used for basic
+	  evaluation of the module loading subsystem (for example when
+	  validating module verification). It lacks any extra dependencies,
+	  and will not normally be loaded by the system unless explicitly
+	  requested by name.
+
+	  If unsure, say N.
+
 source "samples/Kconfig"
 
 source "lib/Kconfig.kgdb"
diff -puN lib/Makefile~test-add-minimal-module-for-verification-testing lib/Makefile
--- a/lib/Makefile~test-add-minimal-module-for-verification-testing
+++ a/lib/Makefile
@@ -31,6 +31,7 @@ obj-y += string_helpers.o
 obj-$(CONFIG_TEST_STRING_HELPERS) += test-string_helpers.o
 obj-y += kstrtox.o
 obj-$(CONFIG_TEST_KSTRTOX) += test-kstrtox.o
+obj-$(CONFIG_TEST_MODULE) += test_module.o
 
 ifeq ($(CONFIG_DEBUG_KOBJECT),y)
 CFLAGS_kobject.o += -DDEBUG
diff -puN /dev/null lib/test_module.c
--- /dev/null
+++ a/lib/test_module.c
@@ -0,0 +1,33 @@
+/*
+ * This module emits "Hello, world" on printk when loaded.
+ *
+ * It is designed to be used for basic evaluation of the module loading
+ * subsystem (for example when validating module signing/verification). It
+ * lacks any extra dependencies, and will not normally be loaded by the
+ * system unless explicitly requested by name.
+ */
+
+#define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
+
+#include <linux/init.h>
+#include <linux/module.h>
+#include <linux/printk.h>
+
+static int __init test_module_init(void)
+{
+	pr_warn("Hello, world\n");
+
+	return 0;
+}
+
+module_init(test_module_init);
+
+static void __exit test_module_exit(void)
+{
+	pr_warn("Goodbye\n");
+}
+
+module_exit(test_module_exit);
+
+MODULE_AUTHOR("Kees Cook <keescook@chromium.org>");
+MODULE_LICENSE("GPL");
_

Patches currently in -mm which might be from keescook@chromium.org are

test-add-minimal-module-for-verification-testing.patch
test-check-copy_to-from_user-boundary-validation.patch
binfmt_elfc-use-get_random_int-to-fix-entropy-depleting.patch
coredump-set_dumpable-fix-the-theoretical-race-with-itself.patch
coredump-kill-mmf_dumpable-and-mmf_dump_securely.patch
coredump-make-__get_dumpable-get_dumpable-inline-kill-fs-coredumph.patch
exec-check_unsafe_exec-use-while_each_thread-rather-than-next_thread.patch
exec-check_unsafe_exec-kill-the-dead-eagain-and-clear_in_exec-logic.patch
exec-move-the-final-allow_write_access-fput-into-free_bprm.patch
exec-kill-task_struct-did_exec.patch
fs-proc-arrayc-change-do_task_stat-to-use-while_each_thread.patch
kernel-sysc-k_getrusage-can-use-while_each_thread.patch
kernel-signalc-change-do_signal_stop-do_sigaction-to-use-while_each_thread.patch
linux-next.patch

