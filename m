From: akpm@linux-foundation.org
Subject: + ext2-xip-check-fix.patch added to -mm tree
Date: Wed, 12 Dec 2007 00:53:58 -0800
Message-ID: <200712120853.lBC8rwSu001900@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:37107 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755735AbXLLIyF (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 12 Dec 2007 03:54:05 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: npiggin@suse.de, cotte@de.ibm.com


The patch titled
     ext2: xip check fix
has been added to the -mm tree.  Its filename is
     ext2-xip-check-fix.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: ext2: xip check fix
From: Nick Piggin <npiggin@suse.de>

ext2 should not worry about checking sb->s_blocksize for XIP before the
sb's blocksize actually gets set.

Signed-off-by: Nick Piggin <npiggin@suse.de>
Acked-by: Carsten Otte <cotte@de.ibm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/ext2/super.c |    3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff -puN fs/ext2/super.c~ext2-xip-check-fix fs/ext2/super.c
--- a/fs/ext2/super.c~ext2-xip-check-fix
+++ a/fs/ext2/super.c
@@ -844,8 +844,7 @@ static int ext2_fill_super(struct super_
 
 	blocksize = BLOCK_SIZE << le32_to_cpu(sbi->s_es->s_log_block_size);
 
-	if ((ext2_use_xip(sb)) && ((blocksize != PAGE_SIZE) ||
-				  (sb->s_blocksize != blocksize))) {
+	if (ext2_use_xip(sb) && blocksize != PAGE_SIZE) {
 		if (!silent)
 			printk("XIP: Unsupported blocksize\n");
 		goto failed_mount;
_

Patches currently in -mm which might be from npiggin@suse.de are

alsa-nopage.patch
alsa-usx2y-nopage.patch
git-dvb.patch
ia64-ia32-nopage.patch
ieee1394-nopage.patch
ib-nopage.patch
git-jfs.patch
git-kvm.patch
nfs-use-gfp_nofs-preloads-for-radix-tree-insertion.patch
sg-nopage.patch
usb-mon-nopage.patch
slub-use-non-atomic-bit-unlock.patch
radix-tree-avoid-atomic-allocations-for-preloaded-insertions.patch
mm-dont-allow-ioremapping-of-ranges-larger-than-vmalloc-space.patch
mm-special-mapping-nopage.patch
agp-alpha-nopage.patch
vt-bitlock-fix.patch
radix_treeh-trivial-comment-correction.patch
inotify-fix-race.patch
inotify-remove-debug-code.patch
relay-nopage.patch
uio-nopage.patch
ext2-xip-check-fix.patch
fb-defio-nopage.patch
rewrite-rd.patch
rewrite-rd-fix.patch
rd-support-xip.patch
reiser4.patch
