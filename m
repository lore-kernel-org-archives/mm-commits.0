From: akpm@linux-foundation.org
Subject: + kernel-add-support-for-gcc-5.patch added to -mm tree
Date: Thu, 04 Sep 2014 14:12:51 -0700
Message-ID: <5408d5d3.G89qfjltyTmmG9DL%akpm__35352.9440508739$1409865183$gmane$org@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:55878 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755316AbaIDVMw (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 4 Sep 2014 17:12:52 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: sasha.levin@oracle.com, stable@vger.kernel.org, mm-commits@vger.kernel.org


The patch titled
     Subject: kernel: add support for gcc 5
has been added to the -mm tree.  Its filename is
     kernel-add-support-for-gcc-5.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/kernel-add-support-for-gcc-5.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/kernel-add-support-for-gcc-5.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Sasha Levin <sasha.levin@oracle.com>
Subject: kernel: add support for gcc 5

We're missing include/linux/compiler-gcc5.h which is required now
because gcc branched off to v5 in trunk.

Just copy the relevant bits out of include/linux/compiler-gcc4.h,
no new code is added as of now.

This fixes a build error when using gcc 5.

Signed-off-by: Sasha Levin <sasha.levin@oracle.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/compiler-gcc5.h |   66 ++++++++++++++++++++++++++++++++
 1 file changed, 66 insertions(+)

diff -puN /dev/null include/linux/compiler-gcc5.h
--- /dev/null
+++ a/include/linux/compiler-gcc5.h
@@ -0,0 +1,66 @@
+#ifndef __LINUX_COMPILER_H
+#error "Please don't include <linux/compiler-gcc5.h> directly, include <linux/compiler.h> instead."
+#endif
+
+#define __used			__attribute__((__used__))
+#define __must_check 		__attribute__((warn_unused_result))
+#define __compiler_offsetof(a,b) __builtin_offsetof(a,b)
+
+/* Mark functions as cold. gcc will assume any path leading to a call
+   to them will be unlikely.  This means a lot of manual unlikely()s
+   are unnecessary now for any paths leading to the usual suspects
+   like BUG(), printk(), panic() etc. [but let's keep them for now for
+   older compilers]
+
+   Early snapshots of gcc 4.3 don't support this and we can't detect this
+   in the preprocessor, but we can live with this because they're unreleased.
+   Maketime probing would be overkill here.
+
+   gcc also has a __attribute__((__hot__)) to move hot functions into
+   a special section, but I don't see any sense in this right now in
+   the kernel context */
+#define __cold			__attribute__((__cold__))
+
+#define __UNIQUE_ID(prefix) __PASTE(__PASTE(__UNIQUE_ID_, prefix), __COUNTER__)
+
+#ifndef __CHECKER__
+# define __compiletime_warning(message) __attribute__((warning(message)))
+# define __compiletime_error(message) __attribute__((error(message)))
+#endif /* __CHECKER__ */
+
+/*
+ * Mark a position in code as unreachable.  This can be used to
+ * suppress control flow warnings after asm blocks that transfer
+ * control elsewhere.
+ *
+ * Early snapshots of gcc 4.5 don't support this and we can't detect
+ * this in the preprocessor, but we can live with this because they're
+ * unreleased.  Really, we need to have autoconf for the kernel.
+ */
+#define unreachable() __builtin_unreachable()
+
+/* Mark a function definition as prohibited from being cloned. */
+#define __noclone	__attribute__((__noclone__))
+
+/*
+ * Tell the optimizer that something else uses this function or variable.
+ */
+#define __visible __attribute__((externally_visible))
+
+/*
+ * GCC 'asm goto' miscompiles certain code sequences:
+ *
+ *   http://gcc.gnu.org/bugzilla/show_bug.cgi?id=58670
+ *
+ * Work it around via a compiler barrier quirk suggested by Jakub Jelinek.
+ * Fixed in GCC 4.8.2 and later versions.
+ *
+ * (asm goto is automatically volatile - the naming reflects this.)
+ */
+#define asm_volatile_goto(x...)	do { asm goto(x); asm (""); } while (0)
+
+#ifdef CONFIG_ARCH_USE_BUILTIN_BSWAP
+#define __HAVE_BUILTIN_BSWAP32__
+#define __HAVE_BUILTIN_BSWAP64__
+#define __HAVE_BUILTIN_BSWAP16__
+#endif /* CONFIG_ARCH_USE_BUILTIN_BSWAP */
_

Patches currently in -mm which might be from sasha.levin@oracle.com are

mm-mmap-use-pr_emerg-when-printing-bug-related-information.patch
kernel-add-support-for-gcc-5.patch
mm-balloon_compaction-ignore-anonymous-pages.patch
introduce-dump_vma.patch
introduce-dump_vma-fix.patch
introduce-dump_vma-fix-2.patch
introduce-vm_bug_on_vma.patch
convert-a-few-vm_bug_on-callers-to-vm_bug_on_vma.patch
convert-a-few-vm_bug_on-callers-to-vm_bug_on_vma-checkpatch-fixes.patch
mm-mmapc-clean-up-config_debug_vm_rb-checks.patch
vmstat-on-demand-vmstat-workers-v8-fix-2.patch
mm-introduce-do_shared_fault-and-drop-do_fault-fix-fix.patch
do_shared_fault-check-that-mmap_sem-is-held.patch
mm-replace-remap_file_pages-syscall-with-emulation.patch

