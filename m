Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C3BD6C56202
	for <mm-commits@archiver.kernel.org>; Wed, 25 Nov 2020 22:44:00 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 5D394206B5
	for <mm-commits@archiver.kernel.org>; Wed, 25 Nov 2020 22:44:00 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="Nmz5V6b/"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725836AbgKYWno (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 25 Nov 2020 17:43:44 -0500
Received: from mail.kernel.org ([198.145.29.99]:57930 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727666AbgKYWno (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Wed, 25 Nov 2020 17:43:44 -0500
Received: from localhost.localdomain (c-73-231-172-41.hsd1.ca.comcast.net [73.231.172.41])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id E5E0A206B5;
        Wed, 25 Nov 2020 22:43:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1606344223;
        bh=nM6gEh8fLzuj1gjaSKHEe/u00nHFlQySp6gT5Eiaf7A=;
        h=Date:From:To:Subject:From;
        b=Nmz5V6b/85NQD9A/NbkuZ4h8QUULqcdiqSgB/54OOTqgik//KzCQmogr9KkOT2pZY
         Im13P7S0zTYGkOSUz3ShVI8DBQ9HoK2D2wyog+mLEQh/gyBIoDXxlqKZYYoj7erUJf
         oYKGD4kD2TrfTTeEWgNlXc9s4HlojItaHCOEiN30=
Date:   Wed, 25 Nov 2020 14:43:42 -0800
From:   akpm@linux-foundation.org
To:     alex.shi@linux.alibaba.com, alexander.h.duyck@linux.intel.com,
        guro@fb.com, hannes@cmpxchg.org, laoar.shao@gmail.com,
        lstoakes@gmail.com, mhocko@suse.com, mm-commits@vger.kernel.org,
        richard.weiyang@gmail.com, sfr@canb.auug.org.au, sh_def@163.com,
        shakeelb@google.com
Subject:  +
 mm-memcontrol-rewrite-mem_cgroup_page_lruvec-fix-fix.patch added to -mm
 tree
Message-ID: <20201125224342.vCv8cULJt%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/memcg: warn on missing memcg on mem_cgroup_page_lruvec()
has been added to the -mm tree.  Its filename is
     mm-memcontrol-rewrite-mem_cgroup_page_lruvec-fix-fix.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/mm-memcontrol-rewrite-mem_cgroup_page_lruvec-fix-fix.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/mm-memcontrol-rewrite-mem_cgroup_page_lruvec-fix-fix.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Lorenzo Stoakes <lstoakes@gmail.com>
Subject: mm/memcg: warn on missing memcg on mem_cgroup_page_lruvec()

Move memcg check to mem_cgroup_page_lruvec() as there are callers which
may invoke this with !memcg in mem_cgroup_lruvec(), whereas they should
not in mem_cgroup_page_lruvec().

We expect that we have always charged a page to the memcg before
mem_cgroup_page_lruvec() is invoked, so add a warning to assert that this
is the case.

Link: https://lkml.kernel.org/r/20201125112202.387009-1-lstoakes@gmail.com
Signed-off-by: Lorenzo Stoakes <lstoakes@gmail.com>
Reported-by: syzbot+ce635500093181f39c1c@syzkaller.appspotmail.com
Acked-by: Alex Shi <alex.shi@linux.alibaba.com>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Shakeel Butt <shakeelb@google.com>
Cc: Roman Gushchin <guro@fb.com>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Yafang Shao <laoar.shao@gmail.com>
Cc: Alexander Duyck <alexander.h.duyck@linux.intel.com>
Cc: Hui Su <sh_def@163.com>
Cc: Wei Yang <richard.weiyang@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/memcontrol.h |    6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

--- a/include/linux/memcontrol.h~mm-memcontrol-rewrite-mem_cgroup_page_lruvec-fix-fix
+++ a/include/linux/memcontrol.h
@@ -618,7 +618,6 @@ static inline struct lruvec *mem_cgroup_
 		goto out;
 	}
 
-	VM_WARN_ON_ONCE(!memcg);
 	if (!memcg)
 		memcg = root_mem_cgroup;
 
@@ -645,7 +644,10 @@ out:
 static inline struct lruvec *mem_cgroup_page_lruvec(struct page *page,
 						struct pglist_data *pgdat)
 {
-	return mem_cgroup_lruvec(page_memcg(page), pgdat);
+	struct mem_cgroup *memcg = page_memcg(page);
+
+	VM_WARN_ON_ONCE_PAGE(!memcg, page);
+	return mem_cgroup_lruvec(memcg, pgdat);
 }
 
 static inline bool lruvec_holds_page_lru_lock(struct page *page,
_

Patches currently in -mm which might be from lstoakes@gmail.com are

mm-memcontrol-rewrite-mem_cgroup_page_lruvec-fix-fix.patch

