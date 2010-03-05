From: akpm@linux-foundation.org
Subject: [folded] elf-coredump-replace-elf_core_extra_-macros-by-functions-fix-2.patch removed from -mm tree
Date: Fri, 05 Mar 2010 13:24:29 -0800
Message-ID: <201003052124.o25LOTcS028459@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:42917 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755131Ab0CEVZ3 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 5 Mar 2010 16:25:29 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: d.hatayama@jp.fujitsu.com, mm-commits@vger.kernel.org


The patch titled
     elf-coredump-replace-elf_core_extra_-macros-by-functions-fix-2
has been removed from the -mm tree.  Its filename was
     elf-coredump-replace-elf_core_extra_-macros-by-functions-fix-2.patch

This patch was dropped because it was folded into elf-coredump-replace-elf_core_extra_-macros-by-functions.patch

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: elf-coredump-replace-elf_core_extra_-macros-by-functions-fix-2
From: Daisuke HATAYAMA <d.hatayama@jp.fujitsu.com>

compat_binfmt_elf.c: Use 32-bit section header, not 64-bit one

I found that the previous fix patch of mine was insufficient for
fixing the problem relevant to EL32. It was necessary that one should
use the 32-bit datatype for section headers instead of the 64-bit one.
Here is a patch complementing it.

I made a runtime test for this fix patch, confirming that the
functionality works well.

Signed-off-by: Daisuke HATAYAMA <d.hatayama@jp.fujitsu.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/compat_binfmt_elf.c |    2 ++
 1 file changed, 2 insertions(+)

diff -puN fs/compat_binfmt_elf.c~elf-coredump-replace-elf_core_extra_-macros-by-functions-fix-2 fs/compat_binfmt_elf.c
--- a/fs/compat_binfmt_elf.c~elf-coredump-replace-elf_core_extra_-macros-by-functions-fix-2
+++ a/fs/compat_binfmt_elf.c
@@ -28,10 +28,12 @@
 
 #undef	elfhdr
 #undef	elf_phdr
+#undef	elf_shdr
 #undef	elf_note
 #undef	elf_addr_t
 #define elfhdr		elf32_hdr
 #define elf_phdr	elf32_phdr
+#define elf_shdr	elf32_shdr
 #define elf_note	elf32_note
 #define elf_addr_t	Elf32_Addr
 
_

Patches currently in -mm which might be from d.hatayama@jp.fujitsu.com are

coredump-unify-dump_seek-implementations-for-each-binfmt_c.patch
coredump-move-dump_write-and-dump_seek-into-a-header-file.patch
elf-coredump-replace-elf_core_extra_-macros-by-functions.patch
elf-coredump-replace-elf_core_extra_-macros-by-functions-fix-2.patch
elf-coredump-make-offset-calculation-process-and-writing-process-explicit.patch
elf-coredump-add-extended-numbering-support.patch

