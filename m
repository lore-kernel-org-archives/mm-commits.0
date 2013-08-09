From: akpm@linux-foundation.org
Subject: +
 syscallsh-use-gcc-alias-instead-of-assembler-aliases-for-syscalls.patch
 added to -mm tree
Date: Fri, 09 Aug 2013 12:51:59 -0700
Message-ID: <5205485f.Qjd2pzfJr21copqa%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:36893 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030968Ab3HITwA (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 9 Aug 2013 15:52:00 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, viro@ZenIV.linux.org.uk, geert@linux-m68k.org, ak@linux.intel.com

Subject: + syscallsh-use-gcc-alias-instead-of-assembler-aliases-for-syscalls.patch added to -mm tree
To: ak@linux.intel.com,geert@linux-m68k.org,viro@ZenIV.linux.org.uk
From: akpm@linux-foundation.org
Date: Fri, 09 Aug 2013 12:51:59 -0700


The patch titled
     Subject: syscalls.h: use gcc alias instead of assembler aliases for syscalls
has been added to the -mm tree.  Its filename is
     syscallsh-use-gcc-alias-instead-of-assembler-aliases-for-syscalls.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/syscallsh-use-gcc-alias-instead-of-assembler-aliases-for-syscalls.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/syscallsh-use-gcc-alias-instead-of-assembler-aliases-for-syscalls.patch

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

thp-account-anon-transparent-huge-pages-into-nr_anon_pages.patch
mm-cleanup-add_to_page_cache_locked.patch
thp-move-maybe_pmd_mkwrite-out-of-mk_huge_pmd.patch
thp-do_huge_pmd_anonymous_page-cleanup.patch
thp-consolidate-code-between-handle_mm_fault-and-do_huge_pmd_anonymous_page.patch
kernel-modsign_pubkeyc-fix-init-const-for-module-signing-code.patch
lto-watchdog-hpwdtc-make-assembler-label-global.patch
syscallsh-use-gcc-alias-instead-of-assembler-aliases-for-syscalls.patch
scripts-mod-modpostc-handle-non-abs-crc-symbols.patch
linux-next.patch

