Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 28BE91F4CBB
	for <mm-commits@vger.kernel.org>; Sun, 21 Sep 2025 21:25:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758489923; cv=none; b=f2fmhQ8QDbmd5uiQ9eV3+SP/aG2/0yB5iAiCqRV90I68h2gE8V6mIVC2kpw9s1rC5DkRWEFWl2Jqj5dW+eqDMXePi54B1aX/BnUlFlqvvN4xUmTtemGqwCIpV0yRT03FFcB+1vEKpcjjwDWW3M/h0mLP3ojOukJse25zN/vRk1o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758489923; c=relaxed/simple;
	bh=QUWZ7bsRBpmNBvx6K3GGXfzzSmtF3A4ckosdFslKnyw=;
	h=Date:To:From:Subject:Message-Id; b=cyCOuarjHUIDGjfZTJd1soMpIPeDnn98jloS01VyAGB/EXGKFgcLj/kn5vOIfvSG/AAqezdAHOtjy+m829/mA8KiI/r3adzjSzB6pY57/1EOefjO0jZ7g/cRVCJwOILyGJTBuTmWyZwwlzPmXEvaDCZxWCjtxxvW73nZNojIHTs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=aMCLnhos; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="aMCLnhos"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F24FCC4CEE7;
	Sun, 21 Sep 2025 21:25:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1758489923;
	bh=QUWZ7bsRBpmNBvx6K3GGXfzzSmtF3A4ckosdFslKnyw=;
	h=Date:To:From:Subject:From;
	b=aMCLnhos2jamNkjhQRpBUhNHMzU0k3DFZyI09iQQOGYWACU6FNqEsQpQ2aR9stOAx
	 KiA5fzes6Bdo2rG5LomKLeZ8x+Fuzc6mlbMjTkcdpjbxo5qnoJOg9ko2b3CHYZuKLw
	 +qVlRL4h2lDr4kmtY/EBuUbTSQlvnN/GpFurTEhI=
Date: Sun, 21 Sep 2025 14:25:22 -0700
To: mm-commits@vger.kernel.org,nao.horiguchi@gmail.com,mhocko@suse.com,david@redhat.com,linmiaohe@huawei.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-hwpoison-decouple-hwpoison_filter-from-mm-memory-failurec.patch removed from -mm tree
Message-Id: <20250921212522.F24FCC4CEE7@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/hwpoison: decouple hwpoison_filter from mm/memory-failure.c
has been removed from the -mm tree.  Its filename was
     mm-hwpoison-decouple-hwpoison_filter-from-mm-memory-failurec.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Miaohe Lin <linmiaohe@huawei.com>
Subject: mm/hwpoison: decouple hwpoison_filter from mm/memory-failure.c
Date: Thu, 4 Sep 2025 14:22:58 +0800

mm/memory-failure.c defines and uses hwpoison_filter_* parameters but the
values of those parameters can only be modified via mm/hwpoison-inject.c
from userspace.  They have a potentially different life time.  Decouple
those parameters from mm/memory-failure.c to fix this broken layering.

Link: https://lkml.kernel.org/r/20250904062258.3336092-1-linmiaohe@huawei.com
Signed-off-by: Miaohe Lin <linmiaohe@huawei.com>
Suggested-by: Michal Hocko <mhocko@suse.com>
Cc: David Hildenbrand <david@redhat.com>
Cc: Naoya Horiguchi <nao.horiguchi@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/proc/page.c       |    1 
 mm/hwpoison-inject.c |   91 +++++++++++++++++++++++++++++++++++
 mm/internal.h        |   10 +--
 mm/memcontrol.c      |    1 
 mm/memory-failure.c  |  106 ++++++-----------------------------------
 5 files changed, 113 insertions(+), 96 deletions(-)

--- a/fs/proc/page.c~mm-hwpoison-decouple-hwpoison_filter-from-mm-memory-failurec
+++ a/fs/proc/page.c
@@ -256,6 +256,7 @@ u64 stable_page_flags(const struct page
 
 	return u;
 }
