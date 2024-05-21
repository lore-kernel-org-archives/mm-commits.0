Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8EE0D1494C0
	for <mm-commits@vger.kernel.org>; Tue, 21 May 2024 19:58:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716321492; cv=none; b=FQys4L+sS/HeXzvAuHl990Y+dXXaBbRuJx4w/F4crj5jvNnHBZvVLNZh7zl/h8cGFQiDKI/nVTVJqcKBODHWAXIVurJ9rUtZgeYm6AIiYLAlaeyWnKJYzXeN6KnaZuqOeUJTtOwRhtXAJaBZ6In3suX8qxBPPJyNEgc2WhpJumY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716321492; c=relaxed/simple;
	bh=OY+QRlKQ86uB1LjoXRdqHQKHjX/460Mv4h62cADk9HY=;
	h=Date:To:From:Subject:Message-Id; b=QUuNnbM7kN9A5zbRp5MluhC6Gy7LhAoFe7Aisbll9Y64TximVGwpzpGnPY7QvLpY9VPO5NspM3XMVahw4pko8nkOd5s6P2P2TFWW31KOrfaw2pMMob/VShrDeKOSXRTRFdNKurO826bz0wLFmC/+aJF19tVleoCCF/65kZSNl9A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=oBa6fIJJ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="oBa6fIJJ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 57EC3C2BD11;
	Tue, 21 May 2024 19:58:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1716321492;
	bh=OY+QRlKQ86uB1LjoXRdqHQKHjX/460Mv4h62cADk9HY=;
	h=Date:To:From:Subject:From;
	b=oBa6fIJJ7PXuMB0LKNskZXMmwODKp3FGtT8wNjMisU3zcRA+kuOMJNPYtMDl2CQqH
	 So5ncBbmzF9RG2xZx4dVH3WteBakXaAk5YJt8xMe/1e9uubXITpHXiV5jO4Fv/EBRt
	 +je/jykolsw+Httq25Ol738/f898DtXEFeRb9Vyk=
Date: Tue, 21 May 2024 12:58:11 -0700
To: mm-commits@vger.kernel.org,yosryahmed@google.com,ying.huang@intel.com,xiubli@redhat.com,willy@infradead.org,v-songbaohua@oppo.com,trond.myklebust@hammerspace.com,ryan.roberts@arm.com,neilb@suse.de,minchan@kernel.org,marc.dionne@auristor.com,konishi.ryusuke@gmail.com,jlayton@kernel.org,jaegeuk@kernel.org,idryomov@gmail.com,hughd@google.com,dhowells@redhat.com,david@redhat.com,chrisl@kernel.org,chao@kernel.org,anna@kernel.org,kasong@tencent.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-swap-get-the-swap-device-offset-directly.patch added to mm-unstable branch
Message-Id: <20240521195812.57EC3C2BD11@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/swap: get the swap device offset directly
has been added to the -mm mm-unstable branch.  Its filename is
     mm-swap-get-the-swap-device-offset-directly.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-swap-get-the-swap-device-offset-directly.patch

This patch will later appear in the mm-unstable branch at
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
From: Kairui Song <kasong@tencent.com>
Subject: mm/swap: get the swap device offset directly
Date: Wed, 22 May 2024 01:58:50 +0800

folio_file_pos and page_file_offset are for mixed usage of swap cache and
page cache, it can't be page cache here, so introduce a new helper to get
the swap offset in swap device directly.

Need to include swapops.h in mm/swap.h to ensure swp_offset is always
defined before use.

