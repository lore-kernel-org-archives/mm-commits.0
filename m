Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3C88E386C08
	for <mm-commits@vger.kernel.org>; Thu,  3 Sep 2026 18:33:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788460425; cv=none; b=cqGpn+lbsZKw7iVOKKlIvEUjwmrv+h8j1bP8Hw9d2u1IMJB/DLLfDeqwpNc/C6oeCPZIUUUvbXcPch8ZHBpVdRWX24WcJt2nAteBH/JhwwFtjNvQc9rDSdgMENUqGlfNfXr7CW/DkegF+crcBoPB0TtPyAFeloqoMSkeWK84W/w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788460425; c=relaxed/simple;
	bh=SEKK1lm2kPjGkluszSKwvGzSUxRozlkRu/gqO67S7Xk=;
	h=Date:To:From:Subject:Message-Id; b=slb4/hd0c0ubl4hDRmMUGqLmaA+tPSQjx9GAF9Y0g2T+UkR2cXIBj/r9VA1dGH73VgfqEoM16hBOYxiMxfyGoCkTQpaa9RN1i9D9QRaZYOmbjxCHxtgas97VI9QJPeFoQlVYQxCs/ISsTWlEkc0GGHR3v22pyKeHDFEKC0a+4Tk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=UhuOMTZJ; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="UhuOMTZJ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 65B261F000E9;
	Thu,  3 Sep 2026 18:33:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1788460416;
	bh=Gc1MtCt3HdZ0diMg7ngYAoxbplLWGrXZUbKKxps/hd8=;
	h=Date:To:From:Subject;
	b=UhuOMTZJKy4ZaVkAaGARmE3Ldq3KB4+RE4KIt46E6Yv+iBWvnY5freYWG6uBEhGgS
	 XIt0Ko/eS9/cp73DlU7Kk4GWdH/Wco/1AkgUPns1rdA1Aser5IdAtFQTNsDkFZUCeM
	 8hBzYv6oZBolBFGBIApGnisMSUIT3GCdOrK9FuHw=
Date: Thu, 03 Sep 2026 11:33:35 -0700
To: mm-commits@vger.kernel.org,piaojun@huawei.com,mark@fasheh.com,junxiao.bi@oracle.com,jlbec@evilplan.org,heming.zhao@suse.com,gechangwei@live.cn,joseph.qi@linux.alibaba.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + ocfs2-allow-xattr-bucket-entries-to-span-multiple-blocks.patch added to mm-nonmm-unstable branch
Message-Id: <20260903183336.65B261F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: ocfs2: allow xattr bucket entries to span multiple blocks
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     ocfs2-allow-xattr-bucket-entries-to-span-multiple-blocks.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/ocfs2-allow-xattr-bucket-entries-to-span-multiple-blocks.patch

This patch will later appear in the mm-nonmm-unstable branch at
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
From: Joseph Qi <joseph.qi@linux.alibaba.com>
Subject: ocfs2: allow xattr bucket entries to span multiple blocks
Date: Thu, 3 Sep 2026 21:13:12 +0800

Patch series "ocfs2: xattr bucket validation fixes", v2.

This series fixes two problems around xattr bucket validation.

Patch 1 fixes a false-corruption failure on blocksize-512 volumes: the
bucket validator limited the entry array to the first bucket block while
the write path stores entries across the whole 4096-byte bucket region, so
a legitimately written, fsck-clean bucket could be rejected and force the
filesystem read-only.  It also adds an alignment check on the bucket block
number, since the entry array is accessed as one contiguous region and a
corrupted xattr tree could otherwise point a bucket at blocks straddling a
page boundary.

Patch 2 converts two mlog_bug_on_msg() checks in the bucket defrag path to
ocfs2_error() returns, so that a corrupt bucket holding overlapping
entries or an inflated xh_free_start marks the filesystem read-only and
fails the setxattr instead of panicking the kernel.