+EXPORT_SYMBOL_GPL(stable_page_flags);
 
 /* /proc/kpageflags - an array exposing page flags
  *
--- a/mm/hwpoison-inject.c~mm-hwpoison-decouple-hwpoison_filter-from-mm-memory-failurec
+++ a/mm/hwpoison-inject.c
@@ -7,8 +7,96 @@
 #include <linux/swap.h>
 #include <linux/pagemap.h>
 #include <linux/hugetlb.h>
+#include <linux/page-flags.h>
+#include <linux/memcontrol.h>
 #include "internal.h"
 
+static u32 hwpoison_filter_enable;
+static u32 hwpoison_filter_dev_major = ~0U;
+static u32 hwpoison_filter_dev_minor = ~0U;
+static u64 hwpoison_filter_flags_mask;
+static u64 hwpoison_filter_flags_value;
+
+static int hwpoison_filter_dev(struct page *p)
+{
+	struct folio *folio = page_folio(p);
+	struct address_space *mapping;
+	dev_t dev;
+
+	if (hwpoison_filter_dev_major == ~0U &&
+	    hwpoison_filter_dev_minor == ~0U)
+		return 0;
+
+	mapping = folio_mapping(folio);
+	if (mapping == NULL || mapping->host == NULL)
+		return -EINVAL;
+
+	dev = mapping->host->i_sb->s_dev;
+	if (hwpoison_filter_dev_major != ~0U &&
+	    hwpoison_filter_dev_major != MAJOR(dev))
+		return -EINVAL;
+	if (hwpoison_filter_dev_minor != ~0U &&
+	    hwpoison_filter_dev_minor != MINOR(dev))
+		return -EINVAL;
+
+	return 0;
+}
+
+static int hwpoison_filter_flags(struct page *p)
+{
+	if (!hwpoison_filter_flags_mask)
+		return 0;
+
+	if ((stable_page_flags(p) & hwpoison_filter_flags_mask) ==
+				    hwpoison_filter_flags_value)
+		return 0;
+	else
+		return -EINVAL;
+}
+
+/*
+ * This allows stress tests to limit test scope to a collection of tasks
+ * by putting them under some memcg. This prevents killing unrelated/important
+ * processes such as /sbin/init. Note that the target task may share clean
+ * pages with init (eg. libc text), which is harmless. If the target task
+ * share _dirty_ pages with another task B, the test scheme must make sure B
+ * is also included in the memcg. At last, due to race conditions this filter
+ * can only guarantee that the page either belongs to the memcg tasks, or is
+ * a freed page.
+ */
+#ifdef CONFIG_MEMCG
+static u64 hwpoison_filter_memcg;
+static int hwpoison_filter_task(struct page *p)
+{
+	if (!hwpoison_filter_memcg)
+		return 0;
+
+	if (page_cgroup_ino(p) != hwpoison_filter_memcg)
+		return -EINVAL;
+
+	return 0;
+}
+#else
+static int hwpoison_filter_task(struct page *p) { return 0; }
+#endif
+
+static int hwpoison_filter(struct page *p)
+{
+	if (!hwpoison_filter_enable)
+		return 0;
+
+	if (hwpoison_filter_dev(p))
+		return -EINVAL;
+
+	if (hwpoison_filter_flags(p))
+		return -EINVAL;
+
+	if (hwpoison_filter_task(p))
+		return -EINVAL;
+
+	return 0;
+}
+
 static struct dentry *hwpoison_dir;
 
 static int hwpoison_inject(void *data, u64 val)
@@ -67,6 +155,7 @@ DEFINE_DEBUGFS_ATTRIBUTE(unpoison_fops,
 static void __exit pfn_inject_exit(void)
 {
 	hwpoison_filter_enable = 0;
+	hwpoison_filter_unregister();
 	debugfs_remove_recursive(hwpoison_dir);
 }
 
@@ -105,6 +194,8 @@ static int __init pfn_inject_init(void)
 			   &hwpoison_filter_memcg);
 #endif
 
+	hwpoison_filter_register(hwpoison_filter);
+
 	return 0;
 }
 
--- a/mm/internal.h~mm-hwpoison-decouple-hwpoison_filter-from-mm-memory-failurec
+++ a/mm/internal.h
@@ -1228,14 +1228,10 @@ static inline bool node_reclaim_enabled(
 #ifdef CONFIG_MEMORY_FAILURE
 int unmap_poisoned_folio(struct folio *folio, unsigned long pfn, bool must_kill);
 void shake_folio(struct folio *folio);
-extern int hwpoison_filter(struct page *p);
+typedef int hwpoison_filter_func_t(struct page *p);
+void hwpoison_filter_register(hwpoison_filter_func_t *filter);
+void hwpoison_filter_unregister(void);
 
-extern u32 hwpoison_filter_dev_major;
-extern u32 hwpoison_filter_dev_minor;
-extern u64 hwpoison_filter_flags_mask;
-extern u64 hwpoison_filter_flags_value;
-extern u64 hwpoison_filter_memcg;
-extern u32 hwpoison_filter_enable;
 #define MAGIC_HWPOISON	0x48575053U	/* HWPS */
 void SetPageHWPoisonTakenOff(struct page *page);
 void ClearPageHWPoisonTakenOff(struct page *page);
--- a/mm/memcontrol.c~mm-hwpoison-decouple-hwpoison_filter-from-mm-memory-failurec
+++ a/mm/memcontrol.c
@@ -287,6 +287,7 @@ ino_t page_cgroup_ino(struct page *page)
 	rcu_read_unlock();
 	return ino;
 }
