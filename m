From: akpm@linux-foundation.org
Subject: + mips-elf-handling-use-selfmag-instead-of-numeric-constant.patch added to -mm tree
Date: Mon, 05 May 2008 14:09:33 -0700
Message-ID: <200805052109.m45L9XRb005191@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:40748 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756757AbYEEVKS (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 5 May 2008 17:10:18 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: gorcunov@gmail.com, ralf@linux-mips.org


The patch titled
     MIPS: ELF handling: use SELFMAG instead of numeric constant
has been added to the -mm tree.  Its filename is
     mips-elf-handling-use-selfmag-instead-of-numeric-constant.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

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
linux-next.patch
cifs-find_unc-cleanup.patch
cifs-cifs_find_tcp_session-cleanup.patch
module-loading-elf-handling-use-selfmag-instead-of-numeric-constant.patch
mips-elf-handling-use-selfmag-instead-of-numeric-constant.patch

