From: akpm@linux-foundation.org
Subject: + binfmt_elfc-use-get_random_int-to-fix-entropy-depleting.patch added to -mm tree
Date: Fri, 16 Nov 2012 14:04:45 -0800
Message-ID: <20121116220445.EB31E10004A@wpzn3.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-gg0-f202.google.com ([209.85.161.202]:42337 "EHLO
	mail-gg0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753419Ab2KPWEs (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 16 Nov 2012 17:04:48 -0500
Received: by mail-gg0-f202.google.com with SMTP id i4so354802ggm.1
        for <mm-commits@vger.kernel.org>; Fri, 16 Nov 2012 14:04:47 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: jeff.liu@oracle.com, aedilger@gmail.com, akpm@linux-foundation.org, alan@linux.intel.com, arnn@arndb.de, drepper@redhat.com, gregkh@linuxfoundation.org, jakub@redhat.com, james.l.morris@oracle.com, john.sobecki@oracle.com, keescook@chromium.org, tytso@mit.edu, viro@zeniv.linux.org.uk


The patch titled
     Subject: binfmt_elf.c: use get_random_int() to fix entropy depleting
has been added to the -mm tree.  Its filename is
     binfmt_elfc-use-get_random_int-to-fix-entropy-depleting.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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
Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: Al Viro <viro@zeniv.linux.org.uk>
Cc: Andreas Dilger <aedilger@gmail.com>
Cc: Alan Cox <alan@linux.intel.com>
Cc: Arnd Bergmann <arnn@arndb.de>
Cc: John Sobecki <john.sobecki@oracle.com>
Cc: James Morris <james.l.morris@oracle.com>
Cc: Jakub Jelinek <jakub@redhat.com>
Cc: Ted Ts'o <tytso@mit.edu>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Acked-by: Kees Cook <keescook@chromium.org>
Cc: Ulrich Drepper <drepper@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/binfmt_elf.c |   21 ++++++++++++++++++++-
 1 file changed, 20 insertions(+), 1 deletion(-)

diff -puN fs/binfmt_elf.c~binfmt_elfc-use-get_random_int-to-fix-entropy-depleting fs/binfmt_elf.c
--- a/fs/binfmt_elf.c~binfmt_elfc-use-get_random_int-to-fix-entropy-depleting
+++ a/fs/binfmt_elf.c
@@ -139,6 +139,25 @@ static int padzero(unsigned long elf_bss
 #define ELF_BASE_PLATFORM NULL
 #endif
 
+/*
+ * Use get_random_int() to implement AT_RANDOM while avoiding depletion
+ * of the entropy pool.
+ */
+static void get_atrandom_bytes(unsigned char *buf, size_t nbytes)
+{
+	unsigned char *p = buf;
+
+	while (nbytes) {
+		unsigned int random_variable;
+		size_t chunk = min(nbytes, sizeof(random_variable));
+
+		random_variable = get_random_int();
+		memcpy(p, &random_variable, chunk);
+		p += chunk;
+		nbytes -= chunk;
+	}
+}
+
 static int
 create_elf_tables(struct linux_binprm *bprm, struct elfhdr *exec,
 		unsigned long load_addr, unsigned long interp_load_addr)
@@ -200,7 +219,7 @@ create_elf_tables(struct linux_binprm *b
 	/*
 	 * Generate 16 random bytes for userspace PRNG seeding.
 	 */
-	get_random_bytes(k_rand_bytes, sizeof(k_rand_bytes));
+	get_atrandom_bytes(k_rand_bytes, sizeof(k_rand_bytes));
 	u_rand_bytes = (elf_addr_t __user *)
 		       STACK_ALLOC(p, sizeof(k_rand_bytes));
 	if (__copy_to_user(u_rand_bytes, k_rand_bytes, sizeof(k_rand_bytes)))
_

Patches currently in -mm which might be from jeff.liu@oracle.com are

linux-next.patch
documentation-cgroups-memorytxt-s-mem_cgroup_charge-mem_cgroup_change_common.patch
mm-vmscanc-try_to_freeze-returns-boolean.patch
binfmt_elfc-use-get_random_int-to-fix-entropy-depleting.patch

