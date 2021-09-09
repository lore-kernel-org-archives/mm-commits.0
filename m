Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E3AF4C433F5
	for <mm-commits@archiver.kernel.org>; Thu,  9 Sep 2021 21:06:16 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id CCE50611C3
	for <mm-commits@archiver.kernel.org>; Thu,  9 Sep 2021 21:06:16 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348379AbhIIVH0 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 9 Sep 2021 17:07:26 -0400
Received: from mail.kernel.org ([198.145.29.99]:57066 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1348070AbhIIVHL (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Thu, 9 Sep 2021 17:07:11 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id C7BAB611AF;
        Thu,  9 Sep 2021 21:06:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1631221561;
        bh=frGYscAxYdnM3eaqxpTdOOxv9xm6aOA0jAzLOp3X0Po=;
        h=Date:From:To:Subject:From;
        b=GdFnTwkfR6MCmEcQxRx9Umrd+qWAEK6DVpCdUX78N94vd2RuSxcx8h17YAePGa/C0
         bn5X3iz/fxSzkMjwOFbrqJISQrJyqpffvAgdMqQz2VuEk9Y45/2nOnggkD4szl7lFB
         InY/5/m3xBbNI9mjHaXU1+pTVOHcpXPrSaBQsBDg=
Date:   Thu, 09 Sep 2021 14:06:00 -0700
From:   akpm@linux-foundation.org
To:     arnd@arndb.de, benh@kernel.crashing.org, borntraeger@de.ibm.com,
        bp@alien8.de, catalin.marinas@arm.com, davem@davemloft.net,
        deller@gmx.de, ebiederm@xmission.com, feng.tang@intel.com,
        gor@linux.ibm.com, hca@linux.ibm.com, hch@infradead.org,
        hch@lst.de, hpa@zytor.com, James.Bottomley@HansenPartnership.com,
        mingo@redhat.com, mm-commits@vger.kernel.org, mpe@ellerman.id.au,
        paulus@samba.org, tglx@linutronix.de, tsbogend@alpha.franken.de,
        viro@zeniv.linux.org.uk, will@kernel.org
Subject:  [merged] compat-remove-some-compat-entry-points.patch
 removed from -mm tree
Message-ID: <20210909210600.f2NEiR_fc%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: compat: remove some compat entry points
has been removed from the -mm tree.  Its filename was
     compat-remove-some-compat-entry-points.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Arnd Bergmann <arnd@arndb.de>
Subject: compat: remove some compat entry points

These are all handled correctly when calling the native system call entry
point, so remove the special cases.

Link: https://lkml.kernel.org/r/20210727144859.4150043-6-arnd@kernel.org
Signed-off-by: Arnd Bergmann <arnd@arndb.de>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Cc: Al Viro <viro@zeniv.linux.org.uk>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: Borislav Petkov <bp@alien8.de>
Cc: Catalin Marinas <catalin.marinas@arm.com>
Cc: Christian Borntraeger <borntraeger@de.ibm.com>
Cc: Christoph Hellwig <hch@infradead.org>
Cc: "David S. Miller" <davem@davemloft.net>
Cc: Eric Biederman <ebiederm@xmission.com>
Cc: Feng Tang <feng.tang@intel.com>
Cc: Heiko Carstens <hca@linux.ibm.com>
Cc: Helge Deller <deller@gmx.de>
Cc: "H. Peter Anvin" <hpa@zytor.com>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: "James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>
Cc: Michael Ellerman <mpe@ellerman.id.au>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Thomas Bogendoerfer <tsbogend@alpha.franken.de>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Vasily Gorbik <gor@linux.ibm.com>
Cc: Will Deacon <will@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/arm64/include/asm/unistd32.h         |   10 ++---
 arch/mips/kernel/syscalls/syscall_n32.tbl |   10 ++---
 arch/mips/kernel/syscalls/syscall_o32.tbl |   10 ++---
 arch/parisc/kernel/syscalls/syscall.tbl   |    8 ++--
 arch/powerpc/kernel/syscalls/syscall.tbl  |   10 ++---
 arch/s390/kernel/syscalls/syscall.tbl     |   10 ++---
 arch/sparc/kernel/syscalls/syscall.tbl    |   10 ++---
 arch/x86/entry/syscalls/syscall_32.tbl    |    4 +-
 arch/x86/entry/syscalls/syscall_64.tbl    |    2 -
 include/linux/compat.h                    |   20 ----------
 include/uapi/asm-generic/unistd.h         |   10 ++---
 kernel/sys_ni.c                           |    5 --
 mm/mempolicy.c                            |   37 --------------------
 mm/migrate.c                              |   13 -------
 14 files changed, 42 insertions(+), 117 deletions(-)

--- a/arch/arm64/include/asm/unistd32.h~compat-remove-some-compat-entry-points
+++ a/arch/arm64/include/asm/unistd32.h
@@ -649,11 +649,11 @@ __SYSCALL(__NR_inotify_add_watch, sys_in
 #define __NR_inotify_rm_watch 318
 __SYSCALL(__NR_inotify_rm_watch, sys_inotify_rm_watch)
 #define __NR_mbind 319
-__SYSCALL(__NR_mbind, compat_sys_mbind)
+__SYSCALL(__NR_mbind, sys_mbind)
 #define __NR_get_mempolicy 320
-__SYSCALL(__NR_get_mempolicy, compat_sys_get_mempolicy)
+__SYSCALL(__NR_get_mempolicy, sys_get_mempolicy)
 #define __NR_set_mempolicy 321
-__SYSCALL(__NR_set_mempolicy, compat_sys_set_mempolicy)
+__SYSCALL(__NR_set_mempolicy, sys_set_mempolicy)
 #define __NR_openat 322
 __SYSCALL(__NR_openat, compat_sys_openat)
 #define __NR_mkdirat 323
@@ -699,7 +699,7 @@ __SYSCALL(__NR_tee, sys_tee)
 #define __NR_vmsplice 343
 __SYSCALL(__NR_vmsplice, sys_vmsplice)
 #define __NR_move_pages 344
-__SYSCALL(__NR_move_pages, compat_sys_move_pages)
+__SYSCALL(__NR_move_pages, sys_move_pages)
 #define __NR_getcpu 345
 __SYSCALL(__NR_getcpu, sys_getcpu)
 #define __NR_epoll_pwait 346
@@ -811,7 +811,7 @@ __SYSCALL(__NR_rseq, sys_rseq)
 #define __NR_io_pgetevents 399
 __SYSCALL(__NR_io_pgetevents, compat_sys_io_pgetevents)
 #define __NR_migrate_pages 400
-__SYSCALL(__NR_migrate_pages, compat_sys_migrate_pages)
+__SYSCALL(__NR_migrate_pages, sys_migrate_pages)
 #define __NR_kexec_file_load 401
 __SYSCALL(__NR_kexec_file_load, sys_kexec_file_load)
 /* 402 is unused */
--- a/arch/mips/kernel/syscalls/syscall_n32.tbl~compat-remove-some-compat-entry-points
+++ a/arch/mips/kernel/syscalls/syscall_n32.tbl
@@ -239,9 +239,9 @@
 228	n32	clock_nanosleep			sys_clock_nanosleep_time32
 229	n32	tgkill				sys_tgkill
 230	n32	utimes				sys_utimes_time32
-231	n32	mbind				compat_sys_mbind
-232	n32	get_mempolicy			compat_sys_get_mempolicy
-233	n32	set_mempolicy			compat_sys_set_mempolicy
+231	n32	mbind				sys_mbind
+232	n32	get_mempolicy			sys_get_mempolicy
+233	n32	set_mempolicy			sys_set_mempolicy
 234	n32	mq_open				compat_sys_mq_open
 235	n32	mq_unlink			sys_mq_unlink
 236	n32	mq_timedsend			sys_mq_timedsend_time32
@@ -258,7 +258,7 @@
 247	n32	inotify_init			sys_inotify_init
 248	n32	inotify_add_watch		sys_inotify_add_watch
 249	n32	inotify_rm_watch		sys_inotify_rm_watch
-250	n32	migrate_pages			compat_sys_migrate_pages
+250	n32	migrate_pages			sys_migrate_pages
 251	n32	openat				sys_openat
 252	n32	mkdirat				sys_mkdirat
 253	n32	mknodat				sys_mknodat
@@ -279,7 +279,7 @@
 268	n32	sync_file_range			sys_sync_file_range
 269	n32	tee				sys_tee
 270	n32	vmsplice			sys_vmsplice
-271	n32	move_pages			compat_sys_move_pages
+271	n32	move_pages			sys_move_pages
 272	n32	set_robust_list			compat_sys_set_robust_list
 273	n32	get_robust_list			compat_sys_get_robust_list
 274	n32	kexec_load			compat_sys_kexec_load
--- a/arch/mips/kernel/syscalls/syscall_o32.tbl~compat-remove-some-compat-entry-points
+++ a/arch/mips/kernel/syscalls/syscall_o32.tbl
@@ -279,9 +279,9 @@
 265	o32	clock_nanosleep			sys_clock_nanosleep_time32
 266	o32	tgkill				sys_tgkill
 267	o32	utimes				sys_utimes_time32
-268	o32	mbind				sys_mbind			compat_sys_mbind
-269	o32	get_mempolicy			sys_get_mempolicy		compat_sys_get_mempolicy
-270	o32	set_mempolicy			sys_set_mempolicy		compat_sys_set_mempolicy
+268	o32	mbind				sys_mbind
+269	o32	get_mempolicy			sys_get_mempolicy
+270	o32	set_mempolicy			sys_set_mempolicy
 271	o32	mq_open				sys_mq_open			compat_sys_mq_open
 272	o32	mq_unlink			sys_mq_unlink
 273	o32	mq_timedsend			sys_mq_timedsend_time32
@@ -298,7 +298,7 @@
 284	o32	inotify_init			sys_inotify_init
 285	o32	inotify_add_watch		sys_inotify_add_watch
 286	o32	inotify_rm_watch		sys_inotify_rm_watch
-287	o32	migrate_pages			sys_migrate_pages		compat_sys_migrate_pages
+287	o32	migrate_pages			sys_migrate_pages
 288	o32	openat				sys_openat			compat_sys_openat
 289	o32	mkdirat				sys_mkdirat
 290	o32	mknodat				sys_mknodat
@@ -319,7 +319,7 @@
 305	o32	sync_file_range			sys_sync_file_range		sys32_sync_file_range
 306	o32	tee				sys_tee
 307	o32	vmsplice			sys_vmsplice
-308	o32	move_pages			sys_move_pages			compat_sys_move_pages
+308	o32	move_pages			sys_move_pages
 309	o32	set_robust_list			sys_set_robust_list		compat_sys_set_robust_list
 310	o32	get_robust_list			sys_get_robust_list		compat_sys_get_robust_list
 311	o32	kexec_load			sys_kexec_load			compat_sys_kexec_load
--- a/arch/parisc/kernel/syscalls/syscall.tbl~compat-remove-some-compat-entry-points
+++ a/arch/parisc/kernel/syscalls/syscall.tbl
@@ -292,9 +292,9 @@
 258	32	clock_nanosleep		sys_clock_nanosleep_time32
 258	64	clock_nanosleep		sys_clock_nanosleep
 259	common	tgkill			sys_tgkill
-260	common	mbind			sys_mbind			compat_sys_mbind
-261	common	get_mempolicy		sys_get_mempolicy		compat_sys_get_mempolicy
-262	common	set_mempolicy		sys_set_mempolicy		compat_sys_set_mempolicy
+260	common	mbind			sys_mbind
+261	common	get_mempolicy		sys_get_mempolicy
+262	common	set_mempolicy		sys_set_mempolicy
 # 263 was vserver
 264	common	add_key			sys_add_key
 265	common	request_key		sys_request_key
@@ -331,7 +331,7 @@
 292	64	sync_file_range		sys_sync_file_range
 293	common	tee			sys_tee
 294	common	vmsplice		sys_vmsplice
-295	common	move_pages		sys_move_pages			compat_sys_move_pages
+295	common	move_pages		sys_move_pages
 296	common	getcpu			sys_getcpu
 297	common	epoll_pwait		sys_epoll_pwait			compat_sys_epoll_pwait
 298	common	statfs64		sys_statfs64			compat_sys_statfs64
--- a/arch/powerpc/kernel/syscalls/syscall.tbl~compat-remove-some-compat-entry-points
+++ a/arch/powerpc/kernel/syscalls/syscall.tbl
@@ -330,10 +330,10 @@
 256	64	sys_debug_setcontext		sys_ni_syscall
 256	spu	sys_debug_setcontext		sys_ni_syscall
 # 257 reserved for vserver
-258	nospu	migrate_pages			sys_migrate_pages		compat_sys_migrate_pages
-259	nospu	mbind				sys_mbind			compat_sys_mbind
-260	nospu	get_mempolicy			sys_get_mempolicy		compat_sys_get_mempolicy
-261	nospu	set_mempolicy			sys_set_mempolicy		compat_sys_set_mempolicy
+258	nospu	migrate_pages			sys_migrate_pages
+259	nospu	mbind				sys_mbind
+260	nospu	get_mempolicy			sys_get_mempolicy
+261	nospu	set_mempolicy			sys_set_mempolicy
 262	nospu	mq_open				sys_mq_open			compat_sys_mq_open
 263	nospu	mq_unlink			sys_mq_unlink
 264	32	mq_timedsend			sys_mq_timedsend_time32
@@ -381,7 +381,7 @@
 298	common	faccessat			sys_faccessat
 299	common	get_robust_list			sys_get_robust_list		compat_sys_get_robust_list
 300	common	set_robust_list			sys_set_robust_list		compat_sys_set_robust_list
-301	common	move_pages			sys_move_pages			compat_sys_move_pages
+301	common	move_pages			sys_move_pages
 302	common	getcpu				sys_getcpu
 303	nospu	epoll_pwait			sys_epoll_pwait			compat_sys_epoll_pwait
 304	32	utimensat			sys_utimensat_time32
--- a/arch/s390/kernel/syscalls/syscall.tbl~compat-remove-some-compat-entry-points
+++ a/arch/s390/kernel/syscalls/syscall.tbl
@@ -274,9 +274,9 @@
 265  common	statfs64		sys_statfs64			compat_sys_statfs64
 266  common	fstatfs64		sys_fstatfs64			compat_sys_fstatfs64
 267  common	remap_file_pages	sys_remap_file_pages		sys_remap_file_pages
-268  common	mbind			sys_mbind			compat_sys_mbind
-269  common	get_mempolicy		sys_get_mempolicy		compat_sys_get_mempolicy
-270  common	set_mempolicy		sys_set_mempolicy		compat_sys_set_mempolicy
+268  common	mbind			sys_mbind			sys_mbind
+269  common	get_mempolicy		sys_get_mempolicy		sys_get_mempolicy
+270  common	set_mempolicy		sys_set_mempolicy		sys_set_mempolicy
 271  common	mq_open			sys_mq_open			compat_sys_mq_open
 272  common	mq_unlink		sys_mq_unlink			sys_mq_unlink
 273  common	mq_timedsend		sys_mq_timedsend		sys_mq_timedsend_time32
@@ -293,7 +293,7 @@
 284  common	inotify_init		sys_inotify_init		sys_inotify_init
 285  common	inotify_add_watch	sys_inotify_add_watch		sys_inotify_add_watch
 286  common	inotify_rm_watch	sys_inotify_rm_watch		sys_inotify_rm_watch
-287  common	migrate_pages		sys_migrate_pages		compat_sys_migrate_pages
+287  common	migrate_pages		sys_migrate_pages		sys_migrate_pages
 288  common	openat			sys_openat			compat_sys_openat
 289  common	mkdirat			sys_mkdirat			sys_mkdirat
 290  common	mknodat			sys_mknodat			sys_mknodat
@@ -317,7 +317,7 @@
 307  common	sync_file_range		sys_sync_file_range		compat_sys_s390_sync_file_range
 308  common	tee			sys_tee				sys_tee
 309  common	vmsplice		sys_vmsplice			sys_vmsplice
-310  common	move_pages		sys_move_pages			compat_sys_move_pages
+310  common	move_pages		sys_move_pages			sys_move_pages
 311  common	getcpu			sys_getcpu			sys_getcpu
 312  common	epoll_pwait		sys_epoll_pwait			compat_sys_epoll_pwait
 313  common	utimes			sys_utimes			sys_utimes_time32
--- a/arch/sparc/kernel/syscalls/syscall.tbl~compat-remove-some-compat-entry-points
+++ a/arch/sparc/kernel/syscalls/syscall.tbl
@@ -365,12 +365,12 @@
 299	common	unshare			sys_unshare
 300	common	set_robust_list		sys_set_robust_list		compat_sys_set_robust_list
 301	common	get_robust_list		sys_get_robust_list		compat_sys_get_robust_list
-302	common	migrate_pages		sys_migrate_pages		compat_sys_migrate_pages
-303	common	mbind			sys_mbind			compat_sys_mbind
-304	common	get_mempolicy		sys_get_mempolicy		compat_sys_get_mempolicy
-305	common	set_mempolicy		sys_set_mempolicy		compat_sys_set_mempolicy
+302	common	migrate_pages		sys_migrate_pages
+303	common	mbind			sys_mbind
+304	common	get_mempolicy		sys_get_mempolicy
+305	common	set_mempolicy		sys_set_mempolicy
 306	common	kexec_load		sys_kexec_load			compat_sys_kexec_load
-307	common	move_pages		sys_move_pages			compat_sys_move_pages
+307	common	move_pages		sys_move_pages
 308	common	getcpu			sys_getcpu
 309	common	epoll_pwait		sys_epoll_pwait			compat_sys_epoll_pwait
 310	32	utimensat		sys_utimensat_time32
--- a/arch/x86/entry/syscalls/syscall_32.tbl~compat-remove-some-compat-entry-points
+++ a/arch/x86/entry/syscalls/syscall_32.tbl
@@ -286,7 +286,7 @@
 272	i386	fadvise64_64		sys_ia32_fadvise64_64
 273	i386	vserver
 274	i386	mbind			sys_mbind
-275	i386	get_mempolicy		sys_get_mempolicy		compat_sys_get_mempolicy
+275	i386	get_mempolicy		sys_get_mempolicy
 276	i386	set_mempolicy		sys_set_mempolicy
 277	i386	mq_open			sys_mq_open			compat_sys_mq_open
 278	i386	mq_unlink		sys_mq_unlink
@@ -328,7 +328,7 @@
 314	i386	sync_file_range		sys_ia32_sync_file_range
 315	i386	tee			sys_tee
 316	i386	vmsplice		sys_vmsplice
-317	i386	move_pages		sys_move_pages			compat_sys_move_pages
+317	i386	move_pages		sys_move_pages
 318	i386	getcpu			sys_getcpu
 319	i386	epoll_pwait		sys_epoll_pwait
 320	i386	utimensat		sys_utimensat_time32
--- a/arch/x86/entry/syscalls/syscall_64.tbl~compat-remove-some-compat-entry-points
+++ a/arch/x86/entry/syscalls/syscall_64.tbl
@@ -398,7 +398,7 @@
 530	x32	set_robust_list		compat_sys_set_robust_list
 531	x32	get_robust_list		compat_sys_get_robust_list
 532	x32	vmsplice		sys_vmsplice
-533	x32	move_pages		compat_sys_move_pages
+533	x32	move_pages		sys_move_pages
 534	x32	preadv			compat_sys_preadv64
 535	x32	pwritev			compat_sys_pwritev64
 536	x32	rt_tgsigqueueinfo	compat_sys_rt_tgsigqueueinfo
--- a/include/linux/compat.h~compat-remove-some-compat-entry-points
+++ a/include/linux/compat.h
@@ -799,26 +799,6 @@ asmlinkage long compat_sys_execve(const
 /* mm/fadvise.c: No generic prototype for fadvise64_64 */
 
 /* mm/, CONFIG_MMU only */
-asmlinkage long compat_sys_mbind(compat_ulong_t start, compat_ulong_t len,
-				 compat_ulong_t mode,
-				 compat_ulong_t __user *nmask,
-				 compat_ulong_t maxnode, compat_ulong_t flags);
-asmlinkage long compat_sys_get_mempolicy(int __user *policy,
-					 compat_ulong_t __user *nmask,
-					 compat_ulong_t maxnode,
-					 compat_ulong_t addr,
-					 compat_ulong_t flags);
-asmlinkage long compat_sys_set_mempolicy(int mode, compat_ulong_t __user *nmask,
-					 compat_ulong_t maxnode);
-asmlinkage long compat_sys_migrate_pages(compat_pid_t pid,
-		compat_ulong_t maxnode, const compat_ulong_t __user *old_nodes,
-		const compat_ulong_t __user *new_nodes);
-asmlinkage long compat_sys_move_pages(pid_t pid, compat_ulong_t nr_pages,
-				      __u32 __user *pages,
-				      const int __user *nodes,
-				      int __user *status,
-				      int flags);
-
 asmlinkage long compat_sys_rt_tgsigqueueinfo(compat_pid_t tgid,
 					compat_pid_t pid, int sig,
 					struct compat_siginfo __user *uinfo);
--- a/include/uapi/asm-generic/unistd.h~compat-remove-some-compat-entry-points
+++ a/include/uapi/asm-generic/unistd.h
@@ -673,15 +673,15 @@ __SYSCALL(__NR_madvise, sys_madvise)
 #define __NR_remap_file_pages 234
 __SYSCALL(__NR_remap_file_pages, sys_remap_file_pages)
 #define __NR_mbind 235
-__SC_COMP(__NR_mbind, sys_mbind, compat_sys_mbind)
+__SYSCALL(__NR_mbind, sys_mbind)
 #define __NR_get_mempolicy 236
-__SC_COMP(__NR_get_mempolicy, sys_get_mempolicy, compat_sys_get_mempolicy)
+__SYSCALL(__NR_get_mempolicy, sys_get_mempolicy)
 #define __NR_set_mempolicy 237
-__SC_COMP(__NR_set_mempolicy, sys_set_mempolicy, compat_sys_set_mempolicy)
+__SYSCALL(__NR_set_mempolicy, sys_set_mempolicy)
 #define __NR_migrate_pages 238
-__SC_COMP(__NR_migrate_pages, sys_migrate_pages, compat_sys_migrate_pages)
+__SYSCALL(__NR_migrate_pages, sys_migrate_pages)
 #define __NR_move_pages 239
-__SC_COMP(__NR_move_pages, sys_move_pages, compat_sys_move_pages)
+__SYSCALL(__NR_move_pages, sys_move_pages)
 #endif
 
 #define __NR_rt_tgsigqueueinfo 240
--- a/kernel/sys_ni.c~compat-remove-some-compat-entry-points
+++ a/kernel/sys_ni.c
@@ -292,15 +292,10 @@ COND_SYSCALL(process_madvise);
 COND_SYSCALL(process_mrelease);
 COND_SYSCALL(remap_file_pages);
 COND_SYSCALL(mbind);
-COND_SYSCALL_COMPAT(mbind);
 COND_SYSCALL(get_mempolicy);
-COND_SYSCALL_COMPAT(get_mempolicy);
 COND_SYSCALL(set_mempolicy);
-COND_SYSCALL_COMPAT(set_mempolicy);
 COND_SYSCALL(migrate_pages);
-COND_SYSCALL_COMPAT(migrate_pages);
 COND_SYSCALL(move_pages);
-COND_SYSCALL_COMPAT(move_pages);
 
 COND_SYSCALL(perf_event_open);
 COND_SYSCALL(accept4);
--- a/mm/mempolicy.c~compat-remove-some-compat-entry-points
+++ a/mm/mempolicy.c
@@ -1649,43 +1649,6 @@ SYSCALL_DEFINE5(get_mempolicy, int __use
 	return kernel_get_mempolicy(policy, nmask, maxnode, addr, flags);
 }
 
-#ifdef CONFIG_COMPAT
-
-COMPAT_SYSCALL_DEFINE5(get_mempolicy, int __user *, policy,
-		       compat_ulong_t __user *, nmask,
-		       compat_ulong_t, maxnode,
-		       compat_ulong_t, addr, compat_ulong_t, flags)
-{
-	return kernel_get_mempolicy(policy, (unsigned long __user *)nmask,
-				    maxnode, addr, flags);
-}
-
-COMPAT_SYSCALL_DEFINE3(set_mempolicy, int, mode, compat_ulong_t __user *, nmask,
-		       compat_ulong_t, maxnode)
-{
-	return kernel_set_mempolicy(mode, (unsigned long __user *)nmask, maxnode);
-}
-
-COMPAT_SYSCALL_DEFINE6(mbind, compat_ulong_t, start, compat_ulong_t, len,
-		       compat_ulong_t, mode, compat_ulong_t __user *, nmask,
-		       compat_ulong_t, maxnode, compat_ulong_t, flags)
-{
-	return kernel_mbind(start, len, mode, (unsigned long __user *)nmask,
-			    maxnode, flags);
-}
-
-COMPAT_SYSCALL_DEFINE4(migrate_pages, compat_pid_t, pid,
-		       compat_ulong_t, maxnode,
-		       const compat_ulong_t __user *, old_nodes,
-		       const compat_ulong_t __user *, new_nodes)
-{
-	return kernel_migrate_pages(pid, maxnode,
-				    (const unsigned long __user *)old_nodes,
-				    (const unsigned long __user *)new_nodes);
-}
-
-#endif /* CONFIG_COMPAT */
-
 bool vma_migratable(struct vm_area_struct *vma)
 {
 	if (vma->vm_flags & (VM_IO | VM_PFNMAP))
--- a/mm/migrate.c~compat-remove-some-compat-entry-points
+++ a/mm/migrate.c
@@ -2047,19 +2047,6 @@ SYSCALL_DEFINE6(move_pages, pid_t, pid,
 	return kernel_move_pages(pid, nr_pages, pages, nodes, status, flags);
 }
 
-#ifdef CONFIG_COMPAT
-COMPAT_SYSCALL_DEFINE6(move_pages, pid_t, pid, compat_ulong_t, nr_pages,
-		       compat_uptr_t __user *, pages,
-		       const int __user *, nodes,
-		       int __user *, status,
-		       int, flags)
-{
-	return kernel_move_pages(pid, nr_pages,
-				 (const void __user *__user *)pages,
-				 nodes, status, flags);
-}
-#endif /* CONFIG_COMPAT */
-
 #ifdef CONFIG_NUMA_BALANCING
 /*
  * Returns true if this is a safe migration target node for misplaced NUMA
_

Patches currently in -mm which might be from arnd@arndb.de are


