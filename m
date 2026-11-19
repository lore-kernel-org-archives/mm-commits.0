Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795111405;
	b=cLNeja1Ki0vPbRZomNOyakBGdcGidH4kGXiAEs4y4ADPDDWObN0ZqTj2ywc+tXK9RhLZ
	 QABxKuZno72VWQL87CElMs9TOAIoFUMR9QteG+HZQ1tCJkQFhFwblSI4gwWHS7wbHZ0X5
	 9Uzp8mcvn/jXfNtXm2mEsdvdgfNAXeGvqUJCtNq/Xi8VaL79C8M7nkCEsWGhxtP6Sx4O+
	 9vFy/M+IPPrr1nHEpvCPzcGM6a5LAK+kgG8NqW6z+KIrKakJSFLWUscY5yBmbGZii2oIW
	 041/B/3xvBDu4X61rHoyjZ4wAuI+eobJt49KwZodDCl5qPf5U4lGjhyIiyz7IYQRAFg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795111405;
	h=Received:DKIM-Signature:Date:To:From:In-Reply-To:References:Subject:
	 Message-Id;
	bh=KJuxHKBoS2oEPsq5B19tqzGhSzTY1MgHiydTaFUrvsI=;
	b=Vyo5F1+UHh5Vcik8+vdGz3Y3PQ7U64pVAry3Y2D/CE6EfqXB0UWVFh0UazeFnSKSRAFp
	 6sRamsVKwtEgfR7wBkW9nHLKI/gsJAKXybIzmRb6Sb3xtr82ykOl/yw4EtF4tFven28gf
	 yRKIsOzkV7ja+xjx9QTjAxF+M411Q4cAkcL1106zdwjDaydeeyQpAFZzkodNz0NdpRCgD
	 5fFpAbY3Xv3cWpvMJOmZfTWoKmj7jhF+pT8ZxoALdSF3eeXV5HwBVnRb/hf385eO/7ldT
	 y4S8szuq7xxe4QFiQOZPDeuu+NYxFvh5j3LgjIFK9PQnGt6/pCNTD7XH6mJ+/QfCwDQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=lxSBNDpi;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 334B8606A325;
	Thu, 19 Nov 2026 18:03:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=lxSBNDpi
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D39341F000C9;
	Thu, 19 Nov 2026 18:03:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1795111404;
	bh=KJuxHKBoS2oEPsq5B19tqzGhSzTY1MgHiydTaFUrvsI=;
	h=Date:To:From:In-Reply-To:References:Subject;
	b=lxSBNDpiViI6flZHVXIot/WqCCpVcTtf6eofu/Yh1LyC1xITvSTEOnHBf856gaNsz
	 4D7pBlqVvFCDxIbdrAM4XG6Pnv0EtYnlyGFEhJfA11KGhLqMWXA67MjDlxHFrG8d+Y
	 H74bshhOJ7Vbyl7jYvq4gsmJlZhfirXkTmG9qOXM=
Date: Thu, 19 Nov 2026 10:03:24 -0800
To: mm-commits@vger.kernel.org,viro@zeniv.linux.org.uk,tz2294@columbia.edu,
	stable@vger.kernel.org,l1za0.sec@gmail.com,kbusch@kernel.org,hch@lst.de,
	hare@kernel.org,brauner@kernel.org,axboe@kernel.dk,4ncienth@gmail.com,
	akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
In-Reply-To: <20261015061907.2713943-1-4ncienth@gmail.com>
References: <20261015061907.2713943-1-4ncienth@gmail.com>
Subject: [merged] iov_iter-validate-extracted-segment-for-bvec-alignment.patch removed from -mm tree
Message-Id: <20261119180324.D39341F000C9@smtp.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Post: <mailto:mm-commits@vger.kernel.org>
List-Help: <mailto:mm-commits+help@vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>
List-Owner: <mailto:mm-commits+owner@vger.kernel.org>
Precedence: list


The quilt patch titled
     Subject: iov_iter: validate extracted segment for bvec alignment
has been removed from the -mm tree.  Its filename was
     iov_iter-validate-extracted-segment-for-bvec-alignment.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Daehyeon Ko <4ncienth@gmail.com>
