From: akpm@linux-foundation.org
Subject: [patch 122/123] binfmt_elf: use vmalloc() for allocation of
 vma_filesz
Date: Mon, 12 Dec 2016 16:46:40 -0800
Message-ID: <584f44f0.36w+TsNXfO9ERPDJ%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:42148 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753282AbcLMAql (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 12 Dec 2016 19:46:41 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: torvalds@linux-foundation.org, mm-commits@vger.kernel.org, akpm@linux-foundation.org, jbaron@akamai.com, viro@zeniv.linux.org.uk

From: Jason Baron <jbaron@akamai.com>
Subject: binfmt_elf: use vmalloc() for allocation of vma_filesz

We have observed page allocations failures of order 4 during core dump
while trying to allocate vma_filesz.  This results in a useless core file
of size 0.  To improve reliability use vmalloc().

Note that the vmalloc() allocation is bounded by sysctl_max_map_count,
which is 65,530 by default.  So with a 4k page size, and 8 bytes per seg,
this is a max of 128 pages or an order 7 allocation.  Other parts of the
core dump path, such as fill_files_note() are already using vmalloc() for
presumably similar reasons.

Link: http://lkml.kernel.org/r/1479745791-17611-1-git-send-email-jbaron@akamai.com
Signed-off-by: Jason Baron <jbaron@akamai.com>
Cc: Al Viro <viro@zeniv.linux.org.uk>

Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/binfmt_elf.c |    6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff -puN fs/binfmt_elf.c~binfmt_elf-use-vmalloc-for-allocation-of-vma_filesz fs/binfmt_elf.c
--- a/fs/binfmt_elf.c~binfmt_elf-use-vmalloc-for-allocation-of-vma_filesz
+++ a/fs/binfmt_elf.c
@@ -2204,7 +2204,9 @@ static int elf_core_dump(struct coredump
 
 	dataoff = offset = roundup(offset, ELF_EXEC_PAGESIZE);
 
-	vma_filesz = kmalloc_array(segs - 1, sizeof(*vma_filesz), GFP_KERNEL);
+	if (segs - 1 > ULONG_MAX / sizeof(*vma_filesz))
+		goto end_coredump;
+	vma_filesz = vmalloc((segs - 1) * sizeof(*vma_filesz));
 	if (!vma_filesz)
 		goto end_coredump;
 
@@ -2311,7 +2313,7 @@ end_coredump:
 cleanup:
 	free_note_info(&info);
 	kfree(shdr4extnum);
-	kfree(vma_filesz);
+	vfree(vma_filesz);
 	kfree(phdr4note);
 	kfree(elf);
 out:
_
