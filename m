Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BC3B0188906
	for <mm-commits@vger.kernel.org>; Tue, 19 Aug 2025 03:13:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755573207; cv=none; b=FlOv/ocjcctQAeuUVtojvZX8hDwcjthibojeW+BM4lM2GCBuIuYcu6yWfUC0ODW0vDh3SVYSIx5ZmnycbfsBrv+J4btCtwgBG0B4PJiJ+fg3X2rc5AhBXH/vSqVvOmzEXXB879gLCfLyB+c6p8ZhedJbN9UiSmIh4f1XaLk2U+k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755573207; c=relaxed/simple;
	bh=+6mV6k0JWz955ATog8041lXWctvHECzOOx6/C/k6hEQ=;
	h=Date:To:From:Subject:Message-Id; b=CEBTpgIEqQt06LoB2safo7J320gwEetDGsN0o2tZsGoZOfaNg3yXzTZ6JLaubPvSbYI/W/dfdfKoixLHzfqxg9CjJIazHprt/Zr4o22cEPZ1QfaG4U6kRbpXNdcsX3POZyKmYUm8CYAxwRmVrRnrA2M769tdD/hBE+GNBEc8kA0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=SogpUcgd; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="SogpUcgd"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 478B3C4CEF4;
	Tue, 19 Aug 2025 03:13:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1755573207;
	bh=+6mV6k0JWz955ATog8041lXWctvHECzOOx6/C/k6hEQ=;
	h=Date:To:From:Subject:From;
	b=SogpUcgd3zET5BUjachaomtNCGK/OOblRxMF2chEaUqDHqARudVr2/RzG6CLI7iMd
	 /82Mrc6LLPNM3vSB/s6z2ibC36jNynv7hFkOf6199GDScjyIXzukg/4fpEbfsr3Vtt
	 BfbLrUkpD4ldUa/nYN8XgUwn4yY58SHBYfCuThbg=
Date: Mon, 18 Aug 2025 20:13:26 -0700
To: mm-commits@vger.kernel.org,sfr@canb.auug.org.au,mcgrof@kernel.org,hch@infradead.org,djwong@kernel.org,brauner@kernel.org,andrealmeid@igalia.com,p.raghav@samsung.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + iomap-use-largest_zero_folio-in-iomap_dio_zero.patch added to mm-new branch
Message-Id: <20250819031327.478B3C4CEF4@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: iomap: use largest_zero_folio() in iomap_dio_zero()
has been added to the -mm mm-new branch.  Its filename is
     iomap-use-largest_zero_folio-in-iomap_dio_zero.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/iomap-use-largest_zero_folio-in-iomap_dio_zero.patch

This patch will later appear in the mm-new branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Note, mm-new is a provisional staging ground for work-in-progress
patches, and acceptance into mm-new is a notification for others take
notice and to finish up reviews.  Please do not hesitate to respond to
review feedback and post updated versions to replace or incrementally
fixup patches in mm-new.

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next via the mm-everything
branch at git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
and is updated there every 2-3 working days

------------------------------------------------------
From: Pankaj Raghav <p.raghav@samsung.com>
Subject: iomap: use largest_zero_folio() in iomap_dio_zero()
Date: Thu, 14 Aug 2025 16:21:37 +0200

iomap_dio_zero() uses a custom allocated memory of zeroes for padding
zeroes.  This was a temporary solution until there was a way to request a
zero folio that was greater than the PAGE_SIZE.

Use largest_zero_folio() function instead of using the custom allocated
memory of zeroes.  There is no guarantee from largest_zero_folio()
function that it will always return a PMD sized folio.  Adapt the code so
that it can also work if largest_zero_folio() returns a ZERO_PAGE.

