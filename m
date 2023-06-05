Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 58CEBC77B73
	for <mm-commits@archiver.kernel.org>; Mon,  5 Jun 2023 21:48:58 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230207AbjFEVs5 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 5 Jun 2023 17:48:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52922 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233193AbjFEVss (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 5 Jun 2023 17:48:48 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 35839F9
        for <mm-commits@vger.kernel.org>; Mon,  5 Jun 2023 14:48:47 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id C558C615DC
        for <mm-commits@vger.kernel.org>; Mon,  5 Jun 2023 21:48:46 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1FDDAC4339B;
        Mon,  5 Jun 2023 21:48:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1686001726;
        bh=RNEIzCv+05bxFBju0P+I9xKTzSP7Hfpb9MbOiBxgG8A=;
        h=Date:To:From:Subject:From;
        b=JKG9r+orSEZqAgEcrCbWDz/SPriMx3jyDFds5oTPlzpRsl9P4MMvc3mCNCMICqUSN
         4xaANi2yZPfbPtFEt20PNHYlUyKIF/tD4d8pFy5gDtiExo0yGuSrjsqVPsANzDPr0y
         2SekvQC1HXBztImjLcCYtvCLL/eVIFNTMw1g0QtA=
Date:   Mon, 05 Jun 2023 14:48:45 -0700
To:     mm-commits@vger.kernel.org, songmuchun@bytedance.com,
        shakeelb@google.com, roman.gushchin@linux.dev, mhocko@kernel.org,
        hannes@cmpxchg.org, david@redhat.com, linmiaohe@huawei.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + memcg-use-helper-macro-flush_time.patch added to mm-unstable branch
Message-Id: <20230605214846.1FDDAC4339B@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: memcg: use helper macro FLUSH_TIME
has been added to the -mm mm-unstable branch.  Its filename is
     memcg-use-helper-macro-flush_time.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/memcg-use-helper-macro-flush_time.patch

This patch will later appear in the mm-unstable branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next via the mm-everything
branch at git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
and is updated there every 2-3 working days

------------------------------------------------------
From: Miaohe Lin <linmiaohe@huawei.com>
Subject: memcg: use helper macro FLUSH_TIME
Date: Sat, 3 Jun 2023 15:21:16 +0800

Use helper macro FLUSH_TIME to indicate the flush time to improve the
readability a bit. No functional change intended.

Link: https://lkml.kernel.org/r/20230603072116.1101690-1-linmiaohe@huawei.com
Signed-off-by: Miaohe Lin <linmiaohe@huawei.com>
Acked-by: Shakeel Butt <shakeelb@google.com>
Reviewed-by: Muchun Song <songmuchun@bytedance.com>
Reviewed-by: David Hildenbrand <david@redhat.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Michal Hocko <mhocko@kernel.org>
Cc: Roman Gushchin <roman.gushchin@linux.dev>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memcontrol.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/mm/memcontrol.c~memcg-use-helper-macro-flush_time
+++ a/mm/memcontrol.c
@@ -5428,7 +5428,7 @@ static int mem_cgroup_css_online(struct
 
 	if (unlikely(mem_cgroup_is_root(memcg)))
 		queue_delayed_work(system_unbound_wq, &stats_flush_dwork,
-				   2UL*HZ);
+				   FLUSH_TIME);
 	lru_gen_online_memcg(memcg);
 	return 0;
 offline_kmem:
_

Patches currently in -mm which might be from linmiaohe@huawei.com are

mm-remove-obsolete-alloc_migrate_target.patch
mm-page_alloc-remove-unneeded-header-files.patch
memcg-use-helper-macro-flush_time.patch

