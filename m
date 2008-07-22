From: akpm@linux-foundation.org
Subject: - execve-filename-document-and-export-via-auxiliary-vector.patch removed from -mm tree
Date: Tue, 22 Jul 2008 14:32:09 -0700
Message-ID: <200807222132.m6MLW9ML018690@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:34831 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754766AbYGVVdA (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 22 Jul 2008 17:33:00 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: jreiser@BitWagon.com, benh@kernel.crashing.org, drepper@redhat.com, jakub@redhat.com, roland@redhat.com, mm-commits@vger.kernel.org


The patch titled
     execve filename: document and export via auxiliary vector
has been removed from the -mm tree.  Its filename was
     execve-filename-document-and-export-via-auxiliary-vector.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: execve filename: document and export via auxiliary vector
From: John Reiser <jreiser@BitWagon.com>

The Linux kernel puts the filename argument of execve() into the
new address space.  Many developers are surprised to learn this.
Those who know and could use it, object "But it's not documented."
Those who want to use it dislike the expression
  (char *)(1+ strlen(env[-1+ n_env]) + env[-1+ n_env])
because it requires locating the last original environment variable,
and assumes that the filename follows the characters.

This patch documents the insertion of the filename, and makes it easier to
find by adding a new tag AT_EXECFN in the ElfXX_auxv_t; see <elf.h>.

In many cases readlink("/proc/self/exe",) gives the same answer.  But if all
the original pages get unmapped, then the kernel erases the symlink for
/proc/self/exe.  This can happen when a program decompressor does a good job
of cleaning up after uncompressing directly to memory, so that the address
space of the target program looks the same as if compression had never
happened.  One example is http://upx.sourceforge.net .

One notable use of the underlying concept (what path containED the executable)
is glibc expanding $ORIGIN in DT_RUNPATH.  In practice for the near term, it
may be a good idea for user-mode code to use both /proc/self/exe and AT_EXECFN
as fall-back methods for each other.  /proc/self/exe can fail due to
unmapping, AT_EXECFN can fail because it won't be present on non-new systems. 
The auxvec or {AT_EXECFN}.d_val also can get overwritten, although in nearly
all cases this would be the result of a bug.

The runtime cost is one NEW_AUX_ENT using two words of stack space.  The
underlying value is maintained already as bprm->exec; setup_arg_pages() in
fs/exec.c slides it for stack_shift, etc.

Signed-off-by: John Reiser <jreiser@BitWagon.com>
Cc: Roland McGrath <roland@redhat.com>
Cc: Jakub Jelinek <jakub@redhat.com>
Cc: Ulrich Drepper <drepper@redhat.com>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/binfmt_elf.c        |    1 +
 include/linux/auxvec.h |    4 +++-
 2 files changed, 4 insertions(+), 1 deletion(-)

diff -puN fs/binfmt_elf.c~execve-filename-document-and-export-via-auxiliary-vector fs/binfmt_elf.c
--- a/fs/binfmt_elf.c~execve-filename-document-and-export-via-auxiliary-vector
+++ a/fs/binfmt_elf.c
@@ -204,6 +204,7 @@ create_elf_tables(struct linux_binprm *b
 	NEW_AUX_ENT(AT_GID, tsk->gid);
 	NEW_AUX_ENT(AT_EGID, tsk->egid);
  	NEW_AUX_ENT(AT_SECURE, security_bprm_secureexec(bprm));
+	NEW_AUX_ENT(AT_EXECFN, bprm->exec);
 	if (k_platform) {
 		NEW_AUX_ENT(AT_PLATFORM,
 			    (elf_addr_t)(unsigned long)u_platform);
diff -puN include/linux/auxvec.h~execve-filename-document-and-export-via-auxiliary-vector include/linux/auxvec.h
--- a/include/linux/auxvec.h~execve-filename-document-and-export-via-auxiliary-vector
+++ a/include/linux/auxvec.h
@@ -26,8 +26,10 @@
 
 #define AT_SECURE 23   /* secure mode boolean */
 
+#define AT_EXECFN  31	/* filename of program */
 #ifdef __KERNEL__
-#define AT_VECTOR_SIZE_BASE (14 + 2) /* NEW_AUX_ENT entries in auxiliary table */
+#define AT_VECTOR_SIZE_BASE 17 /* NEW_AUX_ENT entries in auxiliary table */
+  /* number of "#define AT_.*" above, minus {AT_NULL, AT_IGNORE, AT_NOTELF} */
 #endif
 
 #endif /* _LINUX_AUXVEC_H */
_

Patches currently in -mm which might be from jreiser@BitWagon.com are

origin.patch

