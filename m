Return-Path: <SRS0=vJaG=CJ=vger.kernel.org=mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.0 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 31B4BC433E2
	for <mm-commits@archiver.kernel.org>; Mon, 31 Aug 2020 01:30:25 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 069DF20DD4
	for <mm-commits@archiver.kernel.org>; Mon, 31 Aug 2020 01:30:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1598837425;
	bh=AepLjBaN7j3jTuhrGVmf3LK0cOvYlL0KIpA8DQRBBh4=;
	h=Date:From:To:Subject:Reply-To:List-ID:From;
	b=SlkT5E7ZjGsSuDeg6Ccv+DZoM14Q4XNzjhjkWhSct+QekukXM+oEyzyX54a1Jf5OU
	 RMmm4sIwJya9hvq7UeqwwrUdEz8EI35OAVjQTstvfe90CSs2mpstF01o2phqJN/Xtj
	 YzSjzK6/IZ91UNFfXz1IeK4D/rdKtR3P/VgHMOgM=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727780AbgHaBaV (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Sun, 30 Aug 2020 21:30:21 -0400
Received: from mail.kernel.org ([198.145.29.99]:56434 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727783AbgHaBaT (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Sun, 30 Aug 2020 21:30:19 -0400
Received: from X1 (unknown [65.49.58.28])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id E9D7920DD4;
        Mon, 31 Aug 2020 01:30:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1598837419;
        bh=AepLjBaN7j3jTuhrGVmf3LK0cOvYlL0KIpA8DQRBBh4=;
        h=Date:From:To:Subject:From;
        b=ckbxJ272dL9074Oa9c9djLgGQgg/C8doRdUycRkPPwu/ktq5by/GsxeDSR5iMsqM1
         m6o9qnIX5UFFUIFHMqpDETz8OGJjpopNzArEDpOIrzMSdGjimMXx/DSzI8+S3ksc55
         zy5HkqYTX9QnrK6U/6mZM/hxQBztovBrhSaYmSHU=
Date:   Sun, 30 Aug 2020 18:30:18 -0700
From:   akpm@linux-foundation.org
To:     mm-commits@vger.kernel.org, shakeelb@google.com,
        mike.kravetz@oracle.com, mhocko@suse.com, hannes@cmpxchg.org,
        cai@lca.pw, alex.shi@linux.alibaba.com, hughd@google.com
Subject:  + mm-migration-of-hugetlbfs-page-skip-memcg.patch added to
 -mm tree
Message-ID: <20200831013018.dHj8n%akpm@linux-foundation.org>
User-Agent: s-nail v14.9.10
Sender: mm-commits-owner@vger.kernel.org
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm: migration of hugetlbfs page skip memcg
has been added to the -mm tree.  Its filename is
     mm-migration-of-hugetlbfs-page-skip-memcg.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-migration-of-hugetlbfs-page-skip-memcg.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-migration-of-hugetlbfs-page-skip-memcg.patch

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
Subject: mm: migration of hugetlbfs page skip memcg

hugetlbfs pages do not participate in memcg: so although they do find most
of migrate_page_states() useful, it would be better if they did not call
into mem_cgroup_migrate() - where Qian Cai reported that LTP's
move_pages12 triggers the warning in Alex Shi's prospective commit
"mm/memcg: warning on !memcg after readahead page charged".

Link: http://lkml.kernel.org/r/alpine.LSU.2.11.2008301359460.5954@eggly.anvils
Signed-off-by: Hugh Dickins <hughd@google.com>
Cc: Alex Shi <alex.shi@linux.alibaba.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Mike Kravetz <mike.kravetz@oracle.com>
Cc: Qian Cai <cai@lca.pw>
Cc: Shakeel Butt <shakeelb@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/migrate.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/mm/migrate.c~mm-migration-of-hugetlbfs-page-skip-memcg
+++ a/mm/migrate.c
@@ -668,7 +668,8 @@ void migrate_page_states(struct page *ne
 
 	copy_page_owner(page, newpage);
 
-	mem_cgroup_migrate(page, newpage);
+	if (!PageHuge(page))
+		mem_cgroup_migrate(page, newpage);
 }
 EXPORT_SYMBOL(migrate_page_states);
 
_

Patches currently in -mm which might be from hughd@google.com are

ksm-reinstate-memcg-charge-on-copied-pages.patch
mm-migration-of-hugetlbfs-page-skip-memcg.patch
shmem-shmem_writepage-split-unlikely-i915-thp.patch
mm-fix-check_move_unevictable_pages-on-thp.patch
mlock-fix-unevictable_pgs-event-counts-on-thp.patch

