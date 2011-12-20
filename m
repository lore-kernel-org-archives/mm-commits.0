From: akpm@linux-foundation.org
Subject: + page_cgroup-drop-multi-config_memory_hotplug.patch added to -mm tree
Date: Tue, 20 Dec 2011 15:01:41 -0800
Message-ID: <20111220230142.A40D220004E@hpza10.eem.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-ee0-f74.google.com ([74.125.83.74]:40327 "EHLO
	mail-ee0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753012Ab1LTXBo (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 20 Dec 2011 18:01:44 -0500
Received: by mail-ee0-f74.google.com with SMTP id c1so221453eek.1
        for <mm-commits@vger.kernel.org>; Tue, 20 Dec 2011 15:01:44 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: lliubbo@gmail.com, hannes@cmpxchg.org, kamezawa.hiroyu@jp.fujitsu.com, kosaki.motohiro@jp.fujitsu.com, mhocko@suse.cz


The patch titled
     Subject: page_cgroup: drop multi CONFIG_MEMORY_HOTPLUG
has been added to the -mm tree.  Its filename is
     page_cgroup-drop-multi-config_memory_hotplug.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://userweb.kernel.org/~akpm/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
From: Bob Liu <lliubbo@gmail.com>
Subject: page_cgroup: drop multi CONFIG_MEMORY_HOTPLUG

No need for two CONFIG_MEMORY_HOTPLUG blocks.

Signed-off-by: Bob Liu <lliubbo@gmail.com>
Acked-by: Michal Hocko <mhocko@suse.cz>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
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
Subject: Subject: page_cgroup: drop multi CONFIG_MEMORY_HOTPLUG

Patches currently in -mm which might be from lliubbo@gmail.com are

linux-next.patch
page_cgroup-add-helper-function-to-get-swap_cgroup.patch
page_cgroup-add-helper-function-to-get-swap_cgroup-cleanup.patch
memcg-cleanup-for_each_node_state.patch
page_alloc-break-early-in-check_for_regular_memory.patch
page_cgroup-drop-multi-config_memory_hotplug.patch

