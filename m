From: akpm@osdl.org
Subject: - fs-remove-unused-variable.patch removed from -mm tree
Date: Thu, 07 Dec 2006 15:16:17 -0800
Message-ID: <200612072316.kB7NGH8m030814@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.25]:54117 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1163967AbWLGXTc (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Thu, 7 Dec 2006 18:19:32 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: rientjes@cs.washington.edu, dcb314@hotmail.com, mm-commits@vger.kernel.org


The patch titled
     fs: remove unused variable
has been removed from the -mm tree.  Its filename was
     fs-remove-unused-variable.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: fs: remove unused variable
From: David Rientjes <rientjes@cs.washington.edu>

Removed unused 'have_pt_gnu_stack' variable.

Reported by David Binderman <dcb314@hotmail.com>

Signed-off-by: David Rientjes <rientjes@cs.washington.edu>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 fs/binfmt_elf.c |    3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff -puN fs/binfmt_elf.c~fs-remove-unused-variable fs/binfmt_elf.c
--- a/fs/binfmt_elf.c~fs-remove-unused-variable
+++ a/fs/binfmt_elf.c
@@ -544,7 +544,7 @@ static int load_elf_binary(struct linux_
 	unsigned long reloc_func_desc = 0;
 	char passed_fileno[6];
 	struct files_struct *files;
-	int have_pt_gnu_stack, executable_stack = EXSTACK_DEFAULT;
+	int executable_stack = EXSTACK_DEFAULT;
 	unsigned long def_flags = 0;
 	struct {
 		struct elfhdr elf_ex;
@@ -707,7 +707,6 @@ static int load_elf_binary(struct linux_
 				executable_stack = EXSTACK_DISABLE_X;
 			break;
 		}
-	have_pt_gnu_stack = (i < loc->elf_ex.e_phnum);
 
 	/* Some simple consistency checks for the interpreter */
 	if (elf_interpreter) {
_

Patches currently in -mm which might be from rientjes@cs.washington.edu are

origin.patch
video-sis-remove-unnecessary-variables-in-sis_ddc2delay.patch
hrtimers-clean-up-locking-fix.patch

