From: akpm@linux-foundation.org
Subject: + uml-stop-using-libc-asm-pageh.patch added to -mm tree
Date: Mon, 06 Aug 2007 12:50:15 -0700
Message-ID: <200708061950.l76JoFJv011783@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:44854 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1760578AbXHFTue (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 6 Aug 2007 15:50:34 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: jdike@addtoit.com, jdike@linux.intel.com


The patch titled
     uml: stop using libc asm/page.h
has been added to the -mm tree.  Its filename is
     uml-stop-using-libc-asm-pageh.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: uml: stop using libc asm/page.h
From: Jeff Dike <jdike@addtoit.com>

Remove includes of asm/page.h from libc code.  This header seems to be
disappearing, and UML doesn't make much use of it anyway.

The one use, PAGE_SHIFT in stub.h, is handled by copying the constant from the
kernel side of the house in common_offsets.h.

Signed-off-by: Jeff Dike <jdike@linux.intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/um/include/common-offsets.h   |    1 +
 arch/um/include/sysdep-i386/stub.h |    3 +--
 arch/um/os-Linux/main.c            |    1 -
 arch/um/os-Linux/skas/mem.c        |    1 -
 arch/um/os-Linux/start_up.c        |    1 -
 arch/um/os-Linux/tt.c              |    1 -
 6 files changed, 2 insertions(+), 6 deletions(-)

diff -puN arch/um/include/common-offsets.h~uml-stop-using-libc-asm-pageh arch/um/include/common-offsets.h
--- a/arch/um/include/common-offsets.h~uml-stop-using-libc-asm-pageh
+++ a/arch/um/include/common-offsets.h
@@ -10,6 +10,7 @@ OFFSET(HOST_TASK_PID, task_struct, pid);
 
 DEFINE(UM_KERN_PAGE_SIZE, PAGE_SIZE);
 DEFINE(UM_KERN_PAGE_MASK, PAGE_MASK);
+DEFINE(UM_KERN_PAGE_SHIFT, PAGE_SHIFT);
 DEFINE(UM_NSEC_PER_SEC, NSEC_PER_SEC);
 
 DEFINE_STR(UM_KERN_EMERG, KERN_EMERG);
diff -puN arch/um/include/sysdep-i386/stub.h~uml-stop-using-libc-asm-pageh arch/um/include/sysdep-i386/stub.h
--- a/arch/um/include/sysdep-i386/stub.h~uml-stop-using-libc-asm-pageh
+++ a/arch/um/include/sysdep-i386/stub.h
@@ -9,7 +9,6 @@
 #include <sys/mman.h>
 #include <asm/ptrace.h>
 #include <asm/unistd.h>
-#include <asm/page.h>
 #include "stub-data.h"
 #include "kern_constants.h"
 #include "uml-config.h"
@@ -19,7 +18,7 @@ extern void stub_clone_handler(void);
 
 #define STUB_SYSCALL_RET EAX
 #define STUB_MMAP_NR __NR_mmap2
-#define MMAP_OFFSET(o) ((o) >> PAGE_SHIFT)
+#define MMAP_OFFSET(o) ((o) >> UM_KERN_PAGE_SHIFT)
 
 static inline long stub_syscall0(long syscall)
 {
diff -puN arch/um/os-Linux/main.c~uml-stop-using-libc-asm-pageh arch/um/os-Linux/main.c
--- a/arch/um/os-Linux/main.c~uml-stop-using-libc-asm-pageh
+++ a/arch/um/os-Linux/main.c
@@ -12,7 +12,6 @@
 #include <sys/resource.h>
 #include <sys/mman.h>
 #include <sys/user.h>
-#include <asm/page.h>
 #include "kern_util.h"
 #include "as-layout.h"
 #include "mem_user.h"
diff -puN arch/um/os-Linux/skas/mem.c~uml-stop-using-libc-asm-pageh arch/um/os-Linux/skas/mem.c
--- a/arch/um/os-Linux/skas/mem.c~uml-stop-using-libc-asm-pageh
+++ a/arch/um/os-Linux/skas/mem.c
@@ -9,7 +9,6 @@
 #include <unistd.h>
 #include <sys/mman.h>
 #include <sys/wait.h>
-#include <asm/page.h>
 #include <asm/unistd.h>
 #include "mem_user.h"
 #include "mem.h"
diff -puN arch/um/os-Linux/start_up.c~uml-stop-using-libc-asm-pageh arch/um/os-Linux/start_up.c
--- a/arch/um/os-Linux/start_up.c~uml-stop-using-libc-asm-pageh
+++ a/arch/um/os-Linux/start_up.c
@@ -19,7 +19,6 @@
 #include <sys/mman.h>
 #include <sys/resource.h>
 #include <asm/unistd.h>
-#include <asm/page.h>
 #include <sys/types.h>
 #include "kern_util.h"
 #include "user.h"
diff -puN arch/um/os-Linux/tt.c~uml-stop-using-libc-asm-pageh arch/um/os-Linux/tt.c
--- a/arch/um/os-Linux/tt.c~uml-stop-using-libc-asm-pageh
+++ a/arch/um/os-Linux/tt.c
@@ -17,7 +17,6 @@
 #include <sys/mman.h>
 #include <asm/ptrace.h>
 #include <asm/unistd.h>
-#include <asm/page.h>
 #include "kern_util.h"
 #include "user.h"
 #include "signal_kern.h"
_

Patches currently in -mm which might be from jdike@addtoit.com are

git-kvm.patch
hostfs-convert-to-new-aops.patch
uml-move-userspace-code-to-userspace-file.patch
uml-tidy-recently-moved-code.patch
uml-fix-error-cleanup-ordering.patch
uml-console-subsystem-tidying.patch
uml-fix-console-writing-bugs.patch
uml-console-tidying.patch
uml-stop-using-libc-asm-pageh.patch
uml-fix-an-ipv6-libc-vs-kernel-symbol-clash.patch
uml-fix-nonremovability-of-watchdog.patch
uml-stop-specially-protecting-kernel-stacks.patch
uml-stop-saving-process-fp-state.patch
uml-physmem-code-tidying.patch
