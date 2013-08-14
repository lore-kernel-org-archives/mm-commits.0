From: akpm@linux-foundation.org
Subject: +
 cleanup-add-forward-declarations-for-inplace-syscall-wrappers.patch added
 to -mm tree
Date: Wed, 14 Aug 2013 14:17:26 -0700
Message-ID: <520bf3e6.4iEHcKpn+YtYl8C/%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:55397 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932914Ab3HNVR0 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 14 Aug 2013 17:17:26 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, viro@zeniv.linux.org.uk, slyfox@gentoo.org

Subject: + cleanup-add-forward-declarations-for-inplace-syscall-wrappers.patch added to -mm tree
To: slyfox@gentoo.org,viro@zeniv.linux.org.uk
From: akpm@linux-foundation.org
Date: Wed, 14 Aug 2013 14:17:26 -0700


The patch titled
     Subject: syscalls.h: add forward declarations for inplace syscall wrappers
has been added to the -mm tree.  Its filename is
     cleanup-add-forward-declarations-for-inplace-syscall-wrappers.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/cleanup-add-forward-declarations-for-inplace-syscall-wrappers.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/cleanup-add-forward-declarations-for-inplace-syscall-wrappers.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Sergei Trofimovich <slyfox@gentoo.org>
Subject: syscalls.h: add forward declarations for inplace syscall wrappers

Unclutter -Wmissing-prototypes warning types (enabled at make W=1)

    linux/include/linux/syscalls.h:190:18: warning: no previous prototype for 'SyS_semctl' [-Wmissing-prototypes]
      asmlinkage long SyS##name(__MAP(x,__SC_LONG,__VA_ARGS__)) \
                      ^
    linux/include/linux/syscalls.h:183:2: note: in expansion of macro '__SYSCALL_DEFINEx'
      __SYSCALL_DEFINEx(x, sname, __VA_ARGS__)
      ^
by adding forward declarations right before definitions.

Signed-off-by: Sergei Trofimovich <slyfox@gentoo.org>
Cc: Al Viro <viro@zeniv.linux.org.uk>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/compat.h   |    1 +
 include/linux/syscalls.h |    1 +
 2 files changed, 2 insertions(+)

diff -puN include/linux/compat.h~cleanup-add-forward-declarations-for-inplace-syscall-wrappers include/linux/compat.h
--- a/include/linux/compat.h~cleanup-add-forward-declarations-for-inplace-syscall-wrappers
+++ a/include/linux/compat.h
@@ -44,6 +44,7 @@
 	asmlinkage long compat_sys##name(__MAP(x,__SC_DECL,__VA_ARGS__))\
 		__attribute__((alias(__stringify(compat_SyS##name))));  \
 	static inline long C_SYSC##name(__MAP(x,__SC_DECL,__VA_ARGS__));\
+	asmlinkage long compat_SyS##name(__MAP(x,__SC_LONG,__VA_ARGS__));\
 	asmlinkage long compat_SyS##name(__MAP(x,__SC_LONG,__VA_ARGS__))\
 	{								\
 		return C_SYSC##name(__MAP(x,__SC_DELOUSE,__VA_ARGS__));	\
diff -puN include/linux/syscalls.h~cleanup-add-forward-declarations-for-inplace-syscall-wrappers include/linux/syscalls.h
--- a/include/linux/syscalls.h~cleanup-add-forward-declarations-for-inplace-syscall-wrappers
+++ a/include/linux/syscalls.h
@@ -187,6 +187,7 @@ extern struct trace_event_functions exit
 	asmlinkage long sys##name(__MAP(x,__SC_DECL,__VA_ARGS__))	\
 		__attribute__((alias(__stringify(SyS##name))));		\
 	static inline long SYSC##name(__MAP(x,__SC_DECL,__VA_ARGS__));	\
+	asmlinkage long SyS##name(__MAP(x,__SC_LONG,__VA_ARGS__));	\
 	asmlinkage long SyS##name(__MAP(x,__SC_LONG,__VA_ARGS__))	\
 	{								\
 		long ret = SYSC##name(__MAP(x,__SC_CAST,__VA_ARGS__));	\
_

Patches currently in -mm which might be from slyfox@gentoo.org are

cleanup-add-forward-declarations-for-inplace-syscall-wrappers.patch

