From: akpm@linux-foundation.org
Subject: +
 elf-dont-free-interpreters-elf-pheaders-on-common-path.patch added to -mm
 tree
Date: Wed, 19 Feb 2020 11:18:51 -0800
Message-ID: <20200219191851.NGtUz%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:45290 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726647AbgBSTSx (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Wed, 19 Feb 2020 14:18:53 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, adobriyan@gmail.com


The patch titled
     Subject: fs/binfmt_elf.c: don't free interpreter's ELF pheaders on common path
has been added to the -mm tree.  Its filename is
     elf-dont-free-interpreters-elf-pheaders-on-common-path.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/elf-dont-free-interpreters-elf-pheaders-on-common-path.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/elf-dont-free-interpreters-elf-pheaders-on-common-path.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Alexey Dobriyan <adobriyan@gmail.com>
Subject: fs/binfmt_elf.c: don't free interpreter's ELF pheaders on common path

Static executables don't need to free NULL pointer.

It doesn't matter really because static executable is not common scenario
but do it anyway out of pedantry.

Link: http://lkml.kernel.org/r/20200219185330.GA4933@avx2
Signed-off-by: Alexey Dobriyan <adobriyan@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/binfmt_elf.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/fs/binfmt_elf.c~elf-dont-free-interpreters-elf-pheaders-on-common-path
+++ a/fs/binfmt_elf.c
@@ -1075,6 +1075,7 @@ out_free_interp:
 		fput(interpreter);
 
 		kfree(interp_elf_ex);
+		kfree(interp_elf_phdata);
 	} else {
 		elf_entry = e_entry;
 		if (BAD_ADDR(elf_entry)) {
@@ -1083,7 +1084,6 @@ out_free_interp:
 		}
 	}
 
-	kfree(interp_elf_phdata);
 	kfree(elf_phdata);
 
 	set_binfmt(&elf_format);
_

Patches currently in -mm which might be from adobriyan@gmail.com are

ramfs-support-o_tmpfile.patch
elf-delete-loc-variable.patch
elf-allocate-less-for-static-executable.patch
elf-dont-free-interpreters-elf-pheaders-on-common-path.patch
