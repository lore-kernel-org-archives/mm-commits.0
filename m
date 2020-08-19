Return-Path: <SRS0=1kGn=B5=vger.kernel.org=mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 65704C433E1
	for <mm-commits@archiver.kernel.org>; Wed, 19 Aug 2020 21:43:20 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 40D5120888
	for <mm-commits@archiver.kernel.org>; Wed, 19 Aug 2020 21:43:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1597873400;
	bh=jyBCIjWRtUFD/fTY+zMPd1k3qvnpiE8pKd0ikluu+yQ=;
	h=Date:From:To:Subject:In-Reply-To:Reply-To:List-ID:From;
	b=tI+7kuwH+god+r/S0FMuPhRH1/hVmXPxpFzUvzKSSYm06o+6EcLjpZC3DM7NJF75s
	 D5tzcuLd+tBGu94uKZnBXGoBR+ISLFqWud3Ce/65sQzxeQAVi3YgFScl9RdXEi7LC9
	 YRfdZeOady/2abKbodXI/gmuTFBHDoz3AYnPzzdk=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726841AbgHSVnT (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 19 Aug 2020 17:43:19 -0400
Received: from mail.kernel.org ([198.145.29.99]:37018 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726466AbgHSVnT (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Wed, 19 Aug 2020 17:43:19 -0400
Received: from localhost.localdomain (c-73-231-172-41.hsd1.ca.comcast.net [73.231.172.41])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id D3ED52078D;
        Wed, 19 Aug 2020 21:43:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1597873399;
        bh=jyBCIjWRtUFD/fTY+zMPd1k3qvnpiE8pKd0ikluu+yQ=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=ZhtZjQJsJPxm4DQBfRwvggCFtKWex5AUylefWCzFZTd9PAWXzs85CikdOqZKxJuoU
         Jb93nRWwhhpwXcTr2e9JpAkO16DgZ6B4GgAkbJFGvVyDwZTat0nPyXODEe6dREKMG/
         FO3dW/5GwfY5S2I3hc2scV00fO5sdWohkDvL7p1Y=
Date:   Wed, 19 Aug 2020 14:43:18 -0700
From:   Andrew Morton <akpm@linux-foundation.org>
To:     gustavoars@kernel.org, hannes@cmpxchg.org, mhocko@suse.com,
        mm-commits@vger.kernel.org, vdavydov.dev@gmail.com
Subject:  +
 mm-memcontrol-use-flex_array_size-helper-in-memcpy.patch added to -mm tree
Message-ID: <20200819214318.5bZtN2Rl0%akpm@linux-foundation.org>
In-Reply-To: <20200814172939.55d6d80b6e21e4241f1ee1f3@linux-foundation.org>
User-Agent: s-nail v14.8.16
Sender: mm-commits-owner@vger.kernel.org
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm: memcontrol: use flex_array_size() helper in memcpy()
has been added to the -mm tree.  Its filename is
     mm-memcontrol-use-flex_array_size-helper-in-memcpy.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/mm-memcontrol-use-flex_array_size-helper-in-memcpy.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/mm-memcontrol-use-flex_array_size-helper-in-memcpy.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: "Gustavo A. R. Silva" <gustavoars@kernel.org>
Subject: mm: memcontrol: use flex_array_size() helper in memcpy()

Make use of the flex_array_size() helper to calculate the size of a
flexible array member within an enclosing structure.

This helper offers defense-in-depth against potential integer overflows,
while at the same time makes it explicitly clear that we are dealing with
a flexible array member.

Also, remove unnecessary braces.

Link: https://lkml.kernel.org/r/ddd60dae2d9aea1ccdd2be66634815c93696125e.1596214831.git.gustavoars@kernel.org
Signed-off-by: Gustavo A. R. Silva <gustavoars@kernel.org>
Acked-by: Michal Hocko <mhocko@suse.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Vladimir Davydov <vdavydov.dev@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memcontrol.c |    7 +++----
 1 file changed, 3 insertions(+), 4 deletions(-)

--- a/mm/memcontrol.c~mm-memcontrol-use-flex_array_size-helper-in-memcpy
+++ a/mm/memcontrol.c
@@ -4253,10 +4253,9 @@ static int __mem_cgroup_usage_register_e
 	new->size = size;
 
 	/* Copy thresholds (if any) to new array */
-	if (thresholds->primary) {
-		memcpy(new->entries, thresholds->primary->entries, (size - 1) *
-				sizeof(struct mem_cgroup_threshold));
-	}
+	if (thresholds->primary)
+		memcpy(new->entries, thresholds->primary->entries,
+		       flex_array_size(new, entries, size - 1));
 
 	/* Add new threshold */
 	new->entries[size - 1].eventfd = eventfd;
_

Patches currently in -mm which might be from gustavoars@kernel.org are

mm-memcontrol-use-flex_array_size-helper-in-memcpy.patch
mm-memcontrol-use-the-preferred-form-for-passing-the-size-of-a-structure-type.patch