Link: https://lkml.kernel.org/r/20250814142137.45469-1-kernel@pankajraghav.com
Signed-off-by: Pankaj Raghav <p.raghav@samsung.com>
Cc: Andre Almeida <andrealmeid@igalia.com>
Cc: Christian Brauner <brauner@kernel.org>
Cc: "Darrick J. Wong" <djwong@kernel.org>
Cc: Luis Chamberalin <mcgrof@kernel.org>
Cc: Stehen Rothwell <sfr@canb.auug.org.au>
Cc: Christoph Hellwig <hch@infradead.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/iomap/direct-io.c |   38 +++++++++++++++-----------------------
 1 file changed, 15 insertions(+), 23 deletions(-)

--- a/fs/iomap/direct-io.c~iomap-use-largest_zero_folio-in-iomap_dio_zero
+++ a/fs/iomap/direct-io.c
@@ -24,13 +24,6 @@
 #define IOMAP_DIO_WRITE		(1U << 30)
 #define IOMAP_DIO_DIRTY		(1U << 31)
 
-/*
- * Used for sub block zeroing in iomap_dio_zero()
- */
-#define IOMAP_ZERO_PAGE_SIZE (SZ_64K)
-#define IOMAP_ZERO_PAGE_ORDER (get_order(IOMAP_ZERO_PAGE_SIZE))
-static struct page *zero_page;
-
 struct iomap_dio {
 	struct kiocb		*iocb;
 	const struct iomap_dio_ops *dops;
@@ -285,24 +278,35 @@ static int iomap_dio_zero(const struct i
 {
 	struct inode *inode = file_inode(dio->iocb->ki_filp);
 	struct bio *bio;
+	struct folio *zero_folio = largest_zero_folio();
+	int nr_vecs = max(1, i_blocksize(inode) / folio_size(zero_folio));
 
 	if (!len)
 		return 0;
+
 	/*
-	 * Max block size supported is 64k
+	 * This limit shall never be reached as most filesystems have a
+	 * maximum blocksize of 64k.
 	 */
-	if (WARN_ON_ONCE(len > IOMAP_ZERO_PAGE_SIZE))
+	if (WARN_ON_ONCE(nr_vecs > BIO_MAX_VECS))
 		return -EINVAL;
 
-	bio = iomap_dio_alloc_bio(iter, dio, 1, REQ_OP_WRITE | REQ_SYNC | REQ_IDLE);
+	bio = iomap_dio_alloc_bio(iter, dio, nr_vecs,
+				  REQ_OP_WRITE | REQ_SYNC | REQ_IDLE);
 	fscrypt_set_bio_crypt_ctx(bio, inode, pos >> inode->i_blkbits,
 				  GFP_KERNEL);
 	bio->bi_iter.bi_sector = iomap_sector(&iter->iomap, pos);
 	bio->bi_private = dio;
 	bio->bi_end_io = iomap_dio_bio_end_io;
 
-	__bio_add_page(bio, zero_page, len, 0);
+	while (len > 0) {
+		unsigned int io_len = min(len, folio_size(zero_folio));
+
+		bio_add_folio_nofail(bio, zero_folio, io_len, 0);
+		len -= io_len;
+	}
 	iomap_dio_submit_bio(iter, dio, bio, pos);
+
 	return 0;
 }
 
@@ -822,15 +826,3 @@ iomap_dio_rw(struct kiocb *iocb, struct
 	return iomap_dio_complete(dio);
 }
 EXPORT_SYMBOL_GPL(iomap_dio_rw);
-
-static int __init iomap_dio_init(void)
-{
-	zero_page = alloc_pages(GFP_KERNEL | __GFP_ZERO,
-				IOMAP_ZERO_PAGE_ORDER);
-
-	if (!zero_page)
-		return -ENOMEM;
-
-	return 0;
-}
-fs_initcall(iomap_dio_init);
_

Patches currently in -mm which might be from p.raghav@samsung.com are

mm-rename-huge_zero_page-to-huge_zero_folio.patch
mm-rename-mmf_huge_zero_page-to-mmf_huge_zero_folio.patch
mm-add-persistent-huge-zero-folio.patch
mm-add-largest_zero_folio-routine.patch
block-use-largest_zero_folio-in-__blkdev_issue_zero_pages.patch
iomap-use-largest_zero_folio-in-iomap_dio_zero.patch

