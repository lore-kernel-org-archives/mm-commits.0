Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B848414A8E
	for <mm-commits@vger.kernel.org>; Wed, 25 Jun 2025 00:01:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750809714; cv=none; b=WtDA8HReeiV9XIJvGpDNURgjSsKeTUzyyeI5ge6uPzW0eUFbQ6v0Ntx2CtMPu1j5nLgeGY/J661Apn4oxg8HKCTb1FNTpyBi4THsV4Qk4DLMVlpUEtruN98AKRuok5m89pU6bZOFbqn98DwUA5Qi+ueyfFaDmGnEbziC1x3C6u0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750809714; c=relaxed/simple;
	bh=irVVjJA1chVLR0Sjtat1kuwH2nlq1pv+77v1J5b+jQ4=;
	h=Date:To:From:Subject:Message-Id; b=eY520gyzNjK88XnAw3NAf9uOQqW9kRii5gVU6XKpUaxKtFM2ch69IousdRwOhnPFgHauF80vJob0WFdCmdLD66tyHsD+rG6vIv8aVj/iUuy0Om9zF3Cz32roVhaLLtKlXSGnetcC1QLzFICuMZ1Juv82nSRTnYrPAvmbxOLdQOk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=EjH0TI0U; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="EjH0TI0U"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3857BC4CEE3;
	Wed, 25 Jun 2025 00:01:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1750809714;
	bh=irVVjJA1chVLR0Sjtat1kuwH2nlq1pv+77v1J5b+jQ4=;
	h=Date:To:From:Subject:From;
	b=EjH0TI0Ukn1FCiSh6wnZpsKiS5hK9K7i3iEIYQew8LTGAJZGf3m6HTiJfLQeY5kI8
	 VizVV72n62sOYz1qQVCPUbqXj8YGyMHjUdcXAKOzSRv/njy6gxe85w8Zk7RvP1qDjV
	 wlXM9yWcJ/RFXpRNl1oMpbXzk41AOkSG4xGp5Lgw=
Date: Tue, 24 Jun 2025 17:01:53 -0700
To: mm-commits@vger.kernel.org,ziy@nvidia.com,yuzhao@google.com,ying.huang@linux.alibaba.com,yan.y.zhao@intel.com,viro@zeniv.linux.org.uk,vbabka@suse.cz,vannapurve@google.com,thomas.lendacky@amd.com,tabba@google.com,suzuki.poulose@arm.com,shuah@kernel.org,shivankg@amd.com,serge@hallyn.com,seanjc@google.com,rppt@kernel.org,roypat@amazon.co.uk,rientjes@google.com,rakie.kim@sk.com,quic_eberman@quicinc.com,pvorel@suse.cz,peterx@redhat.com,pbonzini@redhat.com,paul@paul-moore.com,papaluri@amd.com,pankaj.gupta@amd.com,nikunj@amd.com,Neeraj.Upadhyay@amd.com,michael.roth@amd.com,matthew.brost@intel.com,kent.overstreet@linux.dev,joshua.hahnjy@gmail.com,jmorris@namei.org,jgowans@amazon.com,jgg@nvidia.com,jack@suse.cz,ira.weiny@intel.com,hch@infradead.org,gshan@redhat.com,gourry@gourry.net,ddutile@redhat.com,david@redhat.com,dan.j.williams@intel.com,chao.gao@intel.com,cgzones@googlemail.com,byungchul@sk.com,brauner@kernel.org,bharata@amd.com,bfoster@redhat.com,ashish.kalra@amd.com,apopple@nvidia.com,aik@amd.com,ackerleytng@google.com,willy@infradead.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [withdrawn] filemap-add-a-mempolicy-argument-to-filemap_alloc_folio.patch removed from -mm tree
Message-Id: <20250625000154.3857BC4CEE3@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: filemap: add a mempolicy argument to filemap_alloc_folio()
has been removed from the -mm tree.  Its filename was
     filemap-add-a-mempolicy-argument-to-filemap_alloc_folio.patch

