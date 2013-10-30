From: akpm@linux-foundation.org
Subject: +
 initramfs-read-config_rd_-variables-for-initramfs-compression-fix.patch
 added to -mm tree
Date: Wed, 30 Oct 2013 15:05:35 -0700
Message-ID: <527182af.kS3s9JSZ7O37v3AZ%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:48542 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752932Ab3J3WFg (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 30 Oct 2013 18:05:36 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, prasad@redhat.com, ppandit@redhat.com

Subject: + initramfs-read-config_rd_-variables-for-initramfs-compression-fix.patch added to -mm tree
To: ppandit@redhat.com,prasad@redhat.com
From: akpm@linux-foundation.org
Date: Wed, 30 Oct 2013 15:05:35 -0700


The patch titled
     Subject: initramfs-read-config_rd_-variables-for-initramfs-compression-fix
has been added to the -mm tree.  Its filename is
     initramfs-read-config_rd_-variables-for-initramfs-compression-fix.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/initramfs-read-config_rd_-variables-for-initramfs-compression-fix.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/initramfs-read-config_rd_-variables-for-initramfs-compression-fix.patch

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
Subject: initramfs-read-config_rd_-variables-for-initramfs-compression-fix

Oops!  '$ make allmodconfig' seems to enables all compression algorithms;
So the last one overrides the previous choices in usr/Makefile.

Please see an updated patch herein.  I've patched 'gen_initramfs_list.sh'
script to check if a selected compression command is accessible or not;
And fall-back to the default gzip(1) format when it is not.  usr/Makefile
also defaults to '.gz' format when all are enabled.

Signed-off-by: P J P <prasad@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 scripts/gen_initramfs_list.sh |   19 ++++++++++++-------
 usr/Makefile                  |    6 +++---
 2 files changed, 15 insertions(+), 10 deletions(-)

diff -puN scripts/gen_initramfs_list.sh~initramfs-read-config_rd_-variables-for-initramfs-compression-fix scripts/gen_initramfs_list.sh
--- a/scripts/gen_initramfs_list.sh~initramfs-read-config_rd_-variables-for-initramfs-compression-fix
+++ a/scripts/gen_initramfs_list.sh
@@ -240,13 +240,18 @@ case "$arg" in
 		output_file="$1"
 		cpio_list="$(mktemp ${TMPDIR:-/tmp}/cpiolist.XXXXXX)"
 		output=${cpio_list}
-		echo "$output_file" | grep -q "\.gz$" && compr="gzip -n -9 -f"
-		echo "$output_file" | grep -q "\.bz2$" && compr="bzip2 -9 -f"
-		echo "$output_file" | grep -q "\.lzma$" && compr="lzma -9 -f"
-		echo "$output_file" | grep -q "\.xz$" && \
-				compr="xz --check=crc32 --lzma2=dict=1MiB"
-		echo "$output_file" | grep -q "\.lzo$" && compr="lzop -9 -f"
-		echo "$output_file" | grep -q "\.lz4$" && compr="lz4 -9 -f"
+		echo "$output_file" | grep -q "\.gz$" && [ -x "/bin/gzip" ] \
+                && compr="gzip -n -9 -f"
+		echo "$output_file" | grep -q "\.bz2$" && [ -x "/bin/bzip2" ] \
+                && compr="bzip2 -9 -f"
+		echo "$output_file" | grep -q "\.lzma$" && [ -x "/bin/lzma" ] \
+                && compr="lzma -9 -f"
+		echo "$output_file" | grep -q "\.xz$" && [ -x "/bin/xz" ] \
+                && compr="xz --check=crc32 --lzma2=dict=1MiB"
+		echo "$output_file" | grep -q "\.lzo$" && [ -x "/bin/lzop" ] \
+                && compr="lzop -9 -f"
+		echo "$output_file" | grep -q "\.lz4$" && [ -x "/bin/lz4" ] \
+                && compr="lz4 -9 -f"
 		echo "$output_file" | grep -q "\.cpio$" && compr="cat"
 		shift
 		;;
diff -puN usr/Makefile~initramfs-read-config_rd_-variables-for-initramfs-compression-fix usr/Makefile
--- a/usr/Makefile~initramfs-read-config_rd_-variables-for-initramfs-compression-fix
+++ a/usr/Makefile
@@ -6,9 +6,6 @@ klibcdirs:;
 PHONY += klibcdirs
 
 
-# Gzip
-suffix_$(CONFIG_RD_GZIP)   = .gz
