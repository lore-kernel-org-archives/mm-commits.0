From: akpm@linux-foundation.org
Subject: [merged]
 hwpoison-use-page_cgroup_ino-for-filtering-by-memcg.patch removed from -mm
 tree
Date: Fri, 11 Sep 2015 11:11:10 -0700
Message-ID: <55f3193e.zZjR6ZpB57sNdiHq%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:53563 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750862AbbIKSLL (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 11 Sep 2015 14:11:11 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: vdavydov@parallels.com, andreslc@google.com, corbet@lwn.net, gorcunov@openvz.org, gthelen@google.com, hannes@cmpxchg.org, mhocko@suse.cz, minchan@kernel.org, raghavendra.kt@linux.vnet.ibm.com, rientjes@google.com, walken@google.com, xemul@parallels.com, mm-commits@vger.kernel.org


The patch titled
     Subject: hwpoison: use page_cgroup_ino for filtering by memcg
has been removed from the -mm tree.  Its filename was
     hwpoison-use-page_cgroup_ino-for-filtering-by-memcg.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Vladimir Davydov <vdavydov@parallels.com>
Subject: hwpoison: use page_cgroup_ino for filtering by memcg

Hwpoison allows to filter pages by memory cgroup ino.  Currently, it
calls try_get_mem_cgroup_from_page to obtain the cgroup from a page and
then its ino using cgroup_ino, but now we have a helper method for
that, page_cgroup_ino, so use it instead.

This patch also loosens the hwpoison memcg filter dependency rules - it
makes it depend on CONFIG_MEMCG instead of CONFIG_MEMCG_SWAP, because
hwpoison memcg filter does not require anything (nor it used to) from
CONFIG_MEMCG_SWAP side.

Signed-off-by: Vladimir Davydov <vdavydov@parallels.com>
Reviewed-by: Andres Lagar-Cavilla <andreslc@google.com>
Cc: Minchan Kim <minchan@kernel.org>
Cc: Raghavendra K T <raghavendra.kt@linux.vnet.ibm.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Michal Hocko <mhocko@suse.cz>
Cc: Greg Thelen <gthelen@google.com>
Cc: Michel Lespinasse <walken@google.com>
Cc: David Rientjes <rientjes@google.com>
Cc: Pavel Emelyanov <xemul@parallels.com>
Cc: Cyrill Gorcunov <gorcunov@openvz.org>
Cc: Jonathan Corbet <corbet@lwn.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/hwpoison-inject.c |    5 +----
 mm/memory-failure.c  |   16 ++--------------
 2 files changed, 3 insertions(+), 18 deletions(-)

diff -puN mm/hwpoison-inject.c~hwpoison-use-page_cgroup_ino-for-filtering-by-memcg mm/hwpoison-inject.c
--- a/mm/hwpoison-inject.c~hwpoison-use-page_cgroup_ino-for-filtering-by-memcg
+++ a/mm/hwpoison-inject.c
@@ -45,12 +45,9 @@ static int hwpoison_inject(void *data, u
 	/*
 	 * do a racy check with elevated page count, to make sure PG_hwpoison
 	 * will only be set for the targeted owner (or on a free page).
-	 * We temporarily take page lock for try_get_mem_cgroup_from_page().
 	 * memory_failure() will redo the check reliably inside page lock.
 	 */
-	lock_page(hpage);
 	err = hwpoison_filter(hpage);
-	unlock_page(hpage);
 	if (err)
 		goto put_out;
 
@@ -126,7 +123,7 @@ static int pfn_inject_init(void)
 	if (!dentry)
 		goto fail;
 
-#ifdef CONFIG_MEMCG_SWAP
+#ifdef CONFIG_MEMCG
 	dentry = debugfs_create_u64("corrupt-filter-memcg", 0600,
 				    hwpoison_dir, &hwpoison_filter_memcg);
 	if (!dentry)
diff -puN mm/memory-failure.c~hwpoison-use-page_cgroup_ino-for-filtering-by-memcg mm/memory-failure.c
--- a/mm/memory-failure.c~hwpoison-use-page_cgroup_ino-for-filtering-by-memcg
+++ a/mm/memory-failure.c
@@ -130,27 +130,15 @@ static int hwpoison_filter_flags(struct
  * can only guarantee that the page either belongs to the memcg tasks, or is
  * a freed page.
  */
-#ifdef	CONFIG_MEMCG_SWAP
+#ifdef CONFIG_MEMCG
 u64 hwpoison_filter_memcg;
 EXPORT_SYMBOL_GPL(hwpoison_filter_memcg);
 static int hwpoison_filter_task(struct page *p)
 {
-	struct mem_cgroup *mem;
-	struct cgroup_subsys_state *css;
-	unsigned long ino;
-
 	if (!hwpoison_filter_memcg)
 		return 0;
 
-	mem = try_get_mem_cgroup_from_page(p);
-	if (!mem)
-		return -EINVAL;
-
-	css = &mem->css;
-	ino = cgroup_ino(css->cgroup);
-	css_put(css);
