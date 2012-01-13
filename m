From: akpm@linux-foundation.org
Subject: [merged] page_cgroup-drop-multi-config_memory_hotplug.patch removed from -mm tree
Date: Fri, 13 Jan 2012 12:34:31 -0800
Message-ID: <20120113203431.A1A231E004D@wpzn4.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-gx0-f202.google.com ([209.85.161.202]:48503 "EHLO
	mail-gx0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759096Ab2AMUec (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 13 Jan 2012 15:34:32 -0500
Received: by ggnk3 with SMTP id k3so355740ggn.1
        for <mm-commits@vger.kernel.org>; Fri, 13 Jan 2012 12:34:32 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: lliubbo@gmail.com, hannes@cmpxchg.org, kamezawa.hiroyu@jp.fujitsu.com, kosaki.motohiro@jp.fujitsu.com, mhocko@suse.cz, mm-commits@vger.kernel.org


The patch titled
     Subject: page_cgroup: drop multi CONFIG_MEMORY_HOTPLUG
has been removed from the -mm tree.  Its filename was
     page_cgroup-drop-multi-config_memory_hotplug.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
From: Bob Liu <lliubbo@gmail.com>
Subject: page_cgroup: drop multi CONFIG_MEMORY_HOTPLUG

No need for two CONFIG_MEMORY_HOTPLUG blocks.

Signed-off-by: Bob Liu <lliubbo@gmail.com>
Acked-by: Michal Hocko <mhocko@suse.cz>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Acked-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/page_cgroup.c |   30 ++++++++++++++----------------
 1 file changed, 14 insertions(+), 16 deletions(-)

diff -puN mm/page_cgroup.c~page_cgroup-drop-multi-config_memory_hotplug mm/page_cgroup.c
--- a/mm/page_cgroup.c~page_cgroup-drop-multi-config_memory_hotplug
+++ a/mm/page_cgroup.c
@@ -124,22 +124,6 @@ static void *__meminit alloc_page_cgroup
 	return addr;
 }
 
-#ifdef CONFIG_MEMORY_HOTPLUG
-static void free_page_cgroup(void *addr)
-{
-	if (is_vmalloc_addr(addr)) {
-		vfree(addr);
-	} else {
-		struct page *page = virt_to_page(addr);
-		size_t table_size =
-			sizeof(struct page_cgroup) * PAGES_PER_SECTION;
-
-		BUG_ON(PageReserved(page));
-		free_pages_exact(addr, table_size);
-	}
-}
-#endif
-
 static int __meminit init_section_page_cgroup(unsigned long pfn, int nid)
 {
 	struct mem_section *section;
@@ -176,6 +160,20 @@ static int __meminit init_section_page_c
 	return 0;
 }
 #ifdef CONFIG_MEMORY_HOTPLUG
+static void free_page_cgroup(void *addr)
+{
+	if (is_vmalloc_addr(addr)) {
+		vfree(addr);
+	} else {
+		struct page *page = virt_to_page(addr);
+		size_t table_size =
+			sizeof(struct page_cgroup) * PAGES_PER_SECTION;
+
+		BUG_ON(PageReserved(page));
+		free_pages_exact(addr, table_size);
+	}
+}
+
 void __free_page_cgroup(unsigned long pfn)
 {
 	struct mem_section *ms;
_

Patches currently in -mm which might be from lliubbo@gmail.com are

origin.patch

