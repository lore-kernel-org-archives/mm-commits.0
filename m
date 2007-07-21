From: akpm@linux-foundation.org
Subject: - frv-fix-linkage-problems.patch removed from -mm tree
Date: Sat, 21 Jul 2007 03:25:07 -0700
Message-ID: <200707211025.l6LAP7s6011968@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:40522 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S933252AbXGUKZu (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Sat, 21 Jul 2007 06:25:50 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: dhowells@redhat.com, roland@redhat.com, mm-commits@vger.kernel.org


The patch titled
     FRV: Fix linkage problems
has been removed from the -mm tree.  Its filename was
     frv-fix-linkage-problems.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: FRV: Fix linkage problems
From: David Howells <dhowells@redhat.com>

Make it possible to use __start_notes and __stop_notes without getting a
GPREL overflow error from the FRV linker.

Small variables that would otherwise be in .data or .bss may, depending on
the arch, be placed in special sections (.sdata or .sbss) that permit
single instruction references on fixed instruction width machines.

__start_notes and __stop_notes aren't really char variables, and certainly
don't refer to data in .data or .bss.  Making them type "void" fools the
compiler into not assuming anything about them.

Signed-off-by: David Howells <dhowells@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/ksysfs.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff -puN kernel/ksysfs.c~frv-fix-linkage-problems kernel/ksysfs.c
--- a/kernel/ksysfs.c~frv-fix-linkage-problems
+++ a/kernel/ksysfs.c
@@ -65,8 +65,8 @@ KERNEL_ATTR_RO(kexec_crash_loaded);
 /*
  * Make /sys/kernel/notes give the raw contents of our kernel .notes section.
  */
-extern const char __start_notes __attribute__((weak));
-extern const char __stop_notes __attribute__((weak));
+extern const void __start_notes __attribute__((weak));
+extern const void __stop_notes __attribute__((weak));
 #define	notes_size (&__stop_notes - &__start_notes)
 
 static ssize_t notes_read(struct kobject *kobj, struct bin_attribute *bin_attr,
_

Patches currently in -mm which might be from dhowells@redhat.com are

origin.patch
nommu-vmalloc_32_user-vm_insert_page-and-symbol-exports.patch
