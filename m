Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B5D49C2D0A3
	for <mm-commits@archiver.kernel.org>; Mon, 16 Nov 2020 20:58:52 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 781AB22265
	for <mm-commits@archiver.kernel.org>; Mon, 16 Nov 2020 20:58:52 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=kernel.org header.i=@kernel.org header.b="L/7HbmMH"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728581AbgKPU6w (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 16 Nov 2020 15:58:52 -0500
Received: from mail.kernel.org ([198.145.29.99]:45502 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728505AbgKPU6v (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Mon, 16 Nov 2020 15:58:51 -0500
Received: from localhost.localdomain (c-73-231-172-41.hsd1.ca.comcast.net [73.231.172.41])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 4DDF72224B;
        Mon, 16 Nov 2020 20:58:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1605560331;
        bh=AM/F1DvZ0zKmT8FpncVPTPc97dWUYt70t9fgHkJYaAo=;
        h=Date:From:To:Subject:From;
        b=L/7HbmMHHh8pyx9PzA2JW4kGH3Ux9GyuqaIvAdboZwYtnNB9U0+t3Gfg0Q/eK/xpX
         ZWB+8Su+s53mYPhf8SoJ4qgEtTXOPcVJJGdT3Fnyhc25jsg97WuciDIyhluK1VdeRb
         n8xTu8MZdMRVa19MD/uPasbZ3JB9X8l14Zw6mIcQ=
Date:   Mon, 16 Nov 2020 12:58:50 -0800
From:   akpm@linux-foundation.org
To:     guro@fb.com, hannes@cmpxchg.org, lukas.bulwahn@gmail.com,
        mhocko@kernel.org, mm-commits@vger.kernel.org
Subject:  + mm-memcg-remove-obsolete-memcg_has_children.patch added
 to -mm tree
Message-ID: <20201116205850.oEjQalPoN%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm: memcg: remove obsolete memcg_has_children()
has been added to the -mm tree.  Its filename is
     mm-memcg-remove-obsolete-memcg_has_children.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/mm-memcg-remove-obsolete-memcg_has_children.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/mm-memcg-remove-obsolete-memcg_has_children.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Lukas Bulwahn <lukas.bulwahn@gmail.com>
Subject: mm: memcg: remove obsolete memcg_has_children()

Commit 2ef1bf118c40 ("mm: memcg: deprecate the non-hierarchical mode")
removed the only use of memcg_has_children() in
mem_cgroup_hierarchy_write() as part of the feature deprecation.

Hence, since then, make CC=clang W=1 warns:

  mm/memcontrol.c:3421:20:
    warning: unused function 'memcg_has_children' [-Wunused-function]

Simply remove this obsolete unused function.

Link: https://lkml.kernel.org/r/20201116055043.20886-1-lukas.bulwahn@gmail.com
Signed-off-by: Lukas Bulwahn <lukas.bulwahn@gmail.com>
Cc: Roman Gushchin <guro@fb.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Michal Hocko <mhocko@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memcontrol.c |   13 -------------
 1 file changed, 13 deletions(-)

--- a/mm/memcontrol.c~mm-memcg-remove-obsolete-memcg_has_children
+++ a/mm/memcontrol.c
@@ -3454,19 +3454,6 @@ unsigned long mem_cgroup_soft_limit_recl
 }
 
 /*
- * Test whether @memcg has children, dead or alive.
- */
-static inline bool memcg_has_children(struct mem_cgroup *memcg)
-{
-	bool ret;
-
-	rcu_read_lock();
-	ret = css_next_child(NULL, &memcg->css);
-	rcu_read_unlock();
-	return ret;
-}
-
-/*
  * Reclaims as many pages from the given memcg as possible.
  *
  * Caller is responsible for holding css reference for memcg.
_

Patches currently in -mm which might be from lukas.bulwahn@gmail.com are

mm-memcg-remove-obsolete-memcg_has_children.patch
mm-vmscan-drop-unneeded-assignment-in-kswapd.patch

