From: akpm@linux-foundation.org
Subject: - mips-elf-handling-use-selfmag-instead-of-numeric-constant.patch removed from -mm tree
Date: Mon, 12 May 2008 13:23:29 -0700
Message-ID: <200805122023.m4CKNTn9007547@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:53318 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751226AbYELUXl (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 12 May 2008 16:23:41 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: gorcunov@gmail.com, ralf@linux-mips.org, mm-commits@vger.kernel.org


The patch titled
     MIPS: ELF handling: use SELFMAG instead of numeric constant
has been removed from the -mm tree.  Its filename was
     mips-elf-handling-use-selfmag-instead-of-numeric-constant.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: MIPS: ELF handling: use SELFMAG instead of numeric constant
From: Cyrill Gorcunov <gorcunov@gmail.com>

Signed-off-by: Cyrill Gorcunov <gorcunov@gmail.com>
Cc: Ralf Baechle <ralf@linux-mips.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/mips/kernel/vpe.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff -puN arch/mips/kernel/vpe.c~mips-elf-handling-use-selfmag-instead-of-numeric-constant arch/mips/kernel/vpe.c
--- a/arch/mips/kernel/vpe.c~mips-elf-handling-use-selfmag-instead-of-numeric-constant
+++ a/arch/mips/kernel/vpe.c
@@ -840,7 +840,7 @@ static int vpe_elfload(struct vpe * v)
 
 	/* Sanity checks against insmoding binaries or wrong arch,
 	   weird elf version */
-	if (memcmp(hdr->e_ident, ELFMAG, 4) != 0
+	if (memcmp(hdr->e_ident, ELFMAG, SELFMAG) != 0
 	    || (hdr->e_type != ET_REL && hdr->e_type != ET_EXEC)
 	    || !elf_check_arch(hdr)
 	    || hdr->e_shentsize != sizeof(*sechdrs)) {
@@ -1107,7 +1107,7 @@ static int vpe_release(struct inode *ino
 		return -ENODEV;
 
 	hdr = (Elf_Ehdr *) v->pbuffer;
-	if (memcmp(hdr->e_ident, ELFMAG, 4) == 0) {
+	if (memcmp(hdr->e_ident, ELFMAG, SELFMAG) == 0) {
 		if (vpe_elfload(v) >= 0) {
 			vpe_run(v);
 		} else {
_

Patches currently in -mm which might be from gorcunov@gmail.com are

origin.patch
uml-use-page_size-in-linker-scripts.patch
init-dont-loose-initcall-code-returned-v2.patch
ecryptfs-fix-imbalanced-mutex-locking.patch
git-cifs.patch
module-loading-elf-handling-use-selfmag-instead-of-numeric-constant.patch

