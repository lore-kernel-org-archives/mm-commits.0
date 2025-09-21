Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7686129ACC3
	for <mm-commits@vger.kernel.org>; Sun, 21 Sep 2025 21:24:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758489889; cv=none; b=t3Rk9ZqzVgjQkc9vd9ulhYAhNVYvhScquR0xbC0posCj7Cdjw90NqxZPcVExEdJDU9Z3gtjmgpRzMk54VcZqgKo7wm2K5Jk9yUc0RXdvDoJtqVvxaZ7K30nK+Ly2mc68qZYYrVMhrY73uJyrz8GUgtcLf36mr7/59ECxG8PStX4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758489889; c=relaxed/simple;
	bh=M9D+qzCAzExI5GSa6MimXl/BjjWG6ryrPUDci2pqh2g=;
	h=Date:To:From:Subject:Message-Id; b=LD+YHbnYukRADAqrQH+Sh3bEwx+nlrdgphgdvqOxdXMYFJNyO9Gx0M2eCxg5r3eJ827veaN/BlP/synn3PIbBrOELwSqvgw1AhPHK2kQ4+nktV5H5WvNg1OFgaiyoJzjBPtnSpA8YCW4LYOVXqWg6OyM2UqNfvH6bHegdf98zRo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=xRn777iW; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="xRn777iW"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 44699C4CEE7;
	Sun, 21 Sep 2025 21:24:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1758489889;
	bh=M9D+qzCAzExI5GSa6MimXl/BjjWG6ryrPUDci2pqh2g=;
	h=Date:To:From:Subject:From;
	b=xRn777iWqsawZIil8HDYeJweIM8UNV3a5xR53u76j7yI1GQ7KvXjDQ71DtAdAPnjM
	 WI4uyT0li9d35rfTXfX8RCZDEbIUNdMZ0T0BN/YtoJ0dX/IfqBVFTHXZMWQBC02DOh
	 +uR4+oAmBkCK+uas5XMqI1i3tUrwOKAnxA10nWNs=
Date: Sun, 21 Sep 2025 14:24:48 -0700
To: mm-commits@vger.kernel.org,youling.tang@linux.dev,willy@infradead.org,ryan.roberts@arm.com,klarasmodin@gmail.com,jack@suse.cz,david@redhat.com,chizhiling@kylinos.cn,tangyouling@kylinos.cn,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-filemap-align-last_index-to-folio-size.patch removed from -mm tree
Message-Id: <20250921212449.44699C4CEE7@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/filemap: align last_index to folio size
has been removed from the -mm tree.  Its filename was
     mm-filemap-align-last_index-to-folio-size.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Youling Tang <tangyouling@kylinos.cn>
Subject: mm/filemap: align last_index to folio size
Date: Fri, 11 Jul 2025 13:55:09 +0800

On XFS systems with pagesize=4K, blocksize=16K, and
CONFIG_TRANSPARENT_HUGEPAGE enabled, We observed the following readahead
behaviors:

 # echo 3 > /proc/sys/vm/drop_caches
 # dd if=test of=/dev/null bs=64k count=1
 # ./tools/mm/page-types -r -L -f  /mnt/xfs/test
 foffset	offset	flags
 0	136d4c	__RU_l_________H______t_________________F_1
 1	136d4d	__RU_l__________T_____t_________________F_1
 2	136d4e	__RU_l__________T_____t_________________F_1
 3	136d4f	__RU_l__________T_____t_________________F_1
 ...
 c	136bb8	__RU_l_________H______t_________________F_1
 d	136bb9	__RU_l__________T_____t_________________F_1
 e	136bba	__RU_l__________T_____t_________________F_1
 f	136bbb	__RU_l__________T_____t_________________F_1   <-- first read
 10	13c2cc	___U_l_________H______t______________I__F_1   <-- readahead flag
 11	13c2cd	___U_l__________T_____t______________I__F_1
 12	13c2ce	___U_l__________T_____t______________I__F_1
 13	13c2cf	___U_l__________T_____t______________I__F_1
 ...
 1c	1405d4	___U_l_________H______t_________________F_1
 1d	1405d5	___U_l__________T_____t_________________F_1
 1e	1405d6	___U_l__________T_____t_________________F_1
 1f	1405d7	___U_l__________T_____t_________________F_1
 [ra_size = 32, req_count = 16, async_size = 16]

 # echo 3 > /proc/sys/vm/drop_caches
 # dd if=test of=/dev/null bs=60k count=1
 # ./page-types -r -L -f  /mnt/xfs/test
 foffset	offset	flags
 0	136048	__RU_l_________H______t_________________F_1
 ...
 c	110a40	__RU_l_________H______t_________________F_1
 d	110a41	__RU_l__________T_____t_________________F_1
 e	110a42	__RU_l__________T_____t_________________F_1   <-- first read
 f	110a43	__RU_l__________T_____t_________________F_1   <-- first readahead flag
 10	13e7a8	___U_l_________H______t_________________F_1
 ...
 20	137a00	___U_l_________H______t_______P______I__F_1   <-- second readahead flag (20 - 2f)
 21	137a01	___U_l__________T_____t_______P______I__F_1
 ...
 3f	10d4af	___U_l__________T_____t_______P_________F_1
 [first readahead: ra_size = 32, req_count = 15, async_size = 17]

