Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 82C2A1EF0AA
	for <mm-commits@vger.kernel.org>; Tue, 13 May 2025 06:54:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747119299; cv=none; b=Gv6VvEvkvs3sp7Y4EYJE8OMzk5Qz7MMwFuivB80SJCwRyK9EvHPcXAZu6EwakYOceasX6DHezprpdy2eXbnRrKC9zcT82CzLt/SFr8XpCYHl5xwHYsaWyfznxcHTUbXKzt+lDWFDlLRLy0AnaydKdR26KHLl4i/4zyem2aPjN4Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747119299; c=relaxed/simple;
	bh=nMtXSelJzdE9STNVCx+1nTDBqActby4UHcSTqAkQKXE=;
	h=Date:To:From:Subject:Message-Id; b=TlH2Sgtt0nOyJSb3yuTYjbO7sZ/Ir0a90qmWtZv7aS3l2X1crtKDrpA1g3VAC+FOav9l2D1ilxiDJAOYuyA4vXTcIxfWE/gEbBMDV1Gj2HyOkSvB3a2EuAKgQaUvvRZWynGdgnJbtkGN9OymrSRuGdsOmRKohZQx1wnyGFtsx20=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=gMaYi778; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="gMaYi778"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 58C15C4CEE4;
	Tue, 13 May 2025 06:54:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1747119299;
	bh=nMtXSelJzdE9STNVCx+1nTDBqActby4UHcSTqAkQKXE=;
	h=Date:To:From:Subject:From;
	b=gMaYi778Ye4z1necdS9onp2lbNYUOrtjB89Q8Nm7R94WzGexy2yKxQZzFtLkjJhX+
	 VBWnA2gMcGGCbWwEV+7Bn6bTWTEsmA15AsldBKgnynRUx0A+asu6bBkI2OaKV/MMhG
	 HPeDDUvnUWTslLZhf7DvaGwrR0iK/GQcJLYeZs58=
Date: Mon, 12 May 2025 23:54:58 -0700
To: mm-commits@vger.kernel.org,ziy@nvidia.com,willy@infradead.org,wangkefeng.wang@huawei.com,shaggy@kernel.org,lkp@intel.com,jane.chu@oracle.com,donettom@linux.ibm.com,david@redhat.com,dan.carpenter@linaro.org,apopple@nvidia.com,shivankg@amd.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] jfs-implement-migrate_folio-for-jfs_metapage_aops.patch removed from -mm tree
Message-Id: <20250513065459.58C15C4CEE4@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: jfs: implement migrate_folio for jfs_metapage_aops
has been removed from the -mm tree.  Its filename was
     jfs-implement-migrate_folio-for-jfs_metapage_aops.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Shivank Garg <shivankg@amd.com>
Subject: jfs: implement migrate_folio for jfs_metapage_aops
Date: Wed, 30 Apr 2025 10:01:52 +0000

Add the missing migrate_folio operation to jfs_metapage_aops to fix
warnings during memory compaction.  These warnings were introduced by
commit 7ee3647243e5 ("migrate: Remove call to ->writepage") which added
explicit warnings when filesystems don't implement migrate_folio.

System reports following warnings:
  jfs_metapage_aops does not implement migrate_folio
  WARNING: CPU: 0 PID: 6870 at mm/migrate.c:955 fallback_migrate_folio mm/migrate.c:953 [inline]
  WARNING: CPU: 0 PID: 6870 at mm/migrate.c:955 move_to_new_folio+0x70e/0x840 mm/migrate.c:1007

Implement metapage_migrate_folio() which handles both single and multiple
metapages per page configurations.

[shivankg@amd.com: change comment style]
  Link: https://lkml.kernel.org/r/1967593d-8084-4a4a-b384-35d5adc54eb4@amd.com
[akpm@linux-foundation.org: fix build]
[shivankg@amd.com: remove redundant NULL check in __metapage_migrate_folio()]
  Link: https://lkml.kernel.org/r/a67db238-0ca6-4725-abb2-dc092de87e1b@amd.com
Link: https://lkml.kernel.org/r/20250430100150.279751-3-shivankg@amd.com
Fixes: 35474d52c605 ("jfs: Convert metapage_writepage to metapage_write_folio")
Signed-off-by: Shivank Garg <shivankg@amd.com>
Reported-by: syzbot+8bb6fd945af4e0ad9299@syzkaller.appspotmail.com
Closes: https://lore.kernel.org/all/67faff52.050a0220.379d84.001b.GAE@google.com
Tested-by: syzbot+8bb6fd945af4e0ad9299@syzkaller.appspotmail.com
Cc: Alistair Popple <apopple@nvidia.com>
Cc: Dave Kleikamp <shaggy@kernel.org>
Cc: David Hildenbrand <david@redhat.com>
Cc: Donet Tom <donettom@linux.ibm.com>
Cc: Jane Chu <jane.chu@oracle.com>
Cc: Kefeng Wang <wangkefeng.wang@huawei.com>
Cc: Matthew Wilcox <willy@infradead.org>
Cc: Zi Yan <ziy@nvidia.com>
Cc: Dan Carpenter <dan.carpenter@linaro.org>
Cc: kernel test robot <lkp@intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/jfs/jfs_metapage.c |  106 ++++++++++++++++++++++++++++++++++++++++
 1 file changed, 106 insertions(+)

