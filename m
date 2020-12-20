Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CFDB6C3526C
	for <mm-commits@archiver.kernel.org>; Sun, 20 Dec 2020 02:58:25 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 971CC23AC1
	for <mm-commits@archiver.kernel.org>; Sun, 20 Dec 2020 02:58:25 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726882AbgLTC6M (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Sat, 19 Dec 2020 21:58:12 -0500
Received: from mail.kernel.org ([198.145.29.99]:54132 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726865AbgLTC6M (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Sat, 19 Dec 2020 21:58:12 -0500
Date:   Sat, 19 Dec 2020 18:57:31 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1608433051;
        bh=hKLnCOu0qVzAzA73ZGfE49qWMg23acDh/IzKicc54bI=;
        h=From:To:Subject:From;
        b=eDNyXvrhp4dUG2AB94+CWnrUtdDx2krIOCNK3DrIC5VipTls/st79lhle5nhjUcTF
         LmzGatHrqdjvW7Dv/KQBhjS1EyaizIayO1gMdz0xkIcXpsQOHF+AlcnIn6Frg0idDo
         zmcCa24JR/5IFexUoMY2Tuvsmhso+jECUbwGSlng=
From:   akpm@linux-foundation.org
To:     alex.shi@linux.alibaba.com, hannes@cmpxchg.org, hughd@google.com,
        mhocko@suse.com, mm-commits@vger.kernel.org, vdavydov.dev@gmail.com
Subject:  [merged]
 mm-memcg-warning-on-memcg-after-readahead-page-charged.patch removed from
 -mm tree
Message-ID: <20201220025731.ChX6X8Yyx%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/memcg: warning on !memcg after readahead page charged
has been removed from the -mm tree.  Its filename was
     mm-memcg-warning-on-memcg-after-readahead-page-charged.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Alex Shi <alex.shi@linux.alibaba.com>
Subject: mm/memcg: warning on !memcg after readahead page charged

Add VM_WARN_ON_ONCE_PAGE() macro.

Since readahead page is charged on memcg too, in theory we don't have to
check this exception now.  Before safely remove them all, add a warning
for the unexpected !memcg.

Link: https://lkml.kernel.org/r/1604283436-18880-3-git-send-email-alex.shi@linux.alibaba.com
Signed-off-by: Alex Shi <alex.shi@linux.alibaba.com>
Acked-by: Michal Hocko <mhocko@suse.com>
Acked-by: Hugh Dickins <hughd@google.com>
Acked-by: Johannes Weiner <hannes@cmpxchg.org>
Cc: Vladimir Davydov <vdavydov.dev@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/mmdebug.h |   13 +++++++++++++
 mm/memcontrol.c         |   10 ++++------
 2 files changed, 17 insertions(+), 6 deletions(-)

--- a/include/linux/mmdebug.h~mm-memcg-warning-on-memcg-after-readahead-page-charged
+++ a/include/linux/mmdebug.h
@@ -37,6 +37,18 @@ void dump_mm(const struct mm_struct *mm)
 			BUG();						\
 		}							\
 	} while (0)
+#define VM_WARN_ON_ONCE_PAGE(cond, page)	({			\
+	static bool __section(".data.once") __warned;			\
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
@@ -1362,10 +1362,7 @@ struct lruvec *mem_cgroup_page_lruvec(st
 	}
 
 	memcg = page_memcg(page);
-	/*
-	 * Swapcache readahead pages are added to the LRU - and
-	 * possibly migrated - before they are charged.
-	 */
+	VM_WARN_ON_ONCE_PAGE(!memcg, page);
 	if (!memcg)
 		memcg = root_mem_cgroup;
 
@@ -6987,6 +6984,7 @@ void mem_cgroup_migrate(struct page *old
 		return;
 
 	memcg = page_memcg(oldpage);
+	VM_WARN_ON_ONCE_PAGE(!memcg, oldpage);
 	if (!memcg)
 		return;
 
@@ -7186,7 +7184,7 @@ void mem_cgroup_swapout(struct page *pag
 
 	memcg = page_memcg(page);
 
-	/* Readahead page, never charged */
+	VM_WARN_ON_ONCE_PAGE(!memcg, page);
 	if (!memcg)
 		return;
 
@@ -7253,7 +7251,7 @@ int mem_cgroup_try_charge_swap(struct pa
 
 	memcg = page_memcg(page);
 
-	/* Readahead page, never charged */
+	VM_WARN_ON_ONCE_PAGE(!memcg, page);
 	if (!memcg)
 		return 0;
 
_

Patches currently in -mm which might be from alex.shi@linux.alibaba.com are

mm-vmscan-__isolate_lru_page_prepare-clean-up.patch

