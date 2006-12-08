From: akpm@osdl.org
Subject: - log2-alter-roundup_pow_of_two-so-that-it-can-use-a-ilog2-on-a-constant.patch removed from -mm tree
Date: Fri, 08 Dec 2006 12:05:35 -0800
Message-ID: <200612082005.kB8K5Zl3002317@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.25]:57533 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1426326AbWLHUFp (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Fri, 8 Dec 2006 15:05:45 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: dhowells@redhat.com, benh@kernel.crashing.org, paulus@samba.org, mm-commits@vger.kernel.org


The patch titled
     LOG2: Alter roundup_pow_of_two() so that it can use a ilog2() on a constant
has been removed from the -mm tree.  Its filename was
     log2-alter-roundup_pow_of_two-so-that-it-can-use-a-ilog2-on-a-constant.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: LOG2: Alter roundup_pow_of_two() so that it can use a ilog2() on a constant
From: David Howells <dhowells@redhat.com>

Alter roundup_pow_of_two() so that it can make use of ilog2() on a constant to
produce a constant value, retaining the ability for an arch to override it in
the non-const case.

This permits the function to be used to initialise variables.

Signed-off-by: David Howells <dhowells@redhat.com>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: Paul Mackerras <paulus@samba.org>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 include/linux/kernel.h |    6 ------
 include/linux/log2.h   |   26 ++++++++++++++++++++++++++
 2 files changed, 26 insertions(+), 6 deletions(-)

diff -puN include/linux/kernel.h~log2-alter-roundup_pow_of_two-so-that-it-can-use-a-ilog2-on-a-constant include/linux/kernel.h
--- a/include/linux/kernel.h~log2-alter-roundup_pow_of_two-so-that-it-can-use-a-ilog2-on-a-constant
+++ a/include/linux/kernel.h
@@ -158,12 +158,6 @@ static inline int printk(const char *s, 
 
 unsigned long int_sqrt(unsigned long);
 
-static inline unsigned long
-__attribute_const__ roundup_pow_of_two(unsigned long x)
-{
-	return 1UL << fls_long(x - 1);
-}
-
 extern int printk_ratelimit(void);
 extern int __printk_ratelimit(int ratelimit_jiffies, int ratelimit_burst);
 extern bool printk_timed_ratelimit(unsigned long *caller_jiffies,
diff -puN include/linux/log2.h~log2-alter-roundup_pow_of_two-so-that-it-can-use-a-ilog2-on-a-constant include/linux/log2.h
--- a/include/linux/log2.h~log2-alter-roundup_pow_of_two-so-that-it-can-use-a-ilog2-on-a-constant
+++ a/include/linux/log2.h
@@ -43,6 +43,15 @@ int __ilog2_u64(u64 n)
 }
 #endif
 
+/*
+ * round up to nearest power of two
+ */
+static inline __attribute__((const))
+unsigned long __roundup_pow_of_two(unsigned long n)
+{
+	return 1UL << fls_long(n - 1);
+}
+
 /**
  * ilog2 - log of base 2 of 32-bit or a 64-bit unsigned value
  * @n - parameter
@@ -128,4 +137,21 @@ int __ilog2_u64(u64 n)
 	__ilog2_u64(n)				\
  )
 
+/**
+ * roundup_pow_of_two - round the given value up to nearest power of two
+ * @n - parameter
+ *
+ * round the given balue up to the nearest power of two
+ * - the result is undefined when n == 0
+ * - this can be used to initialise global variables from constant data
+ */
+#define roundup_pow_of_two(n)			\
+(						\
+	__builtin_constant_p(n) ? (		\
+		(n == 1) ? 0 :			\
+		(1UL << (ilog2((n) - 1) + 1))	\
+				   ) :		\
+	__roundup_pow_of_two(n)			\
+ )
+
 #endif /* _LINUX_LOG2_H */
_

Patches currently in -mm which might be from dhowells@redhat.com are

origin.patch
log2-alter-roundup_pow_of_two-so-that-it-can-use-a-ilog2-on-a-constant.patch
log2-alter-get_order-so-that-it-can-make-use-of-ilog2-on-a-constant.patch
log2-provide-ilog2-fallbacks-for-powerpc.patch
alsa-workqueue-fixes.patch
nfs-represent-64-bit-fileids-as-64-bit-inode-numbers-on-32-bit-systems.patch
s390-workqueue-fixes.patch
doc-atomic_add_unless-doesnt-imply-mb-on-failure.patch
ecryptfs-public-key-transport-mechanism.patch
ecryptfs-public-key-packet-management.patch
workstruct-implement-generic-up-cmpxchg-where-an-arch-doesnt-support-it.patch
workqueue-tweaks.patch
workqueue-dont-hold-workqueue_mutex-in-flush_scheduled_work.patch
reiser4-get_sb_dev-fix.patch
mutex-subsystem-synchro-test-module.patch