--- a/fs/jfs/jfs_metapage.c~jfs-implement-migrate_folio-for-jfs_metapage_aops
+++ a/fs/jfs/jfs_metapage.c
@@ -15,6 +15,7 @@
 #include <linux/mempool.h>
 #include <linux/seq_file.h>
 #include <linux/writeback.h>
+#include <linux/migrate.h>
 #include "jfs_incore.h"
 #include "jfs_superblock.h"
 #include "jfs_filsys.h"
@@ -151,7 +152,59 @@ static inline void dec_io(struct folio *
 		handler(folio, anchor->status);
 }
 
+#ifdef CONFIG_MIGRATION
+static int __metapage_migrate_folio(struct address_space *mapping,
+				    struct folio *dst, struct folio *src,
+				    enum migrate_mode mode)
+{
+	struct meta_anchor *src_anchor = src->private;
+	struct metapage *mps[MPS_PER_PAGE] = {0};
+	struct metapage *mp;
+	int i, rc;
+
+	for (i = 0; i < MPS_PER_PAGE; i++) {
+		mp = src_anchor->mp[i];
+		if (mp && metapage_locked(mp))
+			return -EAGAIN;
+	}
+
+	rc = filemap_migrate_folio(mapping, dst, src, mode);
+	if (rc != MIGRATEPAGE_SUCCESS)
+		return rc;
+
+	for (i = 0; i < MPS_PER_PAGE; i++) {
+		mp = src_anchor->mp[i];
+		if (!mp)
+			continue;
+		if (unlikely(insert_metapage(dst, mp))) {
+			/* If error, roll-back previosly inserted pages */
+			for (int j = 0 ; j < i; j++) {
+				if (mps[j])
+					remove_metapage(dst, mps[j]);
+			}
+			return -EAGAIN;
+		}
+		mps[i] = mp;
+	}
+
+	/* Update the metapage and remove it from src */
+	for (i = 0; i < MPS_PER_PAGE; i++) {
+		mp = mps[i];
+		if (mp) {
+			int page_offset = mp->data - folio_address(src);
+
+			mp->data = folio_address(dst) + page_offset;
+			mp->folio = dst;
+			remove_metapage(src, mp);
+		}
+	}
+
+	return MIGRATEPAGE_SUCCESS;
+}
+#endif	/* CONFIG_MIGRATION */
+
 #else
+
 static inline struct metapage *folio_to_mp(struct folio *folio, int offset)
 {
 	return folio->private;
@@ -175,6 +228,35 @@ static inline void remove_metapage(struc
 #define inc_io(folio) do {} while(0)
 #define dec_io(folio, status, handler) handler(folio, status)
 
+#ifdef CONFIG_MIGRATION
+static int __metapage_migrate_folio(struct address_space *mapping,
+				    struct folio *dst, struct folio *src,
+				    enum migrate_mode mode)
+{
+	struct metapage *mp;
+	int page_offset;
+	int rc;
+
+	mp = folio_to_mp(src, 0);
+	if (metapage_locked(mp))
+		return -EAGAIN;
+
+	rc = filemap_migrate_folio(mapping, dst, src, mode);
+	if (rc != MIGRATEPAGE_SUCCESS)
+		return rc;
+
+	if (unlikely(insert_metapage(dst, mp)))
+		return -EAGAIN;
+
+	page_offset = mp->data - folio_address(src);
+	mp->data = folio_address(dst) + page_offset;
+	mp->folio = dst;
+	remove_metapage(src, mp);
+
+	return MIGRATEPAGE_SUCCESS;
+}
+#endif	/* CONFIG_MIGRATION */
+
 #endif
 
 static inline struct metapage *alloc_metapage(gfp_t gfp_mask)
@@ -554,6 +636,29 @@ static bool metapage_release_folio(struc
 	return ret;
 }
 
+#ifdef CONFIG_MIGRATION
+/*
+ * metapage_migrate_folio - Migration function for JFS metapages
+ */
+static int metapage_migrate_folio(struct address_space *mapping,
+				  struct folio *dst, struct folio *src,
+				  enum migrate_mode mode)
+{
+	int expected_count;
+
+	if (!src->private)
+		return filemap_migrate_folio(mapping, dst, src, mode);
+
+	/* Check whether page does not have extra refs before we do more work */
+	expected_count = folio_expected_ref_count(src) + 1;
+	if (folio_ref_count(src) != expected_count)
+		return -EAGAIN;
+	return __metapage_migrate_folio(mapping, dst, src, mode);
+}
+#else
+#define metapage_migrate_folio NULL
+#endif	/* CONFIG_MIGRATION */
+
 static void metapage_invalidate_folio(struct folio *folio, size_t offset,
 				    size_t length)
 {
@@ -570,6 +675,7 @@ const struct address_space_operations jf
 	.release_folio	= metapage_release_folio,
 	.invalidate_folio = metapage_invalidate_folio,
 	.dirty_folio	= filemap_dirty_folio,
+	.migrate_folio	= metapage_migrate_folio,
 };
 
 struct metapage *__get_metapage(struct inode *inode, unsigned long lblock,
_

Patches currently in -mm which might be from shivankg@amd.com are


