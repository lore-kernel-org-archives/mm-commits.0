From: akpm@linux-foundation.org
Subject: + uml-fix-compilation-problems.patch added to -mm tree
Date: Tue, 27 Mar 2007 13:35:31 -0700
Message-ID: <200703272035.l2RKZV0I027150@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:42133 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965388AbXC0Ufj (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Tue, 27 Mar 2007 16:35:39 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: jdike@addtoit.com, blaisorblade@yahoo.it, jdike@linux.intel.com


The patch titled
     uml: fix compilation problems
has been added to the -mm tree.  Its filename is
     uml-fix-compilation-problems.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: uml: fix compilation problems
From: Jeff Dike <jdike@addtoit.com>

Fix a few miscellaneous compilation problems -
	an assignment with mismatched types in ldt.c
	a missing include in mconsole.h which needs a definition of uml_pt_regs
	when auditing is configured there are some mismatched types in ptrace.c
	I missed removing an include of user_util.h in hostfs

Signed-off-by: Jeff Dike <jdike@linux.intel.com>
Cc: Paolo 'Blaisorblade' Giarrusso <blaisorblade@yahoo.it>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/um/include/mconsole.h |    2 ++
 arch/um/sys-i386/ldt.c     |    3 ++-
 fs/hostfs/hostfs_kern.c    |    1 -
 3 files changed, 4 insertions(+), 2 deletions(-)

diff -puN arch/um/include/mconsole.h~uml-fix-compilation-problems arch/um/include/mconsole.h
--- a/arch/um/include/mconsole.h~uml-fix-compilation-problems
+++ a/arch/um/include/mconsole.h
@@ -12,6 +12,8 @@
 #define u32 uint32_t
 #endif
 
+#include "sysdep/ptrace.h"
+
 #define MCONSOLE_MAGIC (0xcafebabe)
 #define MCONSOLE_MAX_DATA (512)
 #define MCONSOLE_VERSION 2
diff -puN arch/um/sys-i386/ldt.c~uml-fix-compilation-problems arch/um/sys-i386/ldt.c
--- a/arch/um/sys-i386/ldt.c~uml-fix-compilation-problems
+++ a/arch/um/sys-i386/ldt.c
@@ -394,7 +394,8 @@ static short * host_ldt_entries = NULL;
 static void ldt_get_host_info(void)
 {
 	long ret;
-	struct ldt_entry * ldt, *tmp;
+	struct ldt_entry * ldt;
+	short *tmp;
 	int i, size, k, order;
 
 	spin_lock(&host_ldt_lock);
diff -puN fs/hostfs/hostfs_kern.c~uml-fix-compilation-problems fs/hostfs/hostfs_kern.c
--- a/fs/hostfs/hostfs_kern.c~uml-fix-compilation-problems
+++ a/fs/hostfs/hostfs_kern.c
@@ -20,7 +20,6 @@
 #include "hostfs.h"
 #include "kern_util.h"
 #include "kern.h"
-#include "user_util.h"
 #include "init.h"
 
 struct hostfs_inode_info {
_

Patches currently in -mm which might be from jdike@addtoit.com are

uml-fix-epoll.patch
uml-fix-static-linking.patch
uml-use-correct-register-file-size-everywhere.patch
remove-hardcoding-of-hard_smp_processor_id-on-up.patch
uml-delete-unused-code.patch
uml-formatting-fixes.patch
uml-host_info-tidying.patch
uml-mark-tt-mode-code-for-future-removal.patch
uml-print-coredump-limits.patch
uml-handle-block-device-hotplug-errors.patch
uml-driver-formatting-fixes.patch
uml-driver-formatting-fixes-fix.patch
uml-network-interface-hotplug-error-handling.patch
array_size-check-for-type-uml-fix.patch
uml-fix-prototypes.patch
uml-move-sigio-testing-to-sigioc.patch
uml-create-archh.patch
uml-create-as-layouth.patch
uml-move-remaining-useful-contents-of-user_utilh.patch
uml-remove-user_utilh.patch
uml-add-missing-__init-declarations.patch
remove-unused-header-file-arch-um-kernel-tt-include-mode_kern-tth.patch
i386-fix-cmpxchg-warning.patch
uml-fix-device-unplug-crash.patch
uml-irq-locking-fixes.patch
uml-fix-compilation-problems.patch
fix-utrace-utrace-tracehook-um.patch
