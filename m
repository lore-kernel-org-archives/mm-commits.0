From: akpm@linux-foundation.org
Subject: - elf-implement-at_random-for-glibc-prng-seeding.patch removed from -mm tree
Date: Thu, 08 Jan 2009 14:50:31 -0800
Message-ID: <200901082250.n08MoV9e029694@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:47113 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1763462AbZAHXAG (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 8 Jan 2009 18:00:06 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: kees.cook@canonical.com, andi@firstfloor.org, drepper@redhat.com, jakub@redhat.com, mm-commits@vger.kernel.org


The patch titled
     ELF: implement AT_RANDOM for glibc PRNG seeding
has been removed from the -mm tree.  Its filename was
     elf-implement-at_random-for-glibc-prng-seeding.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: ELF: implement AT_RANDOM for glibc PRNG seeding
From: Kees Cook <kees.cook@canonical.com>

While discussing[1] the need for glibc to have access to random bytes
during program load, it seems that an earlier attempt to implement
AT_RANDOM got stalled.  This implements a random 16 byte string, available
to every ELF program via a new auxv AT_RANDOM vector.

[1] http://sourceware.org/ml/libc-alpha/2008-10/msg00006.html

Ulrich said:

glibc needs right after startup a bit of random data for internal
protections (stack canary etc).  What is now in upstream glibc is that we
always unconditionally open /dev/urandom, read some data, and use it.  For
every process startup.  That's slow.

...

The solution is to provide a limited amount of random data to the
starting process in the aux vector.  I suggested 16 bytes and this is
what the patch implements.  If we need only 16 bytes or less we use the
data directly.  If we need more we'll use the 16 bytes to see a PRNG.
This avoids the costly /dev/urandom use and it allows the kernel to use
the most adequate source of random data for this purpose.  It might not
be the same pool as that for /dev/urandom.

Concerns were expressed about the depletion of the randomness pool.  But
this patch doesn't make the situation worse, it doesn't deplete entropy
more than happens now.

Signed-off-by: Kees Cook <kees.cook@canonical.com>
Cc: Jakub Jelinek <jakub@redhat.com>
Cc: Andi Kleen <andi@firstfloor.org>
Cc: Ulrich Drepper <drepper@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/binfmt_elf.c        |   12 ++++++++++++
 include/linux/auxvec.h |    6 +++---
 2 files changed, 15 insertions(+), 3 deletions(-)

diff -puN fs/binfmt_elf.c~elf-implement-at_random-for-glibc-prng-seeding fs/binfmt_elf.c
--- a/fs/binfmt_elf.c~elf-implement-at_random-for-glibc-prng-seeding
+++ a/fs/binfmt_elf.c
@@ -152,8 +152,10 @@ create_elf_tables(struct linux_binprm *b
 	elf_addr_t __user *sp;
 	elf_addr_t __user *u_platform;
 	elf_addr_t __user *u_base_platform;
+	elf_addr_t __user *u_rand_bytes;
 	const char *k_platform = ELF_PLATFORM;
 	const char *k_base_platform = ELF_BASE_PLATFORM;
+	unsigned char k_rand_bytes[16];
 	int items;
 	elf_addr_t *elf_info;
 	int ei_index = 0;
@@ -196,6 +198,15 @@ create_elf_tables(struct linux_binprm *b
 			return -EFAULT;
 	}
 
+	/*
+	 * Generate 16 random bytes for userspace PRNG seeding.
+	 */
+	get_random_bytes(k_rand_bytes, sizeof(k_rand_bytes));
+	u_rand_bytes = (elf_addr_t __user *)
+		       STACK_ALLOC(p, sizeof(k_rand_bytes));
+	if (__copy_to_user(u_rand_bytes, k_rand_bytes, sizeof(k_rand_bytes)))
+		return -EFAULT;
+
 	/* Create the ELF interpreter info */
 	elf_info = (elf_addr_t *)current->mm->saved_auxv;
 	/* update AT_VECTOR_SIZE_BASE if the number of NEW_AUX_ENT() changes */
@@ -228,6 +239,7 @@ create_elf_tables(struct linux_binprm *b
 	NEW_AUX_ENT(AT_GID, cred->gid);
 	NEW_AUX_ENT(AT_EGID, cred->egid);
  	NEW_AUX_ENT(AT_SECURE, security_bprm_secureexec(bprm));
+	NEW_AUX_ENT(AT_RANDOM, (elf_addr_t)(unsigned long)u_rand_bytes);
 	NEW_AUX_ENT(AT_EXECFN, bprm->exec);
 	if (k_platform) {
 		NEW_AUX_ENT(AT_PLATFORM,
diff -puN include/linux/auxvec.h~elf-implement-at_random-for-glibc-prng-seeding include/linux/auxvec.h
--- a/include/linux/auxvec.h~elf-implement-at_random-for-glibc-prng-seeding
+++ a/include/linux/auxvec.h
@@ -23,16 +23,16 @@
 #define AT_PLATFORM 15  /* string identifying CPU for optimizations */
 #define AT_HWCAP  16    /* arch dependent hints at CPU capabilities */
 #define AT_CLKTCK 17	/* frequency at which times() increments */
-
+/* AT_* values 18 through 22 are reserved */
 #define AT_SECURE 23   /* secure mode boolean */
