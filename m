From: akpm@linux-foundation.org
Subject: + include-linux-inith-use-the-stringify-operator-for-the-__define_initcall-macro.patch added to -mm tree
Date: Tue, 23 Oct 2012 15:17:21 -0700
Message-ID: <20121023221722.0493F5C0050@hpza9.eem.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-wi0-f202.google.com ([209.85.212.202]:51659 "EHLO
	mail-wi0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933379Ab2JWWRY (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 23 Oct 2012 18:17:24 -0400
Received: by mail-wi0-f202.google.com with SMTP id hr7so244485wib.1
        for <mm-commits@vger.kernel.org>; Tue, 23 Oct 2012 15:17:23 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: matthew@mattleach.net, benh@kernel.crashing.org


The patch titled
     Subject: include/linux/init.h: use the stringify operator for the __define_initcall macro
has been added to the -mm tree.  Its filename is
     include-linux-inith-use-the-stringify-operator-for-the-__define_initcall-macro.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Matthew Leach <matthew@mattleach.net>
Subject: include/linux/init.h: use the stringify operator for the __define_initcall macro

Currently the __define_initcall() macro takes three arguments, fn, id and
level.  The level argument is exactly the same as the id argument but
wrapped in quotes.  To overcome this need to specify three arguments to
the __define_initcall macro, where one argument is the stringification of
another, we can just use the stringification macro instead.

Signed-off-by: Matthew Leach <matthew@mattleach.net>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/powerpc/include/asm/machdep.h |   34 ++++++++++++------------
 include/linux/init.h               |   38 +++++++++++++--------------
 2 files changed, 36 insertions(+), 36 deletions(-)

diff -puN arch/powerpc/include/asm/machdep.h~include-linux-inith-use-the-stringify-operator-for-the-__define_initcall-macro arch/powerpc/include/asm/machdep.h
--- a/arch/powerpc/include/asm/machdep.h~include-linux-inith-use-the-stringify-operator-for-the-__define_initcall-macro
+++ a/arch/powerpc/include/asm/machdep.h
@@ -320,28 +320,28 @@ static inline void log_error(char *buf, 
 		ppc_md.log_error(buf, err_type, fatal);
 }
 
-#define __define_machine_initcall(mach,level,fn,id) \
+#define __define_machine_initcall(mach, fn, id) \
 	static int __init __machine_initcall_##mach##_##fn(void) { \
 		if (machine_is(mach)) return fn(); \
 		return 0; \
 	} \
-	__define_initcall(level,__machine_initcall_##mach##_##fn,id);
+	__define_initcall(__machine_initcall_##mach##_##fn, id);
 
-#define machine_core_initcall(mach,fn)		__define_machine_initcall(mach,"1",fn,1)
-#define machine_core_initcall_sync(mach,fn)	__define_machine_initcall(mach,"1s",fn,1s)
-#define machine_postcore_initcall(mach,fn)	__define_machine_initcall(mach,"2",fn,2)
-#define machine_postcore_initcall_sync(mach,fn)	__define_machine_initcall(mach,"2s",fn,2s)
-#define machine_arch_initcall(mach,fn)		__define_machine_initcall(mach,"3",fn,3)
-#define machine_arch_initcall_sync(mach,fn)	__define_machine_initcall(mach,"3s",fn,3s)
-#define machine_subsys_initcall(mach,fn)	__define_machine_initcall(mach,"4",fn,4)
-#define machine_subsys_initcall_sync(mach,fn)	__define_machine_initcall(mach,"4s",fn,4s)
-#define machine_fs_initcall(mach,fn)		__define_machine_initcall(mach,"5",fn,5)
-#define machine_fs_initcall_sync(mach,fn)	__define_machine_initcall(mach,"5s",fn,5s)
-#define machine_rootfs_initcall(mach,fn)	__define_machine_initcall(mach,"rootfs",fn,rootfs)
-#define machine_device_initcall(mach,fn)	__define_machine_initcall(mach,"6",fn,6)
-#define machine_device_initcall_sync(mach,fn)	__define_machine_initcall(mach,"6s",fn,6s)
-#define machine_late_initcall(mach,fn)		__define_machine_initcall(mach,"7",fn,7)
-#define machine_late_initcall_sync(mach,fn)	__define_machine_initcall(mach,"7s",fn,7s)
+#define machine_core_initcall(mach, fn)		__define_machine_initcall(mach, fn, 1)
+#define machine_core_initcall_sync(mach, fn)	__define_machine_initcall(mach, fn, 1s)
+#define machine_postcore_initcall(mach, fn)	__define_machine_initcall(mach, fn, 2)
+#define machine_postcore_initcall_sync(mach, fn)	__define_machine_initcall(mach, fn, 2s)
+#define machine_arch_initcall(mach, fn)		__define_machine_initcall(mach, fn, 3)
+#define machine_arch_initcall_sync(mach, fn)	__define_machine_initcall(mach, fn, 3s)
+#define machine_subsys_initcall(mach, fn)	__define_machine_initcall(mach, fn, 4)
+#define machine_subsys_initcall_sync(mach, fn)	__define_machine_initcall(mach, fn, 4s)
+#define machine_fs_initcall(mach, fn)		__define_machine_initcall(mach, fn, 5)
+#define machine_fs_initcall_sync(mach, fn)	__define_machine_initcall(mach, fn, 5s)
+#define machine_rootfs_initcall(mach, fn)	__define_machine_initcall(mach, fn, rootfs)
+#define machine_device_initcall(mach, fn)	__define_machine_initcall(mach, fn, 6)
+#define machine_device_initcall_sync(mach, fn)	__define_machine_initcall(mach, fn, 6s)
+#define machine_late_initcall(mach, fn)		__define_machine_initcall(mach, fn, 7)
+#define machine_late_initcall_sync(mach, fn)	__define_machine_initcall(mach, fn, 7s)
 
 #endif /* __KERNEL__ */
 #endif /* _ASM_POWERPC_MACHDEP_H */
diff -puN include/linux/init.h~include-linux-inith-use-the-stringify-operator-for-the-__define_initcall-macro include/linux/init.h
--- a/include/linux/init.h~include-linux-inith-use-the-stringify-operator-for-the-__define_initcall-macro
+++ a/include/linux/init.h
@@ -186,16 +186,16 @@ extern bool initcall_debug;
  * can point at the same handler without causing duplicate-symbol build errors.
  */
 
-#define __define_initcall(level,fn,id) \
+#define __define_initcall(fn, id) \
 	static initcall_t __initcall_##fn##id __used \
-	__attribute__((__section__(".initcall" level ".init"))) = fn
+	__attribute__((__section__(".initcall" #id ".init"))) = fn
 
 /*
  * Early initcalls run before initializing SMP.
  *
  * Only for built-in code, not modules.
  */
-#define early_initcall(fn)		__define_initcall("early",fn,early)
+#define early_initcall(fn)		__define_initcall(fn, early)
 
 /*
  * A "pure" initcall has no dependencies on anything else, and purely
@@ -204,23 +204,23 @@ extern bool initcall_debug;
  * This only exists for built-in code, not for modules.
  * Keep main.c:initcall_level_names[] in sync.
  */
-#define pure_initcall(fn)		__define_initcall("0",fn,0)
+#define pure_initcall(fn)		__define_initcall(fn, 0)
 
-#define core_initcall(fn)		__define_initcall("1",fn,1)
-#define core_initcall_sync(fn)		__define_initcall("1s",fn,1s)
-#define postcore_initcall(fn)		__define_initcall("2",fn,2)
-#define postcore_initcall_sync(fn)	__define_initcall("2s",fn,2s)
-#define arch_initcall(fn)		__define_initcall("3",fn,3)
-#define arch_initcall_sync(fn)		__define_initcall("3s",fn,3s)
-#define subsys_initcall(fn)		__define_initcall("4",fn,4)
-#define subsys_initcall_sync(fn)	__define_initcall("4s",fn,4s)
-#define fs_initcall(fn)			__define_initcall("5",fn,5)
-#define fs_initcall_sync(fn)		__define_initcall("5s",fn,5s)
-#define rootfs_initcall(fn)		__define_initcall("rootfs",fn,rootfs)
-#define device_initcall(fn)		__define_initcall("6",fn,6)
-#define device_initcall_sync(fn)	__define_initcall("6s",fn,6s)
-#define late_initcall(fn)		__define_initcall("7",fn,7)
-#define late_initcall_sync(fn)		__define_initcall("7s",fn,7s)
+#define core_initcall(fn)		__define_initcall(fn, 1)
+#define core_initcall_sync(fn)		__define_initcall(fn, 1s)
+#define postcore_initcall(fn)		__define_initcall(fn, 2)
+#define postcore_initcall_sync(fn)	__define_initcall(fn, 2s)
+#define arch_initcall(fn)		__define_initcall(fn, 3)
+#define arch_initcall_sync(fn)		__define_initcall(fn, 3s)
+#define subsys_initcall(fn)		__define_initcall(fn, 4)
+#define subsys_initcall_sync(fn)	__define_initcall(fn, 4s)
+#define fs_initcall(fn)			__define_initcall(fn, 5)
+#define fs_initcall_sync(fn)		__define_initcall(fn, 5s)
+#define rootfs_initcall(fn)		__define_initcall(fn, rootfs)
+#define device_initcall(fn)		__define_initcall(fn, 6)
+#define device_initcall_sync(fn)	__define_initcall(fn, 6s)
+#define late_initcall(fn)		__define_initcall(fn, 7)
+#define late_initcall_sync(fn)		__define_initcall(fn, 7s)
 
 #define __initcall(fn) device_initcall(fn)
 
_

Patches currently in -mm which might be from matthew@mattleach.net are

include-linux-inith-use-the-stringify-operator-for-the-__define_initcall-macro.patch

