From: akpm@linux-foundation.org
Subject: + init-use-the-stringify-operator-for-the-__define_initcall-macro-checkpatch-fixes.patch added to -mm tree
Date: Mon, 22 Oct 2012 12:32:00 -0700
Message-ID: <20121022193201.578A4100047@wpzn3.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-vc0-f202.google.com ([209.85.220.202]:55414 "EHLO
	mail-vc0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752145Ab2JVTcC (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 22 Oct 2012 15:32:02 -0400
Received: by mail-vc0-f202.google.com with SMTP id fy27so379515vcb.1
        for <mm-commits@vger.kernel.org>; Mon, 22 Oct 2012 12:32:01 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: akpm@linux-foundation.org, matthew@mattleach.net


The patch titled
     Subject: init-use-the-stringify-operator-for-the-__define_initcall-macro-checkpatch-fixes
has been added to the -mm tree.  Its filename is
     init-use-the-stringify-operator-for-the-__define_initcall-macro-checkpatch-fixes.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: init-use-the-stringify-operator-for-the-__define_initcall-macro-checkpatch-fixes

Cc: Matthew Leach <matthew@mattleach.net>

ERROR: space required after that ',' (ctx:VxV)
#25: FILE: include/linux/init.h:189:
+#define __define_initcall(fn,id) \
                             ^

ERROR: space required after that ',' (ctx:VxV)
#36: FILE: include/linux/init.h:198:
+#define early_initcall(fn)		__define_initcall(fn,early)
                           		                    ^

ERROR: space required after that ',' (ctx:VxV)
#45: FILE: include/linux/init.h:207:
+#define pure_initcall(fn)		__define_initcall(fn,0)
                          		                    ^

ERROR: space required after that ',' (ctx:VxV)
#62: FILE: include/linux/init.h:209:
+#define core_initcall(fn)		__define_initcall(fn,1)
                          		                    ^

ERROR: space required after that ',' (ctx:VxV)
#63: FILE: include/linux/init.h:210:
+#define core_initcall_sync(fn)		__define_initcall(fn,1s)
                               		                    ^

ERROR: space required after that ',' (ctx:VxV)
#64: FILE: include/linux/init.h:211:
+#define postcore_initcall(fn)		__define_initcall(fn,2)
                              		                    ^

ERROR: space required after that ',' (ctx:VxV)
#65: FILE: include/linux/init.h:212:
+#define postcore_initcall_sync(fn)	__define_initcall(fn,2s)
                                   	                    ^

ERROR: space required after that ',' (ctx:VxV)
#66: FILE: include/linux/init.h:213:
+#define arch_initcall(fn)		__define_initcall(fn,3)
                          		                    ^

ERROR: space required after that ',' (ctx:VxV)
#67: FILE: include/linux/init.h:214:
+#define arch_initcall_sync(fn)		__define_initcall(fn,3s)
                               		                    ^

ERROR: space required after that ',' (ctx:VxV)
#68: FILE: include/linux/init.h:215:
+#define subsys_initcall(fn)		__define_initcall(fn,4)
                            		                    ^

ERROR: space required after that ',' (ctx:VxV)
#69: FILE: include/linux/init.h:216:
+#define subsys_initcall_sync(fn)	__define_initcall(fn,4s)
                                 	                    ^

ERROR: space required after that ',' (ctx:VxV)
#70: FILE: include/linux/init.h:217:
+#define fs_initcall(fn)			__define_initcall(fn,5)
                        			                    ^

ERROR: space required after that ',' (ctx:VxV)
#71: FILE: include/linux/init.h:218:
+#define fs_initcall_sync(fn)		__define_initcall(fn,5s)
                             		                    ^

ERROR: space required after that ',' (ctx:VxV)
#72: FILE: include/linux/init.h:219:
+#define rootfs_initcall(fn)		__define_initcall(fn,rootfs)
                            		                    ^

ERROR: space required after that ',' (ctx:VxV)
#73: FILE: include/linux/init.h:220:
+#define device_initcall(fn)		__define_initcall(fn,6)
                            		                    ^

ERROR: space required after that ',' (ctx:VxV)
#74: FILE: include/linux/init.h:221:
+#define device_initcall_sync(fn)	__define_initcall(fn,6s)
                                 	                    ^

ERROR: space required after that ',' (ctx:VxV)
#75: FILE: include/linux/init.h:222:
+#define late_initcall(fn)		__define_initcall(fn,7)
                          		                    ^

ERROR: space required after that ',' (ctx:VxV)
#76: FILE: include/linux/init.h:223:
+#define late_initcall_sync(fn)		__define_initcall(fn,7s)
                               		                    ^

total: 18 errors, 0 warnings, 58 lines checked

./patches/init-use-the-stringify-operator-for-the-__define_initcall-macro.patch has style problems, please review.

If any of these errors are false positives, please report
them to the maintainer, see CHECKPATCH in MAINTAINERS.

Please run checkpatch prior to sending patches

Cc: Matthew Leach <matthew@mattleach.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/init.h |   36 ++++++++++++++++++------------------
 1 file changed, 18 insertions(+), 18 deletions(-)

diff -puN include/linux/init.h~init-use-the-stringify-operator-for-the-__define_initcall-macro-checkpatch-fixes include/linux/init.h
--- a/include/linux/init.h~init-use-the-stringify-operator-for-the-__define_initcall-macro-checkpatch-fixes
+++ a/include/linux/init.h
@@ -186,7 +186,7 @@ extern bool initcall_debug;
  * can point at the same handler without causing duplicate-symbol build errors.
  */
 
-#define __define_initcall(fn,id) \
+#define __define_initcall(fn, id) \
 	static initcall_t __initcall_##fn##id __used \
 	__attribute__((__section__(".initcall" #id ".init"))) = fn
 
@@ -195,7 +195,7 @@ extern bool initcall_debug;
  *
  * Only for built-in code, not modules.
  */
-#define early_initcall(fn)		__define_initcall(fn,early)
+#define early_initcall(fn)		__define_initcall(fn, early)
 
 /*
  * A "pure" initcall has no dependencies on anything else, and purely
@@ -204,23 +204,23 @@ extern bool initcall_debug;
  * This only exists for built-in code, not for modules.
  * Keep main.c:initcall_level_names[] in sync.
  */
-#define pure_initcall(fn)		__define_initcall(fn,0)
+#define pure_initcall(fn)		__define_initcall(fn, 0)
 
-#define core_initcall(fn)		__define_initcall(fn,1)
-#define core_initcall_sync(fn)		__define_initcall(fn,1s)
-#define postcore_initcall(fn)		__define_initcall(fn,2)
-#define postcore_initcall_sync(fn)	__define_initcall(fn,2s)
-#define arch_initcall(fn)		__define_initcall(fn,3)
-#define arch_initcall_sync(fn)		__define_initcall(fn,3s)
-#define subsys_initcall(fn)		__define_initcall(fn,4)
-#define subsys_initcall_sync(fn)	__define_initcall(fn,4s)
-#define fs_initcall(fn)			__define_initcall(fn,5)
-#define fs_initcall_sync(fn)		__define_initcall(fn,5s)
-#define rootfs_initcall(fn)		__define_initcall(fn,rootfs)
-#define device_initcall(fn)		__define_initcall(fn,6)
-#define device_initcall_sync(fn)	__define_initcall(fn,6s)
-#define late_initcall(fn)		__define_initcall(fn,7)
-#define late_initcall_sync(fn)		__define_initcall(fn,7s)
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

Patches currently in -mm which might be from akpm@linux-foundation.org are

revert-epoll-support-for-disabling-items-and-a-self-test-app.patch
linux-next.patch
linux-next-git-rejects.patch
i-need-old-gcc.patch
arch-alpha-kernel-systblss-remove-debug-check.patch
cpu_hotplug-unmap-cpu2node-when-the-cpu-is-hotremoved-fix.patch
arch-x86-platform-iris-irisc-register-a-platform-device-and-a-platform-driver.patch
arch-x86-tools-insn_sanityc-identify-source-of-messages.patch
mm.patch
memory-hotplug-update-mce_bad_pages-when-removing-the-memory-fix.patch
swap-add-a-simple-detector-for-inappropriate-swapin-readahead-fix.patch
init-use-the-stringify-operator-for-the-__define_initcall-macro-checkpatch-fixes.patch
drivers-firmware-dmi_scanc-check-dmi-version-when-get-system-uuid-fix.patch
drivers-firmware-dmi_scanc-fetch-dmi-version-from-smbios-if-it-exists-checkpatch-fixes.patch
hfsplus-add-support-of-manipulation-by-attributes-file-checkpatch-fixes.patch
fat-exportfs-rebuild-inode-if-ilookup-fails-fix.patch
journal_add_journal_head-debug.patch
kernel-forkc-export-kernel_thread-to-modules.patch
mutex-subsystem-synchro-test-module-fix.patch
slab-leaks3-default-y.patch
put_bh-debug.patch

