From: akpm@linux-foundation.org
Subject: + fix-page-leak-during-core-dump.patch added to -mm tree
Date: Fri, 30 Mar 2007 13:44:21 -0700
Message-ID: <200703302044.l2UKiL7V004637@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:51536 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753618AbXC3Uof (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Fri, 30 Mar 2007 16:44:35 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: bapper@piratehaven.org, bapper@mvista.com, hugh@veritas.com, nickpiggin@yahoo.com.au


The patch titled
     fix page leak during core dump
has been added to the -mm tree.  Its filename is
     fix-page-leak-during-core-dump.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: fix page leak during core dump
From: Brian Pomerantz <bapper@piratehaven.org>

When the dump cannot occur most likely because of a full file system and
the page to be written is the zero page, the call to page_cache_release()
is missed.

Signed-off-by: Brian Pomerantz <bapper@mvista.com>
Cc: Hugh Dickins <hugh@veritas.com>
Cc: Nick Piggin <nickpiggin@yahoo.com.au>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/binfmt_elf.c |    5 ++++-
 1 files changed, 4 insertions(+), 1 deletion(-)

diff -puN fs/binfmt_elf.c~fix-page-leak-during-core-dump fs/binfmt_elf.c
--- a/fs/binfmt_elf.c~fix-page-leak-during-core-dump
+++ a/fs/binfmt_elf.c
@@ -1704,7 +1704,10 @@ static int elf_core_dump(long signr, str
 				DUMP_SEEK(PAGE_SIZE);
 			} else {
 				if (page == ZERO_PAGE(addr)) {
-					DUMP_SEEK(PAGE_SIZE);
+					if (!dump_seek(file, PAGE_SIZE)) {
+						page_cache_release(page);
+						goto end_coredump;
+					}
 				} else {
 					void *kaddr;
 					flush_cache_page(vma, addr,
_

Patches currently in -mm which might be from bapper@piratehaven.org are

fix-page-leak-during-core-dump.patch
