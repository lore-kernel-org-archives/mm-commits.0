From: akpm@linux-foundation.org
Subject: - fdpic-check-that-the-size-returned-by-kernel_read-is-what-we-asked-for.patch removed from -mm tree
Date: Tue, 29 Apr 2008 22:41:09 -0700
Message-ID: <200804300541.m3U5f9kG029032@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:48647 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757020AbYD3FmB (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 30 Apr 2008 01:42:01 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: dhowells@redhat.com, mm-commits@vger.kernel.org


The patch titled
     fdpic: check that the size returned by kernel_read() is what we asked for
has been removed from the -mm tree.  Its filename was
     fdpic-check-that-the-size-returned-by-kernel_read-is-what-we-asked-for.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: fdpic: check that the size returned by kernel_read() is what we asked for
From: David Howells <dhowells@redhat.com>

Check that the size of the read returned by kernel_read() is what we asked
for.  If it isn't, then reject the binary as being a badly formatted.

Signed-off-by: David Howells <dhowells@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/binfmt_elf_fdpic.c |   14 ++++++++++----
 1 file changed, 10 insertions(+), 4 deletions(-)

diff -puN fs/binfmt_elf_fdpic.c~fdpic-check-that-the-size-returned-by-kernel_read-is-what-we-asked-for fs/binfmt_elf_fdpic.c
--- a/fs/binfmt_elf_fdpic.c~fdpic-check-that-the-size-returned-by-kernel_read-is-what-we-asked-for
+++ a/fs/binfmt_elf_fdpic.c
@@ -136,8 +136,8 @@ static int elf_fdpic_fetch_phdrs(struct 
 
 	retval = kernel_read(file, params->hdr.e_phoff,
 			     (char *) params->phdrs, size);
-	if (retval < 0)
-		return retval;
+	if (unlikely(retval != size))
+		return retval < 0 ? retval : -ENOEXEC;
 
 	/* determine stack size for this binary */
 	phdr = params->phdrs;
@@ -218,8 +218,11 @@ static int load_elf_fdpic_binary(struct 
 					     phdr->p_offset,
 					     interpreter_name,
 					     phdr->p_filesz);
-			if (retval < 0)
+			if (unlikely(retval != phdr->p_filesz)) {
+				if (retval >= 0)
+					retval = -ENOEXEC;
 				goto error;
+			}
 
 			retval = -ENOENT;
 			if (interpreter_name[phdr->p_filesz - 1] != '\0')
@@ -245,8 +248,11 @@ static int load_elf_fdpic_binary(struct 
 
 			retval = kernel_read(interpreter, 0, bprm->buf,
 					     BINPRM_BUF_SIZE);
-			if (retval < 0)
+			if (unlikely(retval != BINPRM_BUF_SIZE)) {
+				if (retval >= 0)
+					retval = -ENOEXEC;
 				goto error;
+			}
 
 			interp_params.hdr = *((struct elfhdr *) bprm->buf);
 			break;
_

Patches currently in -mm which might be from dhowells@redhat.com are

origin.patch
git-unionfs.patch
alloc_uid-cleanup.patch
rename-div64_64-to-div64_u64.patch
mutex-subsystem-synchro-test-module.patch

