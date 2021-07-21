Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 34347C6377A
	for <mm-commits@archiver.kernel.org>; Wed, 21 Jul 2021 20:50:48 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 1E97A61244
	for <mm-commits@archiver.kernel.org>; Wed, 21 Jul 2021 20:50:48 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230023AbhGUUKL (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 21 Jul 2021 16:10:11 -0400
Received: from mail.kernel.org ([198.145.29.99]:58960 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229976AbhGUUKL (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Wed, 21 Jul 2021 16:10:11 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 7FF9960FEA;
        Wed, 21 Jul 2021 20:50:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1626900646;
        bh=CVGHgroSQJdS9ufMz7HFjdNzt+eZeGr69Tfx+p7hgb0=;
        h=Date:From:To:Subject:From;
        b=nKp9uFpHuSg8yC/f6wUzfXt0SqHeGkBFbmzdH+bHct4ELFZBODIKgm5No1Uzi9Cut
         NtCyQZvEsFnOY1Den7ltV+DPzHwh48877q3LOgzXiwstOthDlmiYdfFrYgYezQVFMm
         PD1BrxD0KVQkyYQ1oKguHcvDl7dd/a155RBAzyxM=
Date:   Wed, 21 Jul 2021 13:50:44 -0700
From:   akpm@linux-foundation.org
To:     mm-commits@vger.kernel.org, ziy@nvidia.com, ying.huang@intel.com,
        yang.shi@linux.alibaba.com, weixugc@google.com,
        shy828301@gmail.com, rientjes@google.com, osalvador@suse.de,
        mhocko@suse.com, kbusch@kernel.org, gthelen@google.com,
        david@redhat.com, dan.j.williams@intel.com,
        dave.hansen@linux.intel.com
Subject:  +
 mm-vmscan-add-helper-for-querying-ability-to-age-anonymous-pages-v11.patch
 added to -mm tree
Message-ID: <20210721205044.x3uK_%akpm@linux-foundation.org>
User-Agent: s-nail v14.9.10
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm-vmscan-add-helper-for-querying-ability-to-age-anonymous-pages-v11
has been added to the -mm tree.  Its filename is
     mm-vmscan-add-helper-for-querying-ability-to-age-anonymous-pages-v11.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/mm-vmscan-add-helper-for-querying-ability-to-age-anonymous-pages-v11.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/mm-vmscan-add-helper-for-querying-ability-to-age-anonymous-pages-v11.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Dave Hansen <dave.hansen@linux.intel.com>
Subject: mm-vmscan-add-helper-for-querying-ability-to-age-anonymous-pages-v11

Rename can_demote_anon_pages() to can_demote() to reflect the fact that
the function is for anon and file pages.

Link: https://lkml.kernel.org/r/20210715055145.195411-7-ying.huang@intel.com
Link: https://lkml.kernel.org/r/20210721063926.3024591-6-ying.huang@intel.com
Signed-off-by: Dave Hansen <dave.hansen@linux.intel.com>
Signed-off-by: "Huang, Ying" <ying.huang@intel.com>
Reviewed-by: Yang Shi <shy828301@gmail.com>
Reviewed-by: Greg Thelen <gthelen@google.com>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Wei Xu <weixugc@google.com>
Cc: Oscar Salvador <osalvador@suse.de>
Cc: Zi Yan <ziy@nvidia.com>
Cc: David Rientjes <rientjes@google.com>
Cc: Dan Williams <dan.j.williams@intel.com>
Cc: David Hildenbrand <david@redhat.com>
Cc: Keith Busch <kbusch@kernel.org>
Cc: Yang Shi <yang.shi@linux.alibaba.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/vmscan.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/mm/vmscan.c~mm-vmscan-add-helper-for-querying-ability-to-age-anonymous-pages-v11
+++ a/mm/vmscan.c
@@ -2742,7 +2742,7 @@ static bool can_age_anon_pages(struct pg
 		return true;
 
 	/* Also valuable if anon pages can be demoted: */
-	return can_demote_anon_pages(pgdat->node_id, sc);
+	return can_demote(pgdat->node_id, sc);
 }
 
 static void shrink_lruvec(struct lruvec *lruvec, struct scan_control *sc)
_

Patches currently in -mm which might be from dave.hansen@linux.intel.com are

mm-numa-automatically-generate-node-migration-order.patch
mm-migrate-update-node-demotion-order-on-hotplug-events.patch
mm-migrate-demote-pages-during-reclaim.patch
mm-migrate-demote-pages-during-reclaim-v11.patch
mm-vmscan-add-helper-for-querying-ability-to-age-anonymous-pages.patch
mm-vmscan-add-helper-for-querying-ability-to-age-anonymous-pages-v11.patch
mm-vmscan-never-demote-for-memcg-reclaim.patch
mm-mempolicy-add-mpol_preferred_many-for-multiple-preferred-nodes.patch

