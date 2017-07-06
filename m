From: akpm@linux-foundation.org
Subject: [wrecked]
 uaccess-zero-destination-buffer-on-overflow-attempt.patch removed from -mm
 tree
Date: Thu, 06 Jul 2017 11:55:19 -0700
Message-ID: <20170706185519._97rZg4U9%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:38272 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751817AbdGFSzV (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 6 Jul 2017 14:55:21 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: ak@linux.intel.com, arnd@arndb.de, egtvedt@samfundet.no, hoeun.ryu@gmail.com, keescook@chromium.org, mm-commits@vger.kernel.org, viro@zeniv.linux.org.uk


The patch titled
     Subject: uaccess: zero destination buffer on overflow attempt
has been removed from the -mm tree.  Its filename was
     uaccess-zero-destination-buffer-on-overflow-attempt.patch

This patch was dropped because other changes were merged, which wrecked this patch

------------------------------------------------------
From: Kees Cook <keescook@chromium.org>
Subject: uaccess: zero destination buffer on overflow attempt

When the destination buffer size is known at build time but the runtime
size to copy into it is not known, the copy_from_user() will WARN when it
is too large and the copy_from_user() will fail.  However, it was not
zeroing the destination buffer (for which it knows the correct size). 
This fixes that corner case and adds a test for it in test_user_copy.c.

Link: http://lkml.kernel.org/r/20170705200113.GA146915@beast
Signed-off-by: Kees Cook <keescook@chromium.org>
Cc: Al Viro <viro@zeniv.linux.org.uk>
Cc: Andi Kleen <ak@linux.intel.com>
Cc: Arnd Bergmann <arnd@arndb.de>
Cc: Hoeun Ryu <hoeun.ryu@gmail.com>
Cc: Hans-Christian Noren Egtvedt <egtvedt@samfundet.no>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/uaccess.h |    5 +++--
 lib/test_user_copy.c    |   12 ++++++++++++
 2 files changed, 15 insertions(+), 2 deletions(-)

diff -puN include/linux/uaccess.h~uaccess-zero-destination-buffer-on-overflow-attempt include/linux/uaccess.h
--- a/include/linux/uaccess.h~uaccess-zero-destination-buffer-on-overflow-attempt
+++ a/include/linux/uaccess.h
@@ -152,9 +152,10 @@ copy_from_user(void *to, const void __us
 	if (likely(sz < 0 || sz >= n)) {
 		check_object_size(to, n, false);
 		n = _copy_from_user(to, from, n);
-	} else if (!__builtin_constant_p(n))
+	} else if (!__builtin_constant_p(n)) {
 		copy_user_overflow(sz, n);
-	else
+		memset(to, 0, sz);
+	} else
 		__bad_copy_user();
 
 	return n;
diff -puN lib/test_user_copy.c~uaccess-zero-destination-buffer-on-overflow-attempt lib/test_user_copy.c
--- a/lib/test_user_copy.c~uaccess-zero-destination-buffer-on-overflow-attempt
+++ a/lib/test_user_copy.c
@@ -57,6 +57,8 @@ static int __init test_user_copy_init(vo
 	char __user *usermem;
 	char *bad_usermem;
 	unsigned long user_addr;
+	volatile int unconst = 0;
+	char charbuf[8];
 	u8 val_u8;
 	u16 val_u16;
 	u32 val_u32;
@@ -124,6 +126,7 @@ static int __init test_user_copy_init(vo
 	/* Prepare kernel memory with check values. */
 	memset(kmem, 0x5a, PAGE_SIZE);
 	memset(kmem + PAGE_SIZE, 0, PAGE_SIZE);
+	memset(charbuf, 0x6a, sizeof(charbuf));
 
 	/* Reject kernel-to-kernel copies through copy_from_user(). */
 	ret |= test(!copy_from_user(kmem, (char __user *)(kmem + PAGE_SIZE),
@@ -134,6 +137,15 @@ static int __init test_user_copy_init(vo
 	ret |= test(memcmp(kmem + PAGE_SIZE, kmem, PAGE_SIZE),
 		    "zeroing failure for illegal all-kernel copy_from_user");
 
+	/* Reject copies into too-small buffers. */
+	ret |= test(!copy_from_user(charbuf, usermem,
+				    sizeof(charbuf) + 1 + unconst),
+		    "illegal too-large copy_from_user passed");
+
+	/* Destination buffer should have been entirely zeroed. */
+	ret |= test(memcmp(kmem + PAGE_SIZE, charbuf, sizeof(charbuf)),
+		    "zeroing failure for illegal too-large copy_from_user");
+
 #if 0
 	/*
 	 * When running with SMAP/PAN/etc, this will Oops the kernel
_

Patches currently in -mm which might be from keescook@chromium.org are

mm-allow-slab_nomerge-to-be-set-at-build-time.patch
binfmt_elf-use-elf_et_dyn_base-only-for-pie.patch
arm-reduce-elf_et_dyn_base.patch
arm64-move-elf_et_dyn_base-to-4gb-4mb.patch
powerpc-reduce-elf_et_dyn_base.patch
s390-reduce-elf_et_dyn_base.patch
binfmt_elf-safely-increment-argv-pointers.patch
random-do-not-ignore-early-device-randomness.patch
ipc-drop-non-rcu-allocation.patch
ipc-sem-do-not-use-ipc_rcu_free.patch
ipc-shm-do-not-use-ipc_rcu_free.patch
ipc-msg-do-not-use-ipc_rcu_free.patch
ipc-util-drop-ipc_rcu_free.patch
ipc-sem-avoid-ipc_rcu_alloc.patch
ipc-shm-avoid-ipc_rcu_alloc.patch
ipc-msg-avoid-ipc_rcu_alloc.patch
ipc-util-drop-ipc_rcu_alloc.patch
ipc-move-atomic_set-to-where-it-is-needed.patch
ipc-shm-remove-special-shm_alloc-free.patch
ipc-msg-remove-special-msg_alloc-free.patch
ipc-sem-drop-__sem_free.patch
efi-avoid-fortify-checks-in-efi-stub.patch
kexec_file-adjust-declaration-of-kexec_purgatory.patch
ib-rxe-do-not-copy-extra-stack-memory-to-skb.patch
include-linux-stringh-add-the-option-of-fortified-stringh-functions-fix-2.patch
sh-mark-end-of-bug-implementation-as-unreachable.patch

