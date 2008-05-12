From: akpm@linux-foundation.org
Subject: - fs-binfmt_elfc-fix-a-wrong-free.patch removed from -mm tree
Date: Mon, 12 May 2008 13:23:32 -0700
Message-ID: <200805122023.m4CKNWod007550@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:59020 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752472AbYELUXo (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 12 May 2008 16:23:44 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: xiyou.wangcong@gmail.com, penberg@cs.helsinki.fi, viro@zeniv.linux.org.uk, wangcong@zeuux.org, mm-commits@vger.kernel.org


The patch titled
     fs/binfmt_elf.c: fix a wrong free
has been removed from the -mm tree.  Its filename was
     fs-binfmt_elfc-fix-a-wrong-free.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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

uml-redo-host-capability-detection-and-disabling.patch
uml-style-fixes.patch
uml-hppfs-fixes.patch
uml-move-hppfs_kernc-to-hppfsc.patch
uml-tidy-ptrace-interface.patch
uml-fix-errno-return.patch
uml-fix-build-when-slob-is-enabled.patch
uml-remove-unused-header.patch
uml-fix-bad-ntp-interaction-with-clock.patch
uml-use-__spin_lock_unlocked.patch
uml-fix-config_raw-dependencies.patch
uml-use-div_round_up.patch
uml-use-page_size-in-linker-scripts.patch
uml-physical-memory-shouldnt-include-initial-stack.patch
cpumask-remove-bitmap_scnprintf_len-and-cpumask_scnprintf_len.patch
linux-next.patch
arch-um-kernel-irqc-clean-up-some-functions.patch
arch-um-kernel-memc-remove-arch_validate.patch
uml-make-several-more-things-static.patch

