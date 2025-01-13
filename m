Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A572A1F9AB9
	for <mm-commits@vger.kernel.org>; Mon, 13 Jan 2025 23:11:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736809894; cv=none; b=AkO/eP0fEDp0LjcAyJbGI32a+KclM0NB78J632ZyDKYTPFDfiZQzBxprJdN5/7578wFvnJHZyxHcTO590ZxgS+goeQt1ScAlh5n2rW5D4hFXT+rLJ5yfsc3F2JZTBJOR4oO/4+zF0QOnFtW2ocqQBCL2cwEglxdjbqq6+76tUx4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736809894; c=relaxed/simple;
	bh=vCkwMMWngFHiqR+o3Rwv8P70U45YSRGnMLDqR+cCj5o=;
	h=Date:To:From:Subject:Message-Id; b=WP30SQUXPXkw2KTRo75n6kikFxUuThIaeEPpQzStCfpLbjUeYOm7C66ru7WibpRwCSc+Of/H7PHv+cS67UVBsEaSzDCs/zTzUsMRNopWjOsXTdSKJrClL6cI0q+OhwvvgcJJ8LVaMGL0Pj8nmkUsT8//oj8xH2KA0/ZPEw7874I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=egW0sTlL; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="egW0sTlL"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 27B2FC4CED6;
	Mon, 13 Jan 2025 23:11:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1736809894;
	bh=vCkwMMWngFHiqR+o3Rwv8P70U45YSRGnMLDqR+cCj5o=;
	h=Date:To:From:Subject:From;
	b=egW0sTlLFcCnsf8ZyvcNMxhDrE+pXybEKrmlyfH1GSO2W2RSVGs4kmZCnioUBO/B+
	 HMgdrcRyFRI+a2xHJE11y9bApzq7IU4C07wa++0BA0K1nWzpUp1D01mqpw5Zrd9cAG
	 tl6G88bIJI8x937nQqHvuNF9foOFQObOLwBwn660=
Date: Mon, 13 Jan 2025 15:11:33 -0800
To: mm-commits@vger.kernel.org,shakeel.butt@linux.dev,mszeredi@redhat.com,josef@toxicpanda.com,jefflexu@linux.alibaba.com,bernd.schubert@fastmail.fm,joannelkoong@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [withdrawn] mm-add-as_writeback_indeterminate-mapping-flag.patch removed from -mm tree
Message-Id: <20250113231134.27B2FC4CED6@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm: add AS_WRITEBACK_INDETERMINATE mapping flag
has been removed from the -mm tree.  Its filename was
     mm-add-as_writeback_indeterminate-mapping-flag.patch

This patch was dropped because it was withdrawn

------------------------------------------------------
From: Joanne Koong <joannelkoong@gmail.com>
Subject: mm: add AS_WRITEBACK_INDETERMINATE mapping flag
Date: Fri, 22 Nov 2024 15:23:55 -0800

Patch series "fuse: remove temp page copies in writeback", v6.

The purpose of this patchset is to help make writeback-cache write
performance in FUSE filesystems as fast as possible.

In the current FUSE writeback design (see commit 3be5a52b30aa ("fuse:
support writable mmap"))), a temp page is allocated for every dirty page
to be written back, the contents of the dirty page are copied over to the
temp page, and the temp page gets handed to the server to write back. 
This is done so that writeback may be immediately cleared on the dirty
page, and this in turn is done for two reasons:

a) in order to mitigate the following deadlock scenario that may arise
   if reclaim waits on writeback on the dirty page to complete (more
   details can be found in this thread [1]):

   * single-threaded FUSE server is in the middle of handling a request
     that needs a memory allocation
   * memory allocation triggers direct reclaim
   * direct reclaim waits on a folio under writeback
   * the FUSE server can't write back the folio since it's stuck in
     direct reclaim

b) in order to unblock internal (eg sync, page compaction) waits on
   writeback without needing the server to complete writing back to disk,
   which may take an indeterminate amount of time.

Allocating and copying dirty pages to temp pages is the biggest
performance bottleneck for FUSE writeback.  This patchset aims to get rid
of the temp page altogether (which will also allow us to get rid of the
internal FUSE rb tree that is needed to keep track of writeback status on
the temp pages).  Benchmarks show approximately a 20% improvement in
throughput for 4k block-size writes and a 45% improvement for 1M
block-size writes.

