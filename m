Return-Path: <SRS0=1kGn=B5=vger.kernel.org=mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1ED16C433DF
	for <mm-commits@archiver.kernel.org>; Wed, 19 Aug 2020 03:50:39 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id ECD4D20829
	for <mm-commits@archiver.kernel.org>; Wed, 19 Aug 2020 03:50:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1597809039;
	bh=55jppr0ldwp0aNy+8yVrVgZM1kDLuoqw7GDMqoxdxvo=;
	h=Date:From:To:Subject:In-Reply-To:Reply-To:List-ID:From;
	b=qvBL0d0uMCu4uOS+tNZdW4Q5XC64tS9GI4/SiMWcVHLf/puXYjWGKHpJCIiIxRHNe
	 2+qRO+l5IhxdLL7O9mKgXd/HNVx3HewouMi3UqMl2784DzfvHEmA3y7U074dmY9wf3
	 ZBrnG86QwmhIwNF9Twf7gppfkJ/5tpqVaHtKQIzY=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726422AbgHSDui (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 18 Aug 2020 23:50:38 -0400
Received: from mail.kernel.org ([198.145.29.99]:43432 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725903AbgHSDui (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Tue, 18 Aug 2020 23:50:38 -0400
Received: from localhost.localdomain (c-73-231-172-41.hsd1.ca.comcast.net [73.231.172.41])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 0939B20709;
        Wed, 19 Aug 2020 03:50:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1597809037;
        bh=55jppr0ldwp0aNy+8yVrVgZM1kDLuoqw7GDMqoxdxvo=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=OKIJHCeWWqZL5PWTQgTWpyGKTUJAvnl/b06nOIypPCfjXLqJNyMwQ7cS86i51P3Ai
         9NKa26Zj7Wvdt1fV5p5ImZc3qfkVr3BPO3CAY83jozJ0+hIAwjexQVmRqbQSnNHNmn
         +l8p1udf63Xmz0Y5LxTWyoiSYqhvclBWtz0HBCtM=
Date:   Tue, 18 Aug 2020 20:50:36 -0700
From:   Andrew Morton <akpm@linux-foundation.org>
To:     aarcange@redhat.com, alex.shi@linux.alibaba.com, guro@fb.com,
        hannes@cmpxchg.org, hughd@google.com,
        kirill.shutemov@linux.intel.com, mhocko@kernel.org,
        mhocko@suse.com, mm-commits@vger.kernel.org,
        richard.weiyang@gmail.com, vdavydov.dev@gmail.com,
        willy@infradead.org
Subject:  +
 mm-memcg-warning-on-memcg-after-readahead-page-charged.patch added to -mm
 tree
Message-ID: <20200819035036.srx4Cy0hh%akpm@linux-foundation.org>
In-Reply-To: <20200814172939.55d6d80b6e21e4241f1ee1f3@linux-foundation.org>
User-Agent: s-nail v14.8.16
Sender: mm-commits-owner@vger.kernel.org
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/memcg: warning on !memcg after readahead page charged
has been added to the -mm tree.  Its filename is
     mm-memcg-warning-on-memcg-after-readahead-page-charged.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-memcg-warning-on-memcg-after-readahead-page-charged.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-memcg-warning-on-memcg-after-readahead-page-charged.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Alex Shi <alex.shi@linux.alibaba.com>
Subject: mm/memcg: warning on !memcg after readahead page charged

Since readahead page is charged on memcg too, in theory we don't have to
check this exception now.  Before safely remove them all, add a warning
for the unexpected !memcg.

Link: http://lkml.kernel.org/r/1597144232-11370-1-git-send-email-alex.shi@linux.alibaba.com
Signed-off-by: Alex Shi <alex.shi@linux.alibaba.com>
Acked-by: Michal Hocko <mhocko@suse.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Michal Hocko <mhocko@kernel.org>
Cc: Vladimir Davydov <vdavydov.dev@gmail.com>
Cc: Andrea Arcangeli <aarcange@redhat.com>
Cc: Hugh Dickins <hughd@google.com>
Cc: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
Cc: Matthew Wilcox <willy@infradead.org>
Cc: Roman Gushchin <guro@fb.com>
Cc: Wei Yang <richard.weiyang@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/mmdebug.h |   13 +++++++++++++
 mm/memcontrol.c         |   15 ++++++++-------
 2 files changed, 21 insertions(+), 7 deletions(-)

--- a/include/linux/mmdebug.h~mm-memcg-warning-on-memcg-after-readahead-page-charged
+++ a/include/linux/mmdebug.h
@@ -37,6 +37,18 @@ void dump_mm(const struct mm_struct *mm)
 			BUG();						\
 		}							\
 	} while (0)
+#define VM_WARN_ON_ONCE_PAGE(cond, page)	({			\
+	static bool __section(.data.once) __warned;			\
+	int __ret_warn_once = !!(cond);					\
+									\
+	if (unlikely(__ret_warn_once && !__warned)) {			\
+		dump_page(page, "VM_WARN_ON_ONCE_PAGE(" __stringify(cond)")");\
+		__warned = true;					\
+		WARN_ON(1);						\
+	}								\
+	unlikely(__ret_warn_once);					\
+})
+
 #define VM_WARN_ON(cond) (void)WARN_ON(cond)
 #define VM_WARN_ON_ONCE(cond) (void)WARN_ON_ONCE(cond)
 #define VM_WARN_ONCE(cond, format...) (void)WARN_ONCE(cond, format)
