From: akpm@linux-foundation.org
Subject: + modpost-fix-address-calculation-in-reloc_location.patch added to -mm tree
Date: Wed, 22 Dec 2010 16:34:10 -0800
Message-ID: <201012230034.oBN0YAVi028184@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:40626 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751505Ab0LWAey (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 22 Dec 2010 19:34:54 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: olof@lixom.net, mmarek@suse.cz, raymes@google.com, rusty@rustcorp.com.au, sam@ravnborg.org


The patch titled
     modpost: fix address calculation in reloc_location()
has been added to the -mm tree.  Its filename is
     modpost-fix-address-calculation-in-reloc_location.patch

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
Subject: modpost: fix address calculation in reloc_location()
From: Olof Johansson <olof@lixom.net>

Fix a segfault in modpost that is observed when the gold linker is used to
link the input objects.

The problem is that reloc_location (modpost.c) is computing the address of
the relocation target incorrectly.  Here, elf->hdr points to the beginning
of the ELF file in memory, sechdr points to the relocation section header,
section is the index of the section being relocated, and
sechdrs[section].sh_offset would be the offset of that section, relative
to the beginning of the ELF file.  Adding elf->hdr +
sechdrs[section].sh_offset gives you the address of the beginning of the
section, and adding r->r_offset to that gives you the address of the
location to be relocated.  You do not need to subtract
sechdrs[section].sh_addr from that -- the result of this is an address
outside the file, and causes the segfault when addend_386_rel tries to
dereference it.

This bug is not observed when GNU ld is used to link the inputs.  The
object file ubuntu/omnibook/omnibook.o is the result of an ld -r of
several other files.  When GNU ld does an ld -r, it sets the vaddr field
for each section to 0, but gold lays out the section addresses
sequentially instead:

Section Headers:
 [Nr] Name              Type            Addr     Off    Size   ES Flg Lk Inf Al
 [ 0]                   NULL            00000000 000000 000000 00      0   0  0
 [ 1] .text             PROGBITS        00000000 000034 004794 00  AX  0   0  4
 [ 2] .data             PROGBITS        0000b9d0 0047c8 0009c0 00  WA  0   0  4
 [ 3] .bss              NOBITS          000162f8 005188 00013c 00  WA  0   0  4
 [ 4] .rodata.str1.1    PROGBITS        00004f2d 0052c4 001b1a 01 AMS  0   0  1
 [ 5] .init.text        PROGBITS        00004794 006dde 0005fa 00  AX  0   0  1
 [ 6] .exit.text        PROGBITS        00004d8e 0073d8 00018a 00  AX  0   0  1
  ...

So the bug in the tool remained undiscovered because the section's vaddr
always happened to be 0.

Signed-off-by: Raymes Khoury <raymes@google.com>
Signed-off-by: Olof Johansson <olof@lixom.net>
Cc: Michal Marek <mmarek@suse.cz>
Cc: Rusty Russell <rusty@rustcorp.com.au>
Cc: Sam Ravnborg <sam@ravnborg.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 scripts/mod/modpost.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN scripts/mod/modpost.c~modpost-fix-address-calculation-in-reloc_location scripts/mod/modpost.c
--- a/scripts/mod/modpost.c~modpost-fix-address-calculation-in-reloc_location
+++ a/scripts/mod/modpost.c
@@ -1442,7 +1442,7 @@ static unsigned int *reloc_location(stru
 	int section = shndx2secindex(sechdr->sh_info);
 
 	return (void *)elf->hdr + sechdrs[section].sh_offset +
-		r->r_offset - sechdrs[section].sh_addr;
+		r->r_offset;
 }
 
 static int addend_386_rel(struct elf_info *elf, Elf_Shdr *sechdr, Elf_Rela *r)
_

Patches currently in -mm which might be from olof@lixom.net are

linux-next.patch
modpost-fix-address-calculation-in-reloc_location.patch