Subject: iov_iter: validate extracted segment for bvec alignment
Date: Thu, 15 Oct 2026 15:19:07 +0900

iov_iter_extract_bvecs() validates iter_iov_addr() and iter_iov_len()
before iov_iter_extract_pages() selects the first nonempty segment and
limits it by iter->count.  The checks can therefore cover a different
range after a leading empty segment or iov_iter_truncate().

An unprivileged O_DIRECT preadv() reproduced the empty-segment case: an
aligned empty segment followed by a misaligned one completed 4096 bytes
instead of returning -EINVAL.  A truncated iterator has the same mismatch
when its full segment length is aligned but its remaining count is not.

The worst effect I have confirmed is an alignment-contract bypass.  An
unprivileged O_DIRECT preadv() produced bvecs with offset/length pairs
(1, 4095) and (0, 1).  The bio reached brd_submit_bio(), and the read
completed 4096 bytes instead of failing with -EINVAL.

I have not demonstrated harmful behavior on real DMA hardware.  For a
normal blk-mq target, blk_mq_submit_bio() calls
__bio_split_to_limits(), where bio_split_io_at() rejects the misaligned
bvec before queue_rq().  Virtio-blk and loop both returned -EINVAL in
my controls.

So a bio-based driver can receive a bvec which violates its advertised
dma_alignment, but any further effect is driver-specific.  I have not
reproduced memory corruption or a crash on real hardware.

Bound the normal fast-path length by iter->count.  Keep
first_iovec_segment() for leading empty segments so validation covers the
remaining portion of the segment available for extraction.

Link: https://patch.msgid.link/20261015061907.2713943-1-4ncienth@gmail.com
Fixes: 14b007e17881 ("block: validate user space vectors during extraction")
Signed-off-by: Daehyeon Ko <4ncienth@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Closes: https://lore.kernel.org/r/20261012065520.1089147-1-4ncienth@gmail.com
Cc: Al Viro <viro@zeniv.linux.org.uk>
Cc: Jens Axboe <axboe@kernel.dk>
Cc: Keith Busch <kbusch@kernel.org>
Cc: Hannes Reinecke <hare@kernel.org>
Cc: Christoph Hellwig <hch@lst.de>
Cc: Haocheng Yu <l1za0.sec@gmail.com>
Cc: Tal Zussman <tz2294@columbia.edu>
Cc: Christian Brauner <brauner@kernel.org>
Cc: <stable@vger.kernel.org>

 lib/iov_iter.c |    9 +++++++--
 1 file changed, 7 insertions(+), 2 deletions(-)

--- a/lib/iov_iter.c~iov_iter-validate-extracted-segment-for-bvec-alignment
+++ a/lib/iov_iter.c
@@ -1042,7 +1042,7 @@ static ssize_t iter_xarray_get_pages(str
 	return maxsize;
 }
 
-/* must be done on non-empty ITER_UBUF or ITER_IOVEC one */
+/* must be used on a non-empty ITER_UBUF, ITER_IOVEC or ITER_KVEC */
 static unsigned long first_iovec_segment(const struct iov_iter *i, size_t *size)
 {
 	size_t skip;
@@ -1959,8 +1959,13 @@ ssize_t iov_iter_extract_bvecs(struct io
 		   iter_is_iovec(iter) ||
 		   iov_iter_is_kvec(iter))) {
 		unsigned long start = (unsigned long)iter_iov_addr(iter);
+		size_t seg_size = min(iter_iov_len(iter), iter->count);
 
-		if ((start | iter_iov_len(iter)) & mem_align_mask)
+		if (unlikely(!seg_size && iter->count)) {
+			seg_size = iter->count;
+			start = first_iovec_segment(iter, &seg_size);
+		}
+		if ((start | seg_size) & mem_align_mask)
 			return -EINVAL;
 	} else if (iov_iter_alignment(iter) & mem_align_mask) {
 		return -EINVAL;
_

Patches currently in -mm which might be from 4ncienth@gmail.com are

mm-hugetlb_cgroup-prevent-use-after-free-during-cgroup-offlining.patch

