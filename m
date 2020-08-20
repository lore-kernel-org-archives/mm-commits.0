Return-Path: <SRS0=nxWc=B6=vger.kernel.org=mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3603DC433DF
	for <mm-commits@archiver.kernel.org>; Thu, 20 Aug 2020 20:08:00 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 17B88208C7
	for <mm-commits@archiver.kernel.org>; Thu, 20 Aug 2020 20:08:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1597954080;
	bh=cOU3wF0IZM/760cYO0m+9SEBLz/GTcrRSXEV4fxIXJQ=;
	h=Date:From:To:Subject:Reply-To:List-ID:From;
	b=Cu6ULCEAzpnznd6bcoctL6LwL+eYyva8BA+kGdQ/WTJSS94g43TTT9N+ZLYgQMcg8
	 iV/XzNjuSa0ZW+6imtaYLNTHtkSAiVP9Zq8Sg6O/lj6rOzKbu+OgLJX/KBXvN4huZ/
	 0rLKq76qseLEUa3dgPt8l6iOyAqBadjuXN6BO63U=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728246AbgHTUHz (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 20 Aug 2020 16:07:55 -0400
Received: from mail.kernel.org ([198.145.29.99]:54570 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728240AbgHTUHy (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Thu, 20 Aug 2020 16:07:54 -0400
Received: from localhost.localdomain (c-73-231-172-41.hsd1.ca.comcast.net [73.231.172.41])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id C589E207BB;
        Thu, 20 Aug 2020 20:07:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1597954073;
        bh=cOU3wF0IZM/760cYO0m+9SEBLz/GTcrRSXEV4fxIXJQ=;
        h=Date:From:To:Subject:From;
        b=vckntvZoleDCUskL3JflAVLxfi4fPSquigBq0wsAeMT4LAUK/+6dlO3/11+pXz5Dg
         JCfI5irz6EbM7oFjhwKb/+6+RWljWwf8TMpKv3nYWE1vgXJXKebTZJ4oyW/ysfwKSB
         NlTjXvRYTkhjJ/ZtbPoyiFi+SRj+0lP82i4XoYtI=
Date:   Thu, 20 Aug 2020 13:07:52 -0700
From:   akpm@linux-foundation.org
To:     adobriyan@gmail.com, ckennelly@google.com, hughd@google.com,
        irogers@google.com, kirill.shutemov@linux.intel.com,
        maskray@google.com, mike.kravetz@oracle.com,
        mm-commits@vger.kernel.org, ndesaulniers@google.com,
        rientjes@google.com, shuah@kernel.org, songliubraving@fb.com,
        sspatil@google.com, surenb@google.com, viro@zeniv.linux.org.uk
Subject:  +
 fs-binfmt_elf-use-pt_load-p_align-values-for-suitable-start-address.patch
 added to -mm tree
Message-ID: <20200820200752.zlrzOJPvh%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Sender: mm-commits-owner@vger.kernel.org
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: fs/binfmt_elf: use PT_LOAD p_align values for suitable start address
has been added to the -mm tree.  Its filename is
     fs-binfmt_elf-use-pt_load-p_align-values-for-suitable-start-address.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/fs-binfmt_elf-use-pt_load-p_align-values-for-suitable-start-address.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/fs-binfmt_elf-use-pt_load-p_align-values-for-suitable-start-address.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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

 fs/binfmt_elf.c |   23 +++++++++++++++++++++++
 1 file changed, 23 insertions(+)

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
@@ -421,6 +422,24 @@ static int elf_read(struct file *file, v
 	return 0;
 }
 
+static unsigned long maximum_alignment(struct elf_phdr *cmds, int nr)
+{
+	unsigned long alignment = 0;
+	int i;
+
+	for (i = 0; i < nr; i++) {
+		if (cmds[i].p_type == PT_LOAD) {
+			/* skip non-power of two alignments */
+			if (!is_power_of_2(cmds[i].p_align))
+				continue;
+			alignment = max(alignment, cmds[i].p_align);
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
@@ -1008,6 +1027,7 @@ out_free_interp:
 		int elf_prot, elf_flags;
 		unsigned long k, vaddr;
 		unsigned long total_size = 0;
+		unsigned long alignment;
 
 		if (elf_ppnt->p_type != PT_LOAD)
 			continue;
@@ -1086,6 +1106,9 @@ out_free_interp:
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

fs-binfmt_elf-use-pt_load-p_align-values-for-suitable-start-address.patch
add-self-test-for-verifying-load-alignment.patch

