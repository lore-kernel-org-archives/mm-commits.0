Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B32D92222C3
	for <mm-commits@vger.kernel.org>; Thu,  1 May 2025 23:00:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746140407; cv=none; b=DUcQGbUOMn8O0SWSypPiy6O9XvA4QEEcTldsfWjqvgyoZvA9cer5TNK+TQQvOhXaAKrggwx4FgtGhYYRQ/nsGYppT6DbdvTyHSb8md0B8F1gSMJGhMCbCrJxqtz9mnZEPrYnb46nsK98PMuS398lZZuExNrACIrwlzi2j+GqMxI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746140407; c=relaxed/simple;
	bh=QexlS79SwZ3hW+bzTZspr+IxmMxUO62wp4ye2IjnWcE=;
	h=Date:To:From:Subject:Message-Id; b=RqOKZ1gRvf/BGJP9D+w9F4nQh/qM+Rh94cG7t4FXMN3oispz2/iJCNxuhpqxkM2QeyM+5isgj3uKabCKrse1wc8DIYYl+PsMiI0QYSzSXZqI4cX2EZ8z3Bk02CJLvhaPFoTNa/pWJIPPNIzgl89dzmO7k2pf95tKZhIsoR3PbzE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=Um3xh1hi; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="Um3xh1hi"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2AF0FC4CEED;
	Thu,  1 May 2025 23:00:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1746140407;
	bh=QexlS79SwZ3hW+bzTZspr+IxmMxUO62wp4ye2IjnWcE=;
	h=Date:To:From:Subject:From;
	b=Um3xh1hibBCpUQut8ztmgo695iORihRU0g4uj87xixTrRtqpi4Pt0djW3ZTgud9fS
	 K0Q56Lqj999Qr8CfzZ+ECBzc9vKdbRY7Q7pbW1Zx2DoVzAJEUMzJmLhmpjSbllnHvb
	 Nao52PPDCSc0iUuzEYFijLftCuUQWAvwGjT3MaBE=
Date: Thu, 01 May 2025 16:00:06 -0700
To: mm-commits@vger.kernel.org,ziy@nvidia.com,willy@infradead.org,wangkefeng.wang@huawei.com,shivankg@amd.com,shaggy@kernel.org,jane.chu@oracle.com,donettom@linux.ibm.com,david@redhat.com,apopple@nvidia.com,akpm@linux-foundation.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + jfs-implement-migrate_folio-for-jfs_metapage_aops-fix-2.patch added to mm-unstable branch
Message-Id: <20250501230007.2AF0FC4CEED@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: jfs-implement-migrate_folio-for-jfs_metapage_aops-fix-2
has been added to the -mm mm-unstable branch.  Its filename is
     jfs-implement-migrate_folio-for-jfs_metapage_aops-fix-2.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/jfs-implement-migrate_folio-for-jfs_metapage_aops-fix-2.patch

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
From: Andrew Morton <akpm@linux-foundation.org>
Subject: jfs-implement-migrate_folio-for-jfs_metapage_aops-fix-2
Date: Thu May  1 03:52:07 PM PDT 2025

fix build by making fs/jfs/jfs_metapage.c change dependent upon
CONFIG_MIGRATION

Cc: Alistair Popple <apopple@nvidia.com>
Cc: Dave Kleikamp <shaggy@kernel.org>
Cc: David Hildenbrand <david@redhat.com>
Cc: Donet Tom <donettom@linux.ibm.com>
Cc: Jane Chu <jane.chu@oracle.com>
Cc: Kefeng Wang <wangkefeng.wang@huawei.com>
Cc: Matthew Wilcox <willy@infradead.org>
Cc: Shivank Garg <shivankg@amd.com>
Cc: Zi Yan <ziy@nvidia.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/jfs/jfs_metapage.c |   24 ++++++++++++++++++------
 1 file changed, 18 insertions(+), 6 deletions(-)

