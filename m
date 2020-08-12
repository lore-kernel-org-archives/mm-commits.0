Return-Path: <SRS0=McLq=BW=vger.kernel.org=mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.0 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BC89FC433E1
	for <mm-commits@archiver.kernel.org>; Wed, 12 Aug 2020 21:01:54 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 9415B20768
	for <mm-commits@archiver.kernel.org>; Wed, 12 Aug 2020 21:01:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1597266114;
	bh=v7w1qkfJQ8g8teAmR9EJ3JiE8smEFfFRoTZvusIEfyI=;
	h=Date:From:To:Subject:Reply-To:List-ID:From;
	b=BBlLrOkhyW/YB9i21+LvPRsOLIzt02dZ5tF/9hfkZHTD/qL8tPvjOcblJd0arPYzL
	 FlYWps2AWgYoZmFE9I8Oe47jx8rDr+X/xV2KCwsiuwwSr0ES+P1mcVX+1om8JVDrjX
	 ehKFftVBR1aHzGLsQXkslQb5UGn6r0kAWfwOvBQw=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726632AbgHLVBy (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 12 Aug 2020 17:01:54 -0400
Received: from mail.kernel.org ([198.145.29.99]:47718 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726611AbgHLVBy (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Wed, 12 Aug 2020 17:01:54 -0400
Received: from localhost.localdomain (c-71-198-47-131.hsd1.ca.comcast.net [71.198.47.131])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 76FB020774;
        Wed, 12 Aug 2020 21:01:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1597266113;
        bh=v7w1qkfJQ8g8teAmR9EJ3JiE8smEFfFRoTZvusIEfyI=;
        h=Date:From:To:Subject:From;
        b=jphv7BpDGdY8xT1aSS7c1G3ifTVteXI4LjZjBBvRnpT6JG/bC/AxjW85HflZR03WF
         lqSNLcF11l3gV94FYr3ptjfqa1uJD36Dz89u+VnFP1CPTJf3qn2sXspRg+TMNfluM7
         puIA92s4aXGQYWvOXD0+GTDuWJVe+CQJNzt81/1k=
Date:   Wed, 12 Aug 2020 14:01:53 -0700
From:   akpm@linux-foundation.org
To:     corbet@lwn.net, laoar.shao@gmail.com, mhocko@suse.com,
        mm-commits@vger.kernel.org, rientjes@google.com
Subject:  [merged] doc-mm-sync-up-oom_score_adj-documentation.patch
 removed from -mm tree
Message-ID: <20200812210153.bapedPLZt%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Sender: mm-commits-owner@vger.kernel.org
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: doc, mm: sync up oom_score_adj documentation
has been removed from the -mm tree.  Its filename was
     doc-mm-sync-up-oom_score_adj-documentation.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Michal Hocko <mhocko@suse.com>
Subject: doc, mm: sync up oom_score_adj documentation

There are at least two notes in the oom section.  The 3% discount for root
processes is gone since d46078b28889 ("mm, oom: remove 3% bonus for
CAP_SYS_ADMIN processes").

Likewise children of the selected oom victim are not sacrificed since
bbbe48029720 ("mm, oom: remove 'prefer children over parent' heuristic")

Drop both of them.

Link: http://lkml.kernel.org/r/20200709062603.18480-1-mhocko@kernel.org
Signed-off-by: Michal Hocko <mhocko@suse.com>
Cc: Jonathan Corbet <corbet@lwn.net>
Cc: David Rientjes <rientjes@google.com>
Cc: Yafang Shao <laoar.shao@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/filesystems/proc.rst |    8 --------
 1 file changed, 8 deletions(-)

--- a/Documentation/filesystems/proc.rst~doc-mm-sync-up-oom_score_adj-documentation
+++ a/Documentation/filesystems/proc.rst
@@ -1633,9 +1633,6 @@ may allocate from based on an estimation
 For example, if a task is using all allowed memory, its badness score will be
 1000.  If it is using half of its allowed memory, its score will be 500.
 
-There is an additional factor included in the badness score: the current memory
-and swap usage is discounted by 3% for root processes.
-
 The amount of "allowed" memory depends on the context in which the oom killer
 was called.  If it is due to the memory assigned to the allocating task's cpuset
 being exhausted, the allowed memory represents the set of mems assigned to that
@@ -1671,11 +1668,6 @@ The value of /proc/<pid>/oom_score_adj m
 value set by a CAP_SYS_RESOURCE process. To reduce the value any lower
 requires CAP_SYS_RESOURCE.
 
-Caveat: when a parent task is selected, the oom killer will sacrifice any first
-generation children with separate address spaces instead, if possible.  This
-avoids servers and important system daemons from being killed and loses the
-minimal amount of work.
-
 
 3.2 /proc/<pid>/oom_score - Display current oom-killer score
 -------------------------------------------------------------
_

Patches currently in -mm which might be from mhocko@suse.com are


