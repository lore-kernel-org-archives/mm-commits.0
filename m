From: akpm@linux-foundation.org
Subject: + fs-binfmt_elfc-fix-a-wrong-free.patch added to -mm tree
Date: Tue, 06 May 2008 12:25:50 -0700
Message-ID: <200805061925.m46JPopQ023214@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:50041 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758729AbYEFTZ7 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 6 May 2008 15:25:59 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: xiyou.wangcong@gmail.com, penberg@cs.helsinki.fi, viro@zeniv.linux.org.uk, wangcong@zeuux.org


The patch titled
     fs/binfmt_elf.c: fix a wrong free
has been added to the -mm tree.  Its filename is
     fs-binfmt_elfc-fix-a-wrong-free.patch

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
Subject: fs/binfmt_elf.c: fix a wrong free
From: WANG Cong <xiyou.wangcong@gmail.com>

On the kmalloc failure path we shouldn't free pointers in 'info', because the
struct 'info' is uninitialized when kmalloc is called.

And when kmalloc returns NULL, it's needless to kfree it.

Signed-off-by: WANG Cong <wangcong@zeuux.org>
Cc: Alexander Viro <viro@zeniv.linux.org.uk>
Reviewed-by: Pekka Enberg <penberg@cs.helsinki.fi>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/binfmt_elf.c |    5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff -puN fs/binfmt_elf.c~fs-binfmt_elfc-fix-a-wrong-free fs/binfmt_elf.c
--- a/fs/binfmt_elf.c~fs-binfmt_elfc-fix-a-wrong-free
+++ a/fs/binfmt_elf.c
@@ -1900,7 +1900,7 @@ static int elf_core_dump(long signr, str
 	/* alloc memory for large data structures: too large to be on stack */
 	elf = kmalloc(sizeof(*elf), GFP_KERNEL);
 	if (!elf)
-		goto cleanup;
+		goto out;
 	
 	segs = current->mm->map_count;
 #ifdef ELF_CORE_EXTRA_PHDRS
@@ -2034,8 +2034,9 @@ end_coredump:
 	set_fs(fs);
 
 cleanup:
-	kfree(elf);
 	free_note_info(&info);
+	kfree(elf);
+out:
 	return has_dumped;
 }
 
_

Patches currently in -mm which might be from xiyou.wangcong@gmail.com are

uml-fix-inconsistence-due-to-tty_operation-change.patch
fs-binfmt_elfc-fix-a-wrong-free.patch
arch-um-kernel-irqc-clean-up-some-functions.patch
arch-um-kernel-memc-remove-arch_validate.patch
uml-make-several-more-things-static.patch

