From: akpm@linux-foundation.org
Subject: + compilerh-add-__visible.patch added to -mm tree
Date: Thu, 06 Sep 2012 14:33:20 -0700
Message-ID: <20120906213321.11ECC5C0050@hpza9.eem.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-bk0-f74.google.com ([209.85.214.74]:36358 "EHLO
	mail-bk0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933279Ab2IFVdX (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 6 Sep 2012 17:33:23 -0400
Received: by bkcjc3 with SMTP id jc3so131481bkc.1
        for <mm-commits@vger.kernel.org>; Thu, 06 Sep 2012 14:33:22 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: ak@linux.intel.com


The patch titled
     Subject: compiler.h: add __visible
has been added to the -mm tree.  Its filename is
     compilerh-add-__visible.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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

compilerh-add-__visible.patch
linux-next.patch
thp-x86-introduce-have_arch_transparent_hugepage.patch
thp-remove-assumptions-on-pgtable_t-type.patch
thp-introduce-pmdp_invalidate.patch
thp-make-madv_hugepage-check-for-mm-def_flags.patch
thp-s390-thp-splitting-backend-for-s390.patch
thp-s390-thp-pagetable-pre-allocation-for-s390.patch
thp-s390-disable-thp-for-kvm-host-on-s390.patch
thp-s390-architecture-backend-for-thp-on-s390.patch

