Return-Path: <SRS0=oQto=CZ=vger.kernel.org=mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.7 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0C7C4C433E2
	for <mm-commits@archiver.kernel.org>; Wed, 16 Sep 2020 22:58:44 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id A3C64221F1
	for <mm-commits@archiver.kernel.org>; Wed, 16 Sep 2020 22:58:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1600297123;
	bh=mBeFXXlbnSR9B79YuiyR0EAkpjO6zJsKXCBlx3R3LaI=;
	h=Date:From:To:Subject:Reply-To:List-ID:From;
	b=IRXZVDzqyvdeRtLiOWz+5fpuZ6C0T4mUOAQW6Uz5e1C+zhvwZc/cdybTmP6Ofm3o8
	 Rlg5w45pcZ6hICOMk/cWlKxn1PmBshI/rAKq0ibzEyChCBOZy2PNgFH33jtWzNOugn
	 +5qPMbVIK6kwrHHcL3aFFSjQCl66/RgxQmm48PFo=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726285AbgIPW6n (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 16 Sep 2020 18:58:43 -0400
Received: from mail.kernel.org ([198.145.29.99]:59916 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726174AbgIPW6m (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Wed, 16 Sep 2020 18:58:42 -0400
Received: from X1 (unknown [67.22.170.76])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 464152083B;
        Wed, 16 Sep 2020 22:58:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1600297121;
        bh=mBeFXXlbnSR9B79YuiyR0EAkpjO6zJsKXCBlx3R3LaI=;
        h=Date:From:To:Subject:From;
        b=ml6a/vMkIStFmxd2P5AWSdEloWfeQy2FhQR/Wvq1M4geRpD69d0b1j6rU6v4GUK/q
         78pp/mudw1YfuMiqcyd9awqs6zzZd2KlowOBLOGJH+nWL5doW5XEc+tkifPfzH4SEE
         R1htSCxHUBnkM8hH9fZvld3SN3XGl6MJwY2PesX4=
Date:   Wed, 16 Sep 2020 15:58:40 -0700
From:   akpm@linux-foundation.org
To:     mm-commits@vger.kernel.org, vdavydov.dev@gmail.com, vbabka@suse.cz,
        tj@kernel.org, shakeelb@google.com, rdunlap@infradead.org,
        mhocko@kernel.org, lizefan@huawei.com, iamjoonsoo.kim@lge.com,
        hannes@cmpxchg.org, guro@fb.com, corbet@lwn.net,
        songmuchun@bytedance.com
Subject:  +
 mm-memcontrol-fix-missing-suffix-of-workingset_restore.patch added to -mm
 tree
Message-ID: <20200916225840.xs5iO%akpm@linux-foundation.org>
User-Agent: s-nail v14.9.10
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm: memcontrol: fix missing suffix of workingset_restore
has been added to the -mm tree.  Its filename is
     mm-memcontrol-fix-missing-suffix-of-workingset_restore.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/mm-memcontrol-fix-missing-suffix-of-workingset_restore.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/mm-memcontrol-fix-missing-suffix-of-workingset_restore.patch

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
Subject: mm: memcontrol: fix missing suffix of workingset_restore

We forget to add the suffix to the workingset_restore string, so fix it. 
And also update the documentation of cgroup-v2.rst.

Link: https://lkml.kernel.org/r/20200916100030.71698-1-songmuchun@bytedance.com
Fixes: 170b04b7ae49 ("mm/workingset: prepare the workingset detection infrastructure for anon LRU")
Signed-off-by: Muchun Song <songmuchun@bytedance.com>
Reviewed-by: Shakeel Butt <shakeelb@google.com>
Cc: Joonsoo Kim <iamjoonsoo.kim@lge.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Vlastimil Babka <vbabka@suse.cz>
Cc: Tejun Heo <tj@kernel.org>
Cc: Zefan Li <lizefan@huawei.com>
Cc: Jonathan Corbet <corbet@lwn.net>
Cc: Michal Hocko <mhocko@kernel.org>
Cc: Vladimir Davydov <vdavydov.dev@gmail.com>
Cc: Roman Gushchin <guro@fb.com>
Cc: Randy Dunlap <rdunlap@infradead.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/admin-guide/cgroup-v2.rst |   25 +++++++++++++++-------
 mm/memcontrol.c                         |    4 +--
 2 files changed, 20 insertions(+), 9 deletions(-)

--- a/Documentation/admin-guide/cgroup-v2.rst~mm-memcontrol-fix-missing-suffix-of-workingset_restore
+++ a/Documentation/admin-guide/cgroup-v2.rst
@@ -1324,15 +1324,26 @@ PAGE_SIZE multiple when read back.
 	  pgmajfault
 		Number of major page faults incurred
 
-	  workingset_refault
-		Number of refaults of previously evicted pages
+	  workingset_refault_anon
+		Number of refaults of previously evicted anonymous pages.
 
-	  workingset_activate
-		Number of refaulted pages that were immediately activated
+	  workingset_refault_file
+		Number of refaults of previously evicted file pages.
 
-	  workingset_restore
-		Number of restored pages which have been detected as an active
-		workingset before they got reclaimed.
+	  workingset_activate_anon
+		Number of refaulted anonymous pages that were immediately
+		activated.
+
+	  workingset_activate_file
+		Number of refaulted file pages that were immediately activated.
+
+	  workingset_restore_anon
+		Number of restored anonymous pages which have been detected as
+		an active workingset before they got reclaimed.
+
+	  workingset_restore_file
+		Number of restored file pages which have been detected as an
+		active workingset before they got reclaimed.
 
 	  workingset_nodereclaim
 		Number of times a shadow node has been reclaimed
--- a/mm/memcontrol.c~mm-memcontrol-fix-missing-suffix-of-workingset_restore
+++ a/mm/memcontrol.c
@@ -1538,9 +1538,9 @@ static char *memory_stat_format(struct m
 		       memcg_page_state(memcg, WORKINGSET_ACTIVATE_ANON));
 	seq_buf_printf(&s, "workingset_activate_file %lu\n",
 		       memcg_page_state(memcg, WORKINGSET_ACTIVATE_FILE));
-	seq_buf_printf(&s, "workingset_restore %lu\n",
+	seq_buf_printf(&s, "workingset_restore_anon %lu\n",
 		       memcg_page_state(memcg, WORKINGSET_RESTORE_ANON));
-	seq_buf_printf(&s, "workingset_restore %lu\n",
+	seq_buf_printf(&s, "workingset_restore_file %lu\n",
 		       memcg_page_state(memcg, WORKINGSET_RESTORE_FILE));
 	seq_buf_printf(&s, "workingset_nodereclaim %lu\n",
 		       memcg_page_state(memcg, WORKINGSET_NODERECLAIM));
_

Patches currently in -mm which might be from songmuchun@bytedance.com are

kprobes-fix-kill-kprobe-which-has-been-marked-as-gone.patch
mm-memcontrol-fix-missing-suffix-of-workingset_restore.patch
mm-memcontrol-add-the-missing-numa_stat-interface-for-cgroup-v2.patch
mm-memcontrol-add-the-missing-numa_stat-interface-for-cgroup-v2-v3.patch
mm-memcontrol-fix-out-of-bounds-on-the-buf-returned-by-memory_stat_format.patch
mmhwpoison-refactor-soft_offline_huge_page-and-__soft_offline_page-fix-2.patch

