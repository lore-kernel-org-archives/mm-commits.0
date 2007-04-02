From: akpm@linux-foundation.org
Subject: - fix-page-leak-during-core-dump.patch removed from -mm tree
Date: Mon, 02 Apr 2007 16:03:44 -0700
Message-ID: <200704022303.l32N3ivk011912@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:52058 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S966078AbXDBXFN (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Mon, 2 Apr 2007 19:05:13 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: bapper@piratehaven.org, bapper@mvista.com, dhowells@redhat.com, hugh@veritas.com, nickpiggin@yahoo.com.au, stable@kernel.org, mm-commits@vger.kernel.org


The patch titled
     fix page leak during core dump
has been removed from the -mm tree.  Its filename was
     fix-page-leak-during-core-dump.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: fix page leak during core dump
From: Brian Pomerantz <bapper@piratehaven.org>

When the dump cannot occur most likely because of a full file system and
the page to be written is the zero page, the call to page_cache_release()
is missed.

Signed-off-by: Brian Pomerantz <bapper@mvista.com>
Cc: Hugh Dickins <hugh@veritas.com>
Cc: Nick Piggin <nickpiggin@yahoo.com.au>
Cc: David Howells <dhowells@redhat.com>
Cc: <stable@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/binfmt_elf.c       |    5 ++++-
 fs/binfmt_elf_fdpic.c |    2 +-
 2 files changed, 5 insertions(+), 2 deletions(-)

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
diff -puN fs/binfmt_elf_fdpic.c~fix-page-leak-during-core-dump fs/binfmt_elf_fdpic.c
--- a/fs/binfmt_elf_fdpic.c~fix-page-leak-during-core-dump
+++ a/fs/binfmt_elf_fdpic.c
@@ -1480,8 +1480,8 @@ static int elf_fdpic_dump_segments(struc
 				DUMP_SEEK(file->f_pos + PAGE_SIZE);
 			}
 			else if (page == ZERO_PAGE(addr)) {
-				DUMP_SEEK(file->f_pos + PAGE_SIZE);
 				page_cache_release(page);
+				DUMP_SEEK(file->f_pos + PAGE_SIZE);
 			}
 			else {
 				void *kaddr;
_

Patches currently in -mm which might be from bapper@piratehaven.org are

origin.patch
