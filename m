Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C3FEC272813
	for <mm-commits@vger.kernel.org>; Tue, 19 Aug 2025 23:36:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755646612; cv=none; b=d9Y9iX+ZVculedKN/zbCXLZ/oMCNnB65Zw35Qv1US8c3r6DU9PIUVA7ufgBXgyCLyHIItGQpFUi7EoekUUDj7OoRzIrzk7iVm74Pf8BzzRu2C5p9i+9wEhLQcO5caYCudbQHsjDAGacL4FashvzfnWc8wPKeeRtXX3jKBF8GbmU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755646612; c=relaxed/simple;
	bh=nI6TXOQ39hG8kyz3zxZLEQaOUTJBq8icF+Qe24UctNQ=;
	h=Date:To:From:Subject:Message-Id; b=ckXATuU2dMkDE0rSLZSZthX+KTgIZnrsY4h3K9D/uJZFjDY/jq+V3X5HHlJWu47dHOw1nZUBvekdpoFas1QQ/XlGfK36Ym6Z4OxKlph+uQIdYxtZAFqg3MwMPrwoq6+f74mbX7PkItceeEDISJW/kTjTe0u6mXXAI62m+0pqPGM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=xx2QHcb6; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="xx2QHcb6"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 999CAC4CEF1;
	Tue, 19 Aug 2025 23:36:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1755646612;
	bh=nI6TXOQ39hG8kyz3zxZLEQaOUTJBq8icF+Qe24UctNQ=;
	h=Date:To:From:Subject:From;
	b=xx2QHcb6XPLr0L/a0wQMsOHn/QNz9mTnfmrz3mxYyCKB5O1b953ScL4HLKhZyxyKw
	 B2KPoDK8r4Vkywp6DpRC10tcw26N8bsLk0sqTfDXzKO6X1DUb8OxJ5jkILJ7DK+BR4
	 wcV8EomPaYsJ7VUWLdb55dCGLbkIkpkIHpA9+jXk=
Date: Tue, 19 Aug 2025 16:36:52 -0700
To: mm-commits@vger.kernel.org,ziy@nvidia.com,senozhatsky@chromium.org,mst@redhat.com,minchan@kernel.org,lorenzo.stoakes@oracle.com,david@redhat.com,chenhuacai@kernel.org,chenhuacai@loongson.cn,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-hotfixes-stable] mm-migrate-fix-null-movable_ops-if-config_zsmalloc=m.patch removed from -mm tree
Message-Id: <20250819233652.999CAC4CEF1@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/migrate: fix NULL movable_ops if CONFIG_ZSMALLOC=m
has been removed from the -mm tree.  Its filename was
     mm-migrate-fix-null-movable_ops-if-config_zsmalloc=m.patch

This patch was dropped because it was merged into the mm-hotfixes-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Huacai Chen <chenhuacai@loongson.cn>
Subject: mm/migrate: fix NULL movable_ops if CONFIG_ZSMALLOC=m
Date: Sun, 17 Aug 2025 23:17:59 +0800

