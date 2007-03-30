From: akpm@linux-foundation.org
Subject: + fix-page-leak-during-core-dump.patch added to -mm tree
Date: Fri, 30 Mar 2007 16:11:56 -0700
Message-ID: <200703302311.l2UNBuco008526@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:55945 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933020AbXC3XN3 (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Fri, 30 Mar 2007 19:13:29 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: bapper@piratehaven.org, bapper@mvista.com, dhowells@redhat.com, hugh@veritas.com, nickpiggin@yahoo.com.au, stable@kernel.org


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

fix-page-leak-during-core-dump.patch
