From: akpm@linux-foundation.org
Subject: + initramfs-add-support-for-in-kernel-initramfs-compressed-with-lzo.patch added to -mm tree
Date: Tue, 20 Apr 2010 15:13:20 -0700
Message-ID: <201004202213.o3KMDKfS013464@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:48550 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752653Ab0DTWOA (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 20 Apr 2010 18:14:00 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: albin.tonnerre@free-electrons.com, hpa@zytor.com, mmarek@suse.cz


The patch titled
     initramfs: add support for in-kernel initramfs compressed with LZO
has been added to the -mm tree.  Its filename is
     initramfs-add-support-for-in-kernel-initramfs-compressed-with-lzo.patch

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
Subject: initramfs: add support for in-kernel initramfs compressed with LZO
From: Albin Tonnerre <albin.tonnerre@free-electrons.com>

Add the necessary parts to be enable the use of LZO-compressed initramfs
build into the kernel.

Signed-off-by: Albin Tonnerre <albin.tonnerre@free-electrons.com>
Cc: "H. Peter Anvin" <hpa@zytor.com>
Cc: Michal Marek <mmarek@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 scripts/gen_initramfs_list.sh |    1 +
 usr/Makefile                  |    5 ++++-
 usr/initramfs_data.lzo.S      |   29 +++++++++++++++++++++++++++++
 3 files changed, 34 insertions(+), 1 deletion(-)

diff -puN scripts/gen_initramfs_list.sh~initramfs-add-support-for-in-kernel-initramfs-compressed-with-lzo scripts/gen_initramfs_list.sh
--- a/scripts/gen_initramfs_list.sh~initramfs-add-support-for-in-kernel-initramfs-compressed-with-lzo
+++ a/scripts/gen_initramfs_list.sh
@@ -243,6 +243,7 @@ case "$arg" in
 		echo "$output_file" | grep -q "\.gz$" && compr="gzip -9 -f"
 		echo "$output_file" | grep -q "\.bz2$" && compr="bzip2 -9 -f"
 		echo "$output_file" | grep -q "\.lzma$" && compr="lzma -9 -f"
+		echo "$output_file" | grep -q "\.lzo$" && compr="lzop -9 -f"
 		echo "$output_file" | grep -q "\.cpio$" && compr="cat"
 		shift
 		;;
diff -puN usr/Makefile~initramfs-add-support-for-in-kernel-initramfs-compressed-with-lzo usr/Makefile
--- a/usr/Makefile~initramfs-add-support-for-in-kernel-initramfs-compressed-with-lzo
+++ a/usr/Makefile
@@ -15,6 +15,9 @@ suffix_$(CONFIG_INITRAMFS_COMPRESSION_BZ
 # Lzma
 suffix_$(CONFIG_INITRAMFS_COMPRESSION_LZMA)   = .lzma
 
+# Lzo
+suffix_$(CONFIG_INITRAMFS_COMPRESSION_LZO)   = .lzo
+
 # Generate builtin.o based on initramfs_data.o
 obj-$(CONFIG_BLK_DEV_INITRD) := initramfs_data$(suffix_y).o
 
@@ -45,7 +48,7 @@ endif
 quiet_cmd_initfs = GEN     $@
       cmd_initfs = $(initramfs) -o $@ $(ramfs-args) $(ramfs-input)
 
-targets := initramfs_data.cpio.gz initramfs_data.cpio.bz2 initramfs_data.cpio.lzma initramfs_data.cpio
+targets := initramfs_data.cpio.gz initramfs_data.cpio.bz2 initramfs_data.cpio.lzma initramfs_data.cpio.lzo initramfs_data.cpio
 # do not try to update files included in initramfs
 $(deps_initramfs): ;
 
diff -puN /dev/null usr/initramfs_data.lzo.S
--- /dev/null
+++ a/usr/initramfs_data.lzo.S
@@ -0,0 +1,29 @@
+/*
+  initramfs_data includes the compressed binary that is the
+  filesystem used for early user space.
+  Note: Older versions of "as" (prior to binutils 2.11.90.0.23
+  released on 2001-07-14) dit not support .incbin.
+  If you are forced to use older binutils than that then the
+  following trick can be applied to create the resulting binary:
+
+
+  ld -m elf_i386  --format binary --oformat elf32-i386 -r \
+  -T initramfs_data.scr initramfs_data.cpio.gz -o initramfs_data.o
+   ld -m elf_i386  -r -o built-in.o initramfs_data.o
+
+  initramfs_data.scr looks like this:
+SECTIONS
+{
+       .init.ramfs : { *(.data) }
+}
+
+  The above example is for i386 - the parameters vary from architectures.
+  Eventually look up LDFLAGS_BLOB in an older version of the
+  arch/$(ARCH)/Makefile to see the flags used before .incbin was introduced.
+
+  Using .incbin has the advantage over ld that the correct flags are set
+  in the ELF header, as required by certain architectures.
+*/
+
+.section .init.ramfs,"a"
+.incbin "usr/initramfs_data.cpio.lzo"
_

Patches currently in -mm which might be from albin.tonnerre@free-electrons.com are

linux-next.patch
lib-fix-the-use-of-lzo-to-decompress-initramfs-images.patch
initramfs-add-support-for-in-kernel-initramfs-compressed-with-lzo.patch

