From: akpm@linux-foundation.org
Subject: + modules-dont-export-section-names-of-empty-sections-via-sysfs.patch added to -mm tree
Date: Wed, 02 Dec 2009 15:54:10 -0800
Message-ID: <200912022354.nB2NsBw9006336@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:46509 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754649AbZLBXyl (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 2 Dec 2009 18:54:41 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: deller@gmx.de, James.Bottomley@HansenPartnership.com, rolandd@cisco.com, rusty@rustcorp.com.au


The patch titled
     modules: don't export section names of empty sections via sysfs
has been added to the -mm tree.  Its filename is
     modules-dont-export-section-names-of-empty-sections-via-sysfs.patch

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
Subject: modules: don't export section names of empty sections via sysfs
From: Helge Deller <deller@gmx.de>

On the parisc architecture we face for each and every loaded kernel module
this kernel "badness warning":

  sysfs: cannot create duplicate filename '/module/ac97_bus/sections/.text'
  Badness at fs/sysfs/dir.c:487

Reason for that is, that on parisc all kernel modules do have multiple
.text sections due to the usage of the -ffunction-sections compiler flag
which is needed to reach all jump targets on this platform.

An objdump on such a kernel module gives:
Sections:
Idx Name          Size      VMA       LMA       File off  Algn
  0 .note.gnu.build-id 00000024  00000000  00000000  00000034  2**2
                  CONTENTS, ALLOC, LOAD, READONLY, DATA
  1 .text         00000000  00000000  00000000  00000058  2**0
                  CONTENTS, ALLOC, LOAD, READONLY, CODE
  2 .text.ac97_bus_match 0000001c  00000000  00000000  00000058  2**2
                  CONTENTS, ALLOC, LOAD, READONLY, CODE
  3 .text         00000000  00000000  00000000  000000d4  2**0
                  CONTENTS, ALLOC, LOAD, READONLY, CODE

...

Since the .text sections are empty (size of 0 bytes) and won't be loaded
by the kernel module loader anyway, I don't see a reason why such sections
need to be listed under /sys/module/<module_name>/sections/<section_name>
either.

The attached patch does solve this issue by not exporting section names
which are empty.

This fixes bugzilla http://bugzilla.kernel.org/show_bug.cgi?id=14703

Signed-off-by: Helge Deller <deller@gmx.de>
Cc: Rusty Russell <rusty@rustcorp.com.au>
Cc: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: Roland Dreier <rolandd@cisco.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/module.c |    5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff -puN kernel/module.c~modules-dont-export-section-names-of-empty-sections-via-sysfs kernel/module.c
--- a/kernel/module.c~modules-dont-export-section-names-of-empty-sections-via-sysfs
+++ a/kernel/module.c
@@ -1037,7 +1037,8 @@ static void add_sect_attrs(struct module
 
 	/* Count loaded sections and allocate structures */
 	for (i = 0; i < nsect; i++)
-		if (sechdrs[i].sh_flags & SHF_ALLOC)
+		if (sechdrs[i].sh_flags & SHF_ALLOC
+		    && sechdrs[i].sh_size)
 			nloaded++;
 	size[0] = ALIGN(sizeof(*sect_attrs)
 			+ nloaded * sizeof(sect_attrs->attrs[0]),
@@ -1057,6 +1058,8 @@ static void add_sect_attrs(struct module
 	for (i = 0; i < nsect; i++) {
 		if (! (sechdrs[i].sh_flags & SHF_ALLOC))
 			continue;
+		if (!sechdrs[i].sh_size)
+			continue;
 		sattr->address = sechdrs[i].sh_addr;
 		sattr->name = kstrdup(secstrings + sechdrs[i].sh_name,
 					GFP_KERNEL);
_

Patches currently in -mm which might be from deller@gmx.de are

origin.patch
linux-next.patch
modules-dont-export-section-names-of-empty-sections-via-sysfs.patch
kernel-sysc-implement-prctlpr_get_endian-for-all-architectures.patch

