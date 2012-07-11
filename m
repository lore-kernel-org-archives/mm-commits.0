From: akpm@linux-foundation.org
Subject: + ipc-allow-compat-ipc-version-field-parsing-if-arch_want_old_compat_ipc.patch added to -mm tree
Date: Wed, 11 Jul 2012 14:40:14 -0700
Message-ID: <20120711214015.AFABD5C0050@hpza9.eem.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-fa0-f74.google.com ([209.85.161.74]:39040 "EHLO
	mail-fa0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758120Ab2GKVkR (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 11 Jul 2012 17:40:17 -0400
Received: by mail-fa0-f74.google.com with SMTP id 25so83817fat.1
        for <mm-commits@vger.kernel.org>; Wed, 11 Jul 2012 14:40:17 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: will.deacon@arm.com, arnd@arndb.de, catalin.marinas@arm.com, cmetcalf@tilera.com


The patch titled
     Subject: ipc: allow compat IPC version field parsing if !ARCH_WANT_OLD_COMPAT_IPC
has been added to the -mm tree.  Its filename is
     ipc-allow-compat-ipc-version-field-parsing-if-arch_want_old_compat_ipc.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Will Deacon <will.deacon@arm.com>
Subject: ipc: allow compat IPC version field parsing if !ARCH_WANT_OLD_COMPAT_IPC

Commit 48b25c43 ("ipc: provide generic compat versions of IPC syscalls")
added a new ARCH_WANT_OLD_COMPAT_IPC config option for architectures to
select if their compat target requires the old IPC syscall interface.

For architectures (such as AArch64) that do not require the internal
calling conventions provided by this option, but have a compat target
where the C library passes the IPC_64 flag explicitly,
compat_ipc_parse_version no longer strips out the flag before calling the
native system call implementation, resulting in unknown SHM/IPC commands
and -EINVAL being returned to userspace.

This patch separates the selection of the internal calling conventions for
the IPC syscalls from the version parsing, allowing architectures to
select __ARCH_WANT_COMPAT_IPC_PARSE_VERSION if they want to use version
parsing whilst retaining the newer syscall calling conventions.

Acked-by: Chris Metcalf <cmetcalf@tilera.com>
Cc: Arnd Bergmann <arnd@arndb.de>
Acked-by: Catalin Marinas <catalin.marinas@arm.com>
Signed-off-by: Will Deacon <will.deacon@arm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/compat.h |    1 +
 ipc/compat.c           |    2 +-
 2 files changed, 2 insertions(+), 1 deletion(-)

diff -puN include/linux/compat.h~ipc-allow-compat-ipc-version-field-parsing-if-arch_want_old_compat_ipc include/linux/compat.h
--- a/include/linux/compat.h~ipc-allow-compat-ipc-version-field-parsing-if-arch_want_old_compat_ipc
+++ a/include/linux/compat.h
@@ -256,6 +256,7 @@ compat_sys_get_robust_list(int pid, comp
 			   compat_size_t __user *len_ptr);
 
 #ifdef CONFIG_ARCH_WANT_OLD_COMPAT_IPC
+#define __ARCH_WANT_COMPAT_IPC_PARSE_VERSION
 long compat_sys_semctl(int first, int second, int third, void __user *uptr);
 long compat_sys_msgsnd(int first, int second, int third, void __user *uptr);
 long compat_sys_msgrcv(int first, int second, int msgtyp, int third,
diff -puN ipc/compat.c~ipc-allow-compat-ipc-version-field-parsing-if-arch_want_old_compat_ipc ipc/compat.c
--- a/ipc/compat.c~ipc-allow-compat-ipc-version-field-parsing-if-arch_want_old_compat_ipc
+++ a/ipc/compat.c
@@ -118,7 +118,7 @@ extern int sem_ctls[];
 
 static inline int compat_ipc_parse_version(int *cmd)
 {
-#ifdef CONFIG_ARCH_WANT_OLD_COMPAT_IPC
+#ifdef	__ARCH_WANT_COMPAT_IPC_PARSE_VERSION
 	int version = *cmd & IPC_64;
 
 	/* this is tricky: architectures that have support for the old
_
Subject: Subject: ipc: allow compat IPC version field parsing if !ARCH_WANT_OLD_COMPAT_IPC

Patches currently in -mm which might be from will.deacon@arm.com are

linux-next.patch
ipc-add-compat_shmlba-support.patch
ipc-allow-compat-ipc-version-field-parsing-if-arch_want_old_compat_ipc.patch
ipc-compat-use-signed-size_t-types-for-msgsnd-and-msgrcv.patch

