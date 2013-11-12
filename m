From: akpm@linux-foundation.org
Subject: [folded-merged]
 initramfs-read-config_rd_-variables-for-initramfs-compression-fix-2.patch
 removed from -mm tree
Date: Tue, 12 Nov 2013 14:43:11 -0800
Message-ID: <5282aeff.5875eGuatY991rhv%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:60842 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754925Ab3KLWnM (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 12 Nov 2013 17:43:12 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, prasad@redhat.com, ppandit@redhat.com

Subject: [folded-merged] initramfs-read-config_rd_-variables-for-initramfs-compression-fix-2.patch removed from -mm tree
To: ppandit@redhat.com,prasad@redhat.com,mm-commits@vger.kernel.org
From: akpm@linux-foundation.org
Date: Tue, 12 Nov 2013 14:43:11 -0800


The patch titled
     Subject: initramfs-read-config_rd_-variables-for-initramfs-compression-fix-2
has been removed from the -mm tree.  Its filename was
     initramfs-read-config_rd_-variables-for-initramfs-compression-fix-2.patch

This patch was dropped because it was folded into initramfs-read-config_rd_-variables-for-initramfs-compression.patch

------------------------------------------------------
From: P J P <ppandit@redhat.com>
Subject: initramfs-read-config_rd_-variables-for-initramfs-compression-fix-2

Signed-off-by: P J P <prasad@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 scripts/gen_initramfs_list.sh |   18 ++++++++++++------
 1 file changed, 12 insertions(+), 6 deletions(-)

diff -puN scripts/gen_initramfs_list.sh~initramfs-read-config_rd_-variables-for-initramfs-compression-fix-2 scripts/gen_initramfs_list.sh
--- a/scripts/gen_initramfs_list.sh~initramfs-read-config_rd_-variables-for-initramfs-compression-fix-2
+++ a/scripts/gen_initramfs_list.sh
@@ -240,17 +240,23 @@ case "$arg" in
 		output_file="$1"
 		cpio_list="$(mktemp ${TMPDIR:-/tmp}/cpiolist.XXXXXX)"
 		output=${cpio_list}
-		echo "$output_file" | grep -q "\.gz$" && [ -x "/bin/gzip" ] \
+		echo "$output_file" | grep -q "\.gz$" \
+                && [ -x "`which gzip 2> /dev/null`" ] \
                 && compr="gzip -n -9 -f"
-		echo "$output_file" | grep -q "\.bz2$" && [ -x "/bin/bzip2" ] \
+		echo "$output_file" | grep -q "\.bz2$" \
+                && [ -x "`which bzip2 2> /dev/null`" ] \
                 && compr="bzip2 -9 -f"
-		echo "$output_file" | grep -q "\.lzma$" && [ -x "/bin/lzma" ] \
+		echo "$output_file" | grep -q "\.lzma$" \
+                && [ -x "`which lzma 2> /dev/null`" ] \
                 && compr="lzma -9 -f"
-		echo "$output_file" | grep -q "\.xz$" && [ -x "/bin/xz" ] \
+		echo "$output_file" | grep -q "\.xz$" \
+                && [ -x "`which xz 2> /dev/null`" ] \
                 && compr="xz --check=crc32 --lzma2=dict=1MiB"
-		echo "$output_file" | grep -q "\.lzo$" && [ -x "/bin/lzop" ] \
+		echo "$output_file" | grep -q "\.lzo$" \
+                && [ -x "`which lzop 2> /dev/null`" ] \
                 && compr="lzop -9 -f"
-		echo "$output_file" | grep -q "\.lz4$" && [ -x "/bin/lz4" ] \
+		echo "$output_file" | grep -q "\.lz4$" \
+                && [ -x "`which lz4 2> /dev/null`" ] \
                 && compr="lz4 -9 -f"
 		echo "$output_file" | grep -q "\.cpio$" && compr="cat"
 		shift
_

Patches currently in -mm which might be from ppandit@redhat.com are

initramfs-read-config_rd_-variables-for-initramfs-compression.patch
makefile-export-initial-ramdisk-compression-config-option.patch

