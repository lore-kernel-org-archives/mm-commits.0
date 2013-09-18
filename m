From: akpm@linux-foundation.org
Subject: + kernel-add-support-for-init_array-constructors.patch added to
 -mm tree
Date: Wed, 18 Sep 2013 14:24:22 -0700
Message-ID: <523a1a06.uzozaOO3VGvfGjwA%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:46618 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753917Ab3IRVYX (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 18 Sep 2013 17:24:23 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, rusty@rustcorp.com.au, peter.oberparleiter@de.ibm.com, keescook@chromium.org, jstancek@redhat.com, arnd@arndb.de, agospoda@redhat.com, fhrbata@redhat.com

Subject: + kernel-add-support-for-init_array-constructors.patch added to -mm tree
To: fhrbata@redhat.com,agospoda@redhat.com,arnd@arndb.de,jstancek@redhat.com,keescook@chromium.org,peter.oberparleiter@de.ibm.com,rusty@rustcorp.com.au
From: akpm@linux-foundation.org
Date: Wed, 18 Sep 2013 14:24:22 -0700


The patch titled
     Subject: kernel: add support for init_array constructors
has been added to the -mm tree.  Its filename is
     kernel-add-support-for-init_array-constructors.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/kernel-add-support-for-init_array-constructors.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/kernel-add-support-for-init_array-constructors.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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
gcov-compile-specific-gcov-implementation-based-on-gcc-version.patch
kernel-add-support-for-init_array-constructors.patch