--- a/fs/jfs/jfs_metapage.c~jfs-implement-migrate_folio-for-jfs_metapage_aops-fix-2
+++ a/fs/jfs/jfs_metapage.c
@@ -152,8 +152,10 @@ static inline void dec_io(struct folio *
 		handler(folio, anchor->status);
 }
 
-static int __metapage_migrate_folio(struct address_space *mapping, struct folio *dst,
-				    struct folio *src, enum migrate_mode mode)
+#ifdef CONFIG_MIGRATION
+static int __metapage_migrate_folio(struct address_space *mapping,
+				    struct folio *dst, struct folio *src,
+				    enum migrate_mode mode)
 {
 	struct meta_anchor *src_anchor = src->private;
 	struct metapage *mps[MPS_PER_PAGE] = {0};
@@ -199,8 +201,10 @@ static int __metapage_migrate_folio(stru
 
 	return MIGRATEPAGE_SUCCESS;
 }
+#endif	/* CONFIG_MIGRATION */
 
 #else
+
 static inline struct metapage *folio_to_mp(struct folio *folio, int offset)
 {
 	return folio->private;
@@ -224,8 +228,10 @@ static inline void remove_metapage(struc
 #define inc_io(folio) do {} while(0)
 #define dec_io(folio, status, handler) handler(folio, status)
 
-static int __metapage_migrate_folio(struct address_space *mapping, struct folio *dst,
-				    struct folio *src, enum migrate_mode mode)
+#ifdef CONFIG_MIGRATION
+static int __metapage_migrate_folio(struct address_space *mapping,
+				    struct folio *dst, struct folio *src,
+				    enum migrate_mode mode)
 {
 	struct metapage *mp;
 	int page_offset;
@@ -249,6 +255,7 @@ static int __metapage_migrate_folio(stru
 
 	return MIGRATEPAGE_SUCCESS;
 }
+#endif	/* CONFIG_MIGRATION */
 
 #endif
 
@@ -629,11 +636,13 @@ static bool metapage_release_folio(struc
 	return ret;
 }
 
+#ifdef CONFIG_MIGRATION
 /*
  * metapage_migrate_folio - Migration function for JFS metapages
  */
-static int metapage_migrate_folio(struct address_space *mapping, struct folio *dst,
-				  struct folio *src, enum migrate_mode mode)
+static int metapage_migrate_folio(struct address_space *mapping,
+				  struct folio *dst, struct folio *src,
+				  enum migrate_mode mode)
 {
 	int expected_count;
 
@@ -646,6 +655,9 @@ static int metapage_migrate_folio(struct
 		return -EAGAIN;
 	return __metapage_migrate_folio(mapping, dst, src, mode);
 }
+#else
+#define metapage_migrate_folio NULL
+#endif	/* CONFIG_MIGRATION */
 
 static void metapage_invalidate_folio(struct folio *folio, size_t offset,
 				    size_t length)
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

x86-disable-image-size-check-for-test-builds-fix.patch
x86-disable-image-size-check-for-test-builds-fix-fix.patch
mm-debug-fix-parameter-passed-to-page_mapcount_is_type-fix.patch
vmalloc-switch-to-for_each_vmap_node-helper-fix.patch
mm-selftests-add-a-test-to-verify-mmap_changing-race-with-eagain-checkpatch-fixes.patch
jfs-implement-migrate_folio-for-jfs_metapage_aops-fix-2.patch
mm-add-zblock-allocator-fix.patch
mm-zblock-avoid-failing-the-build-fix.patch
mm-establish-mm-vma_execc-for-shared-exec-mm-vma-functionality-fix.patch
mm-perform-vma-allocation-freeing-duplication-in-mm-fix.patch
filemap-do-not-use-folio_contains-for-swap-cache-folios-fix.patch
compiler_typesh-fix-unused-variable-in-__compiletime_assert-fix.patch

