Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6D5EC189F56
	for <mm-commits@vger.kernel.org>; Wed,  6 Nov 2024 01:14:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730855654; cv=none; b=eVM6uOsK76WWOtwExODfwLtRKBP40+Ihm0Ik5/pKUw/m/7krZYC9i8BpBPeH5xGqjUS1yt+N1gzXERHCdLSmwH9ZBTNV6U1i+6XxgPWBJqpIY/zG4fuqat/crF0lSHB4n9h1wOz17t9ndjJlVssIqFfYLATdFHVBLksdjC8qpUw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730855654; c=relaxed/simple;
	bh=c2NRgYko2f2S5kGQr3wf4VFgWWSHQX6bZFz/AgLjDQ0=;
	h=Date:To:From:Subject:Message-Id; b=RgPHMCyil7tA1bhkr6+MX15ZHvqg64xWMlLbVQF7YUyt6v5IV+pbkyDilCt9S7s/zj4x44kxFphdfcL2sR+EjsPBcUfW6at7BBAzjqIaLoD1UdHgG5cjW4+Fj+r9bjzlwLB4OvRG/NE1tY9YzW5StWwnHOEFpF+tHD9bEDtwM+4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=NJE5lDXn; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="NJE5lDXn"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 42ECBC4CECF;
	Wed,  6 Nov 2024 01:14:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1730855654;
	bh=c2NRgYko2f2S5kGQr3wf4VFgWWSHQX6bZFz/AgLjDQ0=;
	h=Date:To:From:Subject:From;
	b=NJE5lDXnDbV1Ayt/XX3QIwoulhWXOcgVb2Bs+6KsB1CgHhQK5MAa/P72WIUh0qCXe
	 4PMy9fDLSSBkbWL4v3LkEW+arZeecjnYA7C4NC51diSdKUwqqny2467bXrcqZJG9QP
	 ebR43fQZQ312I+8X4qr2UjE4GjuZeYPGXxdT63kM=
Date: Tue, 05 Nov 2024 17:14:13 -0800
To: mm-commits@vger.kernel.org,willy@infradead.org,konishi.ryusuke@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-nonmm-stable] nilfs2-convert-segment-buffer-to-be-folio-based.patch removed from -mm tree
Message-Id: <20241106011414.42ECBC4CECF@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: nilfs2: convert segment buffer to be folio-based
has been removed from the -mm tree.  Its filename was
     nilfs2-convert-segment-buffer-to-be-folio-based.patch

This patch was dropped because it was merged into the mm-nonmm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Ryusuke Konishi <konishi.ryusuke@gmail.com>
Subject: nilfs2: convert segment buffer to be folio-based
Date: Thu, 24 Oct 2024 18:25:35 +0900

Patch series "nilfs2: Finish folio conversion".

This series converts all remaining page structure references in nilfs2 to
folio-based, except for nilfs_copy_buffer function, which was converted to
use folios in advance for cross-fs page flags cleanup.

This prioritizes folio conversion, and does not include buffer head
reference reduction, nor does it support for block sizes larger than the
system page size.

The first eight patches in this series mainly convert each of the
nilfs2-specific metadata implementations to use folios.  The last four
patches, by Matthew Wilcox, eliminate aops writepage callbacks and convert
the remaining page structure references to folio-based.  This part
reflects some corrections to the patch series posted by Matthew.


This patch (of 12):

In the segment buffer (log buffer) implementation, two parts of the block
buffer, CRC calculation and bio preparation, are still page-based, so
convert them to folio-based.

Link: https://lkml.kernel.org/r/20241024092602.13395-1-konishi.ryusuke@gmail.com
Link: https://lkml.kernel.org/r/20241024092602.13395-2-konishi.ryusuke@gmail.com
Signed-off-by: Ryusuke Konishi <konishi.ryusuke@gmail.com>
Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/nilfs2/segbuf.c |   17 ++++++++++-------
 1 file changed, 10 insertions(+), 7 deletions(-)

--- a/fs/nilfs2/segbuf.c~nilfs2-convert-segment-buffer-to-be-folio-based
+++ a/fs/nilfs2/segbuf.c
@@ -205,7 +205,6 @@ static void nilfs_segbuf_fill_in_data_cr
 {
 	struct buffer_head *bh;
 	struct nilfs_segment_summary *raw_sum;
-	void *kaddr;
 	u32 crc;
 
 	bh = list_entry(segbuf->sb_segsum_buffers.next, struct buffer_head,
@@ -220,9 +219,13 @@ static void nilfs_segbuf_fill_in_data_cr
 		crc = crc32_le(crc, bh->b_data, bh->b_size);
 	}
 	list_for_each_entry(bh, &segbuf->sb_payload_buffers, b_assoc_buffers) {
-		kaddr = kmap_local_page(bh->b_page);
-		crc = crc32_le(crc, kaddr + bh_offset(bh), bh->b_size);
-		kunmap_local(kaddr);
+		size_t offset = offset_in_folio(bh->b_folio, bh->b_data);
+		unsigned char *from;
+
+		/* Do not support block sizes larger than PAGE_SIZE */
+		from = kmap_local_folio(bh->b_folio, offset);
+		crc = crc32_le(crc, from, bh->b_size);
+		kunmap_local(from);
 	}
 	raw_sum->ss_datasum = cpu_to_le32(crc);
 }
@@ -374,7 +377,7 @@ static int nilfs_segbuf_submit_bh(struct
 				  struct nilfs_write_info *wi,
 				  struct buffer_head *bh)
 {
-	int len, err;
+	int err;
 
 	BUG_ON(wi->nr_vecs <= 0);
  repeat:
@@ -385,8 +388,8 @@ static int nilfs_segbuf_submit_bh(struct
 			(wi->nilfs->ns_blocksize_bits - 9);
 	}
 
-	len = bio_add_page(wi->bio, bh->b_page, bh->b_size, bh_offset(bh));
-	if (len == bh->b_size) {
+	if (bio_add_folio(wi->bio, bh->b_folio, bh->b_size,
+			  offset_in_folio(bh->b_folio, bh->b_data))) {
 		wi->end++;
 		return 0;
 	}
_

Patches currently in -mm which might be from konishi.ryusuke@gmail.com are


