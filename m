Return-Path: <SRS0=vJaG=CJ=vger.kernel.org=mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.0 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 48FB2C433E2
	for <mm-commits@archiver.kernel.org>; Mon, 31 Aug 2020 01:30:39 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 2767620DD4
	for <mm-commits@archiver.kernel.org>; Mon, 31 Aug 2020 01:30:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1598837439;
	bh=cXWxrjDOhBQVT3Bc2AFhoTyEYoX+B7Tjq4GFOymmzH4=;
	h=Date:From:To:Subject:Reply-To:List-ID:From;
	b=So6CBPkRwDoXYgQzObx4ZpUbcDLkn77qVcB4PM9gY9MWDNZr0qcaf6WNtwrTlQUyO
	 YgTeg+8MqLelk3pPUzu7n0oDGbaYN3hjXKZMruOP3TXOPiPTnNMt/r5hgWla9bE4oL
	 YkkalGtvOhi8TdVGy4Euan4GCIgOFhZwggdOzGE0=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727781AbgHaBah (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Sun, 30 Aug 2020 21:30:37 -0400
Received: from mail.kernel.org ([198.145.29.99]:56812 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727806AbgHaBa0 (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Sun, 30 Aug 2020 21:30:26 -0400
Received: from X1 (unknown [65.49.58.28])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id EE19B2083E;
        Mon, 31 Aug 2020 01:30:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1598837425;
        bh=cXWxrjDOhBQVT3Bc2AFhoTyEYoX+B7Tjq4GFOymmzH4=;
        h=Date:From:To:Subject:From;
        b=C6weKJwwrmkTfGjh4dq9KBePKF+1GA0kE0JAd6GL14C2eUxYHd2h9msnP9LSOONKv
         G8ubLNE3pXlQFhyP3EylY0EpJ3QioPVWL5UMLYBuHkfFNAh/ldJgyVU0qEBmUH4r35
         ssOQOf8sOt9onUpM+727Wlw/decopWnk9BhwhDvE=
Date:   Sun, 30 Aug 2020 18:30:24 -0700
From:   akpm@linux-foundation.org
To:     mm-commits@vger.kernel.org, shakeelb@google.com,
        mike.kravetz@oracle.com, mhocko@suse.com, hannes@cmpxchg.org,
        cai@lca.pw, alex.shi@linux.alibaba.com, hughd@google.com
Subject:  + mm-fix-check_move_unevictable_pages-on-thp.patch added to
 -mm tree
Message-ID: <20200831013024.jPs3o%akpm@linux-foundation.org>
User-Agent: s-nail v14.9.10
Sender: mm-commits-owner@vger.kernel.org
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm: fix check_move_unevictable_pages() on THP
has been added to the -mm tree.  Its filename is
     mm-fix-check_move_unevictable_pages-on-thp.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-fix-check_move_unevictable_pages-on-thp.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-fix-check_move_unevictable_pages-on-thp.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Hugh Dickins <hughd@google.com>
Subject: mm: fix check_move_unevictable_pages() on THP

check_move_unevictable_pages() is used in making unevictable shmem pages
evictable: by shmem_unlock_mapping(), drm_gem_check_release_pagevec() and
i915/gem check_release_pagevec().  Those may pass down subpages of a huge
page, when /sys/kernel/mm/transparent_hugepage/shmem_enabled is "force".

That does not crash or warn at present, but the accounting of vmstats
unevictable_pgs_scanned and unevictable_pgs_rescued is inconsistent:
scanned being incremented on each subpage, rescued only on the head (since
tails already appear evictable once the head has been updated).

5.8 commit 5d91f31faf8e ("mm: swap: fix vmstats for huge page") has
established that vm_events in general (and unevictable_pgs_rescued in
particular) should count every subpage: so follow that precedent here.

Do this in such a way that if mem_cgroup_page_lruvec() is made stricter
(to check page->mem_cgroup is always set), no problem: skip the tails
before calling it, and add thp_nr_pages() to vmstats on the head.

Link: http://lkml.kernel.org/r/alpine.LSU.2.11.2008301405000.5954@eggly.anvils
Signed-off-by: Hugh Dickins <hughd@google.com>
Cc: Alex Shi <alex.shi@linux.alibaba.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Mike Kravetz <mike.kravetz@oracle.com>
Cc: Qian Cai <cai@lca.pw>
Cc: Shakeel Butt <shakeelb@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/vmscan.c |   10 ++++++++--
 1 file changed, 8 insertions(+), 2 deletions(-)

--- a/mm/vmscan.c~mm-fix-check_move_unevictable_pages-on-thp
+++ a/mm/vmscan.c
@@ -4268,8 +4268,14 @@ void check_move_unevictable_pages(struct
 	for (i = 0; i < pvec->nr; i++) {
 		struct page *page = pvec->pages[i];
 		struct pglist_data *pagepgdat = page_pgdat(page);
+		int nr_pages;
+
+		if (PageTransTail(page))
+			continue;
+
+		nr_pages = thp_nr_pages(page);
+		pgscanned += nr_pages;
 
-		pgscanned++;
 		if (pagepgdat != pgdat) {
 			if (pgdat)
 				spin_unlock_irq(&pgdat->lru_lock);
@@ -4288,7 +4294,7 @@ void check_move_unevictable_pages(struct
 			ClearPageUnevictable(page);
 			del_page_from_lru_list(page, lruvec, LRU_UNEVICTABLE);
 			add_page_to_lru_list(page, lruvec, lru);
-			pgrescued++;
+			pgrescued += nr_pages;
 		}
 	}
 
_

Patches currently in -mm which might be from hughd@google.com are

ksm-reinstate-memcg-charge-on-copied-pages.patch
mm-migration-of-hugetlbfs-page-skip-memcg.patch
shmem-shmem_writepage-split-unlikely-i915-thp.patch
mm-fix-check_move_unevictable_pages-on-thp.patch
mlock-fix-unevictable_pgs-event-counts-on-thp.patch