+EXPORT_SYMBOL_GPL(page_cgroup_ino);
 
 /* Subset of node_stat_item for memcg stats */
 static const unsigned int memcg_node_stat_items[] = {
--- a/mm/memory-failure.c~mm-hwpoison-decouple-hwpoison_filter-from-mm-memory-failurec
+++ a/mm/memory-failure.c
@@ -212,106 +212,34 @@ static bool page_handle_poison(struct pa
 	return true;
 }
 
-#if IS_ENABLED(CONFIG_HWPOISON_INJECT)
+static hwpoison_filter_func_t __rcu *hwpoison_filter_func __read_mostly;
 
-u32 hwpoison_filter_enable = 0;
-u32 hwpoison_filter_dev_major = ~0U;
-u32 hwpoison_filter_dev_minor = ~0U;
-u64 hwpoison_filter_flags_mask;
-u64 hwpoison_filter_flags_value;
-EXPORT_SYMBOL_GPL(hwpoison_filter_enable);
-EXPORT_SYMBOL_GPL(hwpoison_filter_dev_major);
-EXPORT_SYMBOL_GPL(hwpoison_filter_dev_minor);
-EXPORT_SYMBOL_GPL(hwpoison_filter_flags_mask);
-EXPORT_SYMBOL_GPL(hwpoison_filter_flags_value);
-
-static int hwpoison_filter_dev(struct page *p)
+void hwpoison_filter_register(hwpoison_filter_func_t *filter)
 {
-	struct folio *folio = page_folio(p);
-	struct address_space *mapping;
-	dev_t dev;
-
-	if (hwpoison_filter_dev_major == ~0U &&
-	    hwpoison_filter_dev_minor == ~0U)
-		return 0;
-
-	mapping = folio_mapping(folio);
-	if (mapping == NULL || mapping->host == NULL)
-		return -EINVAL;
-
-	dev = mapping->host->i_sb->s_dev;
-	if (hwpoison_filter_dev_major != ~0U &&
-	    hwpoison_filter_dev_major != MAJOR(dev))
-		return -EINVAL;
-	if (hwpoison_filter_dev_minor != ~0U &&
-	    hwpoison_filter_dev_minor != MINOR(dev))
-		return -EINVAL;
-
-	return 0;
+	rcu_assign_pointer(hwpoison_filter_func, filter);
 }
+EXPORT_SYMBOL_GPL(hwpoison_filter_register);
 
-static int hwpoison_filter_flags(struct page *p)
+void hwpoison_filter_unregister(void)
 {
-	if (!hwpoison_filter_flags_mask)
-		return 0;
-
-	if ((stable_page_flags(p) & hwpoison_filter_flags_mask) ==
-				    hwpoison_filter_flags_value)
-		return 0;
-	else
-		return -EINVAL;
+	RCU_INIT_POINTER(hwpoison_filter_func, NULL);
+	synchronize_rcu();
 }
+EXPORT_SYMBOL_GPL(hwpoison_filter_unregister);
 
-/*
- * This allows stress tests to limit test scope to a collection of tasks
- * by putting them under some memcg. This prevents killing unrelated/important
- * processes such as /sbin/init. Note that the target task may share clean
- * pages with init (eg. libc text), which is harmless. If the target task
- * share _dirty_ pages with another task B, the test scheme must make sure B
- * is also included in the memcg. At last, due to race conditions this filter
- * can only guarantee that the page either belongs to the memcg tasks, or is
- * a freed page.
- */
-#ifdef CONFIG_MEMCG
-u64 hwpoison_filter_memcg;
-EXPORT_SYMBOL_GPL(hwpoison_filter_memcg);
-static int hwpoison_filter_task(struct page *p)
+static int hwpoison_filter(struct page *p)
 {
-	if (!hwpoison_filter_memcg)
-		return 0;
+	int ret = 0;
+	hwpoison_filter_func_t *filter;
 
-	if (page_cgroup_ino(p) != hwpoison_filter_memcg)
-		return -EINVAL;
+	rcu_read_lock();
+	filter = rcu_dereference(hwpoison_filter_func);
+	if (filter)
+		ret = filter(p);
+	rcu_read_unlock();
 
-	return 0;
-}
-#else
-static int hwpoison_filter_task(struct page *p) { return 0; }
-#endif
-
-int hwpoison_filter(struct page *p)
-{
-	if (!hwpoison_filter_enable)
-		return 0;
-
-	if (hwpoison_filter_dev(p))
-		return -EINVAL;
-
-	if (hwpoison_filter_flags(p))
-		return -EINVAL;
-
-	if (hwpoison_filter_task(p))
-		return -EINVAL;
-
-	return 0;
-}
-EXPORT_SYMBOL_GPL(hwpoison_filter);
-#else
-int hwpoison_filter(struct page *p)
-{
-	return 0;
+	return ret;
 }
-#endif
 
 /*
  * Kill all processes that have a poisoned page mapped and then isolate
_

Patches currently in -mm which might be from linmiaohe@huawei.com are


