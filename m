Return-Path: <SRS0=zz/k=DX=vger.kernel.org=mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 39C3DC433E7
	for <mm-commits@archiver.kernel.org>; Fri, 16 Oct 2020 20:54:26 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id E01BF216C4
	for <mm-commits@archiver.kernel.org>; Fri, 16 Oct 2020 20:54:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1602881665;
	bh=26jKbVmrWeHReADJD0xv7tpQrgfD6zwGAnFcvg0hGyM=;
	h=Date:From:To:Subject:Reply-To:List-ID:From;
	b=JCxYy72djbhTD2dTxi7WSrvAFA79q1HYtNfHbJblIfO4W8CP9jtirBRwzGiSmkBkK
	 lGXS1ScjWqFCzXGu4Jm5ZHpo1PDqrm2e+0bpHCrFKws4AVL2ujM7BUZdXrl6lI+7iw
	 jZPquNcm4YeRWnqEnforJVnCggEZSZrCe4gFSCWw=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2409202AbgJPUyZ (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 16 Oct 2020 16:54:25 -0400
Received: from mail.kernel.org ([198.145.29.99]:42176 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2391502AbgJPUyZ (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Fri, 16 Oct 2020 16:54:25 -0400
Received: from localhost.localdomain (c-71-198-47-131.hsd1.ca.comcast.net [71.198.47.131])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id A83F52076C;
        Fri, 16 Oct 2020 20:54:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1602881664;
        bh=26jKbVmrWeHReADJD0xv7tpQrgfD6zwGAnFcvg0hGyM=;
        h=Date:From:To:Subject:From;
        b=EXqkISAM67ICWkmB70VHrqII0GeT5RqIwCkviQ53HY7Zu9jgZsRLBRLP8aUWJCVZ1
         j+o1KWW1hFAzrRp4ns9ZQve+nbWnLZaA/XH2EbTwntrMHh93nUx2Y6uhTH6YmGyBBW
         ij8aMoh3smPh9XidH9JP7BbDQZBboOD1tVln3UmQ=
Date:   Fri, 16 Oct 2020 13:54:23 -0700
From:   akpm@linux-foundation.org
To:     adobriyan@gmail.com, ckennelly@google.com, hughd@google.com,
        irogers@google.com, kirill.shutemov@linux.intel.com,
        maskray@google.com, mike.kravetz@oracle.com,
        mm-commits@vger.kernel.org, ndesaulniers@google.com,
        rientjes@google.com, shuah@kernel.org, songliubraving@fb.com,
        sspatil@google.com, surenb@google.com, viro@zeniv.linux.org.uk
Subject:  [merged]
 fs-binfmt_elf-use-pt_load-p_align-values-for-suitable-start-address.patch
 removed from -mm tree
Message-ID: <20201016205423.Ujru-6xOM%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: fs/binfmt_elf: use PT_LOAD p_align values for suitable start address
has been removed from the -mm tree.  Its filename was
     fs-binfmt_elf-use-pt_load-p_align-values-for-suitable-start-address.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Chris Kennelly <ckennelly@google.com>
Subject: fs/binfmt_elf: use PT_LOAD p_align values for suitable start address

Patch series "Selecting Load Addresses According to p_align", v3.

The current ELF loading mechancism provides page-aligned mappings.  This
can lead to the program being loaded in a way unsuitable for file-backed,
transparent huge pages when handling PIE executables.

While specifying -z,max-page-size=0x200000 to the linker will generate
suitably aligned segments for huge pages on x86_64, the executable needs
to be loaded at a suitably aligned address as well.  This alignment
requires the binary's cooperation, as distinct segments need to be
appropriately paddded to be eligible for THP.

For binaries built with increased alignment, this limits the number of
bits usable for ASLR, but provides some randomization over using fixed
load addresses/non-PIE binaries.


This patch (of 2):

The current ELF loading mechancism provides page-aligned mappings.  This
can lead to the program being loaded in a way unsuitable for file-backed,
transparent huge pages when handling PIE executables.

For binaries built with increased alignment, this limits the number of
bits usable for ASLR, but provides some randomization over using fixed
load addresses/non-PIE binaries.

Tested by verifying program with -Wl,-z,max-page-size=0x200000 loading.

[akpm@linux-foundation.org: fix max() warning]
[ckennelly@google.com: augment comment]
  Link: https://lkml.kernel.org/r/20200821233848.3904680-2-ckennelly@google.com
Link: https://lkml.kernel.org/r/20200820170541.1132271-1-ckennelly@google.com
Link: https://lkml.kernel.org/r/20200820170541.1132271-2-ckennelly@google.com
Signed-off-by: Chris Kennelly <ckennelly@google.com>
Cc: Alexander Viro <viro@zeniv.linux.org.uk>
Cc: Alexey Dobriyan <adobriyan@gmail.com>
Cc: Song Liu <songliubraving@fb.com>
Cc: David Rientjes <rientjes@google.com>
Cc: Ian Rogers <irogers@google.com>
Cc: Hugh Dickens <hughd@google.com>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: Sandeep Patil <sspatil@google.com>
Cc: Fangrui Song <maskray@google.com>
Cc: Nick Desaulniers <ndesaulniers@google.com>
Cc: "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>
Cc: Mike Kravetz <mike.kravetz@oracle.com>
Cc: Shuah Khan <shuah@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/binfmt_elf.c |   25 +++++++++++++++++++++++++
 1 file changed, 25 insertions(+)

--- a/fs/binfmt_elf.c~fs-binfmt_elf-use-pt_load-p_align-values-for-suitable-start-address
+++ a/fs/binfmt_elf.c
@@ -13,6 +13,7 @@
 #include <linux/module.h>
 #include <linux/kernel.h>
 #include <linux/fs.h>
+#include <linux/log2.h>
 #include <linux/mm.h>
 #include <linux/mman.h>
 #include <linux/errno.h>
@@ -421,6 +422,26 @@ static int elf_read(struct file *file, v
 	return 0;
 }
 
+static unsigned long maximum_alignment(struct elf_phdr *cmds, int nr)
+{
+	unsigned long alignment = 0;
+	int i;
+
+	for (i = 0; i < nr; i++) {
+		if (cmds[i].p_type == PT_LOAD) {
+			unsigned long p_align = cmds[i].p_align;
+
+			/* skip non-power of two alignments as invalid */
+			if (!is_power_of_2(p_align))
+				continue;
+			alignment = max(alignment, p_align);
+		}
+	}
+
+	/* ensure we align to at least one page */
+	return ELF_PAGEALIGN(alignment);
+}
+
 /**
  * load_elf_phdrs() - load ELF program headers
  * @elf_ex:   ELF header of the binary whose program headers should be loaded
@@ -1008,6 +1029,7 @@ out_free_interp:
 		int elf_prot, elf_flags;
 		unsigned long k, vaddr;
 		unsigned long total_size = 0;
+		unsigned long alignment;
 
 		if (elf_ppnt->p_type != PT_LOAD)
 			continue;
@@ -1086,6 +1108,9 @@ out_free_interp:
 				load_bias = ELF_ET_DYN_BASE;
 				if (current->flags & PF_RANDOMIZE)
 					load_bias += arch_mmap_rnd();
+				alignment = maximum_alignment(elf_phdata, elf_ex->e_phnum);
+				if (alignment)
+					load_bias &= ~(alignment - 1);
 				elf_flags |= MAP_FIXED;
 			} else
 				load_bias = 0;
_

Patches currently in -mm which might be from ckennelly@google.com are


