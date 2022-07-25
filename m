Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2B87DC43334
	for <mm-commits@archiver.kernel.org>; Mon, 25 Jul 2022 19:48:01 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235337AbiGYTsA (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 25 Jul 2022 15:48:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57462 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234254AbiGYTr7 (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 25 Jul 2022 15:47:59 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 05F471F2FB
        for <mm-commits@vger.kernel.org>; Mon, 25 Jul 2022 12:47:59 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 97FF66106D
        for <mm-commits@vger.kernel.org>; Mon, 25 Jul 2022 19:47:58 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E917AC341C6;
        Mon, 25 Jul 2022 19:47:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1658778478;
        bh=SZi0DID4SY393/mjyap1nseRhUq7fbXr3x45cgF1JOM=;
        h=Date:To:From:Subject:From;
        b=NyHy4pSTCKaGJjHDc74JKvafmHtVo47h3axysY3szjmXO9xc8n7s8y+0d89jQi5VY
         bs68qs4XwGRkI09nuUFy+MDwKvR1/XWY3Y5f/W1P/+DcjiwbylPvJPEEp63QajqUqL
         qXEaz/+zwRox1tK9HqyM8+d7IZeFiPKA3SL9R9go=
Date:   Mon, 25 Jul 2022 12:47:57 -0700
To:     mm-commits@vger.kernel.org, willy@infradead.org, vbabka@suse.cz,
        surenb@google.com, songmuchun@bytedance.com, shakeelb@google.com,
        roman.gushchin@linux.dev, peterx@redhat.com, neilb@suse.de,
        mhocko@suse.com, linmiaohe@huawei.com, hannes@cmpxchg.org,
        david@redhat.com, apopple@nvidia.com, yosryahmed@google.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-vmpressure-dont-count-proactive-reclaim-in-vmpressure-v5.patch added to mm-unstable branch
Message-Id: <20220725194757.E917AC341C6@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm-vmpressure-dont-count-proactive-reclaim-in-vmpressure-v5
has been added to the -mm mm-unstable branch.  Its filename is
     mm-vmpressure-dont-count-proactive-reclaim-in-vmpressure-v5.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-vmpressure-dont-count-proactive-reclaim-in-vmpressure-v5.patch

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
From: Yosry Ahmed <yosryahmed@google.com>
Subject: mm-vmpressure-dont-count-proactive-reclaim-in-vmpressure-v5
Date: Thu, 21 Jul 2022 17:30:15 +0000

update documentation

Link: https://lkml.kernel.org/r/20220721173015.2643248-1-yosryahmed@google.com
Signed-off-by: Yosry Ahmed <yosryahmed@google.com>
Cc: Alistair Popple <apopple@nvidia.com>
Cc: David Hildenbrand <david@redhat.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Matthew Wilcox <willy@infradead.org>
Cc: Miaohe Lin <linmiaohe@huawei.com>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Muchun Song <songmuchun@bytedance.com>
Cc: NeilBrown <neilb@suse.de>
Cc: Peter Xu <peterx@redhat.com>
Cc: Roman Gushchin <roman.gushchin@linux.dev>
Cc: Shakeel Butt <shakeelb@google.com>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: Vlastimil Babka <vbabka@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/admin-guide/cgroup-v2.rst |    7 +++++++
 1 file changed, 7 insertions(+)

--- a/Documentation/admin-guide/cgroup-v2.rst~mm-vmpressure-dont-count-proactive-reclaim-in-vmpressure-v5
+++ a/Documentation/admin-guide/cgroup-v2.rst
@@ -1229,6 +1229,13 @@ PAGE_SIZE multiple when read back.
 	the target cgroup. If less bytes are reclaimed than the
 	specified amount, -EAGAIN is returned.
 
+	Please note that the proactive reclaim (triggered by this
+	interface) is not meant to indicate memory pressure on the
+	memory cgroup. Therefore socket memory balancing triggered by
+	the memory reclaim normally is not exercised in this case.
+	This means that the networking layer will not adapt based on
+	reclaim induced by memory.reclaim.
+
   memory.peak
 	A read-only single value file which exists on non-root
 	cgroups.
_

Patches currently in -mm which might be from yosryahmed@google.com are

mm-vmpressure-dont-count-proactive-reclaim-in-vmpressure.patch
mm-vmpressure-dont-count-proactive-reclaim-in-vmpressure-v5.patch

