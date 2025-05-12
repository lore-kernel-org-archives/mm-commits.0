Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BCB001553A3
	for <mm-commits@vger.kernel.org>; Mon, 12 May 2025 00:51:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747011069; cv=none; b=CSznyrNrmYH1MMGH8J+jdRO+qHhhjjsMquY/ljJijqXmRH7sG44JYFFCT1upBDA/dDRdhwhU9y8RhbLl6rNwXwgKjjmUL7Ap8tMZRKCRRqYOYSpXg2kxLsUFWnmY72NcDy1SWdrVjp7QKAv8eHzBgi8ixE3Y9ffNa6rl/asp0o0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747011069; c=relaxed/simple;
	bh=pdbHfOAixOPJ5KM7pJkwLq0jLxqcX+p8hMM6XsFNOP0=;
	h=Date:To:From:Subject:Message-Id; b=O5cVy+VPxfTWagaNB87FQIBJkG4jxh0fQ80vQsLS25UsiTPmjrelLQ3fIJi10osRrCuMe3LP44dVRWW0klizCEXvF2jLeekuvb+vjG42J2h7eSlOFRMziLqSwvK0glPIZI2eqfv56i8Adjc5qcfIeLkFiUYeOFtC17/ecbJNnuE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=Cr2YbKgY; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="Cr2YbKgY"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 91C73C4CEE4;
	Mon, 12 May 2025 00:51:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1747011069;
	bh=pdbHfOAixOPJ5KM7pJkwLq0jLxqcX+p8hMM6XsFNOP0=;
	h=Date:To:From:Subject:From;
	b=Cr2YbKgYhVjTtvKahKrlqkunoOinmz2R2aC2uJiSxkpdroYDAisu35pDfljMUkSk7
	 5AeI365qXYgD973/NAWFh2aGT6dEwxRupoOVF3DOxqHNX0jOpjVksTddiSJjb9kfof
	 o3O3GfnvuCw4xn+rOqL46HLX0/Fj4dUbSUJ9vPhQ=
Date: Sun, 11 May 2025 17:51:09 -0700
To: mm-commits@vger.kernel.org,willy@infradead.org,vbabka@suse.cz,svetly.todorov@memverge.com,shakeel.butt@linux.dev,roman.gushchin@linux.dev,ran.xiaokai@zte.com.cn,muchun.song@linux.dev,mhocko@kernel.org,hannes@cmpxchg.org,david@redhat.com,liuye@kylinos.cn,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] fs-proc-page-refactoring-to-reduce-code-duplication.patch removed from -mm tree
Message-Id: <20250512005109.91C73C4CEE4@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: fs/proc/page: refactor to reduce code duplication
has been removed from the -mm tree.  Its filename was
     fs-proc-page-refactoring-to-reduce-code-duplication.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Liu Ye <liuye@kylinos.cn>
Subject: fs/proc/page: refactor to reduce code duplication
Date: Tue, 18 Mar 2025 14:32:26 +0800

kpageflags_read() and kpagecgroup_read() are quite similar to
kpagecount_read().  Refactor common code into a helper function to reduce
code duplication.

Link: https://lkml.kernel.org/r/20250318063226.223284-1-liuyerd@163.com
Signed-off-by: Liu Ye <liuye@kylinos.cn>
Acked-by: David Hildenbrand <david@redhat.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: Michal Hocko <mhocko@kernel.org>
Cc: Muchun Song <muchun.song@linux.dev>
Cc: Ran Xiaokai <ran.xiaokai@zte.com.cn>
Cc: Roman Gushchin <roman.gushchin@linux.dev>
Cc: Shakeel Butt <shakeel.butt@linux.dev>
Cc: Svetly Todorov <svetly.todorov@memverge.com>
Cc: Vlastimil Babka <vbabka@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/proc/page.c             |  159 +++++++++++------------------------
 include/linux/memcontrol.h |    4 
 2 files changed, 57 insertions(+), 106 deletions(-)

--- a/fs/proc/page.c~fs-proc-page-refactoring-to-reduce-code-duplication
+++ a/fs/proc/page.c
@@ -22,6 +22,12 @@
 #define KPMMASK (KPMSIZE - 1)
 #define KPMBITS (KPMSIZE * BITS_PER_BYTE)
 
