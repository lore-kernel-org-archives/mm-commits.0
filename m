Return-Path: <SRS0=McLq=BW=vger.kernel.org=mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.0 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8E65DC433E0
	for <mm-commits@archiver.kernel.org>; Wed, 12 Aug 2020 21:01:47 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 61137207F7
	for <mm-commits@archiver.kernel.org>; Wed, 12 Aug 2020 21:01:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1597266107;
	bh=fhn6B8M43ARvwg98jH23RLT5oXhya/K4BgBanhIYDd0=;
	h=Date:From:To:Subject:Reply-To:List-ID:From;
	b=e6Y945i/eiwKZY0IkYfJu12f5rRe5vnj7Q7WktWx7nlXMb40J04eltg1o4UfuLUDX
	 qqRQ1kbhMlvMqbpTkzVi2TmF4pr8TKLhGpZMx6sDGSnHWXGAvVXvyRw4fqrfoXltFJ
	 dbGHy+112REJzIU64259MSHzWpVRzVldMgpWTv7o=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726622AbgHLVBr (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 12 Aug 2020 17:01:47 -0400
Received: from mail.kernel.org ([198.145.29.99]:47208 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726611AbgHLVBq (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Wed, 12 Aug 2020 17:01:46 -0400
Received: from localhost.localdomain (c-71-198-47-131.hsd1.ca.comcast.net [71.198.47.131])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 7FCFF2078B;
        Wed, 12 Aug 2020 21:01:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1597266106;
        bh=fhn6B8M43ARvwg98jH23RLT5oXhya/K4BgBanhIYDd0=;
        h=Date:From:To:Subject:From;
        b=obJzr5q5IJVXZ/jCYjJ2S6U3d86d5/fQ0JZc5OYj+jDWKOjYBUFMpNIbjPVsGqNSI
         xYoqUkB0tLe0bgSh65cN2s2if6vSxlk+DL1+AgFLnMEBuIuBt3m1asMvlPKOPWdPCn
         ePZ9uzWcjQxiDYciHVflH2rz+YTTn4k3/o0ny75M=
Date:   Wed, 12 Aug 2020 14:01:46 -0700
From:   akpm@linux-foundation.org
To:     akpm@linux-foundation.org, haowenchao22@gmail.com,
        mm-commits@vger.kernel.org
Subject:  [merged]
 mm-mempolicy-check-parameters-first-in-kernel_get_mempolicy.patch removed
 from -mm tree
Message-ID: <20200812210146.yXsKuc4e-%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Sender: mm-commits-owner@vger.kernel.org
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/mempolicy.c: check parameters first in kernel_get_mempolicy
has been removed from the -mm tree.  Its filename was
     mm-mempolicy-check-parameters-first-in-kernel_get_mempolicy.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Wenchao Hao <haowenchao22@gmail.com>
Subject: mm/mempolicy.c: check parameters first in kernel_get_mempolicy

Previous implementatoin calls untagged_addr() before error check, while if
the error check failed and return EINVAL, the untagged_addr() call is just
useless work.

Link: http://lkml.kernel.org/r/20200801090825.5597-1-haowenchao22@gmail.com
Signed-off-by: Wenchao Hao <haowenchao22@gmail.com>
Reviewed-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/mempolicy.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/mm/mempolicy.c~mm-mempolicy-check-parameters-first-in-kernel_get_mempolicy
+++ a/mm/mempolicy.c
@@ -1632,11 +1632,11 @@ static int kernel_get_mempolicy(int __us
 	int pval;
 	nodemask_t nodes;
 
-	addr = untagged_addr(addr);
-
 	if (nmask != NULL && maxnode < nr_node_ids)
 		return -EINVAL;
 
+	addr = untagged_addr(addr);
+
 	err = do_get_mempolicy(&pval, &nodes, addr, flags);
 
 	if (err)
_

Patches currently in -mm which might be from haowenchao22@gmail.com are