This patch was dropped because it was withdrawn

------------------------------------------------------
From: "Matthew Wilcox (Oracle)" <willy@infradead.org>
Subject: filemap: add a mempolicy argument to filemap_alloc_folio()
Date: Fri, 20 Jun 2025 15:34:46 +0100

guest_memfd needs to support memory policies so add an argument to
filemap_alloc_folio().  All existing users pass NULL, the first user will
show up later in this series.

Link: https://lkml.kernel.org/r/20250620143502.3055777-1-willy@infradead.org
Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
Reviewed-by: Vlastimil Babka <vbabka@suse.cz>
Reviewed-by: Pankaj Gupta <pankaj.gupta@amd.com>
Cc: Ackerley Tng <ackerleytng@google.com>
Cc: Alexey Kardashevskiy <aik@amd.com>
Cc: Alistair Popple <apopple@nvidia.com>
Cc: Al Viro <viro@zeniv.linux.org.uk>
Cc: Ashish Kalra <ashish.kalra@amd.com>
Cc: Bharata B Rao <bharata@amd.com>
Cc: Brain Foster <bfoster@redhat.com>
Cc: Byungchul Park <byungchul@sk.com>
Cc: Chao Gao <chao.gao@intel.com>
Cc: Christian Brauner <brauner@kernel.org>
Cc: Christian Göttsche <cgzones@googlemail.com>
Cc: Christop Hellwig <hch@infradead.org>
Cc: Dan Williams <dan.j.williams@intel.com>
Cc: David Hildenbrand <david@redhat.com>
Cc: David Rientjes <rientjes@google.com>
Cc: Donald Dutile <ddutile@redhat.com>
Cc: Elliot Berman <quic_eberman@quicinc.com>
Cc: Fuad Tabba <tabba@google.com>
Cc: Gavin Shan <gshan@redhat.com>
Cc: Gregory Price <gourry@gourry.net>
Cc: "Huang, Ying" <ying.huang@linux.alibaba.com>
Cc: Ira Weiny <ira.weiny@intel.com>
Cc: James Gowans <jgowans@amazon.com>
Cc: James Morris <jmorris@namei.org>
Cc: Jan Kara <jack@suse.cz>
Cc: Jason Gunthorpe <jgg@nvidia.com>
Cc: Joshua Hahn <joshua.hahnjy@gmail.com>
Cc: Kent Overstreet <kent.overstreet@linux.dev>
Cc: Mathew Brost <matthew.brost@intel.com>
Cc: Michael Roth <michael.roth@amd.com>
Cc: Mike Rapoport <rppt@kernel.org>
Cc: Neeraj upadhyay <Neeraj.Upadhyay@amd.com>
Cc: Nikunj A Dadhania <nikunj@amd.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>
Cc: Patrick Roy <roypat@amazon.co.uk>
Cc: Paul Moore <paul@paul-moore.com>
Cc: Pavan Kumar Paluri <papaluri@amd.com>
Cc: Peter Xu <peterx@redhat.com>
Cc: Petr Vorel <pvorel@suse.cz>
Cc: Rakie Kim <rakie.kim@sk.com>
Cc: rebased to 5.6.0-rc4+Yan Zhao <yan.y.zhao@intel.com>
Cc: Reported-by:"Suzuki K. Poulose" <suzuki.poulose@arm.com>
Cc: Sean Christopherson <seanjc@google.com>
Cc: "Serge E. Hallyn" <serge@hallyn.com>
Cc: Shivank Garg <shivankg@amd.com>
Cc: Shuah Khan <shuah@kernel.org>
Cc: Thomas Lendacky <thomas.lendacky@amd.com>
Cc: Vishal Annapurve <vannapurve@google.com>
Cc: Yu Zhao <yuzhao@google.com>
Cc: Zi Yan <ziy@nvidia.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/bcachefs/fs-io-buffered.c |    2 +-
 fs/btrfs/compression.c       |    3 ++-
 fs/btrfs/verity.c            |    2 +-
 fs/erofs/zdata.c             |    2 +-
 fs/f2fs/compress.c           |    2 +-
 include/linux/pagemap.h      |    6 +++---
 mm/filemap.c                 |   13 +++++++++----
 mm/readahead.c               |    2 +-
 8 files changed, 19 insertions(+), 13 deletions(-)

