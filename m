From: akpm@linux-foundation.org
Subject: [merged] binfmt_elf-quiet-gcc-46-set-but-not-used-warning-in-load_elf_binary.patch removed from -mm tree
Date: Wed, 23 Mar 2011 13:40:35 -0700
Message-ID: <201103232044.p2NKiBJI029050@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:40804 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S933466Ab1CWUoM (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 23 Mar 2011 16:44:12 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: ddaney@caviumnetworks.com, mm-commits@vger.kernel.org


The patch titled
     binfmt_elf: quiet GCC-4.6 'set but not used' warning in load_elf_binary()
has been removed from the -mm tree.  Its filename was
     binfmt_elf-quiet-gcc-46-set-but-not-used-warning-in-load_elf_binary.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: binfmt_elf: quiet GCC-4.6 'set but not used' warning in load_elf_binary()
From: David Daney <ddaney@caviumnetworks.com>

With GCC-4.6 we get warnings about things being 'set but not used'.

In load_elf_binary() this can happen with reloc_func_desc if ELF_PLAT_INIT
is defined, but doesn't use the reloc_func_desc argument.

Quiet the warning/error by marking reloc_func_desc as __maybe_unused.

Signed-off-by: David Daney <ddaney@caviumnetworks.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/binfmt_elf.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN fs/binfmt_elf.c~binfmt_elf-quiet-gcc-46-set-but-not-used-warning-in-load_elf_binary fs/binfmt_elf.c
--- a/fs/binfmt_elf.c~binfmt_elf-quiet-gcc-46-set-but-not-used-warning-in-load_elf_binary
+++ a/fs/binfmt_elf.c
@@ -570,7 +570,7 @@ static int load_elf_binary(struct linux_
 	unsigned long elf_entry;
 	unsigned long interp_load_addr = 0;
 	unsigned long start_code, end_code, start_data, end_data;
-	unsigned long reloc_func_desc = 0;
+	unsigned long reloc_func_desc __maybe_unused = 0;
 	int executable_stack = EXSTACK_DEFAULT;
 	unsigned long def_flags = 0;
 	struct {
_

Patches currently in -mm which might be from ddaney@caviumnetworks.com are

origin.patch

