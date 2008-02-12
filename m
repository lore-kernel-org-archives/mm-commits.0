From: akpm@linux-foundation.org
Subject: + elf-use-ei_nident-instead-of-numeric-value.patch added to -mm tree
Date: Tue, 12 Feb 2008 14:29:38 -0800
Message-ID: <200802122229.m1CMTcer025648@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:46918 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758134AbYBLWaM (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 12 Feb 2008 17:30:12 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: gorcunov@gmail.com


The patch titled
     ELF: Use EI_NIDENT instead of numeric value
has been added to the -mm tree.  Its filename is
     elf-use-ei_nident-instead-of-numeric-value.patch

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
Subject: ELF: Use EI_NIDENT instead of numeric value
From: Cyrill Gorcunov <gorcunov@gmail.com>

Signed-off-by: Cyrill Gorcunov <gorcunov@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/elf.h |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN include/linux/elf.h~elf-use-ei_nident-instead-of-numeric-value include/linux/elf.h
--- a/include/linux/elf.h~elf-use-ei_nident-instead-of-numeric-value
+++ a/include/linux/elf.h
@@ -208,7 +208,7 @@ typedef struct elf32_hdr{
 } Elf32_Ehdr;
 
 typedef struct elf64_hdr {
-  unsigned char	e_ident[16];		/* ELF "magic number" */
+  unsigned char	e_ident[EI_NIDENT];	/* ELF "magic number" */
   Elf64_Half e_type;
   Elf64_Half e_machine;
   Elf64_Word e_version;
_

Patches currently in -mm which might be from gorcunov@gmail.com are

origin.patch
git-avr32.patch
git-dvb.patch
elf-use-ei_nident-instead-of-numeric-value.patch
binfmt-fill_elf_header-cleanup-use-straigth-memset-first.patch
