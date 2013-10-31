From: akpm@linux-foundation.org
Subject: [merged] kernel-add-support-for-init_array-constructors.patch
 removed from -mm tree
Date: Thu, 31 Oct 2013 10:59:59 -0700
Message-ID: <52729a9f.Rko58X2w/1PAqMvv%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:59456 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754576Ab3JaSAA (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 31 Oct 2013 14:00:00 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, rusty@rustcorp.com.au, peter.oberparleiter@de.ibm.com, keescook@chromium.org, jstancek@redhat.com, arnd@arndb.de, agospoda@redhat.com, fhrbata@redhat.com

Subject: [merged] kernel-add-support-for-init_array-constructors.patch removed from -mm tree
To: fhrbata@redhat.com,agospoda@redhat.com,arnd@arndb.de,jstancek@redhat.com,keescook@chromium.org,peter.oberparleiter@de.ibm.com,rusty@rustcorp.com.au,mm-commits@vger.kernel.org
From: akpm@linux-foundation.org
Date: Thu, 31 Oct 2013 10:59:59 -0700


The patch titled
     Subject: kernel: add support for init_array constructors
has been removed from the -mm tree.  Its filename was
     kernel-add-support-for-init_array-constructors.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Frantisek Hrbata <fhrbata@redhat.com>
Subject: kernel: add support for init_array constructors

This adds the .init_array section as yet another section with
constructors.  This is needed because gcc could add __gcov_init calls to
.init_array or .ctors section, depending on gcc version.

Signed-off-by: Frantisek Hrbata <fhrbata@redhat.com>
Cc: Jan Stancek <jstancek@redhat.com>
Cc: Kees Cook <keescook@chromium.org>
Cc: Peter Oberparleiter <peter.oberparleiter@de.ibm.com>
Acked-by: Rusty Russell <rusty@rustcorp.com.au>
Cc: Arnd Bergmann <arnd@arndb.de>
Cc: Andy Gospodarek <agospoda@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/asm-generic/vmlinux.lds.h |    1 +
 kernel/module.c                   |    3 +++
 2 files changed, 4 insertions(+)

diff -puN include/asm-generic/vmlinux.lds.h~kernel-add-support-for-init_array-constructors include/asm-generic/vmlinux.lds.h
--- a/include/asm-generic/vmlinux.lds.h~kernel-add-support-for-init_array-constructors
+++ a/include/asm-generic/vmlinux.lds.h
@@ -473,6 +473,7 @@
 #define KERNEL_CTORS()	. = ALIGN(8);			   \
 			VMLINUX_SYMBOL(__ctors_start) = .; \
 			*(.ctors)			   \
+			*(.init_array)			   \
 			VMLINUX_SYMBOL(__ctors_end) = .;
 #else
 #define KERNEL_CTORS()
diff -puN kernel/module.c~kernel-add-support-for-init_array-constructors kernel/module.c
--- a/kernel/module.c~kernel-add-support-for-init_array-constructors
+++ a/kernel/module.c
@@ -2768,6 +2768,9 @@ static void find_module_sections(struct
 #ifdef CONFIG_CONSTRUCTORS
 	mod->ctors = section_objs(info, ".ctors",
 				  sizeof(*mod->ctors), &mod->num_ctors);
+	if (!mod->ctors)
+		mod->ctors = section_objs(info, ".init_array",
+				sizeof(*mod->ctors), &mod->num_ctors);
 #endif
 
 #ifdef CONFIG_TRACEPOINTS
_

Patches currently in -mm which might be from fhrbata@redhat.com are

gcov-move-gcov-structs-definitions-to-a-gcc-version-specific-file.patch
gcov-add-support-for-gcc-47-gcov-format.patch
gcov-add-support-for-gcc-47-gcov-format-fix.patch
gcov-add-support-for-gcc-47-gcov-format-fix-fix.patch
gcov-add-support-for-gcc-47-gcov-format-checkpatch-fixes.patch
gcov-add-support-for-gcc-47-gcov-format-fix-3.patch
gcov-compile-specific-gcov-implementation-based-on-gcc-version.patch
kernel-modulec-use-pr_foo.patch
kernel-gcov-fsc-use-pr_warn.patch
linux-next.patch

