From: akpm@linux-foundation.org
Subject: + fdpic-check-that-the-size-returned-by-kernel_read-is-what-we-asked-for.patch added to -mm tree
Date: Sun, 27 Apr 2008 11:57:21 -0700
Message-ID: <200804271857.m3RIvLji020072@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:40716 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750751AbYD0S5n (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Sun, 27 Apr 2008 14:57:43 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: dhowells@redhat.com


The patch titled
     fdpic: check that the size returned by kernel_read() is what we asked for
has been added to the -mm tree.  Its filename is
     fdpic-check-that-the-size-returned-by-kernel_read-is-what-we-asked-for.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

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
remove-the-macro-get_personality.patch
fdpic-check-that-the-size-returned-by-kernel_read-is-what-we-asked-for.patch
xattr-add-missing-consts-to-function-arguments.patch
keys-increase-the-payload-size-when-instantiating-a-key.patch
keys-check-starting-keyring-as-part-of-search.patch
keys-allow-the-callout-data-to-be-passed-as-a-blob-rather-than-a-string.patch
keys-add-keyctl-function-to-get-a-security-label.patch
keys-add-keyctl-function-to-get-a-security-label-fix.patch
keys-switch-to-proc_create.patch
keys-allow-clients-to-set-key-perms-in-key_create_or_update.patch
keys-dont-generate-user-and-user-session-keyrings-unless-theyre-accessed.patch
keys-make-the-keyring-quotas-controllable-through-proc-sys.patch
keys-make-the-keyring-quotas-controllable-through-proc-sys-fix.patch
keys-explicitly-include-required-slabh-header-file.patch
keys-make-key_serial-a-function-if-config_keys=y.patch
procfs-task-exe-symlink.patch
procfs-task-exe-symlink-fix.patch
procfs-task-exe-symlink-fix-2.patch
proc-introduce-proc_create_data-to-setup-de-data.patch
afs-use-non-racy-method-for-proc-entries-creation.patch
alloc_uid-cleanup.patch
rename-div64_64-to-div64_u64.patch
afs-use-the-shorter-list_head-for-brevity.patch
afs-the-afs-rpc-op-cbgetcapabilities-is-actually-cbtellmeaboutyourself.patch
afs-the-afs-rpc-op-cbgetcapabilities-is-actually-cbtellmeaboutyourself-try-3.patch
add-kbuildh-that-contains-common-definitions-for-kbuild-users.patch
frv-use-kbuildh-instead-of-defining-macros-in-asm-offsetsc.patch
mn10300-use-kbuildh-instead-of-defining-macros-in-asm-offsetsc.patch
mutex-subsystem-synchro-test-module.patch

