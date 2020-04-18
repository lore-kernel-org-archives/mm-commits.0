From: akpm@linux-foundation.org
Subject: +
 squashfs-migrate-from-ll_rw_block-usage-to-bio-fix.patch added to -mm tree
Date: Sat, 18 Apr 2020 12:47:53 -0700
Message-ID: <20200418194753.mEKcdizCv%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:48738 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727927AbgDRTrz (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Sat, 18 Apr 2020 15:47:55 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: adrien+dev@schischi.me, akpm@linux-foundation.org, drosen@google.com, groeck@chromium.org, hch@lst.de, mm-commits@vger.kernel.org, phillip@squashfs.org.uk, pliard@google.com, rdunlap@infradead.org, sfr@canb.auug.org.au


The patch titled
     Subject: squashfs-migrate-from-ll_rw_block-usage-to-bio-fix
has been added to the -mm tree.  Its filename is
     squashfs-migrate-from-ll_rw_block-usage-to-bio-fix.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/squashfs-migrate-from-ll_rw_block-usage-to-bio-fix.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/squashfs-migrate-from-ll_rw_block-usage-to-bio-fix.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: squashfs-migrate-from-ll_rw_block-usage-to-bio-fix

fix build error reported by Randy

Link: http://lkml.kernel.org/r/319997c2-5fc8-f889-2ea3-d913308a7c1f@infradead.org
Cc: Adrien Schildknecht <adrien+dev@schischi.me>
Cc: Christoph Hellwig <hch@lst.de>
Cc: Daniel Rosenberg <drosen@google.com>
Cc: Guenter Roeck <groeck@chromium.org>
Cc: Philippe Liard <pliard@google.com>
Cc: Phillip Lougher <phillip@squashfs.org.uk>
Cc: Randy Dunlap <rdunlap@infradead.org>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/squashfs/decompressor_multi_percpu.c |   17 ++++++++++-------
 1 file changed, 10 insertions(+), 7 deletions(-)

--- a/fs/squashfs/decompressor_multi_percpu.c~squashfs-migrate-from-ll_rw_block-usage-to-bio-fix
+++ a/fs/squashfs/decompressor_multi_percpu.c
@@ -72,14 +72,17 @@ void squashfs_decompressor_destroy(struc
 	}
 }
 
-int squashfs_decompress(struct squashfs_sb_info *msblk, struct buffer_head **bh,
-	int b, int offset, int length, struct squashfs_page_actor *output)
+int squashfs_decompress(struct squashfs_sb_info *msblk, struct bio *bio,
+	int offset, int length, struct squashfs_page_actor *output)
 {
-	struct squashfs_stream __percpu *percpu =
-			(struct squashfs_stream __percpu *) msblk->stream;
-	struct squashfs_stream *stream = get_cpu_ptr(percpu);
-	int res = msblk->decompressor->decompress(msblk, stream->stream, bh, b,
-		offset, length, output);
+	struct squashfs_stream __percpu *percpu;
+	struct squashfs_stream *stream;
+	int res;
+
+	percpu = (struct squashfs_stream __percpu *)msblk->stream;
+	stream = get_cpu_ptr(percpu);
+	res = msblk->decompressor->decompress(msblk, stream->stream, bio,
+					      offset, length, output);
 	put_cpu_ptr(stream);
 
 	if (res < 0)
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

maintainers-add-an-entry-for-kfifo-fix.patch
maintainers-add-an-entry-for-kfifo-fix-fix.patch
mm-ksm-fix-null-pointer-dereference-when-ksm-zero-page-is-enabled-v4-fix.patch
squashfs-migrate-from-ll_rw_block-usage-to-bio-fix.patch
drivers-tty-serial-sh-scic-suppress-uninitialized-var-warning.patch
mm.patch
mm-slub-fix-corrupted-freechain-in-deactivate_slab-fix.patch
memcg-optimize-memorynuma_stat-like-memorystat-fix.patch
mm-switch-the-test_vmalloc-module-to-use-__vmalloc_node-fix.patch
mm-replace-zero-length-array-with-flexible-array-member-fix.patch
mm-hugetlb-fix-a-typo-in-comment-manitained-maintained-v2-checkpatch-fixes.patch
linux-next-fix.patch
kernel-forkc-export-kernel_thread-to-modules.patch