--- a/fs/bcachefs/fs-io-buffered.c~filemap-add-a-mempolicy-argument-to-filemap_alloc_folio
+++ a/fs/bcachefs/fs-io-buffered.c
@@ -124,7 +124,7 @@ static int readpage_bio_extend(struct bt
 			if (folio && !xa_is_value(folio))
 				break;
 
-			folio = filemap_alloc_folio(readahead_gfp_mask(iter->mapping), order);
+			folio = filemap_alloc_folio(readahead_gfp_mask(iter->mapping), order, NULL);
 			if (!folio)
 				break;
 
--- a/fs/btrfs/compression.c~filemap-add-a-mempolicy-argument-to-filemap_alloc_folio
+++ a/fs/btrfs/compression.c
@@ -475,7 +475,8 @@ static noinline int add_ra_bio_pages(str
 		}
 
 		folio = filemap_alloc_folio(mapping_gfp_constraint(mapping,
-								   ~__GFP_FS), 0);
+								   ~__GFP_FS),
+				0, NULL);
 		if (!folio)
 			break;
 
--- a/fs/btrfs/verity.c~filemap-add-a-mempolicy-argument-to-filemap_alloc_folio
+++ a/fs/btrfs/verity.c
@@ -742,7 +742,7 @@ again:
 	}
 
 	folio = filemap_alloc_folio(mapping_gfp_constraint(inode->i_mapping, ~__GFP_FS),
-				    0);
+				    0, NULL);
 	if (!folio)
 		return ERR_PTR(-ENOMEM);
 
