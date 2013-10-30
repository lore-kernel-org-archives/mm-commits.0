From: akpm@linux-foundation.org
Subject: +
 initramfs-read-config_rd_-variables-for-initramfs-compression.patch added
 to -mm tree
Date: Wed, 30 Oct 2013 16:08:31 -0700
Message-ID: <5271916f.RlUqjSu/g1gcCKzr%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:49863 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751459Ab3J3XIb (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 30 Oct 2013 19:08:31 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, prasad@redhat.com, ppandit@redhat.com

Subject: + initramfs-read-config_rd_-variables-for-initramfs-compression.patch added to -mm tree
To: ppandit@redhat.com,prasad@redhat.com
From: akpm@linux-foundation.org
Date: Wed, 30 Oct 2013 16:08:31 -0700


The patch titled
     Subject: initramfs: read CONFIG_RD_ variables for initramfs compression
has been added to the -mm tree.  Its filename is
     initramfs-read-config_rd_-variables-for-initramfs-compression.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/initramfs-read-config_rd_-variables-for-initramfs-compression.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/initramfs-read-config_rd_-variables-for-initramfs-compression.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: P J P <ppandit@redhat.com>
Subject: initramfs: read CONFIG_RD_ variables for initramfs compression

When expert configuration option(CONFIG_EXPERT) is enabled, menuconfig
offers a choice of compression algorithm to compress initial ramfs image;
This choice is stored into CONFIG_RD_* variables.  But usr/Makefile uses
earlier INITRAMFS_COMPRESSION_* macros to build initial ramfs file.  Since
none of them is defined, resulting 'initramfs_data.cpio' file remains
un-compressed.

This patch updates the Makefile to use CONFIG_RD_* variables and adds
support for LZ4 compression algorithm.

Signed-off-by: P J P <prasad@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 scripts/gen_initramfs_list.sh |    1 +
 usr/Makefile                  |   19 ++++++++++++-------
 2 files changed, 13 insertions(+), 7 deletions(-)

diff -puN scripts/gen_initramfs_list.sh~initramfs-read-config_rd_-variables-for-initramfs-compression scripts/gen_initramfs_list.sh
--- a/scripts/gen_initramfs_list.sh~initramfs-read-config_rd_-variables-for-initramfs-compression
+++ a/scripts/gen_initramfs_list.sh
@@ -246,6 +246,7 @@ case "$arg" in
 		echo "$output_file" | grep -q "\.xz$" && \
 				compr="xz --check=crc32 --lzma2=dict=1MiB"
 		echo "$output_file" | grep -q "\.lzo$" && compr="lzop -9 -f"
+		echo "$output_file" | grep -q "\.lz4$" && compr="lz4 -9 -f"
 		echo "$output_file" | grep -q "\.cpio$" && compr="cat"
 		shift
 		;;
diff -puN usr/Makefile~initramfs-read-config_rd_-variables-for-initramfs-compression usr/Makefile
--- a/usr/Makefile~initramfs-read-config_rd_-variables-for-initramfs-compression
+++ a/usr/Makefile
@@ -7,19 +7,22 @@ PHONY += klibcdirs
 
 
 # Gzip
-suffix_$(CONFIG_INITRAMFS_COMPRESSION_GZIP)   = .gz
+suffix_$(CONFIG_RD_GZIP)   = .gz
 
 # Bzip2
-suffix_$(CONFIG_INITRAMFS_COMPRESSION_BZIP2)  = .bz2
+suffix_$(CONFIG_RD_BZIP2)  = .bz2
 
 # Lzma
-suffix_$(CONFIG_INITRAMFS_COMPRESSION_LZMA)   = .lzma
+suffix_$(CONFIG_RD_LZMA)   = .lzma
 
 # XZ
-suffix_$(CONFIG_INITRAMFS_COMPRESSION_XZ)     = .xz
+suffix_$(CONFIG_RD_XZ)     = .xz
 
 # Lzo
-suffix_$(CONFIG_INITRAMFS_COMPRESSION_LZO)   = .lzo
+suffix_$(CONFIG_RD_LZO)    = .lzo
+
+# Lz4
+suffix_$(CONFIG_RD_LZ4)    = .lz4
 
 AFLAGS_initramfs_data.o += -DINITRAMFS_IMAGE="usr/initramfs_data.cpio$(suffix_y)"
 
@@ -53,7 +56,10 @@ endif
 quiet_cmd_initfs = GEN     $@
       cmd_initfs = $(initramfs) -o $@ $(ramfs-args) $(ramfs-input)
 
-targets := initramfs_data.cpio.gz initramfs_data.cpio.bz2 initramfs_data.cpio.lzma initramfs_data.cpio.xz initramfs_data.cpio.lzo initramfs_data.cpio
+targets := initramfs_data.cpio.gz initramfs_data.cpio.bz2 \
+	initramfs_data.cpio.lzma initramfs_data.cpio.xz \
+	initramfs_data.cpio.lzo initramfs_data.cpio.lz4 \
+	initramfs_data.cpio
 # do not try to update files included in initramfs
 $(deps_initramfs): ;
 
@@ -66,4 +72,3 @@ $(deps_initramfs): klibcdirs
 $(obj)/initramfs_data.cpio$(suffix_y): $(obj)/gen_init_cpio $(deps_initramfs) klibcdirs
 	$(Q)$(initramfs) -l $(ramfs-input) > $(obj)/.initramfs_data.cpio.d
 	$(call if_changed,initfs)
