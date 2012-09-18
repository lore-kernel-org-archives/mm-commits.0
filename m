From: akpm@linux-foundation.org
Subject: [merged] compilerh-add-__visible.patch removed from -mm tree
Date: Tue, 18 Sep 2012 12:05:15 -0700
Message-ID: <20120918190515.98A64100047@wpzn3.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-yw0-f74.google.com ([209.85.213.74]:36077 "EHLO
	mail-yw0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754295Ab2IRTFQ (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 18 Sep 2012 15:05:16 -0400
Received: by mail-yw0-f74.google.com with SMTP id 10so27406yhl.1
        for <mm-commits@vger.kernel.org>; Tue, 18 Sep 2012 12:05:16 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: ak@linux.intel.com, mm-commits@vger.kernel.org


The patch titled
     Subject: compiler.h: add __visible
has been removed from the -mm tree.  Its filename was
     compilerh-add-__visible.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Andi Kleen <ak@linux.intel.com>
Subject: compiler.h: add __visible

gcc 4.6+ has support for a externally_visible attribute that prevents the
optimizer from optimizing unused symbols away.  Add a __visible macro to
use it with that compiler version or later.

This is used (at least) by the "Link Time Optimization" patchset.

Signed-off-by: Andi Kleen <ak@linux.intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/compiler-gcc4.h |    7 +++++++
 include/linux/compiler.h      |    4 ++++
 2 files changed, 11 insertions(+)

diff -puN include/linux/compiler-gcc4.h~compilerh-add-__visible include/linux/compiler-gcc4.h
--- a/include/linux/compiler-gcc4.h~compilerh-add-__visible
+++ a/include/linux/compiler-gcc4.h
@@ -49,6 +49,13 @@
 #endif
 #endif
 
+#if __GNUC_MINOR__ >= 6
+/*
+ * Tell the optimizer that something else uses this function or variable.
+ */
+#define __visible __attribute__((externally_visible))
+#endif
+
 #if __GNUC_MINOR__ > 0
 #define __compiletime_object_size(obj) __builtin_object_size(obj, 0)
 #endif
diff -puN include/linux/compiler.h~compilerh-add-__visible include/linux/compiler.h
--- a/include/linux/compiler.h~compilerh-add-__visible
+++ a/include/linux/compiler.h
@@ -278,6 +278,10 @@ void ftrace_likely_update(struct ftrace_
 # define __section(S) __attribute__ ((__section__(#S)))
 #endif
 
+#ifndef __visible
+#define __visible
+#endif
+
 /* Are two types/vars the same type (ignoring qualifiers)? */
 #ifndef __same_type
 # define __same_type(a, b) __builtin_types_compatible_p(typeof(a), typeof(b))
_

Patches currently in -mm which might be from ak@linux.intel.com are

origin.patch
linux-next.patch
thp-x86-introduce-have_arch_transparent_hugepage.patch
thp-remove-assumptions-on-pgtable_t-type.patch
thp-introduce-pmdp_invalidate.patch
thp-make-madv_hugepage-check-for-mm-def_flags.patch
thp-s390-thp-splitting-backend-for-s390.patch
thp-s390-thp-pagetable-pre-allocation-for-s390.patch
thp-s390-disable-thp-for-kvm-host-on-s390.patch
thp-s390-architecture-backend-for-thp-on-s390.patch
sections-disable-const-sections-for-pa-risc-v2.patch
sections-fix-section-conflicts-in-arch-arm.patch
sections-fix-section-conflicts-in-arch-frv.patch
sections-fix-section-conflicts-in-arch-h8300.patch
sections-fix-section-conflicts-in-arch-h8300-checkpatch-fixes.patch
sections-fix-section-conflicts-in-arch-ia64.patch
sections-fix-section-conflicts-in-arch-mips.patch
sections-fix-section-conflicts-in-arch-powerpc.patch
sections-fix-section-conflicts-in-arch-score.patch
sections-fix-section-conflicts-in-arch-sh.patch
sections-fix-section-conflicts-in-arch-x86.patch
sections-fix-section-conflicts-in-drivers-atm.patch
sections-fix-section-conflicts-in-drivers-char.patch
sections-fix-section-conflicts-in-drivers-ide.patch
sections-fix-section-conflicts-in-drivers-macintosh.patch
sections-fix-section-conflicts-in-drivers-macintosh-checkpatch-fixes.patch
sections-fix-section-conflicts-in-drivers-mfd.patch
sections-fix-section-conflicts-in-drivers-mmc.patch
sections-fix-section-conflicts-in-drivers-net.patch
sections-fix-section-conflicts-in-drivers-net-hamradio.patch
sections-fix-section-conflicts-in-drivers-net-wan.patch
sections-fix-section-conflicts-in-drivers-platform-x86.patch
sections-fix-section-conflicts-in-drivers-scsi.patch
sections-fix-section-conflicts-in-drivers-video.patch
sections-fix-section-conflicts-in-mm-percpuc.patch
sections-fix-section-conflicts-in-net-can.patch
sections-fix-section-conflicts-in-net.patch
sections-fix-section-conflicts-in-sound.patch
sectons-fix-const-sections-for-crc32-table.patch
sectons-fix-const-sections-for-crc32-table-checkpatch-fixes.patch
compat_ioctl-remove-unused-local-typedef.patch

