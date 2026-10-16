Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A757B2D2495;
	Fri, 16 Oct 2026 01:18:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792113498; cv=none; b=noxcpdy920ZRAsLDQC4CMwToigsrqNK4AajS84xq0zJdzJ1VCb60AFwlv1IxSZclV9huzo2n/rnx2BU6/bl+Nn6h9Td0u13B0EG0rpgurB1PWcMyU5obNvRzbGogATXBo5i6aQI0/YG0b3A2nI8svKpJrVBVW7Pxk9Y8iB6jpQw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792113498; c=relaxed/simple;
	bh=m2p8ClZhjt+mEQdodurL/RDWzXw7j7up6R8PL32MsXs=;
	h=Date:To:From:Subject:Message-Id; b=YZ8ZE+6r5+JqX+5OnOhc3NjfhUX7fya3H+JBWrQM3j59CDp0HVWE1T1tZ8lZa5+IFZ81waq6bll2nsb3u441HnB55vIw16LWNCBs8xU7E1HZTPkRNuDM+U/p65cm0y3C00IS8ZnKhMFX1Dt+LNLCByBKpcuArD6JxHuYgigilhQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=FHa+0HP/; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="FHa+0HP/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3506B1F000C4;
	Fri, 16 Oct 2026 01:18:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1792113497;
	bh=lNh/S+poiI7m/Vn0zI9okNXLfb2gLAZVmJ+NahNXIQY=;
	h=Date:To:From:Subject;
	b=FHa+0HP/xohpQ+d1sFj8VXBRhFbwFkG2iT0Pdnt1uRWnxcsQR2WzgMWyi72IDsigu
	 Qp7CRorPoiRaJki/vttS0m9rH2zQhISyAIvMQU0WY1oOQI/97JENXqtwEuCHrU1ETD
	 +xuIG8/pDRoRwaRkM93BK+c5ud9EP7xKqDDfKG+w=
Date: Thu, 15 Oct 2026 18:18:16 -0700
To: mm-commits@vger.kernel.org,viro@zeniv.linux.org.uk,stable@vger.kernel.org,kbusch@kernel.org,hare@kernel.org,axboe@kernel.dk,4ncienth@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + iov_iter-validate-extracted-segment-for-bvec-alignment.patch added to mm-hotfixes-unstable branch
Message-Id: <20261016011817.3506B1F000C4@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: iov_iter: validate extracted segment for bvec alignment
has been added to the -mm mm-hotfixes-unstable branch.  Its filename is
     iov_iter-validate-extracted-segment-for-bvec-alignment.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/iov_iter-validate-extracted-segment-for-bvec-alignment.patch

This patch will later appear in the mm-hotfixes-unstable branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next via various
branches at git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
and is updated there most days

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

This can result in a misaligned segment getting fed to the device driver,
with unknown results.

Bound the normal fast-path length by iter->count.  Keep
first_iovec_segment() for leading empty segments so validation covers the
remaining portion of the segment available for extraction.

Link: https://lore.kernel.org/20261015061907.2713943-1-4ncienth@gmail.com
Fixes: 14b007e17881 ("block: validate user space vectors during extraction")
Signed-off-by: Daehyeon Ko <4ncienth@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Closes: https://lore.kernel.org/r/20261012065520.1089147-1-4ncienth@gmail.com
Assisted-by: LLM
Cc: Al Viro <viro@zeniv.linux.org.uk>
Cc: Jens Axboe <axboe@kernel.dk>
Cc: Keith Busch <kbusch@kernel.org>
Cc: Hannes Reinecke <hare@kernel.org>
Cc: <stable@vger.kernel.org>
---

 lib/iov_iter.c |    9 +++++++--
 1 file changed, 7 insertions(+), 2 deletions(-)

--- a/lib/iov_iter.c~iov_iter-validate-extracted-segment-for-bvec-alignment
+++ a/lib/iov_iter.c
@@ -1022,7 +1022,7 @@ static ssize_t iter_xarray_get_pages(str
 	return maxsize;
 }
 
-/* must be done on non-empty ITER_UBUF or ITER_IOVEC one */
+/* must be used on a non-empty ITER_UBUF, ITER_IOVEC or ITER_KVEC */
 static unsigned long first_iovec_segment(const struct iov_iter *i, size_t *size)
 {
 	size_t skip;
@@ -1938,8 +1938,13 @@ ssize_t iov_iter_extract_bvecs(struct io
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

assoc_array-discard-shortcut-when-collapsing-a-leaf-only-node.patch
iov_iter-validate-extracted-segment-for-bvec-alignment.patch

