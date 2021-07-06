Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AC9B4C07E9B
	for <mm-commits@archiver.kernel.org>; Tue,  6 Jul 2021 19:20:59 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 962A561CA2
	for <mm-commits@archiver.kernel.org>; Tue,  6 Jul 2021 19:20:59 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231792AbhGFTXh (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 6 Jul 2021 15:23:37 -0400
Received: from mail.kernel.org ([198.145.29.99]:57260 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231696AbhGFTXh (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Tue, 6 Jul 2021 15:23:37 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 97DA961C9A;
        Tue,  6 Jul 2021 19:20:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1625599258;
        bh=lKyd8YpAi8azvXROkrCf9CQ+JEsFyG8E8c44o42187M=;
        h=Date:From:To:Subject:From;
        b=WAeVzNiAcBq+1PnJB+tHxJaOhkJs0sz5HL6vXCdquULMbB+av8XnffaNqy5hhWo31
         pl7y78BeOV0nZLz5ityUk5fxMHbyODWoytNLuWib0Gy5mG06bhYREADtVuujANhBVI
         VmCOjDlL0EC2wqaLoee3irWUGOl51sG4o1P5ekm8=
Date:   Tue, 06 Jul 2021 12:20:58 -0700
From:   akpm@linux-foundation.org
To:     chris@chrisdown.name, david@redhat.com, ddstreet@ieee.org,
        mgorman@techsingularity.net, mhocko@kernel.org,
        mm-commits@vger.kernel.org, shy828301@gmail.com, vbabka@suse.cz
Subject:  [merged]
 =?US-ASCII?Q?mm-memcontrolc-fix-kerneldoc-comment-for-mem=5Fcgroup=5Fca?=
 =?US-ASCII?Q?lculate=5Fprotection.patch?= removed from -mm tree
Message-ID: <20210706192058.NfOrPiCyN%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/memcontrol.c: fix kerneldoc comment for mem_cgroup_calculate_protection
has been removed from the -mm tree.  Its filename was
     mm-memcontrolc-fix-kerneldoc-comment-for-mem_cgroup_calculate_protection.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Mel Gorman <mgorman@techsingularity.net>
Subject: mm/memcontrol.c: fix kerneldoc comment for mem_cgroup_calculate_protection

make W=1 generates the following warning for mem_cgroup_calculate_protection

  mm/memcontrol.c:6468: warning: expecting prototype for mem_cgroup_protected(). Prototype was for mem_cgroup_calculate_protection() instead

Commit 45c7f7e1ef17 ("mm, memcg: decouple e{low,min} state mutations from
protection checks") changed the function definition but not the associated
kerneldoc comment.

Link: https://lkml.kernel.org/r/20210520084809.8576-7-mgorman@techsingularity.net
Fixes: 45c7f7e1ef17 ("mm, memcg: decouple e{low,min} state mutations from protection checks")
Signed-off-by: Mel Gorman <mgorman@techsingularity.net>
Reviewed-by: Yang Shi <shy828301@gmail.com>
Acked-by: Chris Down <chris@chrisdown.name>
Acked-by: Vlastimil Babka <vbabka@suse.cz>
Cc: Dan Streetman <ddstreet@ieee.org>
Cc: David Hildenbrand <david@redhat.com>
Cc: Michal Hocko <mhocko@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memcontrol.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/mm/memcontrol.c~mm-memcontrolc-fix-kerneldoc-comment-for-mem_cgroup_calculate_protection
+++ a/mm/memcontrol.c
@@ -6639,7 +6639,7 @@ static unsigned long effective_protectio
 }
 
 /**
- * mem_cgroup_protected - check if memory consumption is in the normal range
+ * mem_cgroup_calculate_protection - check if memory consumption is in the normal range
  * @root: the top ancestor of the sub-tree being checked
  * @memcg: the memory cgroup to check
  *
_

Patches currently in -mm which might be from mgorman@techsingularity.net are