Link: https://lkml.kernel.org/r/20240521175854.96038-9-ryncsn@gmail.com
Signed-off-by: Kairui Song <kasong@tencent.com>
Reviewed-by: "Huang, Ying" <ying.huang@intel.com>
Cc: Anna Schumaker <anna@kernel.org>
Cc: Barry Song <v-songbaohua@oppo.com>
Cc: Chao Yu <chao@kernel.org>
Cc: Chris Li <chrisl@kernel.org>
Cc: David Hildenbrand <david@redhat.com>
Cc: David Howells <dhowells@redhat.com>
Cc: Hugh Dickins <hughd@google.com>
Cc: Ilya Dryomov <idryomov@gmail.com>
Cc: Jaegeuk Kim <jaegeuk@kernel.org>
Cc: Jeff Layton <jlayton@kernel.org>
Cc: Marc Dionne <marc.dionne@auristor.com>
Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: Minchan Kim <minchan@kernel.org>
Cc: NeilBrown <neilb@suse.de>
Cc: Ryan Roberts <ryan.roberts@arm.com>
Cc: Ryusuke Konishi <konishi.ryusuke@gmail.com>
Cc: Trond Myklebust <trond.myklebust@hammerspace.com>
Cc: Xiubo Li <xiubli@redhat.com>
Cc: Yosry Ahmed <yosryahmed@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/page_io.c |    6 +++---
 mm/swap.h    |    9 +++++++++
 2 files changed, 12 insertions(+), 3 deletions(-)

--- a/mm/page_io.c~mm-swap-get-the-swap-device-offset-directly
+++ a/mm/page_io.c
@@ -280,7 +280,7 @@ static void sio_write_complete(struct ki
 		 * be temporary.
 		 */
 		pr_err_ratelimited("Write error %ld on dio swapfile (%llu)\n",
-				   ret, page_file_offset(page));
+				   ret, swap_dev_pos(page_swap_entry(page)));
 		for (p = 0; p < sio->pages; p++) {
 			page = sio->bvec[p].bv_page;
 			set_page_dirty(page);
@@ -299,7 +299,7 @@ static void swap_writepage_fs(struct fol
 	struct swap_iocb *sio = NULL;
 	struct swap_info_struct *sis = swp_swap_info(folio->swap);
 	struct file *swap_file = sis->swap_file;
-	loff_t pos = folio_file_pos(folio);
+	loff_t pos = swap_dev_pos(folio->swap);
 
 	count_swpout_vm_event(folio);
 	folio_start_writeback(folio);
@@ -430,7 +430,7 @@ static void swap_read_folio_fs(struct fo
 {
 	struct swap_info_struct *sis = swp_swap_info(folio->swap);
 	struct swap_iocb *sio = NULL;
-	loff_t pos = folio_file_pos(folio);
+	loff_t pos = swap_dev_pos(folio->swap);
 
 	if (plug)
 		sio = *plug;
--- a/mm/swap.h~mm-swap-get-the-swap-device-offset-directly
+++ a/mm/swap.h
@@ -5,6 +5,7 @@
 struct mempolicy;
 
 #ifdef CONFIG_SWAP
+#include <linux/swapops.h> /* for swp_offset */
 #include <linux/blk_types.h> /* for bio_end_io_t */
 
 /* linux/mm/page_io.c */
@@ -31,6 +32,14 @@ extern struct address_space *swapper_spa
 	(&swapper_spaces[swp_type(entry)][swp_offset(entry) \
 		>> SWAP_ADDRESS_SPACE_SHIFT])
 
+/*
+ * Return the swap device position of the swap entry.
+ */
+static inline loff_t swap_dev_pos(swp_entry_t entry)
+{
+	return ((loff_t)swp_offset(entry)) << PAGE_SHIFT;
+}
+
 void show_swap_cache_info(void);
 bool add_to_swap(struct folio *folio);
 void *get_shadow_from_swap_cache(swp_entry_t entry);
_

Patches currently in -mm which might be from kasong@tencent.com are

f2fs-drop-usage-of-page_index.patch
nilfs2-drop-usage-of-page_index.patch
ceph-drop-usage-of-page_index.patch
nfs-remove-nfs_page_lengthg-and-usage-of-page_index.patch
afs-drop-usage-of-folio_file_pos.patch
netfs-drop-usage-of-folio_file_pos.patch
nfs-drop-usage-of-folio_file_pos.patch
mm-swap-get-the-swap-device-offset-directly.patch
mm-remove-page_file_offset-and-folio_file_pos.patch
mm-drop-page_index-and-simplify-folio_index.patch
mm-swap-reduce-swap-cache-search-space.patch

