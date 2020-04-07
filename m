From: Andrew Morton <akpm@linux-foundation.org>
Subject: [patch 141/166] fs/binfmt_elf.c: don't free interpreter's
 ELF pheaders on common path
Date: Mon, 06 Apr 2020 20:11:32 -0700
Message-ID: <20200407031132.g4aXebMeQ%akpm@linux-foundation.org>
References: <20200406200254.a69ebd9e08c4074e41ddebaf@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:57280 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726535AbgDGDLd (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Mon, 6 Apr 2020 23:11:33 -0400
In-Reply-To: <20200406200254.a69ebd9e08c4074e41ddebaf@linux-foundation.org>
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: adobriyan@gmail.com, akpm@linux-foundation.org, linux-mm@kvack.org, mm-commits@vger.kernel.org, torvalds@linux-foundation.org

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
@@ -1076,6 +1076,7 @@ out_free_interp:
 		fput(interpreter);
 
 		kfree(interp_elf_ex);
+		kfree(interp_elf_phdata);
 	} else {
 		elf_entry = e_entry;
 		if (BAD_ADDR(elf_entry)) {
@@ -1084,7 +1085,6 @@ out_free_interp:
 		}
 	}
 
-	kfree(interp_elf_phdata);
 	kfree(elf_phdata);
 
 	set_binfmt(&elf_format);
_