When reading 64k data (same for 61-63k range, where last_index is
page-aligned in filemap_get_pages()), 128k readahead is triggered via
page_cache_sync_ra() and the PG_readahead flag is set on the next folio
(the one containing 0x10 page).

When reading 60k data, 128k readahead is also triggered via
page_cache_sync_ra().  However, in this case the readahead flag is set on
the 0xf page.  Although the requested read size (req_count) is 60k, the
actual read will be aligned to folio size (64k), which triggers the
readahead flag and initiates asynchronous readahead via
page_cache_async_ra().  This results in two readahead operations totaling
256k.

The root cause is that when the requested size is smaller than the actual
read size (due to folio alignment), it triggers asynchronous readahead. 
By changing last_index alignment from page size to folio size, we ensure
the requested size matches the actual read size, preventing the case where
a single read operation triggers two readahead operations.

After applying the patch:
 # echo 3 > /proc/sys/vm/drop_caches
 # dd if=test of=/dev/null bs=60k count=1
 # ./page-types -r -L -f  /mnt/xfs/test
 foffset	offset	flags
 0	136d4c	__RU_l_________H______t_________________F_1
 1	136d4d	__RU_l__________T_____t_________________F_1
 2	136d4e	__RU_l__________T_____t_________________F_1
 3	136d4f	__RU_l__________T_____t_________________F_1
 ...
 c	136bb8	__RU_l_________H______t_________________F_1
 d	136bb9	__RU_l__________T_____t_________________F_1
 e	136bba	__RU_l__________T_____t_________________F_1   <-- first read
 f	136bbb	__RU_l__________T_____t_________________F_1
 10	13c2cc	___U_l_________H______t______________I__F_1   <-- readahead flag
 11	13c2cd	___U_l__________T_____t______________I__F_1
 12	13c2ce	___U_l__________T_____t______________I__F_1
 13	13c2cf	___U_l__________T_____t______________I__F_1
 ...
 1c	1405d4	___U_l_________H______t_________________F_1
 1d	1405d5	___U_l__________T_____t_________________F_1
 1e	1405d6	___U_l__________T_____t_________________F_1
 1f	1405d7	___U_l__________T_____t_________________F_1
 [ra_size = 32, req_count = 16, async_size = 16]

The same phenomenon will occur when reading from 49k to 64k.  Set the
readahead flag to the next folio.

Because the minimum order of folio in address_space equals the block size
(at least in xfs and bcachefs that already support bs > ps), having
request_count aligned to block size will not cause overread.

[klarasmodin@gmail.com: fix overflow on 32-bit]
  Link: https://lkml.kernel.org/r/yru7qf5gvyzccq5ohhpylvxug5lr5tf54omspbjh4sm6pcdb2r@fpjgj2pxw7va
[akpm@linux-foundation.org: update it for Max's constification efforts]
Link: https://lkml.kernel.org/r/20250711055509.91587-1-youling.tang@linux.dev
Co-developed-by: Chi Zhiling <chizhiling@kylinos.cn>
Signed-off-by: Chi Zhiling <chizhiling@kylinos.cn>
Signed-off-by: Youling Tang <tangyouling@kylinos.cn>
Signed-off-by: Klara Modin <klarasmodin@gmail.com>
Reviewed-by: Ryan Roberts <ryan.roberts@arm.com>
Reviewed-by: Jan Kara <jack@suse.cz>
Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: Youling Tang <youling.tang@linux.dev>
Cc: David Hildenbrand <david@redhat.com>
Cc: Klara Modin <klarasmodin@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/pagemap.h |    6 ++++++
 mm/filemap.c            |    5 +++--
 2 files changed, 9 insertions(+), 2 deletions(-)

--- a/include/linux/pagemap.h~mm-filemap-align-last_index-to-folio-size
+++ a/include/linux/pagemap.h
@@ -482,6 +482,12 @@ mapping_min_folio_nrpages(const struct a
 	return 1UL << mapping_min_folio_order(mapping);
 }
 
+static inline unsigned long
+mapping_min_folio_nrbytes(const struct address_space *mapping)
+{
+	return mapping_min_folio_nrpages(mapping) << PAGE_SHIFT;
+}
+
 /**
  * mapping_align_index() - Align index for this mapping.
  * @mapping: The address_space.
--- a/mm/filemap.c~mm-filemap-align-last_index-to-folio-size
+++ a/mm/filemap.c
@@ -2600,8 +2600,9 @@ static int filemap_get_pages(struct kioc
 	unsigned int flags;
 	int err = 0;
 
-	/* "last_index" is the index of the page beyond the end of the read */
-	last_index = DIV_ROUND_UP(iocb->ki_pos + count, PAGE_SIZE);
+	/* "last_index" is the index of the folio beyond the end of the read */
+	last_index = round_up(iocb->ki_pos + count,
+			mapping_min_folio_nrbytes(mapping)) >> PAGE_SHIFT;
 retry:
 	if (fatal_signal_pending(current))
 		return -EINTR;
_

Patches currently in -mm which might be from tangyouling@kylinos.cn are


