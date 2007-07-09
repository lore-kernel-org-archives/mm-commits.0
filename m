From: akpm@linux-foundation.org
Subject: - pie-randomization-fix-bad_addr-macro.patch removed from -mm tree
Date: Mon, 09 Jul 2007 14:48:54 -0700
Message-ID: <200707092148.l69LmsEl014139@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:39859 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754272AbXGIVtM (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 9 Jul 2007 17:49:12 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: jkosina@suse.cz, cebbert@redhat.com, jakub@redhat.com, riel@redhat.com, mm-commits@vger.kernel.org


The patch titled
     pie randomization: fix BAD_ADDR macro
has been removed from the -mm tree.  Its filename was
     pie-randomization-fix-bad_addr-macro.patch

This patch was dropped because it was folded into pie-randomization.patch

------------------------------------------------------
Subject: pie randomization: fix BAD_ADDR macro
From: Jiri Kosina <jkosina@suse.cz>

pie-randomization.patch makes the load_addr in load_elf_interp() the load
bias of ld.so (difference between the actual load base address and first
PT_LOAD segment's p_vaddr).  If the difference equals (on x86) to
0xfffff000 (which is valid [1]), SIGSEGV is incorrectly sent.

This patch changes the BAD_ADDR so that it catches the mappings to the
error-area properly.

[1] https://bugzilla.redhat.com/bugzilla/show_bug.cgi?id=246623

Reported-by: Jakub Jelinek <jakub@redhat.com>
Signed-off-by: Jiri Kosina <jkosina@suse.cz>
Cc: Chuck Ebbert <cebbert@redhat.com>
Cc: Rik van Riel <riel@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/binfmt_elf.c |    2 +-
 1 files changed, 1 insertion(+), 1 deletion(-)

diff -puN fs/binfmt_elf.c~pie-randomization-fix-bad_addr-macro fs/binfmt_elf.c
--- a/fs/binfmt_elf.c~pie-randomization-fix-bad_addr-macro
+++ a/fs/binfmt_elf.c
@@ -80,7 +80,7 @@ static struct linux_binfmt elf_format = 
 		.hasvdso	= 1
 };
 
-#define BAD_ADDR(x) ((unsigned long)(x) >= PAGE_MASK)
+#define BAD_ADDR(x) IS_ERR_VALUE(x)
 
 static int set_brk(unsigned long start, unsigned long end)
 {
_

Patches currently in -mm which might be from jkosina@suse.cz are

git-hid.patch
git-ipwireless_cs.patch
x86_64-fix-wrong-comment-regarding-set_fixmap.patch
pie-randomization.patch
pie-randomization-fix-bad_addr-macro.patch
kernel-printkc-document-possible-deadlock-against-scheduler.patch
some-kmalloc-memset-kzalloc-tree-wide.patch
some-kmalloc-memset-kzalloc-tree-wide-kcalloc-fixes.patch
