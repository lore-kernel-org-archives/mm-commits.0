From: akpm@linux-foundation.org
Subject: + initramfs-generalize-initramfs_dataxxxs-variants.patch added to -mm tree
Date: Fri, 17 Sep 2010 15:24:09 -0700
Message-ID: <201009172224.o8HMO9GW013432@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:37864 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754600Ab0IQWYv (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 17 Sep 2010 18:24:51 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: brueckner@linux.vnet.ibm.com, heiko.carstens@de.ibm.com, hpa@zytor.com, mmarek@suse.cz, schwidefsky@de.ibm.com, xiyou.wangcong@gmail.com


The patch titled
     initramfs: generalize initramfs_data.xxx.S variants
has been added to the -mm tree.  Its filename is
     initramfs-generalize-initramfs_dataxxxs-variants.patch

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
Subject: initramfs: generalize initramfs_data.xxx.S variants
From: Hendrik Brueckner <brueckner@linux.vnet.ibm.com>

Remove initramfs_data.{lzo,lzma,gz,bz2}.S variants and use a common
implementation in initramfs_data.S.  The common implementation expects the
file name of the initramfs to be defined in INITRAMFS_IMAGE.

Change the Makefile to set the INITRAMFS_IMAGE define symbol according
to the selected compression method.

Signed-off-by: Hendrik Brueckner <brueckner@linux.vnet.ibm.com>
Cc: WANG Cong <xiyou.wangcong@gmail.com>
Acked-by: Michal Marek <mmarek@suse.cz>
Cc: "H. Peter Anvin" <hpa@zytor.com>
Cc: Hendrik Brueckner <brueckner@linux.vnet.ibm.com>
Cc: Heiko Carstens <heiko.carstens@de.ibm.com>
Cc: Martin Schwidefsky <schwidefsky@de.ibm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 usr/Makefile              |    6 ++++--
 usr/initramfs_data.S      |    5 +++--
 usr/initramfs_data.bz2.S  |   29 -----------------------------
 usr/initramfs_data.gz.S   |   29 -----------------------------
 usr/initramfs_data.lzma.S |   29 -----------------------------
 usr/initramfs_data.lzo.S  |   29 -----------------------------
 6 files changed, 7 insertions(+), 120 deletions(-)

diff -puN usr/Makefile~initramfs-generalize-initramfs_dataxxxs-variants usr/Makefile
--- a/usr/Makefile~initramfs-generalize-initramfs_dataxxxs-variants
+++ a/usr/Makefile
@@ -18,13 +18,15 @@ suffix_$(CONFIG_INITRAMFS_COMPRESSION_LZ
 # Lzo
 suffix_$(CONFIG_INITRAMFS_COMPRESSION_LZO)   = .lzo
 
+AFLAGS_initramfs_data.o += -DINITRAMFS_IMAGE="usr/initramfs_data.cpio$(suffix_y)"
+
 # Generate builtin.o based on initramfs_data.o
-obj-$(CONFIG_BLK_DEV_INITRD) := initramfs_data$(suffix_y).o
+obj-$(CONFIG_BLK_DEV_INITRD) := initramfs_data.o
 
 # initramfs_data.o contains the compressed initramfs_data.cpio image.
 # The image is included using .incbin, a dependency which is not
 # tracked automatically.
-$(obj)/initramfs_data$(suffix_y).o: $(obj)/initramfs_data.cpio$(suffix_y) FORCE
+$(obj)/initramfs_data.o: $(obj)/initramfs_data.cpio$(suffix_y) FORCE
 
 #####
 # Generate the initramfs cpio archive
diff -puN usr/initramfs_data.S~initramfs-generalize-initramfs_dataxxxs-variants usr/initramfs_data.S
--- a/usr/initramfs_data.S~initramfs-generalize-initramfs_dataxxxs-variants
+++ a/usr/initramfs_data.S
@@ -25,6 +25,7 @@ SECTIONS
   in the ELF header, as required by certain architectures.
 */
 
-.section .init.ramfs,"a"
-.incbin "usr/initramfs_data.cpio"
+#include <linux/stringify.h>
 
+.section .init.ramfs,"a"
+.incbin __stringify(INITRAMFS_IMAGE)
diff -puN usr/initramfs_data.bz2.S~initramfs-generalize-initramfs_dataxxxs-variants /dev/null
--- a/usr/initramfs_data.bz2.S
+++ /dev/null
@@ -1,29 +0,0 @@
-/*
-  initramfs_data includes the compressed binary that is the
-  filesystem used for early user space.
-  Note: Older versions of "as" (prior to binutils 2.11.90.0.23
-  released on 2001-07-14) dit not support .incbin.
-  If you are forced to use older binutils than that then the
-  following trick can be applied to create the resulting binary:
-
-
-  ld -m elf_i386  --format binary --oformat elf32-i386 -r \
-  -T initramfs_data.scr initramfs_data.cpio.gz -o initramfs_data.o
-   ld -m elf_i386  -r -o built-in.o initramfs_data.o
-
-  initramfs_data.scr looks like this:
-SECTIONS
-{
-       .init.ramfs : { *(.data) }
-}
-
-  The above example is for i386 - the parameters vary from architectures.
-  Eventually look up LDFLAGS_BLOB in an older version of the
-  arch/$(ARCH)/Makefile to see the flags used before .incbin was introduced.
-
-  Using .incbin has the advantage over ld that the correct flags are set
-  in the ELF header, as required by certain architectures.
-*/
-
-.section .init.ramfs,"a"
-.incbin "usr/initramfs_data.cpio.bz2"
diff -puN usr/initramfs_data.gz.S~initramfs-generalize-initramfs_dataxxxs-variants /dev/null
--- a/usr/initramfs_data.gz.S
+++ /dev/null
@@ -1,29 +0,0 @@
-/*
-  initramfs_data includes the compressed binary that is the
-  filesystem used for early user space.
-  Note: Older versions of "as" (prior to binutils 2.11.90.0.23
-  released on 2001-07-14) dit not support .incbin.
-  If you are forced to use older binutils than that then the
-  following trick can be applied to create the resulting binary:
-
-
-  ld -m elf_i386  --format binary --oformat elf32-i386 -r \
-  -T initramfs_data.scr initramfs_data.cpio.gz -o initramfs_data.o
-   ld -m elf_i386  -r -o built-in.o initramfs_data.o
-
-  initramfs_data.scr looks like this:
-SECTIONS
-{
-       .init.ramfs : { *(.data) }
-}
-
-  The above example is for i386 - the parameters vary from architectures.
-  Eventually look up LDFLAGS_BLOB in an older version of the
-  arch/$(ARCH)/Makefile to see the flags used before .incbin was introduced.
-
-  Using .incbin has the advantage over ld that the correct flags are set
-  in the ELF header, as required by certain architectures.
-*/
-
-.section .init.ramfs,"a"
-.incbin "usr/initramfs_data.cpio.gz"
diff -puN usr/initramfs_data.lzma.S~initramfs-generalize-initramfs_dataxxxs-variants /dev/null
--- a/usr/initramfs_data.lzma.S
+++ /dev/null
@@ -1,29 +0,0 @@
-/*
-  initramfs_data includes the compressed binary that is the
-  filesystem used for early user space.
-  Note: Older versions of "as" (prior to binutils 2.11.90.0.23
-  released on 2001-07-14) dit not support .incbin.
-  If you are forced to use older binutils than that then the
-  following trick can be applied to create the resulting binary:
-
-
-  ld -m elf_i386  --format binary --oformat elf32-i386 -r \
-  -T initramfs_data.scr initramfs_data.cpio.gz -o initramfs_data.o
-   ld -m elf_i386  -r -o built-in.o initramfs_data.o
-
-  initramfs_data.scr looks like this:
-SECTIONS
-{
-       .init.ramfs : { *(.data) }
-}
-
-  The above example is for i386 - the parameters vary from architectures.
-  Eventually look up LDFLAGS_BLOB in an older version of the
-  arch/$(ARCH)/Makefile to see the flags used before .incbin was introduced.
-
-  Using .incbin has the advantage over ld that the correct flags are set
-  in the ELF header, as required by certain architectures.
-*/
-
-.section .init.ramfs,"a"
-.incbin "usr/initramfs_data.cpio.lzma"
diff -puN usr/initramfs_data.lzo.S~initramfs-generalize-initramfs_dataxxxs-variants /dev/null
--- a/usr/initramfs_data.lzo.S
+++ /dev/null
@@ -1,29 +0,0 @@
-/*
-  initramfs_data includes the compressed binary that is the
-  filesystem used for early user space.
-  Note: Older versions of "as" (prior to binutils 2.11.90.0.23
-  released on 2001-07-14) dit not support .incbin.
-  If you are forced to use older binutils than that then the
-  following trick can be applied to create the resulting binary:
-
-
-  ld -m elf_i386  --format binary --oformat elf32-i386 -r \
-  -T initramfs_data.scr initramfs_data.cpio.gz -o initramfs_data.o
-   ld -m elf_i386  -r -o built-in.o initramfs_data.o
-
-  initramfs_data.scr looks like this:
-SECTIONS
-{
-       .init.ramfs : { *(.data) }
-}
-
-  The above example is for i386 - the parameters vary from architectures.
-  Eventually look up LDFLAGS_BLOB in an older version of the
-  arch/$(ARCH)/Makefile to see the flags used before .incbin was introduced.
-
-  Using .incbin has the advantage over ld that the correct flags are set
-  in the ELF header, as required by certain architectures.
-*/
