Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 68263185B4C
	for <mm-commits@vger.kernel.org>; Mon,  7 Apr 2025 21:41:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744062077; cv=none; b=nGLSLj2qleF+pYpedDGyyjzklpRUvKvhH/vmj5fX+c6It7KQ1wdpEZZ2T8wsOF+fpPu0Gd1I84sm4ita4ku/4IhMge6SV6qT2WZTGiQBBp/073C0DTXshnWLgHQ1JqsKtdOm2cJLI2MUC3vGkCPLZkCOQhI68e8kZZQ8v1UUBnA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744062077; c=relaxed/simple;
	bh=X2ZCYAarmdSBHW54WHKWq+OuE0ANLxPg5eqFQBgw53E=;
	h=Date:To:From:Subject:Message-Id; b=Pb35m56/6/vBOr5MZqtZpr/kR//y8IoV+TCyreGh2OneRUyxCVG9FjjhsS6drpvIxDewdNuwMzr4GqqZNm9VcDtg3R+ecDZte+CETuK9R6u0+gT+6WOlGlyH5mBJA3tgGmxSFHFhL5E4peFRQQDKX5ruWEBjgpLjgRTnaNfEQ+g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=08RM+P2M; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="08RM+P2M"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B938BC4CEDD;
	Mon,  7 Apr 2025 21:41:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1744062076;
	bh=X2ZCYAarmdSBHW54WHKWq+OuE0ANLxPg5eqFQBgw53E=;
	h=Date:To:From:Subject:From;
	b=08RM+P2MWz8l5wVoVmtwT4mOO5Fe/l4J629UvccI+0CIRIqcemzVpwX8sfmyj8tyk
	 EY29/VY5h9K6tYTd6SCHac/xzFrOxwfIM2i2uyHVkm2+A8y1t6NtZDqwtACIEO4Gp8
	 NOBhwCH1yCxCt3WWgO+EE16U2xmsqajF0iBjBqDo=
Date: Mon, 07 Apr 2025 14:41:16 -0700
To: mm-commits@vger.kernel.org,willy@infradead.org,vbabka@suse.cz,svetly.todorov@memverge.com,shakeel.butt@linux.dev,roman.gushchin@linux.dev,ran.xiaokai@zte.com.cn,muchun.song@linux.dev,mhocko@kernel.org,hannes@cmpxchg.org,david@redhat.com,liuye@kylinos.cn,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + fs-proc-page-refactoring-to-reduce-code-duplication.patch added to mm-new branch
Message-Id: <20250407214116.B938BC4CEDD@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: fs/proc/page: refactor to reduce code duplication
has been added to the -mm mm-new branch.  Its filename is
     fs-proc-page-refactoring-to-reduce-code-duplication.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/fs-proc-page-refactoring-to-reduce-code-duplication.patch

This patch will later appear in the mm-new branch at
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
Cc: Matthew Wilcow (Oracle) <willy@infradead.org>
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

mm-show_mem-optimize-si_meminfo_node-by-reducing-redundant-code.patch
mm-page_alloc-simplify-free_page_is_bad-by-removing-free_page_is_bad_report.patch
fs-proc-page-refactoring-to-reduce-code-duplication.patch

