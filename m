Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EFC2720EA36
	for <mm-commits@vger.kernel.org>; Fri, 25 Oct 2024 19:37:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729885068; cv=none; b=i6I0SGXiqdgaYM/Rt72sHAS4v888uCtKXlc3tpboweegQU7O2W5lyLL8hjj9xxmkh+7AD1HzB5J9JCAhrN67VY/Xa3NrIN7lNZAp7jLhCCuI6K06xF0jP+sng6s7caYNj/Z56utcTGFC9H7zewODVaeZ48RZBcxWqsNy1AjD0h4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729885068; c=relaxed/simple;
	bh=at0SB5VknJuIXNzvSALT3bq9Da5zcRXSHjB4zzDZeMo=;
	h=Date:To:From:Subject:Message-Id; b=jUTxlzZQlhN+PdUG7Iy8PgOqQGrhbRkCB4yqTn0cE1f+/9joOiBj4vcbmeXq6nxYND84Hj8cgEH9t1k6qesdunRBAv423cwJBzuXv9FOk2h3VKsNMgO5AUKJukvWEc5vQNro6kXm4yfMwshhAF+J7wtXMf4aHtPIO3UFxWFj44Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=WNBTorsO; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="WNBTorsO"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 64AD5C4CEC3;
	Fri, 25 Oct 2024 19:37:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1729885067;
	bh=at0SB5VknJuIXNzvSALT3bq9Da5zcRXSHjB4zzDZeMo=;
	h=Date:To:From:Subject:From;
	b=WNBTorsOucpi8JD/sw0GXWWoqRhahbHV/9uWGkuKQsSooQIWdQRI76r6FbTS3qk69
	 /yR6da/ceIb3V9Fj8T7m4GSvaCSwy7y6DpZUmXS4lEUMmYcM85Ben0zzIQPWFrFQLu
	 zI7Zt0Fg/+00+s66wJM4QtJfRbb/JzXryS5NxOsE=
Date: Fri, 25 Oct 2024 12:37:46 -0700
To: mm-commits@vger.kernel.org,willy@infradead.org,konishi.ryusuke@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + nilfs2-convert-segment-buffer-to-be-folio-based.patch added to mm-nonmm-unstable branch
Message-Id: <20241025193747.64AD5C4CEC3@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: nilfs2: convert segment buffer to be folio-based
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     nilfs2-convert-segment-buffer-to-be-folio-based.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/nilfs2-convert-segment-buffer-to-be-folio-based.patch

This patch will later appear in the mm-nonmm-unstable branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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

nilfs2-fix-potential-deadlock-with-newly-created-symlinks.patch
nilfs2-convert-segment-buffer-to-be-folio-based.patch
nilfs2-convert-common-metadata-file-code-to-be-folio-based.patch
nilfs2-convert-segment-usage-file-to-be-folio-based.patch
nilfs2-convert-persistent-object-allocator-to-be-folio-based.patch
nilfs2-convert-inode-file-to-be-folio-based.patch
nilfs2-convert-dat-file-to-be-folio-based.patch
nilfs2-remove-nilfs_palloc_block_get_entry.patch
nilfs2-convert-checkpoint-file-to-be-folio-based.patch

