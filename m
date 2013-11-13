From: akpm@linux-foundation.org
Subject: [merged]
 syscallsh-use-gcc-alias-instead-of-assembler-aliases-for-syscalls.patch
 removed from -mm tree
Date: Wed, 13 Nov 2013 12:39:50 -0800
Message-ID: <5283e396.oHJzxBXO4TU+NUY7%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:42855 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751631Ab3KMUjv (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 13 Nov 2013 15:39:51 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, viro@ZenIV.linux.org.uk, penguin-kernel@i-love.sakura.ne.jp, geert@linux-m68k.org, ak@linux.intel.com

Subject: [merged] syscallsh-use-gcc-alias-instead-of-assembler-aliases-for-syscalls.patch removed from -mm tree
To: ak@linux.intel.com,geert@linux-m68k.org,penguin-kernel@i-love.sakura.ne.jp,viro@ZenIV.linux.org.uk,mm-commits@vger.kernel.org
From: akpm@linux-foundation.org
Date: Wed, 13 Nov 2013 12:39:50 -0800


The patch titled
     Subject: syscalls.h: use gcc alias instead of assembler aliases for syscalls
has been removed from the -mm tree.  Its filename was
     syscallsh-use-gcc-alias-instead-of-assembler-aliases-for-syscalls.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Andi Kleen <ak@linux.intel.com>
Subject: syscalls.h: use gcc alias instead of assembler aliases for syscalls

Use standard gcc __attribute__((alias(foo))) to define the syscall aliases
instead of custom assembler macros.

This is far cleaner, and also fixes my LTO kernel build.

Signed-off-by: Andi Kleen <ak@linux.intel.com>
Cc: Al Viro <viro@ZenIV.linux.org.uk>
Cc: Geert Uytterhoeven <geert@linux-m68k.org>
Cc: Tetsuo Handa <penguin-kernel@i-love.sakura.ne.jp>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/compat.h   |    4 ++--
 include/linux/syscalls.h |    4 ++--
 2 files changed, 4 insertions(+), 4 deletions(-)

diff -puN include/linux/compat.h~syscallsh-use-gcc-alias-instead-of-assembler-aliases-for-syscalls include/linux/compat.h
--- a/include/linux/compat.h~syscallsh-use-gcc-alias-instead-of-assembler-aliases-for-syscalls
+++ a/include/linux/compat.h
@@ -41,14 +41,14 @@
 	COMPAT_SYSCALL_DEFINEx(6, _##name, __VA_ARGS__)
 
 #define COMPAT_SYSCALL_DEFINEx(x, name, ...)				\
-	asmlinkage long compat_sys##name(__MAP(x,__SC_DECL,__VA_ARGS__));\
+	asmlinkage long compat_sys##name(__MAP(x,__SC_DECL,__VA_ARGS__))\
+		__attribute__((alias(__stringify(compat_SyS##name))));  \
 	static inline long C_SYSC##name(__MAP(x,__SC_DECL,__VA_ARGS__));\
 	asmlinkage long compat_SyS##name(__MAP(x,__SC_LONG,__VA_ARGS__));\
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
 	asmlinkage long SyS##name(__MAP(x,__SC_LONG,__VA_ARGS__));	\
 	asmlinkage long SyS##name(__MAP(x,__SC_LONG,__VA_ARGS__))	\
@@ -194,7 +195,6 @@ extern struct trace_event_functions exit
 		__PROTECT(x, ret,__MAP(x,__SC_ARGS,__VA_ARGS__));	\
 		return ret;						\
 	}								\
-	SYSCALL_ALIAS(sys##name, SyS##name);				\
 	static inline long SYSC##name(__MAP(x,__SC_DECL,__VA_ARGS__))
 
 asmlinkage long sys_time(time_t __user *tloc);
_

Patches currently in -mm which might be from ak@linux.intel.com are

origin.patch
linux-next.patch
mm-avoid-increase-sizeofstruct-page-due-to-split-page-table-lock.patch
mm-rename-use_split_ptlocks-to-use_split_pte_ptlocks.patch
mm-convert-mm-nr_ptes-to-atomic_long_t.patch
mm-introduce-api-for-split-page-table-lock-for-pmd-level.patch
mm-thp-change-pmd_trans_huge_lock-to-return-taken-lock.patch
mm-thp-move-ptl-taking-inside-page_check_address_pmd.patch
mm-thp-do-not-access-mm-pmd_huge_pte-directly.patch
mm-hugetlb-convert-hugetlbfs-to-use-split-pmd-lock.patch
mm-convert-the-rest-to-new-page-table-lock-api.patch
mm-implement-split-page-table-lock-for-pmd-level.patch
x86-mm-enable-split-page-table-lock-for-pmd-level.patch