@@ -48,6 +60,7 @@ void dump_mm(const struct mm_struct *mm)
 #define VM_BUG_ON_MM(cond, mm) VM_BUG_ON(cond)
 #define VM_WARN_ON(cond) BUILD_BUG_ON_INVALID(cond)
 #define VM_WARN_ON_ONCE(cond) BUILD_BUG_ON_INVALID(cond)
+#define VM_WARN_ON_ONCE_PAGE(cond, page)  BUILD_BUG_ON_INVALID(cond)
 #define VM_WARN_ONCE(cond, format...) BUILD_BUG_ON_INVALID(cond)
 #define VM_WARN(cond, format...) BUILD_BUG_ON_INVALID(cond)
 #endif
--- a/mm/memcontrol.c~mm-memcg-warning-on-memcg-after-readahead-page-charged
+++ a/mm/memcontrol.c
@@ -1322,10 +1322,8 @@ struct lruvec *mem_cgroup_page_lruvec(st
 	}
 
 	memcg = page->mem_cgroup;
-	/*
-	 * Swapcache readahead pages are added to the LRU - and
-	 * possibly migrated - before they are charged.
-	 */
+	/* Readahead page is charged too, to see if other page uncharged */
+	VM_WARN_ON_ONCE_PAGE(!memcg, page);
 	if (!memcg)
 		memcg = root_mem_cgroup;
 
@@ -6906,8 +6904,9 @@ void mem_cgroup_migrate(struct page *old
 	if (newpage->mem_cgroup)
 		return;
 
-	/* Swapcache readahead pages can get replaced before being charged */
 	memcg = oldpage->mem_cgroup;
+	/* Readahead page is charged too, to see if other page uncharged */
+	VM_WARN_ON_ONCE_PAGE(!memcg, oldpage);
 	if (!memcg)
 		return;
 
@@ -7104,7 +7103,8 @@ void mem_cgroup_swapout(struct page *pag
 
 	memcg = page->mem_cgroup;
 
-	/* Readahead page, never charged */
+	/* Readahead page is charged too, to see if other page uncharged */
+	VM_WARN_ON_ONCE_PAGE(!memcg, page);
 	if (!memcg)
 		return;
 
@@ -7168,7 +7168,8 @@ int mem_cgroup_try_charge_swap(struct pa
 
 	memcg = page->mem_cgroup;
 
-	/* Readahead page, never charged */
+	/* Readahead page is charged too, to see if other page uncharged */
+	VM_WARN_ON_ONCE_PAGE(!memcg, page);
 	if (!memcg)
 		return 0;
 
_

Patches currently in -mm which might be from alex.shi@linux.alibaba.com are

mm-memcg-warning-on-memcg-after-readahead-page-charged.patch
mm-memcg-remove-useless-check-on-page-mem_cgroup.patch
mm-thp-move-lru_add_page_tail-func-to-huge_memoryc.patch
mm-thp-clean-up-lru_add_page_tail.patch
mm-thp-remove-code-path-which-never-got-into.patch
mm-thp-narrow-lru-locking.patch

