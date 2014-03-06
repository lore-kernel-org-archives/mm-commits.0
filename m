From: akpm@linux-foundation.org
Subject: [merged]
 scripts-gen_initramfs_listsh-fix-flags-for-initramfs-lz4-compression.patch
 removed from -mm tree
Date: Thu, 06 Mar 2014 12:37:36 -0800
Message-ID: <5318dc90.uVNDcLvPlzgVz26f%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:35523 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753032AbaCFUhh (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 6 Mar 2014 15:37:37 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, mmarek@suse.cz, kyungsik.lee@lge.com, dan@danweeks.net

Subject: [merged] scripts-gen_initramfs_listsh-fix-flags-for-initramfs-lz4-compression.patch removed from -mm tree
To: dan@danweeks.net,kyungsik.lee@lge.com,mmarek@suse.cz,mm-commits@vger.kernel.org
From: akpm@linux-foundation.org
Date: Thu, 06 Mar 2014 12:37:36 -0800


The patch titled
     Subject: scripts/gen_initramfs_list.sh: fix flags for initramfs LZ4 compression
has been removed from the -mm tree.  Its filename was
     scripts-gen_initramfs_listsh-fix-flags-for-initramfs-lz4-compression.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: "Daniel M. Weeks" <dan@danweeks.net>
Subject: scripts/gen_initramfs_list.sh: fix flags for initramfs LZ4 compression

LZ4 as implemented in the kernel differs from the default method now used
by the reference implementation of LZ4.  Until the in-kernel method is
updated to support the new default, passing the legacy flag (-l) to the
compressor is necessary.  Without this flag the kernel-generated,
LZ4-compressed initramfs is junk.

Kyungsik said:

: It seems that lz4 supports legacy format with the same option as lz4c
: does.  Just looking at the first few bytes of lz4 compressed image, we can
: see whether it is new format or not.
: 
: It shows new format magic number without this patch.  New format magic
: number is 0x184d2204.
: 
: $ hexdump -C ./initramfs_data.cpio.lz4 |more
: 00000000  04 22 4d 18 64 70 b9 69 (Little Endian)
: ...
: 
: Currently kernel supports legacy format only.

Signed-off-by: Daniel M. Weeks <dan@danweeks.net>
Cc: Michal Marek <mmarek@suse.cz>
Acked-by: Kyungsik Lee <kyungsik.lee@lge.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 scripts/gen_initramfs_list.sh |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN scripts/gen_initramfs_list.sh~scripts-gen_initramfs_listsh-fix-flags-for-initramfs-lz4-compression scripts/gen_initramfs_list.sh
--- a/scripts/gen_initramfs_list.sh~scripts-gen_initramfs_listsh-fix-flags-for-initramfs-lz4-compression
+++ a/scripts/gen_initramfs_list.sh
@@ -257,7 +257,7 @@ case "$arg" in
                 && compr="lzop -9 -f"
 		echo "$output_file" | grep -q "\.lz4$" \
                 && [ -x "`which lz4 2> /dev/null`" ] \
-                && compr="lz4 -9 -f"
+                && compr="lz4 -l -9 -f"
 		echo "$output_file" | grep -q "\.cpio$" && compr="cat"
 		shift
 		;;
_

Patches currently in -mm which might be from dan@danweeks.net are

origin.patch
initramfs-debug-detected-compression-method.patch
initramfs-debug-detected-compression-method-fix.patch

