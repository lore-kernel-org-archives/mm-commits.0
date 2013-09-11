From: akpm@linux-foundation.org
Subject: [failures]
 syscallsh-use-gcc-alias-instead-of-assembler-aliases-for-syscalls.patch
 removed from -mm tree
Date: Tue, 10 Sep 2013 17:22:52 -0700
Message-ID: <522fb7dc.048p6xMLSJhIrhvF%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:40723 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751338Ab3IKAWx (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 10 Sep 2013 20:22:53 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, viro@ZenIV.linux.org.uk, geert@linux-m68k.org, ak@linux.intel.com

Subject: [failures] syscallsh-use-gcc-alias-instead-of-assembler-aliases-for-syscalls.patch removed from -mm tree
To: ak@linux.intel.com,geert@linux-m68k.org,viro@ZenIV.linux.org.uk,mm-commits@vger.kernel.org
From: akpm@linux-foundation.org
Date: Tue, 10 Sep 2013 17:22:52 -0700


The patch titled
     Subject: syscalls.h: use gcc alias instead of assembler aliases for syscalls
has been removed from the -mm tree.  Its filename was
     syscallsh-use-gcc-alias-instead-of-assembler-aliases-for-syscalls.patch

This patch was dropped because it had testing failures

------------------------------------------------------
From: Andi Kleen <ak@linux.intel.com>
Subject: syscalls.h: use gcc alias instead of assembler aliases for syscalls

Use standard gcc __attribute__((alias(foo))) to define the syscall aliases
instead of custom assembler macros.

This is far cleaner, and also fixes my LTO kernel build.

Signed-off-by: Andi Kleen <ak@linux.intel.com>
Cc: Al Viro <viro@ZenIV.linux.org.uk>
Cc: Geert Uytterhoeven <geert@linux-m68k.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/compat.h   |    4 ++--
 include/linux/syscalls.h |    4 ++--
 2 files changed, 4 insertions(+), 4 deletions(-)

diff -puN include/linux/compat.h~syscallsh-use-gcc-alias-instead-of-assembler-aliases-for-syscalls include/linux/compat.h
--- a/include/linux/compat.h~syscallsh-use-gcc-alias-instead-of-assembler-aliases-for-syscalls
+++ a/include/linux/compat.h
@@ -41,13 +41,13 @@
 	COMPAT_SYSCALL_DEFINEx(6, _##name, __VA_ARGS__)
 
 #define COMPAT_SYSCALL_DEFINEx(x, name, ...)				\
-	asmlinkage long compat_sys##name(__MAP(x,__SC_DECL,__VA_ARGS__));\
+	asmlinkage long compat_sys##name(__MAP(x,__SC_DECL,__VA_ARGS__))\
+		__attribute__((alias(__stringify(compat_SyS##name))));  \
 	static inline long C_SYSC##name(__MAP(x,__SC_DECL,__VA_ARGS__));\
 	asmlinkage long compat_SyS##name(__MAP(x,__SC_LONG,__VA_ARGS__))\
 	{								\
 		return C_SYSC##name(__MAP(x,__SC_DELOUSE,__VA_ARGS__));	\
 	}								\
-	SYSCALL_ALIAS(compat_sys##name, compat_SyS##name);		\
 	static inline long C_SYSC##name(__MAP(x,__SC_DECL,__VA_ARGS__))
 
 #ifndef compat_user_stack_pointer
diff -puN include/linux/syscalls.h~syscallsh-use-gcc-alias-instead-of-assembler-aliases-for-syscalls include/linux/syscalls.h
--- a/include/linux/syscalls.h~syscallsh-use-gcc-alias-instead-of-assembler-aliases-for-syscalls
+++ a/include/linux/syscalls.h
@@ -184,7 +184,8 @@ extern struct trace_event_functions exit
 
 #define __PROTECT(...) asmlinkage_protect(__VA_ARGS__)
 #define __SYSCALL_DEFINEx(x, name, ...)					\
-	asmlinkage long sys##name(__MAP(x,__SC_DECL,__VA_ARGS__));	\
+	asmlinkage long sys##name(__MAP(x,__SC_DECL,__VA_ARGS__))	\
+		__attribute__((alias(__stringify(SyS##name))));		\
 	static inline long SYSC##name(__MAP(x,__SC_DECL,__VA_ARGS__));	\
 	asmlinkage long SyS##name(__MAP(x,__SC_LONG,__VA_ARGS__))	\
 	{								\
@@ -193,7 +194,6 @@ extern struct trace_event_functions exit
 		__PROTECT(x, ret,__MAP(x,__SC_ARGS,__VA_ARGS__));	\
 		return ret;						\
 	}								\
-	SYSCALL_ALIAS(sys##name, SyS##name);				\
 	static inline long SYSC##name(__MAP(x,__SC_DECL,__VA_ARGS__))
 
 asmlinkage long sys_time(time_t __user *tloc);
_

Patches currently in -mm which might be from ak@linux.intel.com are

origin.patch
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
scripts-mod-modpostc-handle-non-abs-crc-symbols.patch
x86-add-1-2-4-8-byte-optimization-to-64bit-__copy_fromto_user_inatomic.patch
thp-account-anon-transparent-huge-pages-into-nr_anon_pages.patch
mm-cleanup-add_to_page_cache_locked.patch
thp-move-maybe_pmd_mkwrite-out-of-mk_huge_pmd.patch
thp-do_huge_pmd_anonymous_page-cleanup.patch
thp-consolidate-code-between-handle_mm_fault-and-do_huge_pmd_anonymous_page.patch

