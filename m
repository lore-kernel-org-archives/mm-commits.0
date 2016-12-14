From: akpm@linux-foundation.org
Subject: [merged]
 binfmt_elf-use-vmalloc-for-allocation-of-vma_filesz.patch removed from -mm
 tree
Date: Wed, 14 Dec 2016 11:28:00 -0800
Message-ID: <58519d40.SDinM7BGAQtpyHfm%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:45838 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1756535AbcLNT3j (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 14 Dec 2016 14:29:39 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: jbaron@akamai.com, viro@zeniv.linux.org.uk, mm-commits@vger.kernel.org


The patch titled
     Subject: binfmt_elf: use vmalloc() for allocation of vma_filesz
has been removed from the -mm tree.  Its filename was
     binfmt_elf-use-vmalloc-for-allocation-of-vma_filesz.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
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

Patches currently in -mm which might be from jbaron@akamai.com are


