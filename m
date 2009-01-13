From: akpm@linux-foundation.org
Subject: + bin_elf_fdpic-check-the-return-value-of-clear_user.patch added to -mm tree
Date: Mon, 12 Jan 2009 19:44:50 -0800
Message-ID: <200901130344.n0D3ioO9008129@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:46595 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751578AbZAMDpy (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 12 Jan 2009 22:45:54 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: vapier.adi@gmail.com, cooloney@kernel.org, dhowells@redhat.com, gerg@snapgear.com


The patch titled
     bin_elf_fdpic: check the return value of clear_user
has been added to the -mm tree.  Its filename is
     bin_elf_fdpic-check-the-return-value-of-clear_user.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://userweb.kernel.org/~akpm/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: bin_elf_fdpic: check the return value of clear_user
From: Mike Frysinger <vapier.adi@gmail.com>

Signed-off-by: Mike Frysinger <vapier.adi@gmail.com>
Signed-off-by: Bryan Wu <cooloney@kernel.org>
Cc: David Howells <dhowells@redhat.com>
Cc: Greg Ungerer <gerg@snapgear.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/binfmt_elf_fdpic.c |   25 +++++++++++++++++--------
 1 file changed, 17 insertions(+), 8 deletions(-)

diff -puN fs/binfmt_elf_fdpic.c~bin_elf_fdpic-check-the-return-value-of-clear_user fs/binfmt_elf_fdpic.c
--- a/fs/binfmt_elf_fdpic.c~bin_elf_fdpic-check-the-return-value-of-clear_user
+++ a/fs/binfmt_elf_fdpic.c
@@ -972,9 +972,12 @@ static int elf_fdpic_map_file_constdisp_
 			params->elfhdr_addr = seg->addr;
 
 		/* clear any space allocated but not loaded */
-		if (phdr->p_filesz < phdr->p_memsz)
-			clear_user((void *) (seg->addr + phdr->p_filesz),
-				   phdr->p_memsz - phdr->p_filesz);
+		if (phdr->p_filesz < phdr->p_memsz) {
+			ret = clear_user((void *) (seg->addr + phdr->p_filesz),
+					 phdr->p_memsz - phdr->p_filesz);
+			if (ret)
+				return ret;
+		}
 
 		if (mm) {
 			if (phdr->p_flags & PF_X) {
@@ -1014,7 +1017,7 @@ static int elf_fdpic_map_file_by_direct_
 	struct elf32_fdpic_loadseg *seg;
 	struct elf32_phdr *phdr;
 	unsigned long load_addr, delta_vaddr;
-	int loop, dvset;
+	int loop, dvset, ret;
 
 	load_addr = params->load_addr;
 	delta_vaddr = 0;
@@ -1114,7 +1117,9 @@ static int elf_fdpic_map_file_by_direct_
 		 * PT_LOAD */
 		if (prot & PROT_WRITE && disp > 0) {
 			kdebug("clear[%d] ad=%lx sz=%lx", loop, maddr, disp);
-			clear_user((void __user *) maddr, disp);
+			ret = clear_user((void __user *) maddr, disp);
+			if (ret)
+				return ret;
 			maddr += disp;
 		}
 
@@ -1149,15 +1154,19 @@ static int elf_fdpic_map_file_by_direct_
 		if (prot & PROT_WRITE && excess1 > 0) {
 			kdebug("clear[%d] ad=%lx sz=%lx",
 			       loop, maddr + phdr->p_filesz, excess1);
-			clear_user((void __user *) maddr + phdr->p_filesz,
-				   excess1);
+			ret = clear_user((void __user *) maddr + phdr->p_filesz,
+					 excess1);
+			if (ret)
+				return ret;
 		}
 
 #else
 		if (excess > 0) {
 			kdebug("clear[%d] ad=%lx sz=%lx",
 			       loop, maddr + phdr->p_filesz, excess);
-			clear_user((void *) maddr + phdr->p_filesz, excess);
+			ret = clear_user((void *) maddr + phdr->p_filesz, excess);
+			if (ret)
+				return ret;
 		}
 #endif
 
_

Patches currently in -mm which might be from vapier.adi@gmail.com are

linux-next.patch
bin_elf_fdpic-check-the-return-value-of-clear_user.patch

