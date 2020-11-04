Return-Path: <SRS0=Jp7A=EK=vger.kernel.org=mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AA015C388F2
	for <mm-commits@archiver.kernel.org>; Wed,  4 Nov 2020 03:04:15 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 7241A223FB
	for <mm-commits@archiver.kernel.org>; Wed,  4 Nov 2020 03:04:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1604459055;
	bh=D4z0GHUzSVzy/tRoA6QhUS9W5omZ4Yrof5aelO0r3HM=;
	h=Date:From:To:Subject:Reply-To:List-ID:From;
	b=MlxM3HK+9BWFCUbew1fB0KCg4YGzukICdt2G47MKqAMXd8NLoAJlna2dAdTL9RAjY
	 VRTBW6kC/yovZ2PZL3feRMxx9ERhD0wo1i0V0z+M9sp6HrNkRaLTmRgF9B4gwRqDAK
	 jFUwTgaq3yWvxC4xF1I1Kfeb5X8uzlqUEVXbgpxY=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729801AbgKDDEP (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 3 Nov 2020 22:04:15 -0500
Received: from mail.kernel.org ([198.145.29.99]:48016 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728972AbgKDDEO (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Tue, 3 Nov 2020 22:04:14 -0500
Received: from X1 (unknown [208.106.6.120])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id A06E9223BF;
        Wed,  4 Nov 2020 03:04:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1604459053;
        bh=D4z0GHUzSVzy/tRoA6QhUS9W5omZ4Yrof5aelO0r3HM=;
        h=Date:From:To:Subject:From;
        b=uJZjKJBL534ZjnUBIt0nDkZy6D/KfoDpYydPaSXe5xBoTfDr78LfbmLpb9tn6nCKO
         Kz/sVoFOy2R0XsArdLuj9OfLeDCuY0eHy+2vtMnoStyJA6vgyPE6UqXec6JkPTYIUB
         HH4bNka8rd61WKLutDw4paF8vX0mF4czJmg58+SI=
Date:   Tue, 03 Nov 2020 19:04:10 -0800
From:   akpm@linux-foundation.org
To:     mm-commits@vger.kernel.org, vdavydov.dev@gmail.com,
        mhocko@suse.com, hughd@google.com, hannes@cmpxchg.org,
        alex.shi@linux.alibaba.com
Subject:  +
 mm-memcg-warning-on-memcg-after-readahead-page-charged.patch added to -mm
 tree
Message-ID: <20201104030410.L_EwI%akpm@linux-foundation.org>
User-Agent: s-nail v14.9.10
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/memcg: warning on !memcg after readahead page charged
has been added to the -mm tree.  Its filename is
     mm-memcg-warning-on-memcg-after-readahead-page-charged.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/mm-memcg-warning-on-memcg-after-readahead-page-charged.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/mm-memcg-warning-on-memcg-after-readahead-page-charged.patch

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
@@ -1325,10 +1325,7 @@ struct lruvec *mem_cgroup_page_lruvec(st
 	}
 
 	memcg = page_memcg(page);
-	/*
-	 * Swapcache readahead pages are added to the LRU - and
-	 * possibly migrated - before they are charged.
-	 */
+	VM_WARN_ON_ONCE_PAGE(!memcg, page);
 	if (!memcg)
 		memcg = root_mem_cgroup;
 
@@ -6966,6 +6963,7 @@ void mem_cgroup_migrate(struct page *old
 
 	/* Swapcache readahead pages can get replaced before being charged */
 	memcg = page_memcg(oldpage);
+	VM_WARN_ON_ONCE_PAGE(!memcg, oldpage);
 	if (!memcg)
 		return;
 
@@ -7165,7 +7163,7 @@ void mem_cgroup_swapout(struct page *pag
 
 	memcg = page_memcg(page);
 
-	/* Readahead page, never charged */
+	VM_WARN_ON_ONCE_PAGE(!memcg, page);
 	if (!memcg)
 		return;
 
@@ -7232,7 +7230,7 @@ int mem_cgroup_try_charge_swap(struct pa
 
 	memcg = page_memcg(page);
 
-	/* Readahead page, never charged */
+	VM_WARN_ON_ONCE_PAGE(!memcg, page);
 	if (!memcg)
 		return 0;
 
_

Patches currently in -mm which might be from alex.shi@linux.alibaba.com are

mm-memcg-bail-early-from-swap-accounting-if-memcg-disabled.patch
mm-memcg-warning-on-memcg-after-readahead-page-charged.patch

