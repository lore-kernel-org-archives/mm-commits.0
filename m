From: akpm@linux-foundation.org
Subject: + add-a-rounddown_pow_of_two-routine-to-log2h.patch added to -mm tree
Date: Fri, 31 Aug 2007 12:17:17 -0700
Message-ID: <200708311917.l7VJHMVx022554@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:50960 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932850AbXHaTRZ (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 31 Aug 2007 15:17:25 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: rpjday@mindspring.com


The patch titled
     Add a "rounddown_pow_of_two" routine to log2.h
has been added to the -mm tree.  Its filename is
     add-a-rounddown_pow_of_two-routine-to-log2h.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: Add a "rounddown_pow_of_two" routine to log2.h
From: "Robert P. J. Day" <rpjday@mindspring.com>

To go along with the existing "roundup_pow_of_two" routine, add one for
rounding down since that operation appears to crop up on a regular basis in
the source tree.

Signed-off-by: Robert P. J. Day <rpjday@mindspring.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/log2.h |   25 +++++++++++++++++++++++++
 1 files changed, 25 insertions(+)

diff -puN include/linux/log2.h~add-a-rounddown_pow_of_two-routine-to-log2h include/linux/log2.h
--- a/include/linux/log2.h~add-a-rounddown_pow_of_two-routine-to-log2h
+++ a/include/linux/log2.h
@@ -63,6 +63,15 @@ unsigned long __roundup_pow_of_two(unsig
 	return 1UL << fls_long(n - 1);
 }
 
+/*
+ * round down to nearest power of two
+ */
+static inline __attribute__((const))
+unsigned long __rounddown_pow_of_two(unsigned long n)
+{
+	return 1UL << (fls_long(n) - 1);
+}
+
 /**
  * ilog2 - log of base 2 of 32-bit or a 64-bit unsigned value
  * @n - parameter
@@ -165,4 +174,20 @@ unsigned long __roundup_pow_of_two(unsig
 	__roundup_pow_of_two(n)			\
  )
 
+/**
+ * rounddown_pow_of_two - round the given value down to nearest power of two
+ * @n - parameter
+ *
+ * round the given value down to the nearest power of two
+ * - the result is undefined when n == 0
+ * - this can be used to initialise global variables from constant data
+ */
+#define rounddown_pow_of_two(n)			\
+(						\
+	__builtin_constant_p(n) ? (		\
+		(n == 1) ? 0 :			\
+		(1UL << ilog2(n)) :		\
+	__rounddown_pow_of_two(n)		\
+ )
+
 #endif /* _LINUX_LOG2_H */
_

Patches currently in -mm which might be from rpjday@mindspring.com are

git-kvm.patch
git-mtd.patch
pcmcia-delete-obsolete-pcmcia_ioctl-feature.patch
remove-dead-references-to-module_parm-macro.patch
m68knommu-remove-unused-config-symbol-config_disktel.patch
force-erroneous-inclusions-of-compiler-h-files-to-be-errors.patch
force-erroneous-inclusions-of-compiler-h-files-to-be-errors-fix.patch
kconfig-make-instrumentation-support-non-experimental.patch
remove-superfluous-definition-of-__setup_null_param-macro-and-broken-for-module-__setup_param.patch
remove-valueless-definition-of-hard-selected-ramfs-option.patch
remove-final-traces-of-long-deprecated-ramdisk-kernel.patch
add-a-rounddown_pow_of_two-routine-to-log2h.patch
