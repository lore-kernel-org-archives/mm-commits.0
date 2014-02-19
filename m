From: akpm@linux-foundation.org
Subject: +
 scripts-gen_initramfs_listsh-fix-flags-for-initramfs-lz4-compression.patch
 added to -mm tree
Date: Tue, 18 Feb 2014 16:20:45 -0800
Message-ID: <5303f8dd.32JNiOGGdZajznSa%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:51756 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751848AbaBSAUq (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 18 Feb 2014 19:20:46 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, mmarek@suse.cz, kyungsik.lee@lge.com, dan@danweeks.net

Subject: + scripts-gen_initramfs_listsh-fix-flags-for-initramfs-lz4-compression.patch added to -mm tree
To: dan@danweeks.net,kyungsik.lee@lge.com,mmarek@suse.cz
From: akpm@linux-foundation.org
Date: Tue, 18 Feb 2014 16:20:45 -0800


The patch titled
     Subject: scripts/gen_initramfs_list.sh: fix flags for initramfs LZ4 compression
has been added to the -mm tree.  Its filename is
     scripts-gen_initramfs_listsh-fix-flags-for-initramfs-lz4-compression.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/scripts-gen_initramfs_listsh-fix-flags-for-initramfs-lz4-compression.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/scripts-gen_initramfs_listsh-fix-flags-for-initramfs-lz4-compression.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: "Daniel M. Weeks" <dan@danweeks.net>
Subject: scripts/gen_initramfs_list.sh: fix flags for initramfs LZ4 compression

LZ4 as implemented in the kernel differs from the default method now used
by the reference implementation of LZ4.  Until the in-kernel method is
updated to support the new default, passing the legacy flag (-l) to the
compressor is necessary.  Without this flag the kernel-generated,
LZ4-compressed initramfs is junk.

Signed-off-by: Daniel M. Weeks <dan@danweeks.net>
Cc: Michal Marek <mmarek@suse.cz>
Cc: Kyungsik Lee <kyungsik.lee@lge.com>
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

scripts-gen_initramfs_listsh-fix-flags-for-initramfs-lz4-compression.patch
initramfs-debug-detected-compression-method.patch
initramfs-debug-detected-compression-method-fix.patch

