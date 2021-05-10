Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_RED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AD291C433B4
	for <mm-commits@archiver.kernel.org>; Mon, 10 May 2021 03:54:41 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 8946761431
	for <mm-commits@archiver.kernel.org>; Mon, 10 May 2021 03:54:41 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230083AbhEJDzp (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Sun, 9 May 2021 23:55:45 -0400
Received: from mail.kernel.org ([198.145.29.99]:41128 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230029AbhEJDzo (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Sun, 9 May 2021 23:55:44 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id E680F6138C;
        Mon, 10 May 2021 03:54:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1620618880;
        bh=euP1VzNDi/+dldzsGmVJ8gebv/m6YbkBVKrFSQ1w95o=;
        h=Date:From:To:Subject:From;
        b=OPOwoEOzku6ZXE7mvSxm/cWv7YfkpAO+tchtXduavtN329rPUwb50LPQgeuvld0qV
         4gxGJD8Dd5tzQ5znyGySf3OZaPvTE/Wn3joBiD7PENKjrdzgAQwVgmFFIdvP80ifzZ
         rId4LUd+gq+HYJtCSCEn/6eWsUo3mIFoBcVF3P5o=
Date:   Sun, 09 May 2021 20:54:39 -0700
From:   akpm@linux-foundation.org
To:     almasrymina@google.com, anshuman.khandual@arm.com,
        bodeddub@amazon.com, bp@alien8.de, bsingharora@gmail.com,
        chenhuang5@huawei.com, corbet@lwn.net, dave.hansen@linux.intel.com,
        david@redhat.com, duanxiongchun@bytedance.com, hpa@zytor.com,
        joao.m.martins@oracle.com, jroedel@suse.de, linmiaohe@huawei.com,
        luto@kernel.org, mhocko@suse.com, mike.kravetz@oracle.com,
        mingo@redhat.com, mm-commits@vger.kernel.org,
        naoya.horiguchi@nec.com, oneukum@suse.com, osalvador@suse.de,
        paulmck@kernel.org, pawan.kumar.gupta@linux.intel.com,
        peterz@infradead.org, rdunlap@infradead.org, rientjes@google.com,
        song.bao.hua@hisilicon.com, songmuchun@bytedance.com,
        tglx@linutronix.de, viro@zeniv.linux.org.uk, willy@infradead.org
Subject:  + mm-hugetlb-gather-discrete-indexes-of-tail-page.patch
 added to -mm tree
Message-ID: <20210510035439.1Cvz5Mlju%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm: hugetlb: gather discrete indexes of tail page
has been added to the -mm tree.  Its filename is
     mm-hugetlb-gather-discrete-indexes-of-tail-page.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/mm-hugetlb-gather-discrete-indexes-of-tail-page.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/mm-hugetlb-gather-discrete-indexes-of-tail-page.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Muchun Song <songmuchun@bytedance.com>
Subject: mm: hugetlb: gather discrete indexes of tail page

For HugeTLB page, there are more metadata to save in the struct page.  But
the head struct page cannot meet our needs, so we have to abuse other tail
struct page to store the metadata.  In order to avoid conflicts caused by
subsequent use of more tail struct pages, we can gather these discrete
indexes of tail struct page.  In this case, it will be easier to add a new
tail page index later.

Link: https://lkml.kernel.org/r/20210510030027.56044-4-songmuchun@bytedance.com
Signed-off-by: Muchun Song <songmuchun@bytedance.com>
Reviewed-by: Oscar Salvador <osalvador@suse.de>
Reviewed-by: Miaohe Lin <linmiaohe@huawei.com>
Tested-by: Chen Huang <chenhuang5@huawei.com>
Tested-by: Bodeddula Balasubramaniam <bodeddub@amazon.com>
Acked-by: Michal Hocko <mhocko@suse.com>
Reviewed-by: Mike Kravetz <mike.kravetz@oracle.com>
Cc: Alexander Viro <viro@zeniv.linux.org.uk>
Cc: Andy Lutomirski <luto@kernel.org>
Cc: Anshuman Khandual <anshuman.khandual@arm.com>
Cc: Balbir Singh <bsingharora@gmail.com>
Cc: Barry Song <song.bao.hua@hisilicon.com>
Cc: Borislav Petkov <bp@alien8.de>
Cc: Dave Hansen <dave.hansen@linux.intel.com>
Cc: David Hildenbrand <david@redhat.com>
Cc: David Rientjes <rientjes@google.com>
Cc: HORIGUCHI NAOYA <naoya.horiguchi@nec.com>
Cc: "H. Peter Anvin" <hpa@zytor.com>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: Joao Martins <joao.m.martins@oracle.com>
Cc: Joerg Roedel <jroedel@suse.de>
Cc: Jonathan Corbet <corbet@lwn.net>
Cc: Matthew Wilcox <willy@infradead.org>
Cc: Mina Almasry <almasrymina@google.com>
Cc: Oliver Neukum <oneukum@suse.com>
Cc: Paul E. McKenney <paulmck@kernel.org>
Cc: Pawan Gupta <pawan.kumar.gupta@linux.intel.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Randy Dunlap <rdunlap@infradead.org>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Xiongchun Duan <duanxiongchun@bytedance.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/hugetlb.h        |   21 +++++++++++++++++++--
 include/linux/hugetlb_cgroup.h |   19 +++++++++++--------
 2 files changed, 30 insertions(+), 10 deletions(-)

--- a/include/linux/hugetlb_cgroup.h~mm-hugetlb-gather-discrete-indexes-of-tail-page
+++ a/include/linux/hugetlb_cgroup.h
@@ -21,15 +21,16 @@ struct hugetlb_cgroup;
 struct resv_map;
 struct file_region;
 
+#ifdef CONFIG_CGROUP_HUGETLB
 /*
  * Minimum page order trackable by hugetlb cgroup.
  * At least 4 pages are necessary for all the tracking information.
- * The second tail page (hpage[2]) is the fault usage cgroup.
- * The third tail page (hpage[3]) is the reservation usage cgroup.
+ * The second tail page (hpage[SUBPAGE_INDEX_CGROUP]) is the fault
+ * usage cgroup. The third tail page (hpage[SUBPAGE_INDEX_CGROUP_RSVD])
+ * is the reservation usage cgroup.
  */
-#define HUGETLB_CGROUP_MIN_ORDER	2
+#define HUGETLB_CGROUP_MIN_ORDER order_base_2(__MAX_CGROUP_SUBPAGE_INDEX + 1)
 
-#ifdef CONFIG_CGROUP_HUGETLB
 enum hugetlb_memory_event {
 	HUGETLB_MAX,
 	HUGETLB_NR_MEMORY_EVENTS,
@@ -66,9 +67,9 @@ __hugetlb_cgroup_from_page(struct page *
 	if (compound_order(page) < HUGETLB_CGROUP_MIN_ORDER)
 		return NULL;
 	if (rsvd)
-		return (struct hugetlb_cgroup *)page[3].private;
+		return (void *)page_private(page + SUBPAGE_INDEX_CGROUP_RSVD);
 	else
-		return (struct hugetlb_cgroup *)page[2].private;
+		return (void *)page_private(page + SUBPAGE_INDEX_CGROUP);
 }
 
 static inline struct hugetlb_cgroup *hugetlb_cgroup_from_page(struct page *page)
@@ -90,9 +91,11 @@ static inline int __set_hugetlb_cgroup(s
 	if (compound_order(page) < HUGETLB_CGROUP_MIN_ORDER)
 		return -1;
 	if (rsvd)
-		page[3].private = (unsigned long)h_cg;
+		set_page_private(page + SUBPAGE_INDEX_CGROUP_RSVD,
+				 (unsigned long)h_cg);
 	else
-		page[2].private = (unsigned long)h_cg;
+		set_page_private(page + SUBPAGE_INDEX_CGROUP,
+				 (unsigned long)h_cg);
 	return 0;
 }
 
--- a/include/linux/hugetlb.h~mm-hugetlb-gather-discrete-indexes-of-tail-page
+++ a/include/linux/hugetlb.h
@@ -29,6 +29,23 @@ typedef struct { unsigned long pd; } hug
 #include <linux/shm.h>
 #include <asm/tlbflush.h>
 
+/*
+ * For HugeTLB page, there are more metadata to save in the struct page. But
+ * the head struct page cannot meet our needs, so we have to abuse other tail
+ * struct page to store the metadata. In order to avoid conflicts caused by
+ * subsequent use of more tail struct pages, we gather these discrete indexes
+ * of tail struct page here.
+ */
+enum {
+	SUBPAGE_INDEX_SUBPOOL = 1,	/* reuse page->private */
+#ifdef CONFIG_CGROUP_HUGETLB
+	SUBPAGE_INDEX_CGROUP,		/* reuse page->private */
+	SUBPAGE_INDEX_CGROUP_RSVD,	/* reuse page->private */
+	__MAX_CGROUP_SUBPAGE_INDEX = SUBPAGE_INDEX_CGROUP_RSVD,
+#endif
+	__NR_USED_SUBPAGE,
+};
+
 struct hugepage_subpool {
 	spinlock_t lock;
 	long count;
@@ -627,13 +644,13 @@ extern unsigned int default_hstate_idx;
  */
 static inline struct hugepage_subpool *hugetlb_page_subpool(struct page *hpage)
 {
-	return (struct hugepage_subpool *)(hpage+1)->private;
+	return (void *)page_private(hpage + SUBPAGE_INDEX_SUBPOOL);
 }
 
 static inline void hugetlb_set_page_subpool(struct page *hpage,
 					struct hugepage_subpool *subpool)
 {
-	set_page_private(hpage+1, (unsigned long)subpool);
+	set_page_private(hpage + SUBPAGE_INDEX_SUBPOOL, (unsigned long)subpool);
 }
 
 static inline struct hstate *hstate_file(struct file *f)
_

Patches currently in -mm which might be from songmuchun@bytedance.com are

mm-memcontrol-fix-root_mem_cgroup-charging.patch
mm-memory_hotplug-factor-out-bootmem-core-functions-to-bootmem_infoc.patch
mm-hugetlb-introduce-a-new-config-hugetlb_page_free_vmemmap.patch
mm-hugetlb-gather-discrete-indexes-of-tail-page.patch
mm-hugetlb-free-the-vmemmap-pages-associated-with-each-hugetlb-page.patch
mm-hugetlb-defer-freeing-of-hugetlb-pages.patch
mm-hugetlb-alloc-the-vmemmap-pages-associated-with-each-hugetlb-page.patch
mm-hugetlb-add-a-kernel-parameter-hugetlb_free_vmemmap.patch
mm-memory_hotplug-disable-memmap_on_memory-when-hugetlb_free_vmemmap-enabled.patch
mm-hugetlb-introduce-nr_free_vmemmap_pages-in-the-struct-hstate.patch