After commit 84caf98838a3e5f4bdb34 ("mm: stop storing migration_ops in
page->mapping") we get such an error message if CONFIG_ZSMALLOC=m:

 WARNING: CPU: 3 PID: 42 at mm/migrate.c:142 isolate_movable_ops_page+0xa8/0x1c0
 CPU: 3 UID: 0 PID: 42 Comm: kcompactd0 Not tainted 6.16.0-rc5+ #2133 PREEMPT
 pc 9000000000540bd8 ra 9000000000540b84 tp 9000000100420000 sp 9000000100423a60
 a0 9000000100193a80 a1 000000000000000c a2 000000000000001b a3 ffffffffffffffff
 a4 ffffffffffffffff a5 0000000000000267 a6 0000000000000000 a7 9000000100423ae0
 t0 00000000000000f1 t1 00000000000000f6 t2 0000000000000000 t3 0000000000000001
 t4 ffffff00010eb834 t5 0000000000000040 t6 900000010c89d380 t7 90000000023fcc70
 t8 0000000000000018 u0 0000000000000000 s9 ffffff00010eb800 s0 ffffff00010eb800
 s1 000000000000000c s2 0000000000043ae0 s3 0000800000000000 s4 900000000219cc40
 s5 0000000000000000 s6 ffffff00010eb800 s7 0000000000000001 s8 90000000025b4000
    ra: 9000000000540b84 isolate_movable_ops_page+0x54/0x1c0
   ERA: 9000000000540bd8 isolate_movable_ops_page+0xa8/0x1c0
  CRMD: 000000b0 (PLV0 -IE -DA +PG DACF=CC DACM=CC -WE)
  PRMD: 00000004 (PPLV0 +PIE -PWE)
  EUEN: 00000000 (-FPE -SXE -ASXE -BTE)
  ECFG: 00071c1d (LIE=0,2-4,10-12 VS=7)
 ESTAT: 000c0000 [BRK] (IS= ECode=12 EsubCode=0)
  PRID: 0014c010 (Loongson-64bit, Loongson-3A5000)
 CPU: 3 UID: 0 PID: 42 Comm: kcompactd0 Not tainted 6.16.0-rc5+ #2133 PREEMPT
 Stack : 90000000021fd000 0000000000000000 9000000000247720 9000000100420000
         90000001004236a0 90000001004236a8 0000000000000000 90000001004237e8
         90000001004237e0 90000001004237e0 9000000100423550 0000000000000001
         0000000000000001 90000001004236a8 725a84864a19e2d9 90000000023fcc58
         9000000100420000 90000000024c6848 9000000002416848 0000000000000001
         0000000000000000 000000000000000a 0000000007fe0000 ffffff00010eb800
         0000000000000000 90000000021fd000 0000000000000000 900000000205cf30
         000000000000008e 0000000000000009 ffffff00010eb800 0000000000000001
         90000000025b4000 0000000000000000 900000000024773c 00007ffff103d748
         00000000000000b0 0000000000000004 0000000000000000 0000000000071c1d
         ...
 Call Trace:
 [<900000000024773c>] show_stack+0x5c/0x190
 [<90000000002415e0>] dump_stack_lvl+0x70/0x9c
 [<90000000004abe6c>] isolate_migratepages_block+0x3bc/0x16e0
 [<90000000004af408>] compact_zone+0x558/0x1000
 [<90000000004b0068>] compact_node+0xa8/0x1e0
 [<90000000004b0aa4>] kcompactd+0x394/0x410
 [<90000000002b3c98>] kthread+0x128/0x140
 [<9000000001779148>] ret_from_kernel_thread+0x28/0xc0
 [<9000000000245528>] ret_from_kernel_thread_asm+0x10/0x88

The reason is that defined(CONFIG_ZSMALLOC) evaluates to 1 only when
CONFIG_ZSMALLOC=y, we should use IS_ENABLED(CONFIG_ZSMALLOC) instead.  But
when I use IS_ENABLED(CONFIG_ZSMALLOC), page_movable_ops() cannot access
zsmalloc_mops because zsmalloc_mops is in a module.

To solve this problem, we define a set_movable_ops() interface to register
and unregister offline_movable_ops / zsmalloc_movable_ops in mm/migrate.c,
and call them at mm/balloon_compaction.c & mm/zsmalloc.c.  Since
offline_movable_ops / zsmalloc_movable_ops are always accessible, all
#ifdef / #endif are removed in page_movable_ops().

Link: https://lkml.kernel.org/r/20250817151759.2525174-1-chenhuacai@loongson.cn
Fixes: 84caf98838a3 ("mm: stop storing migration_ops in page->mapping")
Signed-off-by: Huacai Chen <chenhuacai@loongson.cn>
Acked-by: Zi Yan <ziy@nvidia.com>
Acked-by: David Hildenbrand <david@redhat.com>
Cc: Huacai Chen <chenhuacai@kernel.org>
Cc: Huacai Chen <chenhuacai@loongson.cn>
Cc: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Cc: "Michael S. Tsirkin" <mst@redhat.com>
Cc: Minchan Kim <minchan@kernel.org>
Cc: Sergey Senozhatsky <senozhatsky@chromium.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/migrate.h |    5 +++++
 mm/balloon_compaction.c |    6 ++++++
 mm/migrate.c            |   38 ++++++++++++++++++++++++++++++--------
 mm/zsmalloc.c           |   10 ++++++++++
 4 files changed, 51 insertions(+), 8 deletions(-)

--- a/include/linux/migrate.h~mm-migrate-fix-null-movable_ops-if-config_zsmalloc=m
+++ a/include/linux/migrate.h
@@ -79,6 +79,7 @@ void migration_entry_wait_on_locked(swp_
 void folio_migrate_flags(struct folio *newfolio, struct folio *folio);
 int folio_migrate_mapping(struct address_space *mapping,
 		struct folio *newfolio, struct folio *folio, int extra_count);
+int set_movable_ops(const struct movable_operations *ops, enum pagetype type);
 
 #else
 
@@ -100,6 +101,10 @@ static inline int migrate_huge_page_move
 {
 	return -ENOSYS;
 }
+static inline int set_movable_ops(const struct movable_operations *ops, enum pagetype type)
+{
+	return -ENOSYS;
+}
 
 #endif /* CONFIG_MIGRATION */
 
--- a/mm/balloon_compaction.c~mm-migrate-fix-null-movable_ops-if-config_zsmalloc=m
+++ a/mm/balloon_compaction.c
@@ -254,4 +254,10 @@ const struct movable_operations balloon_
 	.putback_page = balloon_page_putback,
 };
 
+static int __init balloon_init(void)
+{
+	return set_movable_ops(&balloon_mops, PGTY_offline);
+}
+core_initcall(balloon_init);
+
 #endif /* CONFIG_BALLOON_COMPACTION */
--- a/mm/migrate.c~mm-migrate-fix-null-movable_ops-if-config_zsmalloc=m
+++ a/mm/migrate.c
@@ -43,8 +43,6 @@
 #include <linux/sched/sysctl.h>
 #include <linux/memory-tiers.h>
 #include <linux/pagewalk.h>
-#include <linux/balloon_compaction.h>
-#include <linux/zsmalloc.h>
 
 #include <asm/tlbflush.h>
 
@@ -53,6 +51,33 @@
 #include "internal.h"
 #include "swap.h"
 
+static const struct movable_operations *offline_movable_ops;
+static const struct movable_operations *zsmalloc_movable_ops;
+
+int set_movable_ops(const struct movable_operations *ops, enum pagetype type)
+{
+	/*
+	 * We only allow for selected types and don't handle concurrent
+	 * registration attempts yet.
+	 */
+	switch (type) {
+	case PGTY_offline:
+		if (offline_movable_ops && ops)
+			return -EBUSY;
+		offline_movable_ops = ops;
+		break;
+	case PGTY_zsmalloc:
+		if (zsmalloc_movable_ops && ops)
+			return -EBUSY;
+		zsmalloc_movable_ops = ops;
+		break;
+	default:
+		return -EINVAL;
+	}
+	return 0;
+}
+EXPORT_SYMBOL_GPL(set_movable_ops);
+
 static const struct movable_operations *page_movable_ops(struct page *page)
 {
 	VM_WARN_ON_ONCE_PAGE(!page_has_movable_ops(page), page);
@@ -62,15 +87,12 @@ static const struct movable_operations *
 	 * it as movable, the page type must be sticky until the page gets freed
 	 * back to the buddy.
 	 */
-#ifdef CONFIG_BALLOON_COMPACTION
 	if (PageOffline(page))
 		/* Only balloon compaction sets PageOffline pages movable. */
-		return &balloon_mops;
-#endif /* CONFIG_BALLOON_COMPACTION */
-#if defined(CONFIG_ZSMALLOC) && defined(CONFIG_COMPACTION)
+		return offline_movable_ops;
 	if (PageZsmalloc(page))
-		return &zsmalloc_mops;
-#endif /* defined(CONFIG_ZSMALLOC) && defined(CONFIG_COMPACTION) */
+		return zsmalloc_movable_ops;
+
 	return NULL;
 }
 
--- a/mm/zsmalloc.c~mm-migrate-fix-null-movable_ops-if-config_zsmalloc=m
+++ a/mm/zsmalloc.c
@@ -2246,9 +2246,16 @@ EXPORT_SYMBOL_GPL(zs_destroy_pool);
 
 static int __init zs_init(void)
 {
+	int rc __maybe_unused;
+
 #ifdef CONFIG_ZPOOL
 	zpool_register_driver(&zs_zpool_driver);
 #endif
+#ifdef CONFIG_COMPACTION
+	rc = set_movable_ops(&zsmalloc_mops, PGTY_zsmalloc);
+	if (rc)
+		return rc;
+#endif
 	zs_stat_init();
 	return 0;
 }
@@ -2258,6 +2265,9 @@ static void __exit zs_exit(void)
 #ifdef CONFIG_ZPOOL
 	zpool_unregister_driver(&zs_zpool_driver);
 #endif
+#ifdef CONFIG_COMPACTION
+	set_movable_ops(NULL, PGTY_zsmalloc);
+#endif
 	zs_stat_exit();
 }
 
_

Patches currently in -mm which might be from chenhuacai@loongson.cn are

init-handle-bootloader-identifier-in-kernel-parameters.patch
init-handle-bootloader-identifier-in-kernel-parameters-v4.patch