+enum kpage_operation {
+	KPAGE_FLAGS,
+	KPAGE_COUNT,
+	KPAGE_CGROUP,
+};
+
 static inline unsigned long get_max_dump_pfn(void)
 {
 #ifdef CONFIG_SPARSEMEM
@@ -37,19 +43,17 @@ static inline unsigned long get_max_dump
 #endif
 }
 
-/* /proc/kpagecount - an array exposing page mapcounts
- *
- * Each entry is a u64 representing the corresponding
- * physical page mapcount.
- */
-static ssize_t kpagecount_read(struct file *file, char __user *buf,
-			     size_t count, loff_t *ppos)
+static ssize_t kpage_read(struct file *file, char __user *buf,
+		size_t count, loff_t *ppos,
+		enum kpage_operation op)
 {
 	const unsigned long max_dump_pfn = get_max_dump_pfn();
 	u64 __user *out = (u64 __user *)buf;
+	struct page *page;
 	unsigned long src = *ppos;
 	unsigned long pfn;
 	ssize_t ret = 0;
+	u64 info;
 
 	pfn = src / KPMSIZE;
 	if (src & KPMMASK || count & KPMMASK)
@@ -59,24 +63,34 @@ static ssize_t kpagecount_read(struct fi
 	count = min_t(unsigned long, count, (max_dump_pfn * KPMSIZE) - src);
 
 	while (count > 0) {
-		struct page *page;
-		u64 mapcount = 0;
-
 		/*
 		 * TODO: ZONE_DEVICE support requires to identify
 		 * memmaps that were actually initialized.
 		 */
 		page = pfn_to_online_page(pfn);
-		if (page) {
-			struct folio *folio = page_folio(page);
 
-			if (IS_ENABLED(CONFIG_PAGE_MAPCOUNT))
-				mapcount = folio_precise_page_mapcount(folio, page);
-			else
-				mapcount = folio_average_page_mapcount(folio);
-		}
+		if (page) {
+			switch (op) {
+			case KPAGE_FLAGS:
+				info = stable_page_flags(page);
+				break;
+			case KPAGE_COUNT:
+				if (IS_ENABLED(CONFIG_PAGE_MAPCOUNT))
+					info = folio_precise_page_mapcount(page_folio(page), page);
+				else
+					info = folio_average_page_mapcount(page_folio(page));
+				break;
+			case KPAGE_CGROUP:
+				info = page_cgroup_ino(page);
+				break;
+			default:
+				info = 0;
+				break;
+			}
+		} else
+			info = 0;
 
-		if (put_user(mapcount, out)) {
+		if (put_user(info, out)) {
 			ret = -EFAULT;
 			break;
 		}
@@ -94,17 +108,23 @@ static ssize_t kpagecount_read(struct fi
 	return ret;
 }
 
+/* /proc/kpagecount - an array exposing page mapcounts
+ *
+ * Each entry is a u64 representing the corresponding
+ * physical page mapcount.
+ */
+static ssize_t kpagecount_read(struct file *file, char __user *buf,
+		size_t count, loff_t *ppos)
+{
+	return kpage_read(file, buf, count, ppos, KPAGE_COUNT);
+}
+
 static const struct proc_ops kpagecount_proc_ops = {
 	.proc_flags	= PROC_ENTRY_PERMANENT,
 	.proc_lseek	= mem_lseek,
 	.proc_read	= kpagecount_read,
 };
 
-/* /proc/kpageflags - an array exposing page flags
- *
- * Each entry is a u64 representing the corresponding
- * physical page flags.
- */
 
 static inline u64 kpf_copy_bit(u64 kflags, int ubit, int kbit)
 {
@@ -225,47 +245,17 @@ u64 stable_page_flags(const struct page
 #endif
 
 	return u;
-};
+}
 
+/* /proc/kpageflags - an array exposing page flags
+ *
+ * Each entry is a u64 representing the corresponding
+ * physical page flags.
+ */
 static ssize_t kpageflags_read(struct file *file, char __user *buf,
-			     size_t count, loff_t *ppos)
+		size_t count, loff_t *ppos)
 {
-	const unsigned long max_dump_pfn = get_max_dump_pfn();
-	u64 __user *out = (u64 __user *)buf;
-	unsigned long src = *ppos;
-	unsigned long pfn;
-	ssize_t ret = 0;
-
-	pfn = src / KPMSIZE;
-	if (src & KPMMASK || count & KPMMASK)
-		return -EINVAL;
-	if (src >= max_dump_pfn * KPMSIZE)
-		return 0;
-	count = min_t(unsigned long, count, (max_dump_pfn * KPMSIZE) - src);
-
-	while (count > 0) {
-		/*
-		 * TODO: ZONE_DEVICE support requires to identify
-		 * memmaps that were actually initialized.
-		 */
-		struct page *page = pfn_to_online_page(pfn);
-
-		if (put_user(stable_page_flags(page), out)) {
-			ret = -EFAULT;
-			break;
-		}
-
-		pfn++;
-		out++;
-		count -= KPMSIZE;
-
-		cond_resched();
-	}
-
-	*ppos += (char __user *)out - buf;
-	if (!ret)
-		ret = (char __user *)out - buf;
-	return ret;
+	return kpage_read(file, buf, count, ppos, KPAGE_FLAGS);
 }
 
 static const struct proc_ops kpageflags_proc_ops = {
@@ -276,53 +266,10 @@ static const struct proc_ops kpageflags_
 
 #ifdef CONFIG_MEMCG
 static ssize_t kpagecgroup_read(struct file *file, char __user *buf,
-				size_t count, loff_t *ppos)
+		size_t count, loff_t *ppos)
 {
-	const unsigned long max_dump_pfn = get_max_dump_pfn();
-	u64 __user *out = (u64 __user *)buf;
-	struct page *ppage;
-	unsigned long src = *ppos;
-	unsigned long pfn;
-	ssize_t ret = 0;
-	u64 ino;
-
-	pfn = src / KPMSIZE;
-	if (src & KPMMASK || count & KPMMASK)
-		return -EINVAL;
-	if (src >= max_dump_pfn * KPMSIZE)
-		return 0;
-	count = min_t(unsigned long, count, (max_dump_pfn * KPMSIZE) - src);
-
-	while (count > 0) {
-		/*
-		 * TODO: ZONE_DEVICE support requires to identify
-		 * memmaps that were actually initialized.
-		 */
-		ppage = pfn_to_online_page(pfn);
-
-		if (ppage)
-			ino = page_cgroup_ino(ppage);
-		else
-			ino = 0;
-
-		if (put_user(ino, out)) {
-			ret = -EFAULT;
-			break;
-		}
-
-		pfn++;
-		out++;
-		count -= KPMSIZE;
-
-		cond_resched();
-	}
-
-	*ppos += (char __user *)out - buf;
-	if (!ret)
-		ret = (char __user *)out - buf;
-	return ret;
+	return kpage_read(file, buf, count, ppos, KPAGE_CGROUP);
 }
-
 static const struct proc_ops kpagecgroup_proc_ops = {
 	.proc_flags	= PROC_ENTRY_PERMANENT,
 	.proc_lseek	= mem_lseek,
--- a/include/linux/memcontrol.h~fs-proc-page-refactoring-to-reduce-code-duplication
+++ a/include/linux/memcontrol.h
@@ -1793,6 +1793,10 @@ static inline void count_objcg_events(st
 {
 }
 
+static inline ino_t page_cgroup_ino(struct page *page)
+{
+	return 0;
+}
 #endif /* CONFIG_MEMCG */
 
 #if defined(CONFIG_MEMCG) && defined(CONFIG_ZSWAP)
_

Patches currently in -mm which might be from liuye@kylinos.cn are

mm-rmap-rename-page__anon_vma-to-anon_vma-for-consistency.patch
mm-rmap-fix-typo-in-comment-in-page_address_in_vma.patch
mm-io-mapping-precompute-remap-protection-flags-for-clarity.patch
mm-debug_page_alloc-improve-error-message-for-invalid-guardpage-minorder.patch
mm-numa-remove-unnecessary-local-variable-in-alloc_node_data.patch

