From: akpm@linux-foundation.org
Subject: +
 x86-add-1-2-4-8-byte-optimization-to-64bit-__copy_fromto_user_inatomic.patch added to -mm tree
Date: Tue, 20 Aug 2013 13:12:25 -0700
Message-ID: <5213cda9.dL1Rei2oPFMvAGez%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:37021 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751112Ab3HTUM0 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 20 Aug 2013 16:12:26 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, tglx@linutronix.de, mingo@elte.hu, hpa@zytor.com, a.p.zijlstra@chello.nl, ak@linux.intel.com

Subject: + x86-add-1-2-4-8-byte-optimization-to-64bit-__copy_fromto_user_inatomic.patch added to -mm tree
To: ak@linux.intel.com,a.p.zijlstra@chello.nl,hpa@zytor.com,mingo@elte.hu,tglx@linutronix.de
From: akpm@linux-foundation.org
Date: Tue, 20 Aug 2013 13:12:25 -0700


The patch titled
     Subject: x86: add 1/2/4/8 byte optimization to 64bit __copy_{from,to}_user_inatomic
has been added to the -mm tree.  Its filename is
     x86-add-1-2-4-8-byte-optimization-to-64bit-__copy_fromto_user_inatomic.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/x86-add-1-2-4-8-byte-optimization-to-64bit-__copy_fromto_user_inatomic.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/x86-add-1-2-4-8-byte-optimization-to-64bit-__copy_fromto_user_inatomic.patch

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
Subject: x86: add 1/2/4/8 byte optimization to 64bit __copy_{from,to}_user_inatomic

The 64bit __copy_{from,to}_user_inatomic always called
copy_from_user_generic, but skipped the special optimizations for 1/2/4/8
byte accesses.

This especially hurts the futex call, which accesses the 4 byte futex user
value with a complicated fast string operation in a function call, instead
of a single movl.

Use __copy_{from,to}_user for _inatomic instead to get the same
optimizations.  The only problem was the might_fault() in those functions.
 So move that to new wrapper and call __copy_{f,t}_user_nocheck() from
*_inatomic directly.

32bit already did this correctly by duplicating the code.

Signed-off-by: Andi Kleen <ak@linux.intel.com>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: "H. Peter Anvin" <hpa@zytor.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/x86/include/asm/uaccess_64.h |   24 ++++++++++++++++++------
 1 file changed, 18 insertions(+), 6 deletions(-)

diff -puN arch/x86/include/asm/uaccess_64.h~x86-add-1-2-4-8-byte-optimization-to-64bit-__copy_fromto_user_inatomic arch/x86/include/asm/uaccess_64.h
--- a/arch/x86/include/asm/uaccess_64.h~x86-add-1-2-4-8-byte-optimization-to-64bit-__copy_fromto_user_inatomic
+++ a/arch/x86/include/asm/uaccess_64.h
@@ -77,11 +77,10 @@ int copy_to_user(void __user *dst, const
 }
 
 static __always_inline __must_check
-int __copy_from_user(void *dst, const void __user *src, unsigned size)
+int __copy_from_user_nocheck(void *dst, const void __user *src, unsigned size)
 {
 	int ret = 0;
 
-	might_fault();
 	if (!__builtin_constant_p(size))
 		return copy_user_generic(dst, (__force void *)src, size);
 	switch (size) {
@@ -121,11 +120,17 @@ int __copy_from_user(void *dst, const vo
 }
 
 static __always_inline __must_check
-int __copy_to_user(void __user *dst, const void *src, unsigned size)
+int __copy_from_user(void *dst, const void __user *src, unsigned size)
+{
+	might_fault();
+	return __copy_from_user_nocheck(dst, src, size);
+}
+
+static __always_inline __must_check
+int __copy_to_user_nocheck(void __user *dst, const void *src, unsigned size)
 {
 	int ret = 0;
 
-	might_fault();
 	if (!__builtin_constant_p(size))
 		return copy_user_generic((__force void *)dst, src, size);
 	switch (size) {
@@ -165,6 +170,13 @@ int __copy_to_user(void __user *dst, con
 }
 
 static __always_inline __must_check
+int __copy_to_user(void __user *dst, const void *src, unsigned size)
+{
+	might_fault();
+	return __copy_to_user_nocheck(dst, src, size);
+}
+
+static __always_inline __must_check
 int __copy_in_user(void __user *dst, const void __user *src, unsigned size)
 {
 	int ret = 0;
@@ -220,13 +232,13 @@ int __copy_in_user(void __user *dst, con
 static __must_check __always_inline int
 __copy_from_user_inatomic(void *dst, const void __user *src, unsigned size)
 {
-	return copy_user_generic(dst, (__force const void *)src, size);
+	return __copy_from_user_nocheck(dst, (__force const void *)src, size);
 }
 
 static __must_check __always_inline int
 __copy_to_user_inatomic(void __user *dst, const void *src, unsigned size)
 {
-	return copy_user_generic((__force void *)dst, src, size);
+	return __copy_to_user_nocheck((__force void *)dst, src, size);
 }
 
 extern long __copy_user_nocache(void *dst, const void __user *src,
_

Patches currently in -mm which might be from ak@linux.intel.com are

thp-account-anon-transparent-huge-pages-into-nr_anon_pages.patch
mm-cleanup-add_to_page_cache_locked.patch
thp-move-maybe_pmd_mkwrite-out-of-mk_huge_pmd.patch
thp-do_huge_pmd_anonymous_page-cleanup.patch
thp-consolidate-code-between-handle_mm_fault-and-do_huge_pmd_anonymous_page.patch
mm-migrate-make-core-migration-code-aware-of-hugepage.patch
mm-soft-offline-use-migrate_pages-instead-of-migrate_huge_page.patch
migrate-add-hugepage-migration-code-to-migrate_pages.patch
mm-migrate-add-hugepage-migration-code-to-move_pages.patch
mm-mbind-add-hugepage-migration-code-to-mbind.patch
mm-migrate-remove-vm_hugetlb-from-vma-flag-check-in-vma_migratable.patch
mm-memory-hotplug-enable-memory-hotplug-to-handle-hugepage.patch
mm-migrate-check-movability-of-hugepage-in-unmap_and_move_huge_page.patch
mm-prepare-to-remove-proc-sys-vm-hugepages_treat_as_movable.patch
mm-prepare-to-remove-proc-sys-vm-hugepages_treat_as_movable-v2.patch
mm-mempolicy-rename-check_range-to-queue_pages_range.patch
kernel-modsign_pubkeyc-fix-init-const-for-module-signing-code.patch
lto-watchdog-hpwdtc-make-assembler-label-global.patch
syscallsh-use-gcc-alias-instead-of-assembler-aliases-for-syscalls.patch
scripts-mod-modpostc-handle-non-abs-crc-symbols.patch
x86-add-1-2-4-8-byte-optimization-to-64bit-__copy_fromto_user_inatomic.patch
x86-include-linux-schedh-in-asm-uaccessh.patch
tree-sweep-include-linux-schedh-for-might_sleep-users.patch
move-might_sleep-and-friends-from-kernelh-to-schedh.patch
sched-mark-should_resched-__always_inline.patch
sched-inline-the-need_resched-test-into-the-caller-for-_cond_resched.patch
linux-next.patch

