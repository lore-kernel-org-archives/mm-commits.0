From: akpm@linux-foundation.org
Subject: [to-be-updated] binfmt_elfc-use-get_random_int-to-fix-entropy-depleting.patch removed from -mm tree
Date: Wed, 14 Nov 2012 14:39:15 -0800
Message-ID: <20121114223915.EB5F0100047@wpzn3.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-gg0-f202.google.com ([209.85.161.202]:60117 "EHLO
	mail-gg0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933153Ab2KNWjR (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 14 Nov 2012 17:39:17 -0500
Received: by mail-gg0-f202.google.com with SMTP id i4so104680ggm.1
        for <mm-commits@vger.kernel.org>; Wed, 14 Nov 2012 14:39:17 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: jeff.liu@oracle.com, aedilger@gmail.com, alan@linux.intel.com, arnn@arndb.de, drepper@redhat.com, gregkh@linuxfoundation.org, jakub@redhat.com, james.l.morris@oracle.com, john.sobecki@oracle.com, keescook@chromium.org, tytso@mit.edu, viro@zeniv.linux.org.uk, mm-commits@vger.kernel.org


The patch titled
     Subject: binfmt_elf.c: use get_random_int() to fix entropy depleting
has been removed from the -mm tree.  Its filename was
     binfmt_elfc-use-get_random_int-to-fix-entropy-depleting.patch

This patch was dropped because an updated version will be merged

------------------------------------------------------
From: Jeff Liu <jeff.liu@oracle.com>
Subject: binfmt_elf.c: use get_random_int() to fix entropy depleting

Entropy is quickly depleted under normal operations like ls(1), cat(1),
etc...  between 2.6.30 to current mainline, for instance:

$ cat /proc/sys/kernel/random/entropy_avail
3428
$ cat /proc/sys/kernel/random/entropy_avail
2911
$cat /proc/sys/kernel/random/entropy_avail
2620

We observed this problem has been occurring since 2.6.30 with
fs/binfmt_elf.c: create_elf_tables()->get_random_bytes(), introduced by
f06295b44c296c8f ("ELF: implement AT_RANDOM for glibc PRNG seeding").

/*
 * Generate 16 random bytes for userspace PRNG seeding.
 */
get_random_bytes(k_rand_bytes, sizeof(k_rand_bytes));

The patch introduces a wrapper around get_random_int() which has lower
overhead than calling get_random_bytes() directly.

With this patch applied:
$ cat /proc/sys/kernel/random/entropy_avail
2731
$ cat /proc/sys/kernel/random/entropy_avail
2802
$ cat /proc/sys/kernel/random/entropy_avail
2878

Analyzed by John Sobecki.

Signed-off-by: Jie Liu <jeff.liu@oracle.com>
Cc: John Sobecki <john.sobecki@oracle.com>
Cc: Al Viro <viro@zeniv.linux.org.uk>
Cc: Andreas Dilger <aedilger@gmail.com>
Cc: Alan Cox <alan@linux.intel.com>
Cc: Arnd Bergmann <arnn@arndb.de>
Cc: James Morris <james.l.morris@oracle.com>
Cc: Ted Ts'o <tytso@mit.edu>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Kees Cook <keescook@chromium.org>
Cc: Jakub Jelinek <jakub@redhat.com>
Cc: Ulrich Drepper <drepper@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/binfmt_elf.c |   26 +++++++++++++++++++++++++-
 1 file changed, 25 insertions(+), 1 deletion(-)

diff -puN fs/binfmt_elf.c~binfmt_elfc-use-get_random_int-to-fix-entropy-depleting fs/binfmt_elf.c
--- a/fs/binfmt_elf.c~binfmt_elfc-use-get_random_int-to-fix-entropy-depleting
+++ a/fs/binfmt_elf.c
@@ -48,6 +48,7 @@ static int load_elf_binary(struct linux_
 static int load_elf_library(struct file *);
 static unsigned long elf_map(struct file *, unsigned long, struct elf_phdr *,
 				int, int, unsigned long);
+static void randomize_stack_user(unsigned char *buf, size_t nbytes);
 
 /*
  * If we don't support core dumping, then supply a NULL so we
@@ -200,7 +201,7 @@ create_elf_tables(struct linux_binprm *b
 	/*
 	 * Generate 16 random bytes for userspace PRNG seeding.
 	 */
-	get_random_bytes(k_rand_bytes, sizeof(k_rand_bytes));
+	randomize_stack_user(k_rand_bytes, sizeof(k_rand_bytes));
 	u_rand_bytes = (elf_addr_t __user *)
 		       STACK_ALLOC(p, sizeof(k_rand_bytes));
 	if (__copy_to_user(u_rand_bytes, k_rand_bytes, sizeof(k_rand_bytes)))
@@ -558,6 +559,29 @@ static unsigned long randomize_stack_top
 #endif
 }
 
+/*
+ * A wrapper of get_random_int() to generate random bytes which has lower
+ * overhead than call get_random_bytes() directly.
+ * create_elf_tables() call this function to generate 16 random bytes for
+ * userspace PRNG seeding.
+ */
+static void randomize_stack_user(unsigned char *buf, size_t nbytes)
+{
+	unsigned char *p = buf;
+
+	while (nbytes) {
+		unsigned int random_variable;
+		size_t chunk = min(nbytes, sizeof(unsigned int));
+
+		random_variable = get_random_int() & STACK_RND_MASK;
+		random_variable <<= PAGE_SHIFT;
+
+		memcpy(p, &random_variable, chunk);
+		p += chunk;
+		nbytes -= chunk;
+	}
+}
+
 static int load_elf_binary(struct linux_binprm *bprm)
 {
 	struct file *interpreter = NULL; /* to shut gcc up */
_

Patches currently in -mm which might be from jeff.liu@oracle.com are

linux-next.patch
documentation-cgroups-memorytxt-s-mem_cgroup_charge-mem_cgroup_change_common.patch
mm-vmscanc-try_to_freeze-returns-boolean.patch
binfmt_elfc-use-get_random_int-to-fix-entropy-depleting-fix.patch