--- a/fs/erofs/zdata.c~filemap-add-a-mempolicy-argument-to-filemap_alloc_folio
+++ a/fs/erofs/zdata.c
@@ -562,7 +562,7 @@ static void z_erofs_bind_cache(struct z_
 			 * Allocate a managed folio for cached I/O, or it may be
 			 * then filled with a file-backed folio for in-place I/O
 			 */
-			newfolio = filemap_alloc_folio(gfp, 0);
+			newfolio = filemap_alloc_folio(gfp, 0, NULL);
 			if (!newfolio)
 				continue;
 			newfolio->private = Z_EROFS_PREALLOCATED_FOLIO;
--- a/fs/f2fs/compress.c~filemap-add-a-mempolicy-argument-to-filemap_alloc_folio
+++ a/fs/f2fs/compress.c
@@ -1942,7 +1942,7 @@ void f2fs_cache_compressed_page(struct f
 		return;
 	}
 
-	cfolio = filemap_alloc_folio(__GFP_NOWARN | __GFP_IO, 0);
+	cfolio = filemap_alloc_folio(__GFP_NOWARN | __GFP_IO, 0, NULL);
 	if (!cfolio)
 		return;
 
--- a/include/linux/pagemap.h~filemap-add-a-mempolicy-argument-to-filemap_alloc_folio
+++ a/include/linux/pagemap.h
@@ -646,9 +646,9 @@ static inline void *detach_page_private(
 }
 
 #ifdef CONFIG_NUMA
-struct folio *filemap_alloc_folio_noprof(gfp_t gfp, unsigned int order);
+struct folio *filemap_alloc_folio_noprof(gfp_t gfp, unsigned int order, struct mempolicy *policy);
 #else
-static inline struct folio *filemap_alloc_folio_noprof(gfp_t gfp, unsigned int order)
+static inline struct folio *filemap_alloc_folio_noprof(gfp_t gfp, unsigned int order, struct mempolicy *policy)
 {
 	return folio_alloc_noprof(gfp, order);
 }
@@ -659,7 +659,7 @@ static inline struct folio *filemap_allo
 
 static inline struct page *__page_cache_alloc(gfp_t gfp)
 {
-	return &filemap_alloc_folio(gfp, 0)->page;
+	return &filemap_alloc_folio(gfp, 0, NULL)->page;
 }
 
 static inline gfp_t readahead_gfp_mask(struct address_space *x)
--- a/mm/filemap.c~filemap-add-a-mempolicy-argument-to-filemap_alloc_folio
+++ a/mm/filemap.c
@@ -989,11 +989,16 @@ int filemap_add_folio(struct address_spa
 EXPORT_SYMBOL_GPL(filemap_add_folio);
 
 #ifdef CONFIG_NUMA
-struct folio *filemap_alloc_folio_noprof(gfp_t gfp, unsigned int order)
+struct folio *filemap_alloc_folio_noprof(gfp_t gfp, unsigned int order,
+		struct mempolicy *policy)
 {
 	int n;
 	struct folio *folio;
 
+	if (policy)
+		return folio_alloc_mpol_noprof(gfp, order, policy,
+				NO_INTERLEAVE_INDEX, numa_node_id());
+
 	if (cpuset_do_page_mem_spread()) {
 		unsigned int cpuset_mems_cookie;
 		do {
@@ -1978,7 +1983,7 @@ no_page:
 			err = -ENOMEM;
 			if (order > min_order)
 				alloc_gfp |= __GFP_NORETRY | __GFP_NOWARN;
-			folio = filemap_alloc_folio(alloc_gfp, order);
+			folio = filemap_alloc_folio(alloc_gfp, order, NULL);
 			if (!folio)
 				continue;
 
@@ -2517,7 +2522,7 @@ static int filemap_create_folio(struct k
 	if (iocb->ki_flags & (IOCB_NOWAIT | IOCB_WAITQ))
 		return -EAGAIN;
 
-	folio = filemap_alloc_folio(mapping_gfp_mask(mapping), min_order);
+	folio = filemap_alloc_folio(mapping_gfp_mask(mapping), min_order, NULL);
 	if (!folio)
 		return -ENOMEM;
 	if (iocb->ki_flags & IOCB_DONTCACHE)
@@ -3888,7 +3893,7 @@ repeat:
 	folio = filemap_get_folio(mapping, index);
 	if (IS_ERR(folio)) {
 		folio = filemap_alloc_folio(gfp,
-					    mapping_min_folio_order(mapping));
+				mapping_min_folio_order(mapping), NULL);
 		if (!folio)
 			return ERR_PTR(-ENOMEM);
 		index = mapping_align_index(mapping, index);
--- a/mm/readahead.c~filemap-add-a-mempolicy-argument-to-filemap_alloc_folio
+++ a/mm/readahead.c
@@ -183,7 +183,7 @@ static struct folio *ractl_alloc_folio(s
 {
 	struct folio *folio;
 
-	folio = filemap_alloc_folio(gfp_mask, order);
+	folio = filemap_alloc_folio(gfp_mask, order, NULL);
 	if (folio && ractl->dropbehind)
 		__folio_set_dropbehind(folio);
 
_

Patches currently in -mm which might be from willy@infradead.org are

mm-restore-documentation-for-__free_pages.patch
bio-use-memzero_page-in-bio_truncate.patch
null_blk-use-memzero_page.patch
direct-io-use-memzero_page.patch
ceph-convert-ceph_zero_partial_page-to-use-a-folio.patch
mm-remove-zero_user.patch
secretmem-remove-uses-of-struct-page.patch
highmem-remove-a-use-of-folio-page.patch
filemap-add-__filemap_get_folio_mpol.patch
squashfs-pass-the-inode-to-squashfs_readahead_fragment.patch
squashfs-use-folios-in-squashfs_bio_read_cached.patch