With removing the temp page, writeback state is now only cleared on the
dirty page after the server has written it back to disk.  This may take an
indeterminate amount of time.  As well, there is also the possibility of
malicious or well-intentioned but buggy servers where writeback may in the
worst case scenario, never complete.  This means that any
folio_wait_writeback() on a dirty page belonging to a FUSE filesystem
needs to be carefully audited.

In particular, these are the cases that need to be accounted for:
* potentially deadlocking in reclaim, as mentioned above
* potentially stalling sync(2)
* potentially stalling page migration / compaction

This patchset adds a new mapping flag, AS_WRITEBACK_INDETERMINATE, which
filesystems may set on its inode mappings to indicate that writeback
operations may take an indeterminate amount of time to complete.  FUSE
will set this flag on its mappings.  This patchset adds checks to the
critical parts of reclaim, sync, and page migration logic where writeback
may be waited on.

Please note the following:
* For sync(2), waiting on writeback will be skipped for FUSE, but this has no
  effect on existing behavior. Dirty FUSE pages are already not guaranteed to
  be written to disk by the time sync(2) returns (eg writeback is cleared on
  the dirty page but the server may not have written out the temp page to disk
  yet). If the caller wishes to ensure the data has actually been synced to
  disk, they should use fsync(2)/fdatasync(2) instead.
* AS_WRITEBACK_INDETERMINATE does not indicate that the folios should never be
  waited on when in writeback. There are some cases where the wait is
  desirable. For example, for the sync_file_range() syscall, it is fine to
  wait on the writeback since the caller passes in a fd for the operation.

[1] https://lore.kernel.org/linux-kernel/495d2400-1d96-4924-99d3-8b2952e05fc3@linux.alibaba.com/


This patch (of 5):

Add a new mapping flag AS_WRITEBACK_INDETERMINATE which filesystems may
set to indicate that writing back to disk may take an indeterminate amount
of time to complete.  Extra caution should be taken when waiting on
writeback for folios belonging to mappings where this flag is set.

Link: https://lkml.kernel.org/r/20241122232359.429647-1-joannelkoong@gmail.com
Link: https://lkml.kernel.org/r/20241122232359.429647-2-joannelkoong@gmail.com
Signed-off-by: Joanne Koong <joannelkoong@gmail.com>
Reviewed-by: Shakeel Butt <shakeel.butt@linux.dev>
Acked-by: Miklos Szeredi <mszeredi@redhat.com>
Cc: Bernd Schubert <bernd.schubert@fastmail.fm>
Cc: Jingbo Xu <jefflexu@linux.alibaba.com>
Cc: Josef Bacik <josef@toxicpanda.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/pagemap.h |   11 +++++++++++
 1 file changed, 11 insertions(+)

--- a/include/linux/pagemap.h~mm-add-as_writeback_indeterminate-mapping-flag
+++ a/include/linux/pagemap.h
@@ -210,6 +210,7 @@ enum mapping_flags {
 	AS_STABLE_WRITES = 7,	/* must wait for writeback before modifying
 				   folio contents */
 	AS_INACCESSIBLE = 8,	/* Do not attempt direct R/W access to the mapping */
+	AS_WRITEBACK_INDETERMINATE = 9, /* Use caution when waiting on writeback */
 	/* Bits 16-25 are used for FOLIO_ORDER */
 	AS_FOLIO_ORDER_BITS = 5,
 	AS_FOLIO_ORDER_MIN = 16,
@@ -335,6 +336,16 @@ static inline bool mapping_inaccessible(
 	return test_bit(AS_INACCESSIBLE, &mapping->flags);
 }
 
+static inline void mapping_set_writeback_indeterminate(struct address_space *mapping)
+{
+	set_bit(AS_WRITEBACK_INDETERMINATE, &mapping->flags);
+}
+
+static inline bool mapping_writeback_indeterminate(struct address_space *mapping)
+{
+	return test_bit(AS_WRITEBACK_INDETERMINATE, &mapping->flags);
+}
+
 static inline gfp_t mapping_gfp_mask(struct address_space * mapping)
 {
 	return mapping->gfp_mask;
_

Patches currently in -mm which might be from joannelkoong@gmail.com are

mm-skip-reclaiming-folios-in-legacy-memcg-writeback-indeterminate-contexts.patch
fs-writeback-in-wait_sb_inodes-skip-wait-for-as_writeback_indeterminate-mappings.patch
mm-migrate-skip-migrating-folios-under-writeback-with-as_writeback_indeterminate-mappings.patch
fuse-remove-tmp-folio-for-writebacks-and-internal-rb-tree.patch