Both patches have been tested in QEMU: the blocksize-512 reproducer (40
xattrs with 100-byte values, previously failing with "entry count 32
exceeds maximum 31") now passes with a clean fsck.ocfs2 result, and the
ocfs2 testsuite xattr tests pass 48/48 across blocksize combinations.


This patch (of 2):

ocfs2_validate_xattr_bucket() limits the entry array to the first bucket
block, but the write path stores entries across the whole
OCFS2_XATTR_BUCKET_SIZE region.  With 512-byte blocks a bucket spans eight
blocks, and a bucket filled with small xattrs places its last entries past
offset 512.  Reading such a bucket back errors out:

  OCFS2: ERROR (device loop0): ocfs2_validate_xattr_bucket: Invalid xattr bucket 86072: entry count 32 exceeds maximum 31
  On-disk corruption discovered. Please run fsck.ocfs2 once the filesystem is unmounted.
  OCFS2: File system is now read-only.

This is reproducible by setting ~33 xattrs with 100-byte values on a file
on a blocksize-512 volume; fsck.ocfs2 reports the resulting image clean.

Check the entry count against the full bucket region instead.  The
per-block bounds checks for names and values stay as they are, since
ocfs2_bucket_align_free_start() keeps each name+value pair within a single
block.

The entry array is one contiguous region, so a bucket from a corrupted
xattr tree whose first block is not aligned to OCFS2_XATTR_BUCKET_SIZE
could straddle a page and make the validation loop read out of bounds. 
Buckets allocated within clusters are always aligned, so reject any other
block number while validating.

Link: https://lore.kernel.org/20260903131313.2396208-1-joseph.qi@linux.alibaba.com
Link: https://lore.kernel.org/20260903131313.2396208-2-joseph.qi@linux.alibaba.com
Fixes: 2cf82b46d5e4 ("ocfs2: validate external xattr entries when reading metadata")
Signed-off-by: Joseph Qi <joseph.qi@linux.alibaba.com>
Cc: Mark Fasheh <mark@fasheh.com>
Cc: Joel Becker <jlbec@evilplan.org>
Cc: Junxiao Bi <junxiao.bi@oracle.com>
Cc: Changwei Ge <gechangwei@live.cn>
Cc: Jun Piao <piaojun@huawei.com>
Cc: Heming Zhao <heming.zhao@suse.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/ocfs2/xattr.c |   21 ++++++++++++++++++++-
 1 file changed, 20 insertions(+), 1 deletion(-)

--- a/fs/ocfs2/xattr.c~ocfs2-allow-xattr-bucket-entries-to-span-multiple-blocks
+++ a/fs/ocfs2/xattr.c
@@ -1153,11 +1153,30 @@ static int ocfs2_validate_xattr_bucket(s
 	struct ocfs2_xattr_header *xh = bucket_xh(bucket);
 	u16 xattr_count = le16_to_cpu(xh->xh_count);
 	size_t region_size = (size_t)sb->s_blocksize * bucket->bu_blocks;
-	size_t entries_limit = sb->s_blocksize;
+	/*
+	 * The entry array grows up from the header across the whole
+	 * bucket region, so it may extend beyond the first bucket block
+	 * when the blocksize is smaller than OCFS2_XATTR_BUCKET_SIZE.
+	 * Name/value pairs, however, always live within a single block.
+	 */
+	size_t entries_limit = region_size;
 	size_t nv_limit = sb->s_blocksize;
 	size_t max_entries;
 	int i, ret;
 
+	/*
+	 * The entry array is one contiguous region that may span the
+	 * bucket's buffer_heads.  Buckets are allocated within clusters,
+	 * so their first block is always aligned to
+	 * OCFS2_XATTR_BUCKET_SIZE and the whole bucket fits in one page.
+	 * A corrupted xattr tree can point a bucket at blocks straddling
+	 * a page, so reject it before touching the entry array.
+	 */
+	if (blkno & (bucket->bu_blocks - 1))
+		return ocfs2_error(sb,
+				   "Invalid xattr bucket %llu: unaligned block number\n",
+				   (unsigned long long)blkno);
+
 	if (region_size < sizeof(*xh))
 		return ocfs2_error(sb,
 				   "Invalid xattr bucket %llu: region size %zu is too small\n",
_

Patches currently in -mm which might be from joseph.qi@linux.alibaba.com are

ocfs2-fix-deadlock-in-inline-data-truncate-transactions.patch
ocfs2-exit-recovery-thread-on-mount-error-path.patch
ocfs2-free-replay-slots-in-ocfs2_recovery_exit.patch
ocfs2-defer-suballocator-block-group-reclaim-to-workqueue.patch
ocfs2-restrict-ocfs2_invalid_slot-suballoc-slot-to-system-inodes.patch
ocfs2-validate-suballoc-bit-during-inode-read.patch
ocfs2-validate-suballoc-slot-and-bit-of-xattr-and-dir-index-blocks.patch
ocfs2-validate-suballoc-slot-and-bit-of-extent-and-refcount-blocks.patch
ocfs2-allow-xattr-bucket-entries-to-span-multiple-blocks.patch
ocfs2-reject-inconsistent-xattr-bucket-during-defrag.patch

